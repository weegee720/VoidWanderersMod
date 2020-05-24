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
			CF_DrawString("RETURN",self.LZControlPanelPos[i] + Vector(-16,0),120,20 )
		end
	end
	
	for plr = 0, self.PlayerCount - 1 do
		local act = self:GetControlledActor(plr);
	
		if MovableMan:IsActor(act) and act.PresetName == "LZ Control Panel" then
			local cont = act:GetController()
			local pos = act.Pos
			
			self:PutGlow("ControlPanel_LZ_Button", pos)
			
			if cont:IsState(Controller.WEAPON_FIRE) then
				if self.ControlPanelLZPressTime ==nil then
					self.ControlPanelLZPressTime = self.Time
				end
				CF_DrawString("RETURN IN T-" ..tostring(self.ControlPanelLZPressTime + CF_TeamReturnDelay - self.Time) , pos + Vector(-30, -10), 130, 20)
				
				-- Return to ship
				if self.ControlPanelLZPressTime + CF_TeamReturnDelay - self.Time then
					self.DeployedActors = {}
				
					for actor in MovableMan.Actors do
						if actor.Team == CF_PlayerTeam then
							local assignable = true
							local f = CF_GetPlayerFaction(self.GS, 0)
							
							if CF_UnassignableUnits[f] ~= nil then
								for i = 1, #CF_UnassignableUnits[f] do
									if actor.PresetName == CF_UnassignableUnits[f][i] then
										assignable = false
									end
								end
							end
						
							if assignable and actor.PresetName ~= "LZ Control Panel" and (actor.ClassName == "AHuman" or actor.ClassName == "ACrab") then
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
					
					local scene = CF_VesselScene[self.GS["Player0Vessel"]]
					-- Set new operating mode
					self.GS["Mode"] = "Vessel"
					self.GS["SceneType"] = "Vessel"					

					self:SaveCurrentGameState();
					
					self:LaunchScript(scene, "Tactics.lua")
					self.EnableBrainSelection = false
					self:DestroyLZControlPanelUI()
					return
				end
			else
				CF_DrawString("HOLD FIRE TO RETURN", pos + Vector(-54, -10), 130, 20)
				self.ControlPanelLZPressTime = nil
			end
		end
	end
end
