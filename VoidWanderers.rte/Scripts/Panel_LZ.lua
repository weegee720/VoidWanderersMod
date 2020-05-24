-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:InitLZControlPanelUI()
	self.LZControlPanelActor = {}

	self.BombsControlPanelInBombMode = false

	self.BombsControlPanelItemsPerPage = 3
	self.LastKnownBombingPosition = nil
	
	self.BombsControlPanelModes = {RETURN = 0, BOMB = 1}
	self.BombsControlPanelSelectedModes = {}

	-- Reset bombing state
	self.BombingTarget = nil
	self.BombingStart = nil
	self.BombingLoadTime = nil
	self.BobmingRange = nil
	
	for plr = 0 , self.PlayerCount - 1 do
		-- Create actor
		if not MovableMan:IsActor(self.LZControlPanelActor[plr + 1]) then
			self.LZControlPanelActor[plr + 1] = CreateActor("LZ Control Panel")
			--self.LZControlPanelActor[plr + 1] = CreateActor("Brain Case")
			if self.LZControlPanelActor[plr + 1] ~= nil then
				self.LZControlPanelActor[plr + 1].Pos = self.LZControlPanelPos[plr + 1]
				self.LZControlPanelActor[plr + 1].Team = CF_PlayerTeam
				MovableMan:AddActor(self.LZControlPanelActor[plr + 1])
			end
			self.BombsControlPanelSelectedModes[plr + 1] = self.BombsControlPanelModes.RETURN
		end
		--print (self.LZControlPanelActor[plr + 1])
	end
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:DestroyLZControlPanelUI()
	for plr = 0 , self.PlayerCount - 1 do
		-- Create actor
		if MovableMan:IsActor(self.LZControlPanelActor[plr + 1]) then
			self.LZControlPanelActor[plr + 1].ToDelete = true
		end
	end
	
	self.LZControlPanelActor = nil
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:ProcessLZControlPanelUI()
	if self.LZControlPanelActor == nil or self.ActivityState == Activity.OVER then
		return 
	end

	-- Process bombing UI
	self:ProcessBombsControlPanelUI()
	
	-- And process bombing itself
	if self.BombingTarget ~= nil then
		if self.Time > self.BombingStart + self.BombingLoadTime + CF_BombFlightInterval then
			if self.Time > self.BombingLastBombShot + CF_BombInterval then
				self.BombingLastBombShot = self.Time

				self.BombsControlPanelInBombMode = true
				
				-- Launch bombs
				for i = 1, tonumber(self.GS["Player0VesselBombBays"]) do
					--print (self.BombPayload[self.BombingCount]["Preset"])
					--print (self.BombPayload[self.BombingCount]["Class"])
					
					local bombpos = Vector(self.BombingTarget - self.BobmingRange / 2 + math.random(self.BobmingRange), -40)
					
					local bomb = CF_MakeItem2(self.BombPayload[self.BombingCount]["Preset"], self.BombPayload[self.BombingCount]["Class"])
					if bomb then
						bomb.Pos = bombpos
						MovableMan:AddItem(bomb)
					end
					
					-- Place special actor so the bombs can detect the fake dropship that drops them launches
					-- Fake dropship will delete itself after 250 ms
					local dropship = CreateACDropShip("Fake Drop Ship MK1", self.ModuleName)
					if dropship then
						dropship.Team = CF_PlayerTeam
						dropship.Pos = bombpos + Vector(0,-20)
						MovableMan:AddActor(dropship)
					else
						print ("ERR: Dropship not created")
					end
				
					self.BombingCount = self.BombingCount + 1
					if self.BombingCount > #self.BombPayload then
						break
					end
				end

				-- Alert all enemy units in target area when bombs fall
				if self.BombingCount == 2 and #self.BombPayload > 1 then
					for actor in MovableMan.Actors do
						if actor.Team ~= CF_PlayerTeam and not actor:IsInGroup("Brains") and actor.AIMode == Actor.AIMODE_SENTRY and (actor.ClassName == "AHuman" or actor.ClassName == "ACrab") then
							local d = CF_Dist(actor.Pos, self.LastKnownBombingPosition)
							
							if d < self.BobmingRange * 1.5 then
								actor.AIMode = Actor.AIMODE_BRAINHUNT
							end
						end
					end
				end
				
				-- Bombing over, clean everything
				if self.BombingCount > #self.BombPayload then
					self:DestroyBombsControlPanelUI()

					self.BombingTarget = nil
					self.BombingStart = nil
					self.BombingLoadTime = nil
					self.BobmingRange = nil
					self.BombingCount = nil
					self.BombsControlPanelInBombMode = false
				end
			end
		end
	end
	
	-- Re-create dead LZs
	for plr = 0 , self.PlayerCount - 1 do
		if not MovableMan:IsActor(self.LZControlPanelActor[plr + 1]) then
			self.LZControlPanelActor[plr + 1] = CreateActor("LZ Control Panel")

			if self.LZControlPanelActor[plr + 1] ~= nil then
				self.LZControlPanelActor[plr + 1].Pos = self.LZControlPanelPos[plr + 1]
				self.LZControlPanelActor[plr + 1].Team = CF_PlayerTeam
				MovableMan:AddActor(self.LZControlPanelActor[plr + 1])
			end
		end		
	end
	
	for i = 1, #self.LZControlPanelActor do
		local showidle = true
	
		for plr = 0, self.PlayerCount - 1 do
			local act = self:GetControlledActor(plr);
		
			if MovableMan:IsActor(act) and act.PresetName == "LZ Control Panel" and act.ID == self.LZControlPanelActor[i].ID then
				showidle = false
			end
		end
	
		if showidle then
			self:PutGlow("ControlPanel_LZ", self.LZControlPanelPos[i])
			--CF_DrawString("RETURN",self.LZControlPanelPos[i] + Vector(-13,0),120,20 )
		end
	end
	
	local anypanelselected = false
	
	for plr = 0, self.PlayerCount - 1 do
		local act = self:GetControlledActor(plr);
	
		if MovableMan:IsActor(act) and act.PresetName == "LZ Control Panel" then
			local cont = act:GetController()
			local pos = act.Pos
			local selectedpanel = 0
			anypanelselected = true
			
			for i = 1, self.PlayerCount do
				if act.Pos.X == self.LZControlPanelActor[i].Pos.X and act.Pos.Y == self.LZControlPanelActor[i].Pos.Y then
					selectedpanel = i
				end
			end
			
			if self.BombsControlPanelSelectedModes[selectedpanel] == self.BombsControlPanelModes.RETURN then
				local safe = false
				
				local enemies = 0
				local friends = 0
				local unsafefriends = 0
				
				local targets = {}
				local unsafe = {}
				
				for actor in MovableMan.Actors do
					if not self:IsAlly(actor) and (actor.ClassName == "AHuman" or actor.ClassName == "ACrab") then
						if actor.Team ~= CF_PlayerTeam then
							enemies = enemies + 1
							targets[#targets + 1] = actor.Pos
						else
							friends = friends + 1
							
							for i = 1, #self.LZControlPanelPos do
								if CF_Dist(actor.Pos, self.LZControlPanelPos[i]) > CF_EvacDist then
									unsafefriends = unsafefriends + 1
									unsafe[#unsafe + 1] = actor.Pos
								end
							end
						end
					end
				end
				
				if enemies == 0 or friends / 4 > enemies then
					safe = true
				end
				
				if safe then
					self:PutGlow("ControlPanel_LZ_Button", pos)
				else
					self:PutGlow("ControlPanel_LZ_ButtonRed", pos)
					if unsafefriends > 0 then
						local s = "";
						
						if unsafefriends > 1 then
							s = "S"
						end
					
						CF_DrawString("AND ABANDON "..unsafefriends.." UNIT"..s , pos + Vector(-54, 4), 130, 20)
					end
					
					if self.Time % 2 == 0 then
						-- Show hostiles to indicate that they prevent from returning safely
						for i = 1, #targets do
							self:AddObjectivePoint("HOSTILE", targets[i] + Vector(0,-40), CF_PlayerTeam, GameActivity.ARROWDOWN);
						end
					else
						-- Show hostiles to indicate that they prevent from returning safely
						for i = 1, #unsafe do
							self:AddObjectivePoint("ABANDONED", unsafe[i] + Vector(0,-40), CF_PlayerTeam, GameActivity.ARROWDOWN);
						end
					end
				end

				if cont:IsState(Controller.PRESS_LEFT) then
					self.BombsControlPanelSelectedModes[selectedpanel] = self.BombsControlPanelSelectedModes[selectedpanel] - 1

					if self.BombsControlPanelSelectedModes[selectedpanel] < self.BombsControlPanelModes.RETURN then
						self.BombsControlPanelSelectedModes[selectedpanel] = self.BombsControlPanelModes.BOMB
					end
					
					if self.BombsControlPanelSelectedModes[selectedpanel] == self.BombsControlPanelModes.BOMB then
						if self.BombsControlPanelInBombMode or CF_IsLocationHasAttribute(self.GS["Location"], CF_LocationAttributeTypes.NOBOMBS) then
							self.BombsControlPanelSelectedModes[selectedpanel] = self.BombsControlPanelSelectedModes[selectedpanel] - 1
						end
					end
				end

				if cont:IsState(Controller.PRESS_RIGHT) then
					self.BombsControlPanelSelectedModes[selectedpanel] = self.BombsControlPanelSelectedModes[selectedpanel] + 1

					if self.BombsControlPanelSelectedModes[selectedpanel] == self.BombsControlPanelModes.BOMB then
						if self.BombsControlPanelInBombMode or CF_IsLocationHasAttribute(self.GS["Location"], CF_LocationAttributeTypes.NOBOMBS) then
							self.BombsControlPanelSelectedModes[selectedpanel] = self.BombsControlPanelSelectedModes[selectedpanel] + 1
						end
					end
					
					if self.BombsControlPanelSelectedModes[selectedpanel] > self.BombsControlPanelModes.BOMB then
						self.BombsControlPanelSelectedModes[selectedpanel] = self.BombsControlPanelModes.RETURN
					end
				end
				
				if cont:IsState(Controller.WEAPON_FIRE) then
					if self.ControlPanelLZPressTime ==nil then
						self.ControlPanelLZPressTime = self.Time
					end
					CF_DrawString("RETURN IN T-" ..tostring(self.ControlPanelLZPressTime + CF_TeamReturnDelay - self.Time) , pos + Vector(-30, -10), 130, 20)
					
					-- Return to ship
					if self.ControlPanelLZPressTime + CF_TeamReturnDelay == self.Time then
						self.DeployedActors = {}
						
						-- Bring back actors
						for actor in MovableMan.Actors do
							if actor.Team == CF_PlayerTeam then
								local assignable = true
								local f = CF_GetPlayerFaction(self.GS, 0)
								
								-- Check if unit is playable
								if CF_UnassignableUnits[f] ~= nil then
									for i = 1, #CF_UnassignableUnits[f] do
										if actor.PresetName == CF_UnassignableUnits[f][i] then
											assignable = false
										end
									end
								end
								
								-- Don't bring back allied units
								if self:IsAlly(actor) then
									assignable = false
								end
								
								-- Check if unit is safe
								local actorsafe = true
								if not safe then
									for i = 1, #self.LZControlPanelPos do
										if CF_Dist(actor.Pos, self.LZControlPanelPos[i]) > CF_EvacDist then
											actorsafe = false
										end
									end
								end
							
								if actorsafe and assignable and actor.PresetName ~= "LZ Control Panel" and (actor.ClassName == "AHuman" or actor.ClassName == "ACrab") then
									local pre, cls = CF_GetInventory(actor)
									-- These actors must be deployed
									local n =  #self.DeployedActors + 1
									self.DeployedActors[n] = {}
									self.DeployedActors[n]["Preset"] = actor.PresetName
									self.DeployedActors[n]["Class"] = actor.ClassName
									self.DeployedActors[n]["InventoryPresets"] = pre
									self.DeployedActors[n]["InventoryClasses"] = cls
									--print (#pre)
								end
							end
						end

						if self.MissionAvailable and self.MissionFailed then
							self:GiveMissionPenalties()
						end

						if self.MissionAvailable then
							-- Generate new missions
							CF_GenerateRandomMissions(self.GS)
						end
						
						-- Update casualties report
						if self.MissionDeployedTroops > #self.DeployedActors then
							local s = ""
							if self.MissionDeployedTroops - #self.DeployedActors > 1 then
								s = "S"
							end
							
							if #self.DeployedActors == 0 then
								self.MissionReport[#self.MissionReport + 1] = "ALL UNIT"..s.." LOST"
							else
								self.MissionReport[#self.MissionReport + 1] = tostring(self.MissionDeployedTroops - #self.DeployedActors) .. " UNIT"..s.." LOST"
							end
						else
							self.MissionReport[#self.MissionReport + 1] = "NO CASUALTIES"
						end
						
						-- Collect items
						if safe then
							local itemcount = 0
							local storage = CF_GetStorageArray(self.GS, false)
							
							for item in MovableMan.Items do
								local count = CF_CountUsedStorageInArray(storage)
		
								if  count < tonumber(self.GS["Player0VesselStorageCapacity"]) then
									CF_PutItemToStorageArray(storage, item.PresetName, item.ClassName)
									itemcount = itemcount + 1
								else
									break
								end
							end
						
							CF_SetStorageArray(self.GS, storage)
							
							if itemcount > 0 then
								local s = ""
								if itemcount > 1 then
									s = "s"
								end
							
								self.MissionReport[#self.MissionReport + 1] = tostring(itemcount).." item"..s.." collected"
							end
						end
						
						-- Save fog of war
						if CF_FogOfWarEnabled then
							self:SaveFogOfWarState(self.GS)
						end
						
						-- Dump mission report to config to be saved 
						CF_SaveMissionReport(self.GS, self.MissionReport)
						
						local scene = CF_VesselScene[self.GS["Player0Vessel"]]
						-- Set new operating mode
						self.GS["Mode"] = "Vessel"
						self.GS["SceneType"] = "Vessel"
						self.GS["WasReset"] = "False"
						
						self:SaveCurrentGameState();
						
						self:LaunchScript(scene, "Tactics.lua")
						self.EnableBrainSelection = false
						self:DestroyLZControlPanelUI()
						
						-- Destroy mission and ambient specific objects
						if self.AmbientDestroy ~= nil then
							self:AmbientDestroy()
						end

						if self.MissionDestroy ~= nil then
							self:MissionDestroy()
						end
						
						-- Clean everything
						self.MissionCreate = nil
						self.MissionUpdate = nil
						self.MissionDestroy = nil

						self.AmbientCreate = nil
						self.AmbientUpdate = nil
						self.AmbientDestroy = nil
						
						collectgarbage("collect");
						return
					end
				else
					CF_DrawString("HOLD FIRE TO RETURN", pos + Vector(-50, -10), 130, 20)
					self.ControlPanelLZPressTime = nil
				end
				
				if self.MissionStatus ~= nil then
					local l = CF_GetStringPixelWidth(self.MissionStatus)
					CF_DrawString(self.MissionStatus, pos + Vector(-l/2, 16), 130, 25)
				end
			elseif self.BombsControlPanelSelectedModes[selectedpanel] == self.BombsControlPanelModes.BOMB then
				if not self.BombsControlPanelInBombMode then
					self.BombsControlPanelSelectedItem = 1
					
					self.Bombs = CF_GetBombsArray(self.GS)
					n = #self.Bombs + 1
					self.Bombs[n] = {}
					self.Bombs[n]["Preset"] = "Request orbital strike"
					self.Bombs[n]["Class"] = ""
					self.Bombs[n]["Count"] = 0
					
					self.BombPayload = {}
				end
				
				self.BombsControlPanelInBombMode = true

				if cont:IsState(Controller.PRESS_UP) then
					if self.BombsControlPanelSelectedItem > 1 then
						self.BombsControlPanelSelectedItem = self.BombsControlPanelSelectedItem - 1
					end
				end

				if cont:IsState(Controller.PRESS_DOWN) then
					if self.BombsControlPanelSelectedItem < #self.Bombs then
						self.BombsControlPanelSelectedItem = self.BombsControlPanelSelectedItem + 1
					end
				end

				if cont:IsState(Controller.PRESS_LEFT) then
					self.BombsControlPanelInBombMode = false
					self.BombsControlPanelSelectedModes[selectedpanel] = self.BombsControlPanelSelectedModes[selectedpanel] - 1

					if self.BombsControlPanelSelectedModes[selectedpanel] < self.BombsControlPanelModes.RETURN then
						self.BombsControlPanelSelectedModes[selectedpanel] = self.BombsControlPanelModes.BOMB
					end
				end

				if cont:IsState(Controller.PRESS_RIGHT) then
					self.BombsControlPanelInBombMode = false
					self.BombsControlPanelSelectedModes[selectedpanel] = self.BombsControlPanelSelectedModes[selectedpanel] + 1
					
					if self.BombsControlPanelSelectedModes[selectedpanel] > self.BombsControlPanelModes.BOMB then
						self.BombsControlPanelSelectedModes[selectedpanel] = self.BombsControlPanelModes.RETURN
					end
				end
				
				if cont:IsState(Controller.WEAPON_FIRE) then
					if not self.FirePressed then
						self.FirePressed = true;
						
						if self.Bombs[self.BombsControlPanelSelectedItem] ~= nil then
							if self.Bombs[self.BombsControlPanelSelectedItem]["Preset"] == "Request orbital strike" and #self.BombPayload > 0 then
								-- Start targeting
								self.BombsControlPanelSelectedModes[selectedpanel] = self.BombsControlPanelModes.RETURN
								self:InitBombsControlPanelUI()
								if MovableMan:IsActor(self.BombsControlPanelActor) then
									-- Remove orbital strike option from bombs array because bombing actor will commit changes made here
									self.Bombs[#self.Bombs] = nil
								
									--print (self.LastKnownBombingPosition)
									if self.LastKnownBombingPosition == nil then
										self.BombsControlPanelActor.Pos = Vector(pos.X, 0)
									else
										self.BombsControlPanelActor.Pos = self.LastKnownBombingPosition
									end
									
									self:SwitchToActor(self.BombsControlPanelActor, plr, CF_PlayerTeam);
									return
								else
									print ("ERROR: Bomb control actor not created!")
								end
							else
								-- Add bomb to payload
								if self.Bombs[self.BombsControlPanelSelectedItem]["Count"] > 0 and #self.BombPayload < tonumber(self.GS["Player0VesselBombBays"]) * CF_BombsPerBay then
									self.Bombs[self.BombsControlPanelSelectedItem]["Count"] = self.Bombs[self.BombsControlPanelSelectedItem]["Count"] - 1
									
									local n = #self.BombPayload + 1
									self.BombPayload[n] = {}
									self.BombPayload[n]["Preset"] = self.Bombs[self.BombsControlPanelSelectedItem]["Preset"]
									self.BombPayload[n]["Class"] = self.Bombs[self.BombsControlPanelSelectedItem]["Class"]
								end
							end
						end
					end
				else
					self.FirePressed = false
				end
				
				self.BombControlPanelListStart = self.BombsControlPanelSelectedItem - (self.BombsControlPanelSelectedItem - 1) % self.BombsControlPanelItemsPerPage

				self:PutGlow("ControlPanel_LZ_Button", pos)			

				CF_DrawString("PAYLOAD: ", pos + Vector(-40,-8) + Vector(0, - 10), 120, 10)
				CF_DrawString(tostring(#self.BombPayload).." / " .. self.GS["Player0VesselBombBays"] * CF_BombsPerBay, pos + Vector(20,-8) + Vector(0, - 10), 120, 10)
				
				-- Draw list
				for i = self.BombControlPanelListStart, self.BombControlPanelListStart + self.BombsControlPanelItemsPerPage - 1 do
					if i <= #self.Bombs and i > 0 then
						local loc = i - self.BombControlPanelListStart
						
						if i == self.BombsControlPanelSelectedItem then
							CF_DrawString("> "..self.Bombs[i]["Preset"], pos + Vector(-60,-8) + Vector(0, (loc) * 12), 130, 10)
						else
							CF_DrawString(self.Bombs[i]["Preset"], pos + Vector(-60,-8) + Vector(0, (loc) * 12), 130, 10)
						end
						if self.Bombs[i]["Preset"] ~= "Request orbital strike" then
							CF_DrawString(tostring(self.Bombs[i]["Count"]), pos + Vector(56,-8) + Vector(0, (loc) * 12), 120, 10)
						end
					end
				end
			end
		end
	end
	
	-- Reset panel states when they are not selected
	if not anypanelselected and self.BombsControlPanelActor == nil then
		self.BombsControlPanelInBombMode = false

		for plr = 0 , self.PlayerCount - 1 do
			self.BombsControlPanelSelectedModes[plr + 1] = self.BombsControlPanelModes.RETURN
		end
	end
end
