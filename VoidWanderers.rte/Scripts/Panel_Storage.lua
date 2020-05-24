-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:InitStorageControlPanelUI()
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
	
	-- Init variables
	--self.ShipControlPanelModes = {LOCATION = 0, PLANET = 1}
	
	--self.ShipControlMode = self.ShipControlPanelModes.LOCATION
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

			self.LastSelectedItem = self.SelectedItem
			
			-- Init control panel
			if not self.StorageControlPanelInitialized then
				self.StorageItems = CF_GetStorageArray(self.GS)
				self.SelectedItem = 1
				self.LastSelectedItem = 0
				self.StorageControlPanelInitialized = true
			end
			
			-- Draw generic UI
			local pos = act.Pos
			self:PutGlow("ControlPanel_Storage_List", pos + Vector(-70,0))
			self:PutGlow("ControlPanel_Storage_Description", pos + Vector(90,0))
			
			-- Draw items list
			for i = 1, #self.StorageItems do
				if i == self.SelectedItem then
					CF_DrawString("> "..self.StorageItems[i]["Preset"], pos + Vector(-130,-60) + Vector(0, (i - 1) * 10), 90, 10)
				else
					CF_DrawString(self.StorageItems[i]["Preset"], pos + Vector(-130,-60) + Vector(0, (i - 1) * 10), 90, 10)
				end
				CF_DrawString(tostring(self.StorageItems[i]["Count"]), pos + Vector(-130,-60) + Vector(110, (i - 1) * 10), 90, 10)
			end
			
			if self.SelectedItem ~= self.LastSelectedItem then
				-- Get item description
				local f, i = CF_FindItemInFactions(self.StorageItems[self.SelectedItem]["Preset"], self.StorageItems[self.SelectedItem]["Class"])
				
				if f ~= nil and i ~= nil then
					self.SelectedItemDescription = CF_ItmDescriptions[f][i]
					self.SelectedItemManufacturer = CF_FactionNames[f]
					
				else
					self.SelectedItemDescription = "Unknown item"
					self.SelectedItemManufacturer = "Unknown"
				end
			end
			
			-- Print description
			
			--print (self.StorageItems[self.SelectedItem]["Preset"])
			--print (self.StorageItems[self.SelectedItem]["Class"])
			
			if self.SelectedItemDescription ~= nil then
				CF_DrawString(self.SelectedItemDescription, pos + Vector(10,-25) , 170, 120)
			end

			if self.SelectedItemManufacturer ~= nil then
				CF_DrawString("Manufacturer: "..self.SelectedItemManufacturer, pos + Vector(10,-40) , 170, 120)
			end
		end
	end
	
	if showidle and self.StorageControlPanelPos ~= nil then
		self:PutGlow("ControlPanel_Storage", self.StorageControlPanelPos)
		self.StorageControlPanelInitialized = false
	end
	
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
















