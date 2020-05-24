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
		if G_VW_Active[i] and MovableMan:IsActor(G_VW_Shields[i]) and G_VW_Shields[i].Health > 0 and G_VW_Shields[i]:IsInGroup("Brains") and string.find(G_VW_Shields[i].PresetName ,"RPG Brain Robot") ~= nil then
			n = #shields + 1
		
			shields[n] = G_VW_Shields[i]
			active[n] = true
			
			rads[n] = G_VW_ShieldRadius - G_VW_Pressure[i] / 10
			
			if rads[n] < 0 then
				rads[n] = 0
			end
			
			if G_VW_Pressure[i] > 7 and rads[n] > 5 then
				for i = 1, 4 do
					local a = math.random(360) / (180 / 3.14)
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
	
	for p in MovableMan.Particles do
		if p.HitsMOs and p.Vel.Magnitude >= G_VW_MinVelocity then
			for i = 1, #G_VW_Shields do
				s = G_VW_Shields[i]
				pr = G_VW_Pressure[i]
			
				if G_VW_Active[i] then
					if G_VW_Shields[i].Team ~= p.Team then
						dist = SceneMan:ShortestDistance(s.Pos , p.Pos,true).Magnitude
						
						radius = rads[i]
					
						if dist <= radius and dist > radius * 0.50 then
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
						
							p.Vel = p.Vel - Vector(p.Vel.X * 0.75, p.Vel.Y * 0.75)
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
	end
end