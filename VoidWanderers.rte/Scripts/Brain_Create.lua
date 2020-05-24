function do_create(self)
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
	
	if self.ThisActor then
		self.TelekinesisLvl = 0
		self.ShieldLvl = 0
		self.MaxHealth = 100
		self.RegenInterval = 0
	
		-- Calculate actor base power
		local s = self.ThisActor.PresetName
		local pos = string.find(s ,"RPG Brain Robot");
		if pos == 1 then
			local bplr = tonumber(string.sub(s, string.len(s), string.len(s) ))
			
			self.TelekinesisLvl = tonumber(CF_GS["Brain".. bplr .."Telekinesis"])
			self.ShieldLvl = tonumber(CF_GS["Brain".. bplr .."Field"])
			
			self.MaxHealth = 100 + tonumber(CF_GS["Brain".. bplr .."Level"])
			self.RegenInterval = 1500 - tonumber(CF_GS["Brain".. bplr .."Level"]) * 10
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
			if G_VW_Timer == nil then
				G_VW_Timer = Timer()
				G_VW_ThisFrameTime = 0
			end
			if G_VW_DepressureTimer == nil then
				G_VW_DepressureTimer = Timer()
			end
			
			G_VW_ShieldRadius = 150
			G_VW_MinVelocity = 10
			
			G_VW_Shields[#G_VW_Shields + 1] = self.ThisActor
			G_VW_Active[#G_VW_Shields] = true
			G_VW_Pressure[#G_VW_Shields] = 0
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
