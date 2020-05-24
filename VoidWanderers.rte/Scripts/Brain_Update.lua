function do_rpgbrain_shield()
	local radius = 0
	local dist = 0
	local glownum =0
	local s;
	local pr;

	local rads = {}
	local shields = {}
	local active = {}
	local pressure = {}
	local n = 0
	
	local depressure = false
	-- Looks like global timers will show negative values, generated during previous activty run or something
	if G_VW_DepressureTimer.ElapsedSimTimeMS < 0 then
		G_VW_DepressureTimer:Reset()
	end
	
	if G_VW_DepressureTimer:IsPastSimMS(25) then
		depressure = true
		G_VW_DepressureTimer:Reset()
	end
	
	for i = 1, #G_VW_Active do
		if G_VW_Active[i] and MovableMan:IsActor(G_VW_Shields[i]) and G_VW_Shields[i].Health > 0 then
			n = #shields + 1
		
			shields[n] = G_VW_Shields[i]
			active[n] = true
			
			--rads[n] = G_VW_ShieldRadius - G_VW_Pressure[i] / 10
			rads[n] = (100 + (G_VW_Power[i] - 1) * G_VW_ShieldRadiusPerPower) - (G_VW_Pressure[i] / 10)
			
			if rads[n] < 0 then
				rads[n] = 0
			end
			
			if G_VW_Pressure[i] > 7 and rads[n] > 5 then
				for i = 1, 4 do
					local a = math.random(360) / (180 / math.pi)
					local pos = shields[n].Pos + Vector(math.cos(a) * rads[n], math.sin(a) * rads[n])
					if SceneMan:GetTerrMatter(pos.X, pos.Y) == 0 then
						VoidWanderersRPG_AddEffect(pos, "Purple Glow 1")
					end
				end
			end

			pressure[n] = G_VW_Pressure[i]
			if depressure then
				--pressure[n] = G_VW_Pressure[i] - G_VW_Pressure[i] * (0.020 * G_VW_Power[i])
				pressure[n] = G_VW_Pressure[i] - 3 * G_VW_Power[i]
				if pressure[n] < 0 then
					pressure[n] = 0
				end
			end
			
			--CF_DrawString(tostring(math.ceil(G_VW_Pressure[i])), shields[n].Pos + Vector(0,-50), 200, 200)
		else
			G_VW_Active[i] = false;
		end
	end

	G_VW_Shields = shields;
	G_VW_Active = active;
	G_VW_Pressure = pressure;
	
	local counter = 0
	
	if G_VW_Switch == 0 then
		G_VW_Switch = 1
	else
		G_VW_Switch = 0
	end
	
	for p in MovableMan.Particles do
		counter = counter + 1
	
		if counter % 2 == G_VW_Switch and p.HitsMOs and p.Vel.Magnitude >= G_VW_MinVelocity then
			for i = 1, #G_VW_Shields do
				s = G_VW_Shields[i]
				pr = G_VW_Pressure[i]
			
				if G_VW_Active[i] then
					if G_VW_Shields[i].Team ~= p.Team then
						dist = SceneMan:ShortestDistance(s.Pos , p.Pos,true).Magnitude
						
						radius = rads[i]
					
						if dist <= radius and dist > radius * 0.1 then
							pr = pr + (p.Mass * p.Vel.Magnitude)
						
							if math.random(3) == 1 then
								glownum = math.floor(p.Vel.Magnitude / 5)
							
								if glownum > 20 then
									glownum = 20
								end
								
								if glownum >= 1 then
									VoidWanderersRPG_AddEffect(p.Pos, "Purple Glow "..tostring(glownum))
								end
							end
						
							--p.Vel = p.Vel - Vector(p.Vel.X * 0.95, p.Vel.Y * 0.95)
							p.Vel = Vector(p.Vel.X * 0.001, p.Vel.Y * 0.001)
						end
					end
				else
					G_VW_Active[i] = false
				end
				
				G_VW_Pressure[i] = pr
			end
		end
	end
end

function do_rpgbrain_update(self)
	-- Don't do anything when in edit mode
	if ActivityMan:GetActivity().ActivityState ~= Activity.RUNNING then
		return
	end

	--[[if true then
		return
	end--]]--
	
	if G_VW_Shields ~= nil then
		-- Timers are updated on every sim update
		-- so to find out if it's first run during this sim update we just
		-- get current timer value
		if G_VW_ThisFrameTime ~= G_VW_Timer.ElapsedSimTimeMS then
			G_VW_ThisFrameTime = G_VW_Timer.ElapsedSimTimeMS;
			do_rpgbrain_shield()
			--print ("Do "..G_VW_Timer.ElapsedSimTimeMS)
		else
			--print ("Skip "..G_VW_Timer.ElapsedSimTimeMS)
		end
	end

	if MovableMan:IsActor(self.ThisActor) then
		self.FullPower = self.TelekinesisLvl
		
		-- Calculate effective skills distance
		self.EffectiveDistance = self.FullPower * self.DistPerPower;

		self.Threat = nil
		local nearestenemydist = 1000000
		local catalysts = 0
		local inhibitors = 0
		local dreadnoughtnearby = false;
		
		-- Search for nearby actors 
		for actor in MovableMan.Actors do
			-- Search for friends to amplify power
			if not actor:IsInGroup("Brains") and actor.Health > 0 then
				-- Search for enemies to find threat
				local d = SceneMan:ShortestDistance(actor.Pos, self.ThisActor.Pos, true).Magnitude;
				
				-- Find only nearest enemies
				if d < self.EffectiveDistance and d < nearestenemydist then
					-- Search for targets only if we have enough power and not recharging
					if self.Energy >= 15 and self.CoolDownTimer:IsPastSimMS(self.CoolDownInterval) then
						local angle = VoidWanderersRPG_GetAngle(self.Pos, actor.Pos)
						local pos = self.Pos + Vector(math.cos(-angle) * 20, math.sin(-angle) * 20)

						-- To improve enemy visibility cast rays across the whole enemy figure
						local offsets = {Vector(0,-15), Vector(0,-7), Vector(0,0), Vector(0,7), Vector(0,15)}
						
						for i = 1, #offsets do
							local actorpos = pos
							local vectortoactor = actor.Pos + offsets[i] - actorpos;
							local moid = SceneMan:CastMORay(actorpos , vectortoactor , self.ThisActor.ID , self.ThisActor.Team , -1, false , 4);
							local mo = MovableMan:GetMOFromID(moid);
							
							if mo ~= nil then
								if mo.ClassName == "AHuman" then
									self.Threat = ToAHuman(mo)
									nearestenemydist = d;
								else
									local mo = MovableMan:GetMOFromID(mo.RootID);
									if mo ~= nil then
										if mo.ClassName == "AHuman" then
											self.Threat = ToAHuman(mo)
											nearestenemydist = d;
										end
									end
								end
							end -- if
						end -- for
					end
				end --if d <
			end -- if not brain
		end
		
		-- Debug, draw selected target
		if self.PrintSkills and MovableMan:IsActor(self.Threat) then
			self.Threat:FlashWhite(25)
		end

		-- Check for applicable skill from closest to farthest
		-- Teleport closest weapon
		if self.Energy >= self.WeaponTeleportCost and self.WeaponTeleportEnabled and self.CoolDownTimer:IsPastSimMS(self.CoolDownInterval) and self.ThisActor.EquippedItem == nil then
			local nearestitmdist = 1000000
			local nearestitem = nil

			-- Find nearest weapon
			for itm in MovableMan.Items do
				if itm.ClassName == "HDFirearm" then
					local d = SceneMan:ShortestDistance(itm.Pos, self.ThisActor.Pos, true).Magnitude;
					
					if d < self.EffectiveDistance and d < nearestitmdist then
						nearestitem = itm
						nearestenemydist = d;
					end --if d <
				end
			end
				
			-- Teleport weapon
			if nearestitem ~= nil then
				if self.PrintSkills then
					print ("Teleport - "..tostring(math.ceil(self.FullPower)))
				end
			
				self.Energy = self.Energy - self.WeaponTeleportCost
				VoidWanderersRPG_AddPsyEffect(self.Pos)
				VoidWanderersRPG_AddPsyEffect(nearestitem.Pos)
				
				local newitem = CreateHDFirearm(nearestitem.PresetName)
				if newitem ~= nil then
					self.ThisActor:AddInventoryItem(newitem)
					nearestitem.ToDelete = true
					-- This item will be teleported only on the next sim update, we need to move it far away to avoid grabbing by other psyclones
					nearestitem.Pos = Vector(0,25000)
				end--]]--
				--self.ThisActor:AddInventoryItem(nearestitem)
				self.CoolDownTimer:Reset();
			end
		end

		
		-- If we have target then use some skills on it
		if MovableMan:IsActor(self.Threat) then
			-- Damage and gib
			if self.Energy >= self.DamageCost and nearestenemydist < self.EffectiveDistance * 0.3 and self.FullPower > 10 and self.DamageEnabled and self.CoolDownTimer:IsPastSimMS(self.CoolDownInterval)then
				self.Energy = self.Energy - self.DamageCost

				if self.PrintSkills then
					print ("Damage - "..tostring(math.ceil(self.FullPower)).." - "..self.Threat.PresetName)
				end
				
				for i = 1, self.FullPower / 4 do
					local pix = CreateMOPixel("Hit particle");
					pix.Pos = self.Threat.Pos + Vector(-2 + math.random(4), -2 + math.random(4))
					pix.Vel = Vector(-2 + math.random(4), -2 + math.random(4))
					MovableMan:AddParticle(pix); 
				end
				
				VoidWanderersRPG_AddPsyEffect(self.Threat.Pos)
				self.DamageThreat = self.Threat;
				self.Threat:AddAbsImpulseForce(Vector(0, -6), Vector(0,0))
				
				VoidWanderersRPG_AddPsyEffect(self.Pos)
				self.CoolDownTimer:Reset();
			end--]]--

			-- Steal weapon
			if self.Energy >= self.StealCost and nearestenemydist < self.EffectiveDistance * 0.6 and self.StealEnabled and self.CoolDownTimer:IsPastSimMS(self.CoolDownInterval) then
				local weap = self.Threat.EquippedItem;

				if weap ~= nil then
					local newweap = VoidWanderersRPG_VW_MakeItem(weap.PresetName, weap.ClassName)
					if newweap ~= nil then
						if self.PrintSkills then
							print ("Steal - "..tostring(math.ceil(self.FullPower)).." - "..self.Threat.PresetName)
						end

						self.Energy = self.Energy - self.StealCost
					
						-- If enemy holds grenade then explode it
						if newweap.ClassName == "TDExplosive" then
							newweap:GibThis();
						else
							-- Pull wepon otherwise
							newweap.Pos = weap.Pos;
							MovableMan:AddItem(newweap)
							
							local angle, d = VoidWanderersRPG_GetAngle(self.Pos, weap.Pos)
							local vel = Vector(-math.cos(-angle) * (2 * self.FullPower), -math.sin(-angle) * (2 * self.FullPower))
							
							newweap.Vel = vel
							
							VoidWanderersRPG_AddPsyEffect(weap.Pos)
							weap.ToDelete = true
						end
						
						VoidWanderersRPG_AddPsyEffect(self.Pos)
						self.CoolDownTimer:Reset();
					end
				end
			end--]]--

			-- Push target
			if self.Energy >= self.PushCost and nearestenemydist < self.EffectiveDistance * 0.8 and self.PushEnabled and self.CoolDownTimer:IsPastSimMS(self.CoolDownInterval) then
				local pow = 7.5 * self.FullPower
			
				if self.PrintSkills then
					print ("Push - "..tostring(math.ceil(self.FullPower)).." - "..tostring(math.ceil(pow)).." - "..self.Threat.PresetName)
				end

				self.Energy = self.Energy - self.PushCost

				local target = self.Threat.Pos
				local angle, d = VoidWanderersRPG_GetAngle(self.Pos, target)
				
				-- Apply forces
				self.Threat:AddAbsImpulseForce(Vector(math.cos(-angle) * pow, math.sin(-angle) * pow), Vector(0,0))
				
				VoidWanderersRPG_AddPsyEffect(self.Threat.Pos)
				VoidWanderersRPG_AddPsyEffect(self.Pos)
				self.CoolDownTimer:Reset();
			end--]]--
			
			-- Distort aiming
			if self.Energy >= self.DistortCost and self.DistortEnabled and self.CoolDownTimer:IsPastSimMS(self.CoolDownInterval) then
				if self.PrintSkills then
					print ("Distort - "..tostring(math.ceil(self.FullPower)).." - "..self.Threat.PresetName)
				end

				self.Energy = self.Energy - self.DistortCost
				self.AimDistortThreat = self.Threat;
				VoidWanderersRPG_AddPsyEffect(self.Pos)
				self.CoolDownTimer:Reset();
			end--]]--
		end
		
		-- Do distortion
		if MovableMan:IsActor(self.AimDistortThreat) and not self.CoolDownTimer:IsPastSimMS(self.CoolDownInterval) then
			self.AimDistortThreat:GetController():SetState(Controller.AIM_UP, true)
			
			if self.AimDistortThreat:GetAimAngle(false) < 0.75 then
				self.AimDistortThreat:GetController():SetState(Controller.WEAPON_FIRE, true)
			end
		else
			self.AimDistortThreat = nil;
		end

		-- Do distortion after damage
		if MovableMan:IsActor(self.DamageThreat) and not self.CoolDownTimer:IsPastSimMS(self.CoolDownInterval) then
			if self.DamageDistortEnabled then
				self.DamageThreat:GetController():SetState(Controller.BODY_CROUCH, true)
				self.DamageThreat:GetController():SetState(Controller.AIM_DOWN, true)
			end
		else
			self.DamageThreat = nil;
		end

		--CF_DrawString(tostring(self.ThisActor:GetAimAngle(true)), self.Pos + Vector(0,-110), 200, 200)
		--CF_DrawString(tostring(math.cos(self.ThisActor:GetAimAngle(false))), self.Pos + Vector(0,-100), 200, 200)
		--CF_DrawString(tostring(math.floor(self.ThisActor:GetAimAngle(true) * (180 / 3.14))), self.Pos + Vector(0,-90), 200, 200)
		
		-- Update state
		if self.Timer:IsPastSimMS(250) then
			-- Add power
			if self.Energy < 100 then
				self.Energy = self.Energy + self.FullPower * 0.1
				
				if self.Energy > 100 then
					self.Energy = 100
				end
			end

			self.Timer:Reset()
		end
		
		if self.RegenInterval > 0 and self.MaxHealth > 100 and self.RegenTimer:IsPastSimMS(self.RegenInterval) then
			if self.ThisActor.Health < self.MaxHealth then
				self.ThisActor.Health = self.ThisActor.Health + 1
			end
			self.RegenTimer:Reset();
		end
		
		-- Draw power marker
		if self.TelekinesisLvl > 0 then
			local glownum = math.ceil(self.FullPower * 2 * (self.Energy / 100))
			
			if glownum > 10 then
				glownum = 10
			end
			
			if glownum > 0 then
				local pix = CreateMOPixel("Purple Glow "..glownum);
				pix.Pos = self.Pos + Vector(1, -2)
				MovableMan:AddParticle(pix);
			end
		end
		
		if CF_DrawString ~= nil and self.PrintSkills then
			CF_DrawString("E "..math.floor(self.Energy), self.Pos + Vector(0,-50), 200, 200)
			CF_DrawString("P "..self.FullPower, self.Pos + Vector(0,-40), 200, 200)
		end
		
		-- Process scanner
		if self.ScanLevel > 0 and self.ScanEnabled then
			for actor in MovableMan.Actors do
				if actor.ClassName ~= "ADoor" and actor.ClassName ~= "Actor" and actor.ID ~= self.ThisActor.ID then
					local d = CF_Dist(actor.Pos, self.Pos)
				
					if d < self.ScanRange then
						local a = VoidWanderersRPG_GetAngle(self.Pos, actor.Pos)
						local relpos = Vector(math.cos(-a) * (20 + (d * 0.1)), math.sin(-a) * (20 + (d * 0.1)))
						
						local effect = "Blue Glow"
						
						if actor.Team ~= self.ThisActor.Team then
							local pos = self.Pos + Vector(math.cos(-a) * 20, math.sin(-a) * 20)
							local actorpos = pos
							local vectortoactor = actor.Pos - actorpos;
							local moid = SceneMan:CastMORay(actorpos , vectortoactor , self.ThisActor.ID , -2 , -1, false , 4);
							local mo = MovableMan:GetMOFromID(moid);
							
							if mo ~= nil then
								effect = "Red Glow"
							else
								effect = "Yellow Glow"
							end
						end
						
						VoidWanderersRPG_AddEffect(self.Pos + relpos, effect)--]]--
					end
				end
			end
			
			-- Show eye pos
			local a = VoidWanderersRPG_GetAngle(self.Pos, self.ThisActor.ViewPoint)
			local d = CF_Dist(self.ThisActor.ViewPoint, self.Pos)
			local relpos = Vector(math.cos(-a) * (20 + (d * 0.1)), math.sin(-a) * (20 + (d * 0.1)))
			local effect = "Green Glow"

			VoidWanderersRPG_AddEffect(self.Pos + relpos, effect)
		end
		
		-- Process PDA input
		if self.ThisActor:IsPlayerControlled() then
			if CF_PDAInitiator ~= nil and CF_PDAInitiator.ID == self.ThisActor.ID then
				-- Enable PDA only if we're not flying or something
				if self.PDAEnabled then
					self.PDAEnabled = false
				else
					if self.ThisActor.Vel.Magnitude < 3 then
						self.PDAEnabled = true
					end
				end
				CF_PDAInitiator = nil
				self.SelectedMenuItem = 1
				self.PinPoint = Vector(self.ThisActor.Pos.X, self.ThisActor.Pos.Y)
				self.ActiveMenu = self.Skills
			end
		else
			self.PDAEnabled = false
		end
		
		if self.PDAEnabled then
			do_rpgbrain_pda(self)
		end
	end
end

function do_rpgbrain_pda(self)
	self.ThisActor.Vel = Vector(0,0)
	self.ThisActor.Pos = self.PinPoint
	
	--local pos = self.ThisActor.Pos + Vector(0,-34)
	local pos = self.ThisActor.Pos + Vector(0,-130)
	
	self.SkillTargetActor = nil
	
	-- Detect nearby target actor
	if self.ActiveMenu[self.SelectedMenuItem]["ActorDetectRange"] ~= nil then
		local dist = self.ActiveMenu[self.SelectedMenuItem]["ActorDetectRange"]
		local a = nil

		for actor in MovableMan.Actors do
			local brainonly = false
			
			if self.ActiveMenu[self.SelectedMenuItem]["AffectsBrains"] ~= nil and self.ActiveMenu[self.SelectedMenuItem]["AffectsBrains"] == true then
				brainonly = true
			end
		
			local acceptable = true
			
			if brainonly then
				if actor:IsInGroup("Brains") then
					acceptable = true
				else
					acceptable = false
				end
			else
				if actor:IsInGroup("Brains") then
					acceptable = false
				else
					acceptable = true
				end
			end
		
			if actor.Team == self.ThisActor.Team and (actor.ClassName == "AHuman" or actor.ClassName == "ACrab") and acceptable then
				local d = CF_Dist(self.ThisActor.Pos, actor.Pos)
				if d <= dist then
					a = actor;
					dist = d
				end
			end
		end
		
		if a ~= nil then
			self.SkillTargetActor = a
			
			if self.BlinkTimer:IsPastSimMS(500) then
				self.SkillTargetActor:FlashWhite(25)
				self.BlinkTimer:Reset()
			end
		end
	end
	
	local cont = self.ThisActor:GetController()
	if cont:IsState(Controller.PRESS_UP) then
		cont:SetState(Controller.PRESS_UP, false)
		cont:SetState(Controller.MOVE_UP, false)
		cont:SetState(Controller.BODY_JUMPSTART, false)
		cont:SetState(Controller.BODY_JUMP, false)

		self.SelectedMenuItem = self.SelectedMenuItem - 1
		if self.SelectedMenuItem < 1 then
			self.SelectedMenuItem = 1
		end		
	end

	if cont:IsState(Controller.PRESS_DOWN) then
		cont:SetState(Controller.PRESS_DOWN, false)
		cont:SetState(Controller.MOVE_DOWN, false)
		cont:SetState(Controller.BODY_CROUCH, false)

		self.SelectedMenuItem = self.SelectedMenuItem + 1
		if self.SelectedMenuItem > #self.ActiveMenu then
			self.SelectedMenuItem = #self.ActiveMenu
		end		
	end
	
	self.MenuItemsListStart = self.SelectedMenuItem - (self.SelectedMenuItem - 1) % 6
	
	-- Show price if item will be nanolyzed
	if 	self.NanolyzeItem ~= nil then
		self.Skills[self.NanolyzeItem]["Count"] = "EMPTY"
	
		if self.ThisActor.EquippedItem ~= nil then
			local mass = self.ThisActor.EquippedItem.Mass
			local convert = self.SplitterLevel * CF_QuantumSplitterEffectiveness
			local matter = math.floor(mass * convert)
			
			if self.QuantumStorage + matter > self.QuantumCapacity then
				matter = self.QuantumCapacity - self.QuantumStorage
			end
			self.Skills[self.NanolyzeItem]["Count"] = "+"..matter
			
			if self.QuantumStorage == self.QuantumCapacity then
				self.Skills[self.NanolyzeItem]["Count"] = "MAX"
			end
		end
	end

	-- Draw background
	VoidWanderersRPG_AddEffect(pos + Vector(0,27), "ControlPanel_Skills")	
	
	-- Draw skills menu
	if self.ActiveMenu == nil or #self.ActiveMenu == 0 then
		local s = "NO SKILLS"
		local l = CF_GetStringPixelWidth(s)
		
		CF_DrawString(s, pos + Vector(-l / 2, -80), 100 , 8)
	else
		for i = self.MenuItemsListStart, self.MenuItemsListStart + 6 - 1 do
			if i <= #self.ActiveMenu then
				local s = self.ActiveMenu[i]["Text"]
				
				if self.ActiveMenu[i]["Count"] ~= nil and self.ActiveMenu[i]["Count"] ~= -1 then
					s = s .." "..self.ActiveMenu[i]["Count"]
				end
			
				if i == self.SelectedMenuItem then
					CF_DrawString("> "..s, pos + Vector(-50, (i - self.MenuItemsListStart) * 10), 150 , 8)
				else
					CF_DrawString(s, pos + Vector(-50, (i - self.MenuItemsListStart) * 10), 150 , 8)
				end
			end
		end
	end
	
	if cont:IsState(Controller.WEAPON_FIRE) then
		cont:SetState(Controller.WEAPON_FIRE, false)
		
		if not self.FirePressed then
			self.FirePressed = true;
			
			-- Execute skill function
			if self.ActiveMenu[self.SelectedMenuItem]["Function"] ~= nil then
				self.ActiveMenu[self.SelectedMenuItem]["Function"](self)
			end
			
			if self.ActiveMenu[self.SelectedMenuItem]["SubMenu"] ~= nill then
				self.ActiveMenu = self.ActiveMenu[self.SelectedMenuItem]["SubMenu"]
				self.SelectedMenuItem = 1
			end
		end
	else
		self.FirePressed = false
	end
end

function rpgbrain_skill_heal(self)
	if self.ActiveMenu[self.SelectedMenuItem]["Count"] > 0 then
		if self.SkillTargetActor ~= nil and MovableMan:IsActor(self.SkillTargetActor) and self.SkillTargetActor.Health > 0 then
			self.ActiveMenu[self.SelectedMenuItem]["Count"] = self.ActiveMenu[self.SelectedMenuItem]["Count"] - 1

			local presets, classes
			if self.SkillTargetActor.ClassName == "AHuman" then
				presets, classes = CF_GetInventory(self.SkillTargetActor)
			end
			local preset = self.SkillTargetActor.PresetName
			local class = self.SkillTargetActor.ClassName
			local pos = Vector(self.SkillTargetActor.Pos.X, self.SkillTargetActor.Pos.Y)
			local mode = self.SkillTargetActor.AIMode
			
			self.SkillTargetActor.Pos = Vector(0,-1000)
			self.SkillTargetActor.ToDelete = true
			self.SkillTargetActor = nil
			
			local actor = CF_MakeActor2(preset,class)
			if actor then
				actor.Pos = pos
				actor.Team = self.ThisActor.Team
				actor.AIMode = mode
				
				if actor.ClassName == "AHuman" then
					for i = 1, #presets do
						local itm = CF_MakeItem2(presets[i], classes[i])
						if itm then
							actor:AddInventoryItem(itm)
						end
					end
				end
				
				MovableMan:AddActor(actor)
			end
		end
	end
end

function rpgbrain_skill_repair(self)
	if self.ActiveMenu[self.SelectedMenuItem]["Count"] > 0 then
		if self.ThisActor.EquippedItem ~= nil then
			local preset = self.ThisActor.EquippedItem.PresetName
			local class = self.ThisActor.EquippedItem.ClassName
			
			self.ThisActor.EquippedItem.ToDelete = true;
			
			local newgun = CF_MakeItem2(preset, class)
			if newgun then
				self.ThisActor:AddInventoryItem(newgun)
				self.ThisActor:GetController():SetState(Controller.WEAPON_CHANGE_PREV,true);
			end
		end
	end
end

function rpgbrain_skill_split(self)
	if self.ThisActor.EquippedItem ~= nil then
		if self.QuantumStorage < self.QuantumCapacity then
			local mass = self.ThisActor.EquippedItem.Mass
			local convert = self.SplitterLevel * CF_QuantumSplitterEffectiveness
			local matter = math.floor(mass * convert)
			
			self.QuantumStorage = self.QuantumStorage + matter
			if self.QuantumStorage > self.QuantumCapacity then
				self.QuantumStorage = self.QuantumCapacity
			end

			CF_GS["Brain".. self.BrainNumber .."QuantumStorage"] = self.QuantumStorage
			self.Skills[self.QuantumStorageItem]["Count"] = self.QuantumStorage
			
			self.ThisActor.EquippedItem.ToDelete = true;
			self.ThisActor:GetController():SetState(Controller.WEAPON_CHANGE_PREV, true);
		end
	end
end

function rpgbrain_skill_synthesize(self)
	if self.QuantumStorage >= self.ActiveMenu[self.SelectedMenuItem]["Price"] then
		local preset = self.ActiveMenu[self.SelectedMenuItem]["Preset"]
		local class = self.ActiveMenu[self.SelectedMenuItem]["Class"]
		local module = self.ActiveMenu[self.SelectedMenuItem]["Module"]
		
		local newgun = CF_MakeItem(preset, class, module)
		if newgun then
			self.ThisActor:AddInventoryItem(newgun)
			self.ThisActor:GetController():SetState(Controller.WEAPON_CHANGE_PREV, true);
		end
		
		self.QuantumStorage = self.QuantumStorage - self.ActiveMenu[self.SelectedMenuItem]["Price"]
		
		CF_GS["Brain".. self.BrainNumber .."QuantumStorage"] = self.QuantumStorage
		self.Skills[self.QuantumStorageItem]["Count"] = self.QuantumStorage
	end
end

function rpgbrain_skill_scanner(self)
	self.ScanEnabled = not self.ScanEnabled
end

function CF_GetAvailableQuantumItems(c)
	local arr = {}

	for i = 1, #CF_QuantumItems do
		local id = CF_QuantumItems[i]
		
		if c["QuantumItemUnlocked_"..id] == "True" then
			local n = #arr + 1
			arr[n] = {}
			arr[n]["ID"] = id
			arr[n]["Preset"] = CF_QuantumItmPresets[id]
			arr[n]["Class"] = CF_QuantumItmClasses[id]
			arr[n]["Module"] = CF_QuantumItmModules[id]
			arr[n]["Price"] = math.ceil(CF_QuantumItmPrices[id] / 2)
		end
	end
	
	return arr
end

function CF_UnlockRandomQuantumItem(c)
	local id = CF_QuantumItems[ math.random(#CF_QuantumItems) ]
	
	c["QuantumItemUnlocked_"..id] = "True"
	
	return id;
end
