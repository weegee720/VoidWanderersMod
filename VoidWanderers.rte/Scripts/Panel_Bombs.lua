-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:InitBombsControlPanelUI()
	local count = tonumber(self.GS["Player0VesselBombs"])

	self.BombsControlPanelPos = {}
	
	for i = 1, count do
		local x = tonumber(self.GS["Bomb"..i.."X"])
		local y = tonumber(self.GS["Bomb"..i.."Y"])
	
		if x ~= nil and  y~= nil then
			self.BombsControlPanelPos[i] = Vector(x, y)
		else
			self.BombsControlPanelPos[i] = self.AwayTeamPos[i]
		end
	end

	self.BombsControlPanelActor = {}
	
	for i = 1, count do
		if not MovableMan:IsActor(self.BombsControlPanelActor[i]) then
			self.BombsControlPanelActor[i] = CreateActor("Bomb Control Panel")
			if self.BombsControlPanelActor[i] ~= nil then
				self.BombsControlPanelActor[i].Pos = self.BombsControlPanelPos[i]
				self.BombsControlPanelActor[i].Team = CF_PlayerTeam
				MovableMan:AddActor(self.BombsControlPanelActor[i])
			end
		else
			--print (self.BombsControlPanelActor)
		end
	end

	self.BombsControlPanelEditMode = {}
	self.BombsControlPanelInitialized = {}
	for i = 1, count do
		self.BombsControlPanelEditMode[i] = false
		self.BombsControlPanelInitialized[i] = false
	end
	
	self.Bombs = CF_GetBombsArray(self.GS)
	self.BombsControlPanelLinesPerPage = 4
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:DestroyBombsControlPanelUI()
	local count = tonumber(self.GS["Player0VesselBombs"])
	for i = 1, count do
		if self.BombsControlPanelActor[i] ~= nil and MovableMan:IsActor(self.BombsControlPanelActor[i]) then
			self.BombsControlPanelActor[i].ToDelete = true
			self.BombsControlPanelActor[i] = nil
		end
	end
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:ProcessBombsControlPanelUI()
	local count = tonumber(self.GS["Player0VesselBombs"])

	for turr = 1, count do
		if MovableMan:IsActor(self.BombsControlPanelActor[turr]) then
			local showidle = true
			local empty = true
			
			if self.GS["DeployedBomb"..turr.."Preset"] ~= nil then
				empty = false
			end
			
			for plr = 0 , self.PlayerCount - 1 do
				local act = self:GetControlledActor(plr);
			
				if MovableMan:IsActor(act) and act.Pos.X == self.BombsControlPanelActor[turr].Pos.X and act.Pos.Y == self.BombsControlPanelActor[turr].Pos.Y and act.Age == self.BombsControlPanelActor[turr].Age then
					showidle = false
					
					local pos = self.BombsControlPanelPos[turr]
					local cont = act:GetController()
					
					if self.BombsControlPanelEditMode[turr] then
						if not self.BombsControlPanelInitialized[turr] then
							if #self.Bombs > 0 then
								self.SelectedBomb = 1
							else
								self.SelectedBomb = 0
							end
							
							self.BombsStorageSelectedItem = 1
							
							self.BombsControlPanelInitialized[turr] = true
						end

						-- Add or delete 'remove Bomb' menu item
						if self.GS["DeployedBomb"..turr.."Preset"] ~= nil then
							if self.Bombs[#self.Bombs]["Preset"] ~= "Remove Bomb" then
								local n = #self.Bombs + 1
								
								self.Bombs[n] = {}
								self.Bombs[n]["Preset"] = "Remove Bomb"
								self.Bombs[n]["Class"] = ""
								self.Bombs[n]["Count"] = 0
							end
						else
						end
						
						if cont:IsState(Controller.PRESS_UP) then
							if #self.Bombs > 0 then
								self.SelectedBomb = self.SelectedBomb - 1
								
								if self.SelectedBomb < 1 then
									self.SelectedBomb = 1
								end
							end
						end

						if cont:IsState(Controller.PRESS_DOWN) then
							if #self.Bombs > 0 then
								self.SelectedBomb = self.SelectedBomb + 1
								
								if self.SelectedBomb > #self.Bombs then
									self.SelectedBomb = #self.Bombs
								end
							end
						end
						
						if cont:IsState(Controller.WEAPON_FIRE) then
							if not self.FirePressed then
								self.FirePressed = true;
								
								if self.SelectedBomb > 0 then
									-- Remove current Bomb  if 'remove Bomb' was selected
									if self.Bombs[self.SelectedBomb]["Preset"] == "Remove Bomb" then
										if self.GS["DeployedBomb"..turr.."Preset"] ~= nil and self.GS["DeployedBomb"..turr.."Class"] ~= nil then
											if CF_CountUsedBombsInArray(self.Bombs) < tonumber(self.GS["Player0VesselBombStorage"]) then
												if self.Bombs[#self.Bombs]["Preset"] == "Remove Bomb" then
													self.Bombs[#self.Bombs] = nil
												end

												self.SelectedBomb = #self.Bombs
												
												CF_PutBombToStorageArray(self.Bombs, self.GS["DeployedBomb"..turr.."Preset"], self.GS["DeployedBomb"..turr.."Class"])

												self.GS["DeployedBomb"..turr.."Preset"] = nil
												self.GS["DeployedBomb"..turr.."Class"] = nil
												CF_SetBombsArray(self.GS, self.Bombs)
											end
										end
									else
										if self.Bombs[self.SelectedBomb]["Count"] > 0 then
											if self.GS["DeployedBomb"..turr.."Preset"] ~= nil and self.GS["DeployedBomb"..turr.."Class"] ~= nil then
												CF_PutBombToStorageArray(self.Bombs, self.GS["DeployedBomb"..turr.."Preset"], self.GS["DeployedBomb"..turr.."Class"])
											end
										
											self.GS["DeployedBomb"..turr.."Preset"] = self.Bombs[self.SelectedBomb]["Preset"]
											self.GS["DeployedBomb"..turr.."Class"] = self.Bombs[self.SelectedBomb]["Class"]
											self.Bombs[self.SelectedBomb]["Count"] = self.Bombs[self.SelectedBomb]["Count"] - 1
											
											CF_SetBombsArray(self.GS, self.Bombs)
										end
									end
								end
							end
						else
							self.FirePressed = false
						end
						
						self.BombsControlCloneListStart = self.SelectedBomb - (self.SelectedBomb - 1) % self.BombsControlPanelLinesPerPage

						local pre = self.GS["DeployedBomb"..turr.."Preset"]
						
						if self.Time % 2 == 0 then
							if pre ~= nil then
								CF_DrawString("Active: "..pre, pos + Vector(-60,-24), 136, 10)
							else
								CF_DrawString("Active: NONE", pos + Vector(-60,-24), 136, 10)
							end
						else
							CF_DrawString("Storage: "..CF_CountUsedBombsInArray(self.Bombs) .." / ".. self.GS["Player0VesselBombStorage"], pos + Vector(-60,-24), 136, 10)
						end
						
						-- Draw list
						for i = self.BombsControlCloneListStart, self.BombsControlCloneListStart + self.BombsControlPanelLinesPerPage - 1 do
							if i <= #self.Bombs and i > 0 then
								local loc = i - self.BombsControlCloneListStart
								
								if i == self.SelectedBomb then
									CF_DrawString("> "..self.Bombs[i]["Preset"], pos + Vector(-60,-8) + Vector(0, (loc) * 12), 120, 10)
								else
									CF_DrawString(self.Bombs[i]["Preset"], pos + Vector(-60,-8) + Vector(0, (loc) * 12), 120, 10)
								end
								if self.Bombs[i]["Preset"] ~= "Remove Bomb" then
									CF_DrawString(tostring(self.Bombs[i]["Count"]), pos + Vector(56,-8) + Vector(0, (loc) * 12), 120, 10)
								end
							end
						end

						self:PutGlow("ControlPanel_Bomb_Select", self.BombsControlPanelPos[turr])
					else
						local ax = 0
						local ay = 0
						
						if cont:IsState(Controller.PRESS_LEFT) then
							ax = -1
						end					

						if cont:IsState(Controller.PRESS_RIGHT) then
							ax = 1
						end					

						if cont:IsState(Controller.PRESS_UP) then
							ay = -1
						end					
						
						if cont:IsState(Controller.PRESS_DOWN) then
							ay = 1
						end					
						
						if ax ~= 0 or ay ~= 0 then
							local newpos = Vector(self.BombsControlPanelActor[turr].Pos.X + ax * 8, self.BombsControlPanelActor[turr].Pos.Y + ay * 8)
							
							--if self.Ship:IsInside(newpos) and SceneMan:GetTerrMatter(newpos.X, newpos.Y) == 0 then
							if self.Ship:IsInside(newpos) then
								self.BombsControlPanelActor[turr].Pos = newpos
								self.BombsControlPanelPos[turr] = newpos
								self.GS["Bomb"..turr.."X"] = math.floor(newpos.X)
								self.GS["Bomb"..turr.."Y"] = math.floor(newpos.Y)
							end
						end
						
						if cont:IsState(Controller.WEAPON_FIRE) then
							if not self.FirePressed then
								self.FirePressed = true;
								
								self.BombsControlPanelEditMode[turr] = true
								self.BombsControlPanelInitialized[turr] = false
							end
						else
							self.FirePressed = false
						end
						
						-- Draw background
						if empty then
							self:PutGlow("ControlPanel_Bomb_EmptyMove", self.BombsControlPanelPos[turr])
						else
							if self.GS["DeployedBomb"..turr.."Preset"] ~= nil and self.GS["DeployedBomb"..turr.."Class"] ~= nil then
								local l = CF_GetStringPixelWidth(self.GS["DeployedBomb"..turr.."Preset"])
								CF_DrawString(self.GS["DeployedBomb"..turr.."Preset"], self.BombsControlPanelPos[turr] + Vector( -l/2, -28), 120,10)
							end

							self:PutGlow("ControlPanel_Bomb_Move", self.BombsControlPanelPos[turr])
						end
					end
				end
			end
			
			if showidle then
				self.BombsControlPanelEditMode[turr] = false
				self.BombsControlPanelInitialized[turr] = false
			end
			
			if showidle and self.BombsControlPanelPos[turr] ~= nil then
				if empty then
					self:PutGlow("ControlPanel_Bomb_Empty", self.BombsControlPanelPos[turr])
				else
					self:PutGlow("ControlPanel_Bomb", self.BombsControlPanelPos[turr])
				end
			end
			
			if MovableMan:IsActor(self.BombsControlPanelActor[turr]) then
				self.BombsControlPanelActor[turr].Health = 100
			end
		end
	end
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:DeployBombs()
	self.BombsDeployedActors = {}
	local count = tonumber(self.GS["Player0VesselBombs"])

	for turr = 1, count do
		local pre = self.GS["DeployedBomb"..turr.."Preset"]
		local cls = self.GS["DeployedBomb"..turr.."Class"]
	
		if pre ~= nil and cls ~= nil then
			local a = CF_MakeActor2(pre, cls)
			if a then
				a.Team = CF_PlayerTeam
				a.Pos = self.BombsControlPanelPos[turr]
				a.AIMode = Actor.AIMODE_SENTRY
				self.BombsDeployedActors[turr] = a
				MovableMan:AddActor(a)
			else
				print ("Can't create Bomb "..pre.." "..cls)
			end
		end
	end
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:RemoveDeployedBombs()
	if self.BombsDeployedActors ~= nil then
		local count = tonumber(self.GS["Player0VesselBombs"])

		for turr = 1, count do
			if MovableMan:IsActor(self.BombsDeployedActors[turr]) then
				self.BombsDeployedActors[turr].ToDelete = true
			else
				self.GS["DeployedBomb"..turr.."Preset"] = nil
				self.GS["DeployedBomb"..turr.."Class"] = nil
			end
		end
		
		self.BombsDeployedActors = nil
	end
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
