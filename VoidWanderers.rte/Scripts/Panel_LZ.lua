-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:InitLZControlPanelUI()
	self.LZControlPanelActor = {}

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
	if self.LZControlPanelActor == nil then
		return 
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
	
	for plr = 0, self.PlayerCount - 1 do
		local act = self:GetControlledActor(plr);
	
		if MovableMan:IsActor(act) and act.PresetName == "LZ Control Panel" then
			local cont = act:GetController()
			local pos = act.Pos
			
			local safe = false
			
			local enemies = 0
			local friends = 0
			local unsafefriends = 0
			
			local targets = {}
			local unsafe = {}
			
			for actor in MovableMan.Actors do
				if actor.PresetName ~= "-" and (actor.ClassName == "AHuman" or actor.ClassName == "ACrab") then
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
							if actor.PresetName == "-" then
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
					for i = 1, CF_MaxMissionReportLines do
						self.GS["MissionReport"..i] = nil
					end					
					
					for i = 1, #self.MissionReport do
						self.GS["MissionReport"..i] = self.MissionReport[i]
					end
					
					local scene = CF_VesselScene[self.GS["Player0Vessel"]]
					-- Set new operating mode
					self.GS["Mode"] = "Vessel"
					self.GS["SceneType"] = "Vessel"
					self.GS["WasReset"] = "False"
					
					self:SaveCurrentGameState();
					
					self:LaunchScript(scene, "Tactics.lua")
					self.EnableBrainSelection = false
					self:DestroyLZControlPanelUI()
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
		end
	end
end
