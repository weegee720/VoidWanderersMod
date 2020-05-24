-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:InitStorageControlPanelUI()
	-- Storage Control Panel
	local x,y;
			
	x = tonumber(self.LS["StorageControlPanelX"])
	y = tonumber(self.LS["StorageControlPanelY"])
	if x~= nil and y ~= nil then
		self.StorageControlPanelPos = Vector(x,y)
	else
		self.StorageControlPanelPos = nil
	end
	
	-- Create actor
	-- Ship
	if self.StorageControlPanelPos ~= nil then
		if not MovableMan:IsActor(self.StorageControlPanelActor) then
			self.StorageControlPanelActor = CreateActor("Storage Control Panel")
			if self.StorageControlPanelActor ~= nil then
				self.StorageControlPanelActor.Pos = self.StorageControlPanelPos
				self.StorageControlPanelActor.Team = CF_PlayerTeam
				MovableMan:AddActor(self.StorageControlPanelActor)
			end
		end
	end
	
	self.StorageControlPanelItemsPerPage = 9
	
	-- Init variables
	self.StorageControlPanelModes = {UNKNOWN = -2, EVERYTHING = -1, PISTOL = 0, RIFLE = 1, SHOTGUN = 2, SNIPER = 3, HEAVY = 4, SHIELD = 5, DIGGER = 6, GRENADE = 7, TOOL = 8}
	self.StorageControlPanelModesTexts = {}
	
	self.StorageControlPanelModesTexts[self.StorageControlPanelModes.UNKNOWN] = "Unknown items"
	self.StorageControlPanelModesTexts[self.StorageControlPanelModes.EVERYTHING] = "All items"
	self.StorageControlPanelModesTexts[self.StorageControlPanelModes.PISTOL] = "Pistols"
	self.StorageControlPanelModesTexts[self.StorageControlPanelModes.RIFLE] = "Rifles"
	self.StorageControlPanelModesTexts[self.StorageControlPanelModes.SHOTGUN] = "Shotguns"
	self.StorageControlPanelModesTexts[self.StorageControlPanelModes.SNIPER] = "Sniper rifles"
	self.StorageControlPanelModesTexts[self.StorageControlPanelModes.HEAVY] = "Heavy weapons"
	self.StorageControlPanelModesTexts[self.StorageControlPanelModes.SHIELD] = "Shields"
	self.StorageControlPanelModesTexts[self.StorageControlPanelModes.DIGGER] = "Diggers"
	self.StorageControlPanelModesTexts[self.StorageControlPanelModes.GRENADE] = "Explosives"
	self.StorageControlPanelModesTexts[self.StorageControlPanelModes.TOOL] = "Tools"
	
	self.StorageControlMode = self.StorageControlPanelModes.EVERYTHING
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:ProcessStorageControlPanelUI()
	local showidle = true

	for plr = 0 , self.PlayerCount - 1 do
		local act = self:GetControlledActor(plr);
	
		if MovableMan:IsActor(act) and act.PresetName == "Storage Control Panel" then
			showidle = false

			self.LastStorageSelectedItem = self.StorageSelectedItem
			
			-- Init control panel
			if not self.StorageControlPanelInitialized then
				if self.StorageItems == nil then
					self.StorageItems, self.StorageFilters = CF_GetStorageArray(self.GS, true)
				end
				self.StorageSelectedItem = 1
				self.LastStorageSelectedItem = 0
				self.StorageControlPanelInitialized = true
				self.StorageItemsUsedByStorage = true
			end
			
			-- Draw generic UI
			local pos = act.Pos
			self:PutGlow("ControlPanel_Storage_List", pos + Vector(-71,0))
			self:PutGlow("ControlPanel_Storage_Description", pos + Vector(90,0))
			self:PutGlow("ControlPanel_Storage_HorizontalPanel", pos + Vector(20,-77))
			self:PutGlow("ControlPanel_Storage_HorizontalPanel", pos + Vector(20,78))

			-- Process controls
			local cont = act:GetController()

			if cont:IsState(Controller.PRESS_UP) then
				if #self.StorageFilters[self.StorageControlMode] > 0 then
					self.StorageSelectedItem = self.StorageSelectedItem - 1
					
					if self.StorageSelectedItem < 1 then
						self.StorageSelectedItem = 1
					end
				end
			end

			if cont:IsState(Controller.PRESS_DOWN) then
				if #self.StorageFilters[self.StorageControlMode] > 0 then
					self.StorageSelectedItem = self.StorageSelectedItem + 1
					
					if self.StorageSelectedItem > #self.StorageFilters[self.StorageControlMode] then
						self.StorageSelectedItem = #self.StorageFilters[self.StorageControlMode]
					end
				end
			end

			if cont:IsState(Controller.PRESS_LEFT) then
				self.StorageControlMode = self.StorageControlMode - 1
				self.StorageSelectedItem = 1
				self.LastStorageSelectedItem = 0
				
				if self.StorageControlMode == -3 then
					self.StorageControlMode = self.StorageControlPanelModes.TOOL
				end
			end	

			if cont:IsState(Controller.PRESS_RIGHT) then
				self.StorageControlMode = self.StorageControlMode + 1
				self.StorageSelectedItem = 1
				self.LastStorageSelectedItem = 0
				
				if self.StorageControlMode == 9 then
					self.StorageControlMode = self.StorageControlPanelModes.UNKNOWN
				end
			end
			
			self.StorageControlItemsListStart = self.StorageSelectedItem - (self.StorageSelectedItem - 1) % self.StorageControlPanelItemsPerPage
			
			-- Draw items list
			for i = self.StorageControlItemsListStart, self.StorageControlItemsListStart + self.StorageControlPanelItemsPerPage - 1 do
				if i <= #self.StorageFilters[self.StorageControlMode] then
					local itm = self.StorageFilters[self.StorageControlMode][i]
					local loc = i - self.StorageControlItemsListStart
					
					if i == self.StorageSelectedItem then
						CF_DrawString("> "..self.StorageItems[itm]["Preset"], pos + Vector(-130,-40) + Vector(0, (loc) * 12), 90, 10)
					else
						CF_DrawString(self.StorageItems[itm]["Preset"], pos + Vector(-130,-40) + Vector(0, (loc) * 12), 90, 10)
					end
					CF_DrawString(tostring(self.StorageItems[itm]["Count"]), pos + Vector(-130,-40) + Vector(110, (loc) * 12), 90, 10)
				end
			end

			if self.StorageSelectedItem ~= self.LastStorageSelectedItem then
				local itm = self.StorageFilters[self.StorageControlMode][self.StorageSelectedItem]

				-- Delete old item object
				if self.StorageControlPanelObject ~= nil then
					if MovableMan:IsDevice(self.StorageControlPanelObject) then
						self.StorageControlPanelObject.ToDelete = true
					end
				end
				
				if itm ~= nil then
					-- Get item description
					local f, i = CF_FindItemInFactions(self.StorageItems[itm]["Preset"], self.StorageItems[itm]["Class"])
					
					if f ~= nil and i ~= nil then
						self.StorageSelectedItemDescription = CF_ItmDescriptions[f][i]
						self.StorageSelectedItemManufacturer = CF_FactionNames[f]
						
					else
						self.StorageSelectedItemDescription = "Unknown item"
						self.StorageSelectedItemManufacturer = "Unknown"
					end
					
					-- Create new item object
					self.StorageControlPanelObject = CF_MakeItem2(self.StorageItems[itm]["Preset"], self.StorageItems[itm]["Class"])
					if self.StorageControlPanelObject ~= nil then
						MovableMan:AddItem(self.StorageControlPanelObject)
						--self.StorageControlPanelObject.HitsMOs = false
						--self.StorageControlPanelObject.GetsHitByMOs = false
					end
				else
					self.StorageSelectedItemDescription = ""
					self.StorageSelectedItemManufacturer = ""
				end
			end
			
			-- Pin item object
			if self.StorageControlPanelObject ~= nil then
				if MovableMan:IsDevice(self.StorageControlPanelObject) then
					self.StorageControlPanelObject.Pos = pos + Vector(85,-40)
					self.StorageControlPanelObject.Vel = Vector(0,0)
				end
			end
			
			-- Print description
			if self.StorageSelectedItemDescription ~= nil then
				CF_DrawString(self.StorageSelectedItemDescription, pos + Vector(10,-10) , 170, 120)
			end

			-- Print manufacturer
			if self.StorageSelectedItemManufacturer ~= nil then
				CF_DrawString("Manufacturer: "..self.StorageSelectedItemManufacturer, pos + Vector(10,-25) , 170, 120)
			end
			
			-- Print Selected mode text
			CF_DrawString(self.StorageControlPanelModesTexts[self.StorageControlMode], pos + Vector(-130,-77) , 170, 10)
			
			-- Print help text
			CF_DrawString("L/R - Change filter, U/D - Select, FIRE - Dispense", pos + Vector(-130,78) , 300, 10)
			
			-- Print storage capacity
			CF_DrawString("Capacity: "..CF_CountUsedStorageInArray(self.StorageItems).."/"..self.GS["Player0VesselStorageCapacity"], pos + Vector(-130,-60) , 300, 10)
		end
	end
	
	if showidle and self.StorageControlPanelPos ~= nil then
		self:PutGlow("ControlPanel_Storage", self.StorageControlPanelPos)
		self.StorageControlPanelInitialized = false
		
		-- Delete sample weapon
		if self.StorageControlPanelObject ~= nil then
			if MovableMan:IsDevice(self.StorageControlPanelObject) then
				self.StorageControlPanelObject.ToDelete = true
			end
		end
		
		self.StorageItemsUsedByStorage = nil
		
		-- Delete storage data array
		if self.StorageItems ~= nil and self.StorageItemsUsedByStorage == nil and self.StorageItemsUsedByClones == nil then
			self.StorageItems = nil
		end
	end
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
















