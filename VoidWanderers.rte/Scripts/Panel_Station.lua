-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:InitStationControlPanelUI()
	-- Station Control Panel
	local x,y;
			
	x = tonumber(self.LS["StationControlPanelX"])
	y = tonumber(self.LS["StationControlPanelY"])
	if x~= nil and y ~= nil then
		self.StationControlPanelPos = Vector(x,y)
	else
		self.StationControlPanelPos = nil
	end

	x = tonumber(self.LS["StationInputX"])
	y = tonumber(self.LS["StationInputY"])
	if x~= nil and y ~= nil then
		self.StationInputPos = Vector(x,y)
	else
		self.StationInputPos = nil
	end
	
	x = tonumber(self.LS["StationDeployX"])
	y = tonumber(self.LS["StationDeployY"])
	if x~= nil and y ~= nil then
		self.StationDeployPos = Vector(x,y)
	else
		self.StationDeployPos = nil
	end
	
	-- Create actor
	if self.StationControlPanelPos ~= nil then
		if not MovableMan:IsActor(self.StationControlPanelActor) then
			self.StationControlPanelActor = CreateActor("Station Control Panel")
			if self.StationControlPanelActor ~= nil then
				self.StationControlPanelActor.Pos = self.StationControlPanelPos
				self.StationControlPanelActor.Team = CF_PlayerTeam
				MovableMan:AddActor(self.StationControlPanelActor)
			end
		end
		
		-- Crate debug
		--[[local crt = CreateMOSRotating("Case", self.ModuleName)
		if crt then
			crt.Pos = self.StationControlPanelPos
			MovableMan:AddParticle(crt)
		end		--]]--
	end
	
	self.StationControlPanelItemsPerPage = 9
	
	self.StationInputRange = 50
	self.StationInputDelay = 3
	
	-- Init variables
	self.StationControlPanelModes = {UNKNOWN = -2, EVERYTHING = -1, PISTOL = 0, RIFLE = 1, SHOTGUN = 2, SNIPER = 3, HEAVY = 4, SHIELD = 5, DIGGER = 6, GRENADE = 7, TOOL = 8}
	self.StationControlPanelModesTexts = {}
	
	self.StationControlPanelModesTexts[self.StationControlPanelModes.UNKNOWN] = "[ Unknown items ]"
	self.StationControlPanelModesTexts[self.StationControlPanelModes.EVERYTHING] = "[ All items ]"
	self.StationControlPanelModesTexts[self.StationControlPanelModes.PISTOL] = "[ Pistols ]"
	self.StationControlPanelModesTexts[self.StationControlPanelModes.RIFLE] = "[ Rifles ]"
	self.StationControlPanelModesTexts[self.StationControlPanelModes.SHOTGUN] = "[ Shotguns ]"
	self.StationControlPanelModesTexts[self.StationControlPanelModes.SNIPER] = "[ Sniper rifles ]"
	self.StationControlPanelModesTexts[self.StationControlPanelModes.HEAVY] = "[ Heavy weapons ]"
	self.StationControlPanelModesTexts[self.StationControlPanelModes.SHIELD] = "[ Shields ]"
	self.StationControlPanelModesTexts[self.StationControlPanelModes.DIGGER] = "[ Diggers ]"
	self.StationControlPanelModesTexts[self.StationControlPanelModes.GRENADE] = "[ Explosives ]"
	self.StationControlPanelModesTexts[self.StationControlPanelModes.TOOL] = "[ Tools ]"
	
	self.StationControlMode = self.StationControlPanelModes.EVERYTHING
	
	self.StationItems, self.StationFilters = CF_GetStationArray(self.GS, true)
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:DestroyStationControlPanelUI()
	if self.StationControlPanelActor ~= nil then
		self.StationControlPanelActor.ToDelete = true
		self.StationControlPanelActor = nil
	end
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:ProcessStationControlPanelUI()
	local showidle = true

	for plr = 0 , self.PlayerCount - 1 do
		local act = self:GetControlledActor(plr);
	
		if MovableMan:IsActor(act) and act.PresetName == "Station Control Panel" then
			showidle = false

			self.LastStationSelectedItem = self.StationSelectedItem
			
			-- Init control panel
			if not self.StationControlPanelInitialized then
				self.StationSelectedItem = 1
				self.LastStationSelectedItem = 0
				self.StationControlPanelInitialized = true
			end
			
			-- Draw generic UI
			local pos = act.Pos
			self:PutGlow("ControlPanel_Station_List", pos + Vector(-71,0))
			self:PutGlow("ControlPanel_Station_Description", pos + Vector(90,0))
			self:PutGlow("ControlPanel_Station_HorizontalPanel", pos + Vector(20,-77))
			self:PutGlow("ControlPanel_Station_HorizontalPanel", pos + Vector(20,78))

			-- Process controls
			local cont = act:GetController()

			if cont:IsState(Controller.WEAPON_FIRE) then
				if not self.FirePressed then
					self.FirePressed = true;
					
					if self.StationSelectedItem > 0 then
						local itm = self.StationFilters[self.StationControlMode][self.StationSelectedItem]
						
						if self.StationItems[itm]["Count"] > 0 then
							-- Remove item from Station and spawn it
							self.StationItems[itm]["Count"] = self.StationItems[itm]["Count"] - 1
							
							local hasactor = false
							local foundactor = nil
							
							-- Try to find actor or put item as is otherwise
							for actor in MovableMan.Actors do
								if CF_Dist(actor.Pos, self.StationInputPos) <= self.StationInputRange then
									hasactor = true
									foundactor = actor
									break;
								end
							end
							
							local item = CF_MakeItem2(self.StationItems[itm]["Preset"], self.StationItems[itm]["Class"])
							if item ~= nil then
								if hasactor then
									foundactor:AddInventoryItem(item)
									foundactor:FlashWhite(250)
								else
									item.Pos = self.StationDeployPos
									MovableMan:AddItem(item)
								end
							end
							-- Update game state
							CF_SetStationArray(self.GS, self.StationItems)
						end
					end
				end
			else
				self.FirePressed = false
			end			
			
			
			if cont:IsState(Controller.PRESS_UP) then
				if #self.StationFilters[self.StationControlMode] > 0 then
					self.StationSelectedItem = self.StationSelectedItem - 1
					
					if self.StationSelectedItem < 1 then
						self.StationSelectedItem = 1
					end
				end
			end

			if cont:IsState(Controller.PRESS_DOWN) then
				if #self.StationFilters[self.StationControlMode] > 0 then
					self.StationSelectedItem = self.StationSelectedItem + 1
					
					if self.StationSelectedItem > #self.StationFilters[self.StationControlMode] then
						self.StationSelectedItem = #self.StationFilters[self.StationControlMode]
					end
				end
			end

			if cont:IsState(Controller.PRESS_LEFT) then
				self.StationControlMode = self.StationControlMode - 1
				self.StationSelectedItem = 1
				self.LastStationSelectedItem = 0
				
				if self.StationControlMode == -3 then
					self.StationControlMode = self.StationControlPanelModes.TOOL
				end
			end	

			if cont:IsState(Controller.PRESS_RIGHT) then
				self.StationControlMode = self.StationControlMode + 1
				self.StationSelectedItem = 1
				self.LastStationSelectedItem = 0
				
				if self.StationControlMode == 9 then
					self.StationControlMode = self.StationControlPanelModes.UNKNOWN
				end
			end
			
			self.StationControlItemsListStart = self.StationSelectedItem - (self.StationSelectedItem - 1) % self.StationControlPanelItemsPerPage
			
			-- Draw items list
			for i = self.StationControlItemsListStart, self.StationControlItemsListStart + self.StationControlPanelItemsPerPage - 1 do
				if i <= #self.StationFilters[self.StationControlMode] then
					local itm = self.StationFilters[self.StationControlMode][i]
					local loc = i - self.StationControlItemsListStart
					
					if i == self.StationSelectedItem then
						CF_DrawString("> "..self.StationItems[itm]["Preset"], pos + Vector(-130,-40) + Vector(0, (loc) * 12), 90, 10)
					else
						CF_DrawString(self.StationItems[itm]["Preset"], pos + Vector(-130,-40) + Vector(0, (loc) * 12), 90, 10)
					end
					CF_DrawString(tostring(self.StationItems[itm]["Count"]), pos + Vector(-130,-40) + Vector(110, (loc) * 12), 90, 10)
				end
			end

			if self.StationSelectedItem ~= self.LastStationSelectedItem then
				local itm = self.StationFilters[self.StationControlMode][self.StationSelectedItem]

				-- Delete old item object
				if self.StationControlPanelObject ~= nil then
					if MovableMan:IsDevice(self.StationControlPanelObject) then
						self.StationControlPanelObject.ToDelete = true
					end
				end
				
				if itm ~= nil then
					-- Get item description
					local f, i = CF_FindItemInFactions(self.StationItems[itm]["Preset"], self.StationItems[itm]["Class"])
					
					if f ~= nil and i ~= nil then
						self.StationSelectedItemDescription = CF_ItmDescriptions[f][i]
						self.StationSelectedItemManufacturer = CF_FactionNames[f]
						
					else
						self.StationSelectedItemDescription = "Unknown item"
						self.StationSelectedItemManufacturer = "Unknown"
					end
					
					-- Create new item object
					self.StationControlPanelObject = CF_MakeItem2(self.StationItems[itm]["Preset"], self.StationItems[itm]["Class"])
					if self.StationControlPanelObject ~= nil then
						MovableMan:AddItem(self.StationControlPanelObject)
					end
				else
					self.StationSelectedItemDescription = ""
					self.StationSelectedItemManufacturer = ""
				end
			end
			
			-- Pin item object
			if self.StationControlPanelObject ~= nil then
				if MovableMan:IsDevice(self.StationControlPanelObject) then
					self.StationControlPanelObject.Pos = pos + Vector(85,-40)
					self.StationControlPanelObject.Vel = Vector(0,0)
				end
			end
			
			-- Print description
			if self.StationSelectedItemDescription ~= nil then
				CF_DrawString(self.StationSelectedItemDescription, pos + Vector(10,-10) , 170, 120)
			end

			-- Print manufacturer
			if self.StationSelectedItemManufacturer ~= nil then
				CF_DrawString("Manufacturer: "..self.StationSelectedItemManufacturer, pos + Vector(10,-25) , 170, 120)
			end
			
			-- Print Selected mode text
			CF_DrawString(self.StationControlPanelModesTexts[self.StationControlMode], pos + Vector(-130,-77) , 170, 10)
			
			-- Print help text
			CF_DrawString("L/R - Change filter, U/D - Select, FIRE - Dispense", pos + Vector(-130,78) , 300, 10)
			
			-- Print Station capacity
			CF_DrawString("Capacity: "..CF_CountUsedStationInArray(self.StationItems).."/"..self.GS["Player0VesselStationCapacity"], pos + Vector(-130,-60) , 300, 10)
		end
	end
	
	if showidle and self.StationControlPanelPos ~= nil then
		self:PutGlow("ControlPanel_Station", self.StationControlPanelPos)
		CF_DrawString("Station",self.StationControlPanelPos + Vector(-16,0),120,20 )

		self.StationControlPanelInitialized = false
		
		-- Delete sample weapon
		if self.StationControlPanelObject ~= nil then
			if MovableMan:IsDevice(self.StationControlPanelObject) then
				self.StationControlPanelObject.ToDelete = true
			end
		end
	end
	
	-- Process weapons input
	if self.ClonesInputPos ~= nil then
		local count = CF_CountUsedStationInArray(self.StationItems)
	
		if  count < tonumber(self.GS["Player0VesselStationCapacity"]) then
			local hasitem = false
			
			-- Search for item and put it in Station
			for item in MovableMan.Items do
				if CF_Dist(item.Pos, self.StationInputPos) <= self.StationInputRange then
					if self.StationLastDetectedItemTime ~= nil then
						-- Put item to Station
						if self.Time >= self.StationLastDetectedItemTime + self.StationInputDelay and CF_CountUsedStationInArray(self.StationItems) < tonumber(self.GS["Player0VesselStationCapacity"]) then
							local needrefresh = CF_PutItemToStationArray(self.StationItems, item.PresetName, item.ClassName)
							
							item.ToDelete = true

							-- Store everything
							CF_SetStationArray(self.GS, self.StationItems)
							
							-- Refresh Station items array and filters
							if needrefresh then
								self.StationItems, self.StationFilters = CF_GetStationArray(self.GS, true)
							end
							
							self.StationLastDetectedItemTime = nil
						end
						
						hasitem = true
					else
						self.StationLastDetectedItemTime = self.Time
					end
				end
			end
			
			if showidle then
				if hasitem and self.ClonesLastDetectedBodyTime ~= nil then
					self:AddObjectivePoint("Store in "..self.ClonesLastDetectedBodyTime + self.ClonesInputDelay - self.Time, self.StationDeployPos , CF_PlayerTeam, GameActivity.ARROWDOWN);
				else
					self:AddObjectivePoint("Stand here to receive items\nor place items here to store\n"..count.." / "..self.GS["Player0VesselStationCapacity"], self.StationDeployPos , CF_PlayerTeam, GameActivity.ARROWDOWN);
				end
			end
		else
			self:AddObjectivePoint("Station is full", self.StationInputPos + Vector(0,-40), CF_PlayerTeam, GameActivity.ARROWUP);
			self.StationLastDetectedItemTime = nil
		end
	end
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
















