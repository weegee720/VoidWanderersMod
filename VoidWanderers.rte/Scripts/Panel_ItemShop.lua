-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:InitItemShopControlPanelUI()
	-- ItemShop Control Panel
	local x,y;
			
	x = tonumber(self.LS["ItemShopControlPanelX"])
	y = tonumber(self.LS["ItemShopControlPanelY"])
	if x~= nil and y ~= nil then
		self.ItemShopControlPanelPos = Vector(x,y)
	else
		self.ItemShopControlPanelPos = nil
	end
	
	-- Create actor
	if self.ItemShopControlPanelPos ~= nil then
		if not MovableMan:IsActor(self.ItemShopControlPanelActor) then
			self.ItemShopControlPanelActor = CreateActor("Item Shop Control Panel")
			if self.ItemShopControlPanelActor ~= nil then
				self.ItemShopControlPanelActor.Pos = self.ItemShopControlPanelPos
				self.ItemShopControlPanelActor.Team = CF_PlayerTeam
				MovableMan:AddActor(self.ItemShopControlPanelActor)
			end
		end
	end
	
	self.ItemShopControlPanelItemsPerPage = 8
	
	-- Init variables
	self.ItemShopControlPanelModes = {EVERYTHING = -1, PISTOL = 0, RIFLE = 1, SHOTGUN = 2, SNIPER = 3, HEAVY = 4, SHIELD = 5, DIGGER = 6, GRENADE = 7, TOOL = 8}
	self.ItemShopControlPanelModesTexts = {}
	
	self.ItemShopControlPanelModesTexts[self.ItemShopControlPanelModes.EVERYTHING] = "All items"
	self.ItemShopControlPanelModesTexts[self.ItemShopControlPanelModes.PISTOL] = "Pistols"
	self.ItemShopControlPanelModesTexts[self.ItemShopControlPanelModes.RIFLE] = "Rifles"
	self.ItemShopControlPanelModesTexts[self.ItemShopControlPanelModes.SHOTGUN] = "Shotguns"
	self.ItemShopControlPanelModesTexts[self.ItemShopControlPanelModes.SNIPER] = "Sniper rifles"
	self.ItemShopControlPanelModesTexts[self.ItemShopControlPanelModes.HEAVY] = "Heavy weapons"
	self.ItemShopControlPanelModesTexts[self.ItemShopControlPanelModes.SHIELD] = "Shields"
	self.ItemShopControlPanelModesTexts[self.ItemShopControlPanelModes.DIGGER] = "Diggers"
	self.ItemShopControlPanelModesTexts[self.ItemShopControlPanelModes.GRENADE] = "Explosives"
	self.ItemShopControlPanelModesTexts[self.ItemShopControlPanelModes.TOOL] = "Tools"
	
	self.ItemShopControlMode = self.ItemShopControlPanelModes.EVERYTHING
	
	self.ItemShopItems, self.ItemShopFilters = CF_GetItemShopArray(self.GS, true)
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:DestroyItemShopControlPanelUI()
	if self.ItemShopControlPanelActor ~= nil then
		self.ItemShopControlPanelActor.ToDelete = true
		self.ItemShopControlPanelActor = nil
	end
	
	if self.ItemShopControlPanelObject ~= nil then
		if MovableMan:IsDevice(self.ItemShopControlPanelObject) then
			self.ItemShopControlPanelObject.ToDelete = true
			self.ItemShopControlPanelObject = nil
		end
	end	
	--print (self.ItemShopControlPanelActor)
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:ProcessItemShopControlPanelUI()
	local showidle = true

	for plr = 0 , self.PlayerCount - 1 do
		local act = self:GetControlledActor(plr);
	
		if MovableMan:IsActor(act) and act.PresetName == "Item Shop Control Panel" then
			showidle = false

			self.LastItemShopSelectedItem = self.ItemShopSelectedItem
			
			-- Init control panel
			if not self.ItemShopControlPanelInitialized then
				self.ItemShopSelectedItem = 1
				self.LastItemShopSelectedItem = 0
				self.ItemShopControlPanelInitialized = true
			end
			
			-- Draw generic UI
			local pos = act.Pos
			self:PutGlow("ControlPanel_Storage_List", pos + Vector(-71,0))
			self:PutGlow("ControlPanel_ItemShop_Description", pos + Vector(90,0))
			self:PutGlow("ControlPanel_Storage_HorizontalPanel", pos + Vector(20,-77))
			self:PutGlow("ControlPanel_Storage_HorizontalPanel", pos + Vector(20,78))
			
			-- Print help text
			CF_DrawString("L/R - Change filter, U/D - Select, FIRE - Buy", pos + Vector(-130,78) , 300, 10)


			-- Process controls
			local cont = act:GetController()
			
			if cont:IsState(Controller.PRESS_UP) then
				if #self.ItemShopFilters[self.ItemShopControlMode] > 0 then
					self.ItemShopSelectedItem = self.ItemShopSelectedItem - 1
					
					if self.ItemShopSelectedItem < 1 then
						self.ItemShopSelectedItem = 1
					end
				end
			end

			if cont:IsState(Controller.PRESS_DOWN) then
				if #self.ItemShopFilters[self.ItemShopControlMode] > 0 then
					self.ItemShopSelectedItem = self.ItemShopSelectedItem + 1
					
					if self.ItemShopSelectedItem > #self.ItemShopFilters[self.ItemShopControlMode] then
						self.ItemShopSelectedItem = #self.ItemShopFilters[self.ItemShopControlMode]
					end
				end
			end

			if cont:IsState(Controller.PRESS_LEFT) then
				self.ItemShopControlMode = self.ItemShopControlMode - 1
				self.ItemShopSelectedItem = 1
				self.LastItemShopSelectedItem = 0
				
				if self.ItemShopControlMode == -2 then
					self.ItemShopControlMode = self.ItemShopControlPanelModes.TOOL
				end
			end	

			if cont:IsState(Controller.PRESS_RIGHT) then
				self.ItemShopControlMode = self.ItemShopControlMode + 1
				self.ItemShopSelectedItem = 1
				self.LastItemShopSelectedItem = 0
				
				if self.ItemShopControlMode == 9 then
					self.ItemShopControlMode = self.ItemShopControlPanelModes.EVERYTHING
				end
			end
			
			self.ItemShopControlItemsListStart = self.ItemShopSelectedItem - (self.ItemShopSelectedItem - 1) % self.ItemShopControlPanelItemsPerPage

			-- Get selected item info
			if self.ItemShopSelectedItem ~= self.LastItemShopSelectedItem then
				local itm = self.ItemShopFilters[self.ItemShopControlMode][self.ItemShopSelectedItem]

				-- Delete old item object
				if self.ItemShopControlPanelObject ~= nil then
					if MovableMan:IsDevice(self.ItemShopControlPanelObject) then
						self.ItemShopControlPanelObject.ToDelete = true
						self.ItemShopControlPanelObject = nil
					end
				end
				
				if itm ~= nil then
					-- Get item description
					self.ItemShopSelectedItemDescription = self.ItemShopItems[itm]["Description"]
					self.ItemShopSelectedItemManufacturer = CF_FactionNames[self.ItemShopItems[itm]["Faction"]]
					self.ItemShopSelectedItemPrice = self.ItemShopItems[itm]["Price"]
					
					-- Create new item object
					self.ItemShopControlPanelObject = CF_MakeItem2(self.ItemShopItems[itm]["Preset"], self.ItemShopItems[itm]["Class"])
					if self.ItemShopControlPanelObject ~= nil then
						MovableMan:AddItem(self.ItemShopControlPanelObject)
					end
				else
					self.ItemShopSelectedItemDescription = ""
					self.ItemShopSelectedItemManufacturer = ""
					self.ItemShopSelectedItemPrice =  nil
				end
			end

			-- Dispense/sell/dump items
			if cont:IsState(Controller.WEAPON_FIRE) then
				if not self.FirePressed then
					self.FirePressed = true;
					
					if self.ItemShopSelectedItem > 0 then
						local itm = self.ItemShopFilters[self.ItemShopControlMode][self.ItemShopSelectedItem]
						
						if itm ~= nil and CF_CountUsedStorageInArray(self.StorageItems) < tonumber(self.GS["Player0VesselStorageCapacity"]) and self.ItemShopSelectedItemPrice <= CF_GetPlayerGold(self.GS, 0) then
							local needrefresh = CF_PutItemToStorageArray(self.StorageItems, self.ItemShopItems[itm]["Preset"], self.ItemShopItems[itm]["Class"])
							
							CF_SetPlayerGold(self.GS, 0, CF_GetPlayerGold(self.GS, 0) - self.ItemShopSelectedItemPrice)

							-- Store everything
							CF_SetStorageArray(self.GS, self.StorageItems)
							
							-- Refresh storage items array and filters
							if needrefresh then
								self.StorageItems, self.StorageFilters = CF_GetStorageArray(self.GS, true)
							end						
						end
					end
				end
			else
				self.FirePressed = false
			end			
			
			-- Draw items list
			for i = self.ItemShopControlItemsListStart, self.ItemShopControlItemsListStart + self.ItemShopControlPanelItemsPerPage - 1 do
				if i <= #self.ItemShopFilters[self.ItemShopControlMode] then
					local itm = self.ItemShopFilters[self.ItemShopControlMode][i]
					local loc = i - self.ItemShopControlItemsListStart
					
					if i == self.ItemShopSelectedItem then
						CF_DrawString("> "..self.ItemShopItems[itm]["Preset"], pos + Vector(-130,-26) + Vector(0, (loc) * 12), 90, 10)
					else
						CF_DrawString(self.ItemShopItems[itm]["Preset"], pos + Vector(-130,-26) + Vector(0, (loc) * 12), 90, 10)
					end
					CF_DrawString(tostring(self.ItemShopItems[itm]["Price"]), pos + Vector(-130,-26) + Vector(110, (loc) * 12), 90, 10)
				end
			end

			
			-- Pin item object
			if self.ItemShopControlPanelObject ~= nil then
				if MovableMan:IsDevice(self.ItemShopControlPanelObject) then
					self.ItemShopControlPanelObject.Pos = pos + Vector(85,-40)
					self.ItemShopControlPanelObject.Vel = Vector(0,0)
				end
			end
			
			-- Print description
			if self.ItemShopSelectedItemDescription ~= nil then
				CF_DrawString(self.ItemShopSelectedItemDescription, pos + Vector(10,-10) , 170, 70)
			end

			-- Print manufacturer or price
			if self.ItemShopSelectedItemManufacturer ~= nil then
				CF_DrawString("Manufacturer: "..self.ItemShopSelectedItemManufacturer, pos + Vector(10,-25) , 170, 120)
			end
			
			-- Print Selected mode text
			CF_DrawString(self.ItemShopControlPanelModesTexts[self.ItemShopControlMode], pos + Vector(-130,-77) , 170, 10)
			
			-- Print ItemShop capacity
			CF_DrawString("Capacity: "..CF_CountUsedStorageInArray(self.StorageItems).."/"..self.GS["Player0VesselStorageCapacity"], pos + Vector(-130,-60) , 300, 10)
			CF_DrawString("Gold: "..CF_GetPlayerGold(self.GS, 0).." oz", pos + Vector(-130,-44) , 300, 10)
		end
	end
	
	if showidle and self.ItemShopControlPanelPos ~= nil and self.ItemShopControlPanelActor ~= nil then
		self:PutGlow("ControlPanel_ItemShop", self.ItemShopControlPanelPos)
		--CF_DrawString("Item\nStore ",self.ItemShopControlPanelPos + Vector(-16,0), 120, 20)

		self.ItemShopControlPanelInitialized = false
		
		-- Delete sample weapon
		if self.ItemShopControlPanelObject ~= nil then
			if MovableMan:IsDevice(self.ItemShopControlPanelObject) then
				self.ItemShopControlPanelObject.ToDelete = true
				self.ItemShopControlPanelObject = nil
			end
		end
	end
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
















