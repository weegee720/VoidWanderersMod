-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:InitCloneShopControlPanelUI()
	-- CloneShop Control Panel
	local x,y;
			
	x = tonumber(self.LS["CloneShopControlPanelX"])
	y = tonumber(self.LS["CloneShopControlPanelY"])
	if x~= nil and y ~= nil then
		self.CloneShopControlPanelPos = Vector(x,y)
	else
		self.CloneShopControlPanelPos = nil
	end
	
	-- Create actor
	if self.CloneShopControlPanelPos ~= nil then
		if not MovableMan:IsActor(self.CloneShopControlPanelActor) then
			self.CloneShopControlPanelActor = CreateActor("Clone Shop Control Panel")
			if self.CloneShopControlPanelActor ~= nil then
				self.CloneShopControlPanelActor.Pos = self.CloneShopControlPanelPos
				self.CloneShopControlPanelActor.Team = CF_PlayerTeam
				MovableMan:AddActor(self.CloneShopControlPanelActor)
			end
		end
	end
	
	self.CloneShopControlPanelItemsPerPage = 8
	
	-- Init variables
	self.CloneShopControlPanelModes = {EVERYTHING = -1, LIGHT = 0, HEAVY = 1, ARMOR = 2, TURRET = 3}
	self.CloneShopControlPanelModesTexts = {}
	
	self.CloneShopControlPanelModesTexts[self.CloneShopControlPanelModes.EVERYTHING] = "All bodies"
	self.CloneShopControlPanelModesTexts[self.CloneShopControlPanelModes.LIGHT] = "Light bodies"
	self.CloneShopControlPanelModesTexts[self.CloneShopControlPanelModes.HEAVY] = "Heavy bodies"
	self.CloneShopControlPanelModesTexts[self.CloneShopControlPanelModes.ARMOR] = "Armored bodies"
	self.CloneShopControlPanelModesTexts[self.CloneShopControlPanelModes.TURRET] = "Turrets"
	
	self.CloneShopControlMode = self.CloneShopControlPanelModes.EVERYTHING
	
	self.CloneShopItems, self.CloneShopFilters = CF_GetCloneShopArray(self.GS, true)
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:DestroyCloneShopControlPanelUI()
	if self.CloneShopControlPanelActor ~= nil then
		self.CloneShopControlPanelActor.ToDelete = true
		self.CloneShopControlPanelActor = nil
	end
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:ProcessCloneShopControlPanelUI()
	local showidle = true

	for plr = 0 , self.PlayerCount - 1 do
		local act = self:GetControlledActor(plr);
	
		if MovableMan:IsActor(act) and act.PresetName == "Clone Shop Control Panel" then
			showidle = false

			self.LastCloneShopSelectedClone = self.CloneShopSelectedClone
			
			-- Init control panel
			if not self.CloneShopControlPanelInitialized then
				self.CloneShopSelectedClone = 1
				self.LastCloneShopSelectedClone = 0
				self.CloneShopControlPanelInitialized = true
			end
			
			-- Draw generic UI
			local pos = act.Pos
			self:PutGlow("ControlPanel_Storage_List", pos + Vector(-71,0))
			self:PutGlow("ControlPanel_CloneShop_Description", pos + Vector(90,0))
			self:PutGlow("ControlPanel_Storage_HorizontalPanel", pos + Vector(20,-77))
			self:PutGlow("ControlPanel_Storage_HorizontalPanel", pos + Vector(20,78))
			
			-- Print help text
			CF_DrawString("L/R - Change filter, U/D - Select, FIRE - Buy", pos + Vector(-130,78) , 300, 10)

			-- Process controls
			local cont = act:GetController()
			
			if cont:IsState(Controller.PRESS_UP) then
				if #self.CloneShopFilters[self.CloneShopControlMode] > 0 then
					self.CloneShopSelectedClone = self.CloneShopSelectedClone - 1
					
					if self.CloneShopSelectedClone < 1 then
						self.CloneShopSelectedClone = 1
					end
				end
			end

			if cont:IsState(Controller.PRESS_DOWN) then
				if #self.CloneShopFilters[self.CloneShopControlMode] > 0 then
					self.CloneShopSelectedClone = self.CloneShopSelectedClone + 1
					
					if self.CloneShopSelectedClone > #self.CloneShopFilters[self.CloneShopControlMode] then
						self.CloneShopSelectedClone = #self.CloneShopFilters[self.CloneShopControlMode]
					end
				end
			end

			if cont:IsState(Controller.PRESS_LEFT) then
				self.CloneShopControlMode = self.CloneShopControlMode - 1
				self.CloneShopSelectedClone = 1
				self.LastCloneShopSelectedClone = 0
				
				if self.CloneShopControlMode == -2 then
					self.CloneShopControlMode = self.CloneShopControlPanelModes.TURRET
				end
			end	

			if cont:IsState(Controller.PRESS_RIGHT) then
				self.CloneShopControlMode = self.CloneShopControlMode + 1
				self.CloneShopSelectedClone = 1
				self.LastCloneShopSelectedClone = 0
				
				if self.CloneShopControlMode == 4 then
					self.CloneShopControlMode = self.CloneShopControlPanelModes.EVERYTHING
				end
			end
			
			self.CloneShopControlItemsListStart = self.CloneShopSelectedClone - (self.CloneShopSelectedClone - 1) % self.CloneShopControlPanelItemsPerPage

			-- Get selected item info
			if self.CloneShopSelectedClone ~= self.LastCloneShopSelectedClone then
				local cln = self.CloneShopFilters[self.CloneShopControlMode][self.CloneShopSelectedClone]
				
				if cln ~= nil then
					-- Get item description
					self.CloneShopSelectedCloneDescription = self.CloneShopItems[cln]["Description"]
					self.CloneShopSelectedCloneManufacturer = CF_FactionNames[self.CloneShopItems[cln]["Faction"]]
					self.CloneShopSelectedClonePrice = self.CloneShopItems[cln]["Price"]
					
				else
					self.CloneShopSelectedCloneDescription = ""
					self.CloneShopSelectedCloneManufacturer = ""
					self.CloneShopSelectedClonePrice =  nil
				end
			end

			-- Dispense/sell/dump items
			if cont:IsState(Controller.WEAPON_FIRE) then
				if not self.FirePressed then
					self.FirePressed = true;
					
					if self.CloneShopSelectedClone > 0 then
						local cln = self.CloneShopFilters[self.CloneShopControlMode][self.CloneShopSelectedClone]
						
						if cln ~= nil and CF_CountUsedClonesInArray(self.Clones) < tonumber(self.GS["Player0VesselClonesCapacity"]) and self.CloneShopSelectedClonePrice <= CF_GetPlayerGold(self.GS, 0) then
							-- Remove actor from array
							local c = #self.Clones + 1
							
							self.Clones[c] = {}
							self.Clones[c]["Preset"] = self.CloneShopItems[cln]["Preset"]
							self.Clones[c]["Class"] = self.CloneShopItems[cln]["Class"]
							self.Clones[c]["Items"] = {}
							
							CF_SetClonesArray(self.GS, self.Clones)
							
							CF_SetPlayerGold(self.GS, 0, CF_GetPlayerGold(self.GS, 0) - self.CloneShopSelectedClonePrice)
						end
					end
				end
			else
				self.FirePressed = false
			end			
			
			-- Draw items list
			for i = self.CloneShopControlItemsListStart, self.CloneShopControlItemsListStart + self.CloneShopControlPanelItemsPerPage - 1 do
				if i <= #self.CloneShopFilters[self.CloneShopControlMode] then
					local cln = self.CloneShopFilters[self.CloneShopControlMode][i]
					local loc = i - self.CloneShopControlItemsListStart
					
					if i == self.CloneShopSelectedClone then
						CF_DrawString("> "..self.CloneShopItems[cln]["Preset"], pos + Vector(-130,-26) + Vector(0, (loc) * 12), 90, 10)
					else
						CF_DrawString(self.CloneShopItems[cln]["Preset"], pos + Vector(-130,-26) + Vector(0, (loc) * 12), 90, 10)
					end
					CF_DrawString(tostring(self.CloneShopItems[cln]["Price"]), pos + Vector(-130,-26) + Vector(110, (loc) * 12), 90, 10)
				end
			end
			
			-- Print description
			if self.CloneShopSelectedCloneDescription ~= nil then
				CF_DrawString(self.CloneShopSelectedCloneDescription, pos + Vector(10,-40) , 170, 140)
			end

			-- Print manufacturer or price
			if self.CloneShopSelectedCloneManufacturer ~= nil then
				CF_DrawString("Manufacturer: "..self.CloneShopSelectedCloneManufacturer, pos + Vector(10,-58) , 170, 120)
			end
			
			-- Print Selected mode text
			CF_DrawString(self.CloneShopControlPanelModesTexts[self.CloneShopControlMode], pos + Vector(-130,-77) , 170, 10)
			
			-- Print CloneShop capacity
			CF_DrawString("Capacity: "..CF_CountUsedClonesInArray(self.Clones).."/"..self.GS["Player0VesselClonesCapacity"], pos + Vector(-130,-60) , 300, 10)
			CF_DrawString("Gold: "..CF_GetPlayerGold(self.GS, 0).." oz", pos + Vector(-130,-44) , 300, 10)
		end
	end
	
	if showidle and self.CloneShopControlPanelPos ~= nil and self.CloneShopControlPanelActor ~= nil then
		self:PutGlow("ControlPanel_CloneShop", self.CloneShopControlPanelPos)
		CF_DrawString("Body\nStore ",self.CloneShopControlPanelPos + Vector(-16,0), 120, 20)

		self.CloneShopControlPanelInitialized = false
	end
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
















