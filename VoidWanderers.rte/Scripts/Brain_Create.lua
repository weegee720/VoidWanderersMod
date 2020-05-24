function do_rpgbrain_create(self)
	-- Set up constants
	self.DistPerPower = 75
	self.CoolDownInterval = 4000
	self.PrintSkills = false;

	self.WeaponTeleportEnabled = false;
	self.DamageEnabled = false;
	self.PushEnabled = false;
	self.StealEnabled = false;
	self.DistortEnabled = false;
	self.ShieldEnabled = false;

	self.WeaponTeleportCost = 15;
	self.DamageCost = 65;
	self.PushCost = 15;
	self.StealCost = 30;
	self.DistortCost = 25;
	
	-- Find our owner actor
	local found = MovableMan:GetMOFromID(self.RootID);

	if found then
		-- Store actor for future use
		if found.ClassName == "AHuman" then
			self.ThisActor = ToAHuman(found)
		elseif found.ClassName == "ACrab" then
			self.ThisActor = ToACrab(found)
		else
			self.ThisActor = nil;
		end
	end

	self.Energy = 100;
	self.Timer = Timer();
	self.CoolDownTimer = Timer()
	self.RegenTimer = Timer();
	self.BlinkTimer = Timer();
	
	if self.ThisActor then
		self.TelekinesisLvl = 0
		self.ShieldLvl = 0
		self.MaxHealth = 100
		self.RegenInterval = 0
		self.RepairCount = 0
		self.HealCount = 0
		self.SelfHealCount = 0
		self.ScanRange = 0
		self.ScanLevel = 0
	
		-- Calculate actor base power
		local s = self.ThisActor.PresetName
		local pos = string.find(s ,"RPG Brain Robot");
		if pos ~= nil and pos == 1 then
			if CF_GS ~= nil and self.ThisActor.Team == 0 then
				--print ("GS")
				local bplr = tonumber(string.sub(s, string.len(s), string.len(s) ))
				
				self.TelekinesisLvl = tonumber(CF_GS["Brain".. bplr .."Telekinesis"])
				self.ShieldLvl = tonumber(CF_GS["Brain".. bplr .."Field"])
				
				self.MaxHealth = 100 + tonumber(CF_GS["Brain".. bplr .."Level"])
				self.RegenInterval = 1500 - tonumber(CF_GS["Brain".. bplr .."Level"]) * 10
				
				self.RepairCount = tonumber(CF_GS["Brain".. bplr .."Fix"]) * 3
				self.HealCount = tonumber(CF_GS["Brain".. bplr .."Heal"]) * 2
				self.SelfHealCount = tonumber(CF_GS["Brain".. bplr .."SelfHeal"])
				self.ScanLevel = tonumber(CF_GS["Brain".. bplr .."Scanner"])
			else
				--print ("Preset")
				local pos = string.find(s ,"SHLD");
				if pos ~= nil then
					self.ShieldLvl = tonumber(string.sub(s, pos + 4, pos + 4 ))
				end
			
				local pos = string.find(s ,"TLKN");
				if pos ~= nil then
					self.TelekinesisLvl = tonumber(string.sub(s, pos + 4, pos + 4 ))
				end
				
				local pos = string.find(s ,"HLTH");
				if pos ~= nil then
					local val = (tonumber(string.sub(s, pos + 4, pos + 4 )) + 1) * 10
				
					self.MaxHealth = 100 + val
					self.RegenInterval = 1500 - val * 10
				end
				
				local pos = string.find(s ,"FIXW");
				if pos ~= nil then
					self.RepairCount = tonumber(string.sub(s, pos + 4, pos + 4 )) * 3
				end
				
				local pos = string.find(s ,"HEAL");
				if pos ~= nil then
					self.HealCount = tonumber(string.sub(s, pos + 4, pos + 4 )) * 2
				end
				
				local pos = string.find(s ,"RGEN");
				if pos ~= nil then
					self.SelfHealCount = tonumber(string.sub(s, pos + 4, pos + 4 ))
				end
				
				local pos = string.find(s ,"SCAN");
				if pos ~= nil then
					self.ScanLevel = tonumber(string.sub(s, pos + 4, pos + 4 ))
				end				
			end
		end

		self.ScanEnabled = true
		self.ScanRange = 200 + self.ScanLevel * 160
		
		self.ThisActor.Health = self.MaxHealth
		
		--print (self.ThisActor.PresetName)
		--print ("Shield: "..self.ShieldLvl)
		--print ("Kinesis: "..self.TelekinesisLvl)
		--print ("MaxHealth: "..self.MaxHealth)
		
		-- Create skills menu
		self.Skills = {}
		local count = 0

		if self.RepairCount > 0 then
			count = count + 1
			self.Skills[count] = {}
			
			self.Skills[count]["Text"] = "Toggle scanner"
			self.Skills[count]["Count"] = -1
			self.Skills[count]["Function"] = rpgbrain_skill_scanner
		end
		
		if self.RepairCount > 0 then
			count = count + 1
			self.Skills[count] = {}
			
			self.Skills[count]["Text"] = "Repair weapon"
			self.Skills[count]["Count"] = self.RepairCount
			self.Skills[count]["Function"] = rpgbrain_skill_repair
		end

		if self.HealCount > 0 then
			count = count + 1
			self.Skills[count] = {}
			
			self.Skills[count]["Text"] = "Heal unit"
			self.Skills[count]["Count"] = self.HealCount
			self.Skills[count]["Function"] = rpgbrain_skill_heal
			self.Skills[count]["ActorDetectRange"] = 50
		end
		
		if self.SelfHealCount > 0 then
			count = count + 1
			self.Skills[count] = {}
			
			self.Skills[count]["Text"] = "Heal brain"
			self.Skills[count]["Count"] = self.SelfHealCount
			self.Skills[count]["Function"] = rpgbrain_skill_heal
			self.Skills[count]["ActorDetectRange"] = 0.1
			self.Skills[count]["AffectsBrains"] = true
		end
		
		if self.ShieldLvl > 0 then
			self.ShieldEnabled = true
		end
		
		if self.TelekinesisLvl > 0 then
			self.DistortEnabled = true
		end

		if self.TelekinesisLvl > 1 then
			self.PushEnabled = true
		end

		if self.TelekinesisLvl > 2 then
			self.WeaponTeleportEnabled = true
		end

		if self.TelekinesisLvl > 3 then
			self.StealEnabled = true
		end

		if self.TelekinesisLvl > 4 then
			self.DamageEnabled = true
		end
		
		if self.ShieldEnabled then
			-- Shield variables
			if G_VW_Shields == nil then
				G_VW_Shields = {}
			end
			if G_VW_Active == nil then
				G_VW_Active = {}
			end
			if G_VW_Pressure == nil then
				G_VW_Pressure = {}
			end
			if G_VW_Power == nil then
				G_VW_Power = {}
			end
			if G_VW_Timer == nil then
				G_VW_Timer = Timer()
				G_VW_ThisFrameTime = 0
			end
			if G_VW_DepressureTimer == nil then
				G_VW_DepressureTimer = Timer()
			end
			
			G_VW_ShieldRadius = 180
			G_VW_ShieldRadiusPerPower = 30
			G_VW_MinVelocity = 10
			
			local shld = #G_VW_Shields + 1
			
			G_VW_Shields[shld] = self.ThisActor
			G_VW_Active[shld] = true
			G_VW_Pressure[shld] = 0
			G_VW_Power[shld] = self.ShieldLvl
			G_VW_Switch = 0
			
			-- Remove inactive shields from the global list
			local shields ={}
			local active = {}
			local pressure = {}
			local power = {}
			
			local j = 0
			
			for i = 1, #G_VW_Shields do
				-- Remove shield duplicates
				for ii = 1, i - 1 do
					if MovableMan:IsActor(G_VW_Shields[ii]) and MovableMan:IsActor(G_VW_Shields[i])then
						if G_VW_Shields[ii].ID == G_VW_Shields[i].ID then
							G_VW_Active[i] = false
						end
					end
				end

				if not MovableMan:IsActor(G_VW_Shields[i]) then
					G_VW_Active[i] = false
				else
					if not G_VW_Shields[i]:IsInGroup("Brains") or string.find(G_VW_Shields[i].PresetName ,"RPG Brain Robot") == nil then
						G_VW_Active[i] = false
					end
				end
				
				-- Remove disabled shields
				if G_VW_Active[i] then
					j = j + 1
					shields[j] = G_VW_Shields[i]
					active[j] = G_VW_Active[i]
					pressure[j] = G_VW_Pressure[i]
					power[j] = G_VW_Power[i]
					--print (shields[j])
				end
			end
			
			G_VW_Shields = shields
			G_VW_Active = active
			G_VW_Pressure = pressure
			G_VW_Power = power--]]--
			
			--print ("Shield count: "..#G_VW_Shields)
		end
	else 
		--print (self.ThisActor)
	end
end

function VoidWanderersRPG_AddEffect(pos, preset)
	local pix = CreateMOPixel(preset);
	pix.Pos = pos
	MovableMan:AddParticle(pix);
end

function VoidWanderersRPG_AddPsyEffect(pos)
	local pix = CreateMOPixel("Huge Glow");
	pix.Pos = pos
	MovableMan:AddParticle(pix);
end

function VoidWanderersRPG_VW_MakeItem(item, class)
	if class == "HeldDevice" then
		return CreateHeldDevice(item)
	elseif class == "HDFirearm" then
		return CreateHDFirearm(item)
	elseif class == "TDExplosive" then
		return CreateTDExplosive(item)
	elseif class == "ThrownDevice" then
		return CreateThrownDevice(item)
	end
	
	return nil;
end

function VoidWanderersRPG_GetAngle(from, to)
	local b = to.X - from.X
	local a = to.Y - from.Y
	local c = SceneMan:ShortestDistance(from, to, true).Magnitude;
	
	local cosa =  (b * b + c * c - a * a) / (2 * b * c)
	local angle = math.acos(cosa)
	
	if (from.X > to.X and from.Y > to.Y) then
		angle = angle
	elseif (from.X < to.X and from.Y > to.Y) then
		angle = angle --
	elseif (from.X < to.X and from.Y < to.Y) then
		angle = -angle
	elseif (from.X > to.X and from.Y < to.Y) then
		angle =  2 * 3.14 - angle --
	end
	
	return angle, c, cosa
end
