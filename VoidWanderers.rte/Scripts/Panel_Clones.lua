-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:InitClonesControlPanelUI()
	-- Clone Control Panel
	local x,y;
			
	x = tonumber(self.LS["ClonesControlPanelX"])
	y = tonumber(self.LS["ClonesControlPanelY"])
	if x~= nil and y ~= nil then
		self.ClonesControlPanelPos = Vector(x,y)
	else
		self.ClonesControlPanelPos = nil
	end
	
	x = tonumber(self.LS["ClonesDeployX"])
	y = tonumber(self.LS["ClonesDeployY"])
	if x~= nil and y ~= nil then
		self.ClonesDeployPos = Vector(x,y)
	else
		self.ClonesDeployPos = nil
	end

	x = tonumber(self.LS["ClonesInputX"])
	y = tonumber(self.LS["ClonesInputY"])
	if x~= nil and y ~= nil then
		self.ClonesInputPos = Vector(x,y)
	else
		self.ClonesInputPos = nil
	end
	
	-- Create actor
	-- Ship
	if self.ClonesControlPanelPos ~= nil then
		if not MovableMan:IsActor(self.ClonesControlPanelActor) then
			self.ClonesControlPanelActor = CreateActor("Clones Control Panel")
			if self.ClonesControlPanelActor ~= nil then
				self.ClonesControlPanelActor.Pos = self.ClonesControlPanelPos
				self.ClonesControlPanelActor.Team = CF_PlayerTeam
				MovableMan:AddActor(self.ClonesControlPanelActor)
			end
		end
	end
	
	self.ClonesInputDelay = 3
	self.ClonesInputRange = 35
	self.ClonesControlLastMessageTime = -1000
	self.ClonesControlMessageIntrval = 3
	self.ClonesControlMessageText = ""
	
	self.ClonesControlPanelLinesPerPage = 9
	
	self.ClonesControlPanelModes = {SELL = 0, CLONES = 1, INVENTORY = 2, ITEMS = 3}
	self.ClonesControlPanelModesTexts = {}
	self.ClonesControlPanelModesHelpTexts = {}
	
	self.ClonesControlPanelModesTexts[self.ClonesControlPanelModes.SELL] = "SELL BODIES"
	self.ClonesControlPanelModesTexts[self.ClonesControlPanelModes.CLONES] = "Bodies"
	self.ClonesControlPanelModesTexts[self.ClonesControlPanelModes.INVENTORY] = "Inventory"
	self.ClonesControlPanelModesTexts[self.ClonesControlPanelModes.ITEMS] = "Items"

	self.ClonesControlPanelModesHelpTexts[self.ClonesControlPanelModes.SELL] = "L/R/U/D - Select, FIRE - Sell"
	self.ClonesControlPanelModesHelpTexts[self.ClonesControlPanelModes.CLONES] = "L/R/U/D - Select, FIRE - Deploy"
	self.ClonesControlPanelModesHelpTexts[self.ClonesControlPanelModes.INVENTORY] = "L/R/U/D - Select, FIRE - Remove from inventory"
	self.ClonesControlPanelModesHelpTexts[self.ClonesControlPanelModes.ITEMS] = "L/R/U/D - Select, FIRE - Add to inventory"
	
	self.Clones = CF_GetClonesArray(self.GS)
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:DestroyClonesControlPanelUI()
	if self.ClonesControlPanelActor ~= nil then
		self.ClonesControlPanelActor.ToDelete = true
		self.ClonesControlPanelActor = nil
	end
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:ProcessClonesControlPanelUI()
	local showidle = true

	for plr = 0 , self.PlayerCount - 1 do
		local act = self:GetControlledActor(plr);
	
		if MovableMan:IsActor(act) and act.PresetName == "Clones Control Panel" then
			showidle = false

			local pos = act.Pos
			
			-- Process controls
			local cont = act:GetController()
			
			-- Clone selection screen
			-- Init control panel
			if not self.ClonesControlPanelInitialized then
				if #self.Clones > 0 then
					self.SelectedClone = 1
				else
					self.SelectedClone = 0
				end
				
				self.ClonesStorageSelectedItem = 1
				self.ClonesInventorySelectedItem = 1
				
				self.ClonesControlPanelInitialized = true
				
				self.ClonesControlMode = self.ClonesControlPanelModes.CLONES
			end			
			
			if self.SelectedClone ~= 0 then
				if cont:IsState(Controller.PRESS_LEFT) then
					self.ClonesControlMode = self.ClonesControlMode - 1
					
					if self.ClonesControlMode == -1 then
						self.ClonesControlMode = 0
					end
					
					if self.SelectedClone > 0 then 
						if #self.Clones[self.SelectedClone]["Items"] < self.ClonesInventorySelectedItem then
							self.ClonesInventorySelectedItem = #self.Clones[self.SelectedClone]["Items"]
						end
						
						if self.ClonesInventorySelectedItem < 1 and #self.Clones[self.SelectedClone]["Items"] > 0 then
							self.ClonesInventorySelectedItem = 1
						end
					end
				end	

				if cont:IsState(Controller.PRESS_RIGHT) then
					self.ClonesControlMode = self.ClonesControlMode + 1
					
					if self.ClonesControlMode == 4 then
						self.ClonesControlMode = 3
					end
					
					if self.SelectedClone > 0 then 
						if #self.Clones[self.SelectedClone]["Items"] < self.ClonesInventorySelectedItem then
							self.ClonesInventorySelectedItem = #self.Clones[self.SelectedClone]["Items"]
						end
						
						if self.ClonesInventorySelectedItem < 1 and #self.Clones[self.SelectedClone]["Items"] > 0 then
							self.ClonesInventorySelectedItem = 1
						end
					end
				end
			end

			-- Clones list screen
			if self.ClonesControlMode == self.ClonesControlPanelModes.CLONES or self.ClonesControlMode == self.ClonesControlPanelModes.SELL then
				if self.ClonesControlMode == self.ClonesControlPanelModes.SELL then
					if CF_IsLocationHasAttribute(self.GS["Location"], CF_LocationAttributeTypes.TRADESTAR) or CF_IsLocationHasAttribute(self.GS["Location"], CF_LocationAttributeTypes.BLACKMARKET) then
						self.ClonesControlPanelModesTexts[self.ClonesControlPanelModes.SELL] = "SELL BODIES "..CF_GetPlayerGold(self.GS, 0).." oz"
						self.ClonesControlPanelModesHelpTexts[self.ClonesControlPanelModes.SELL] = "L/R/U/D - Select, FIRE - Sell"
					else
						self.ClonesControlPanelModesTexts[self.ClonesControlPanelModes.SELL] = "DUMP BODIES"
						self.ClonesControlPanelModesHelpTexts[self.ClonesControlPanelModes.SELL] = "L/R/U/D - Select, FIRE - Dump"
					end
				end
			
				if cont:IsState(Controller.PRESS_UP) then
					if #self.Clones > 0 then
						self.SelectedClone = self.SelectedClone - 1
						
						if self.SelectedClone < 1 then
							self.SelectedClone = 1
						end
					end
				end

				if cont:IsState(Controller.PRESS_DOWN) then
					if #self.Clones > 0 then
						self.SelectedClone = self.SelectedClone + 1
						
						if self.SelectedClone > #self.Clones then
							self.SelectedClone = #self.Clones
						end
					end
				end
				
				self.ClonesControlCloneListStart = self.SelectedClone - (self.SelectedClone - 1) % self.ClonesControlPanelLinesPerPage
				
				self.SelectedClonePrice = 0
				
				-- Draw clones list
				for i = self.ClonesControlCloneListStart, self.ClonesControlCloneListStart + self.ClonesControlPanelLinesPerPage - 1 do
					if i <= #self.Clones and i > 0 then
						local loc = i - self.ClonesControlCloneListStart
						
						if i == self.SelectedClone then
							CF_DrawString("> "..self.Clones[i]["Preset"], pos + Vector(-130,-40) + Vector(0, (loc) * 12), 120, 10)
							
							-- Calculate actor price
							local fact, indx = CF_FindActorInFactions(self.Clones[i]["Preset"], self.Clones[i]["Class"])
							if fact ~= nil and indx ~= nil then
								self.SelectedClonePrice = self.SelectedClonePrice + math.floor(CF_ActPrices[fact][indx] * CF_SellPriceCoeff)
							else
								self.SelectedClonePrice = CF_UnknownActorPrice
							end

							--if self.ClonesControlMode == self.ClonesControlPanelModes.SELL and self.GS["Planet"] == "TradeStar" and self.GS["Location"] ~= nil then
							--	CF_DrawString(tostring(self.SelectedClonePrice).."oz", pos + Vector(-20,-40) + Vector(0, (loc) * 12), 120, 10)
							--end
						else
							CF_DrawString(self.Clones[i]["Preset"], pos + Vector(-130,-40) + Vector(0, (loc) * 12), 120, 10)
						end
						
					end
				end
				
				-- Draw selected clone items
				if self.SelectedClone ~= nil and self.SelectedClone > 0 then
					-- Print inventory
					CF_DrawString("Inventory: "..#self.Clones[self.SelectedClone]["Items"].."/"..CF_MaxItems, pos + Vector(12,-60) , 300, 10)
					
					for i = 1, #self.Clones[self.SelectedClone]["Items"] do
						-- Calculate inventory price
						local price
						local fact, indx = CF_FindItemInFactions(self.Clones[self.SelectedClone]["Items"][i]["Preset"], self.Clones[self.SelectedClone]["Items"][i]["Class"])
						if fact ~= nil and indx ~= nil then
							price = math.floor(CF_ItmPrices[fact][indx] * CF_SellPriceCoeff)
						else
							price = CF_UnknownItemPrice
						end
						self.SelectedClonePrice = self.SelectedClonePrice + price
						
						local prefix = ""
						if self.ClonesControlMode == self.ClonesControlPanelModes.SELL then
							if CF_IsLocationHasAttribute(self.GS["Location"], CF_LocationAttributeTypes.TRADESTAR) or CF_IsLocationHasAttribute(self.GS["Location"], CF_LocationAttributeTypes.BLACKMARKET) then
								prefix = tostring(price).."oz "
							end
						end

						CF_DrawString(prefix..self.Clones[self.SelectedClone]["Items"][i]["Preset"], pos + Vector(12,-40) + Vector(0, (i - 1) * 12), 120, 10)
					end
				end

				if self.ClonesControlMode == self.ClonesControlPanelModes.SELL then
					if CF_IsLocationHasAttribute(self.GS["Location"], CF_LocationAttributeTypes.TRADESTAR) or CF_IsLocationHasAttribute(self.GS["Location"], CF_LocationAttributeTypes.BLACKMARKET) then
						CF_DrawString("Sell price: "..self.SelectedClonePrice, pos + Vector(12,60) , 300, 10)
					end
				end
				
				-- Print clone storage capacity
				CF_DrawString("Capacity: "..CF_CountUsedClonesInArray(self.Clones).."/"..self.GS["Player0VesselClonesCapacity"], pos + Vector(-130,-60) , 300, 10)
				
				-- Change panel text to show life support capacity
				self.ClonesControlPanelModesTexts[self.ClonesControlPanelModes.CLONES] = "Bodies - Life support usage: "..CF_CountActors(CF_PlayerTeam).."/"..self.GS["Player0VesselLifeSupport"]
				
				if cont:IsState(Controller.WEAPON_FIRE) then
					if not self.FirePressed then
						self.FirePressed = true;
						
						if self.ClonesControlMode == self.ClonesControlPanelModes.SELL then
							if self.SelectedClone ~= 0 then
								if CF_IsLocationHasAttribute(self.GS["Location"], CF_LocationAttributeTypes.TRADESTAR) or CF_IsLocationHasAttribute(self.GS["Location"], CF_LocationAttributeTypes.BLACKMARKET) then
									CF_SetPlayerGold(self.GS, 0 , CF_GetPlayerGold(self.GS, 0) + self.SelectedClonePrice)
								end
							
								-- Remove actor from array
								local newarr = {}
								local ii = 1
								
								for i = 1, #self.Clones do
									if i ~= self.SelectedClone then
										newarr[ii] = self.Clones[i]
										ii = ii + 1
									end
								end
								
								self.Clones = newarr
								
								-- Update game state data
								CF_SetClonesArray(self.GS, self.Clones)
								
								if self.SelectedClone > #self.Clones then
									self.SelectedClone = #self.Clones
								end
							else
								self.ClonesControlLastMessageTime = self.Time
								self.ClonesControlMessageText = "Clone storage is empty"
							end
						else
							if CF_CountActors(CF_PlayerTeam) < tonumber(self.GS["Player0VesselLifeSupport"]) then
								-- Create new unit
								if self.SelectedClone ~= 0 then
									if MovableMan:GetMOIDCount() < CF_MOIDLimit then
										-- Spawn actor
										local a = CF_MakeActor2(self.Clones[self.SelectedClone]["Preset"], self.Clones[self.SelectedClone]["Class"])
										if a ~= nil then
											a.Team = CF_PlayerTeam
											if self.ClonesDeployPos ~= nil then
												a.Pos = self.ClonesDeployPos
											else
												a.Pos = self.ClonesControlPanelPos
											end
											
											for i = 1, #self.Clones[self.SelectedClone]["Items"] do
												local itm = CF_MakeItem2(self.Clones[self.SelectedClone]["Items"][i]["Preset"], self.Clones[self.SelectedClone]["Items"][i]["Class"])
												if itm ~= nil then
													a:AddInventoryItem(itm)
												else
													self.ClonesControlLastMessageTime = self.Time
													self.ClonesControlMessageText = "ERROR!!! Can't create item!!!"
												end
											end
											
											MovableMan:AddActor(a)
											
											-- Remove actor from array
											local newarr = {}
											local ii = 1
											
											for i = 1, #self.Clones do
												if i ~= self.SelectedClone then
													newarr[ii] = self.Clones[i]
													ii = ii + 1
												end
											end
											
											self.Clones = newarr
											
											-- Update game state data
											CF_SetClonesArray(self.GS, self.Clones)
											
											if self.SelectedClone > #self.Clones then
												self.SelectedClone = #self.Clones
											end
										else
											self.ClonesControlLastMessageTime = self.Time
											self.ClonesControlMessageText = "ERROR!!! Can't create actor!!!"
										end
									else
										self.ClonesControlLastMessageTime = self.Time
										self.ClonesControlMessageText = "Too many objects in simulation"
									end
								else
									self.ClonesControlLastMessageTime = self.Time
									self.ClonesControlMessageText = "Clone storage is empty"
								end
							else
								if self.SelectedClone == 0 then
									self.ClonesControlLastMessageTime = self.Time
									self.ClonesControlMessageText = "Clone storage is empty"
								else
									self.ClonesControlLastMessageTime = self.Time
									self.ClonesControlMessageText = "Too many units. Upgrade life support."
								end
							end
						end -- If not sell mode
					end
				else
					self.FirePressed = false
				end
			end

			-- Inventory list screen
			if self.ClonesControlMode == self.ClonesControlPanelModes.INVENTORY then		
				if cont:IsState(Controller.WEAPON_FIRE) then
					if not self.FirePressed then
						self.FirePressed = true;
						
						if self.SelectedClone > 0 and CF_CountUsedStorageInArray(self.StorageItems) < tonumber(self.GS["Player0VesselStorageCapacity"]) and #self.Clones[self.SelectedClone]["Items"] > 0 then
							-- Put item to storage array
							CF_PutItemToStorageArray(self.StorageItems, self.Clones[self.SelectedClone]["Items"][self.ClonesInventorySelectedItem]["Preset"], self.Clones[self.SelectedClone]["Items"][self.ClonesInventorySelectedItem]["Class"])
							CF_SetStorageArray(self.GS, self.StorageItems)

							-- Refresh storage items array and filters
							self.StorageItems, self.StorageFilters = CF_GetStorageArray(self.GS, true)							
							
							-- Remove item from inventory via temp array
							local inv = {}
							local ii = 1
							
							for i = 1, #self.Clones[self.SelectedClone]["Items"] do
								if i ~= self.ClonesInventorySelectedItem then
									inv[ii] = {}
									
									inv[ii]["Preset"] = self.Clones[self.SelectedClone]["Items"][i]["Preset"]									
									inv[ii]["Class"] = self.Clones[self.SelectedClone]["Items"][i]["Class"]									
								
									ii = ii + 1
								end
							end
							
							self.Clones[self.SelectedClone]["Items"] = inv
							
							CF_SetClonesArray(self.GS, self.Clones)
						end
					end
				else
					self.FirePressed = false
				end
				
				if cont:IsState(Controller.PRESS_UP) then
					self.ClonesInventorySelectedItem = self.ClonesInventorySelectedItem - 1
					
					if self.ClonesInventorySelectedItem < 1 then
						self.ClonesInventorySelectedItem = 1
					end
				end

				if cont:IsState(Controller.PRESS_DOWN) then
					self.ClonesInventorySelectedItem = self.ClonesInventorySelectedItem + 1
					
					if self.ClonesInventorySelectedItem > #self.Clones[self.SelectedClone]["Items"] then
						self.ClonesInventorySelectedItem = #self.Clones[self.SelectedClone]["Items"]
					end
				end
			end

			if self.ClonesControlMode == self.ClonesControlPanelModes.ITEMS then
				if cont:IsState(Controller.WEAPON_FIRE) then
					if not self.FirePressed then
						self.FirePressed = true;
						
						if self.SelectedClone > 0 and #self.StorageFilters[self.StorageControlPanelModes.EVERYTHING] > 0 then
							local itm = self.StorageFilters[self.StorageControlPanelModes.EVERYTHING][self.ClonesStorageSelectedItem]
							
							--Add item to unit's inventory
							if #self.Clones[self.SelectedClone]["Items"] < CF_MaxItems then
								if self.StorageItems[itm]["Count"] > 0 then
									local newitm = #self.Clones[self.SelectedClone]["Items"] + 1
									self.StorageItems[itm]["Count"] = self.StorageItems[itm]["Count"] - 1
									self.Clones[self.SelectedClone]["Items"][newitm] = {}
									self.Clones[self.SelectedClone]["Items"][newitm]["Preset"] = self.StorageItems[itm]["Preset"]
									self.Clones[self.SelectedClone]["Items"][newitm]["Class"] = self.StorageItems[itm]["Class"]
									
									-- Update game state
									CF_SetClonesArray(self.GS, self.Clones)
									CF_SetStorageArray(self.GS, self.StorageItems)
							
									-- Refresh storage array and filters
									if self.StorageItems[itm]["Count"] == 0 then
										self.StorageItems, self.StorageFilters = CF_GetStorageArray(self.GS, true)							
									end
								else
									self.ClonesControlLastMessageTime = self.Time
									self.ClonesControlMessageText = "No more items in storage"
								end
							else
								self.ClonesControlLastMessageTime = self.Time
								self.ClonesControlMessageText = "Unit inventory full"
							end
						else
							self.ClonesControlLastMessageTime = self.Time
							self.ClonesControlMessageText = "Clone storage empty"
						end
					end
				else
					self.FirePressed = false
				end

				-- Bacause StorageFilters my change outside of this panel by other players always check for out-of-bounds 
				if self.ClonesStorageSelectedItem > #self.StorageFilters[self.StorageControlPanelModes.EVERYTHING] and #self.StorageFilters[self.StorageControlPanelModes.EVERYTHING] > 0 then
					self.ClonesStorageSelectedItem = #self.StorageFilters[self.StorageControlPanelModes.EVERYTHING]
				end
				
				if cont:IsState(Controller.PRESS_UP) then
					if #self.StorageFilters[self.StorageControlPanelModes.EVERYTHING] > 0 then
						self.ClonesStorageSelectedItem = self.ClonesStorageSelectedItem - 1
						
						if self.ClonesStorageSelectedItem < 1 then
							self.ClonesStorageSelectedItem = 1
						end
					end
				end

				if cont:IsState(Controller.PRESS_DOWN) then
					if #self.StorageFilters[self.StorageControlPanelModes.EVERYTHING] > 0 then
						self.ClonesStorageSelectedItem = self.ClonesStorageSelectedItem + 1
						
						if self.ClonesStorageSelectedItem > #self.StorageFilters[self.StorageControlPanelModes.EVERYTHING] then
							self.ClonesStorageSelectedItem = #self.StorageFilters[self.StorageControlPanelModes.EVERYTHING]
						end
					end
				end		
			end
			
			-- Draw clones inventory and stored items lists
			if self.ClonesControlMode == self.ClonesControlPanelModes.INVENTORY or self.ClonesControlMode == self.ClonesControlPanelModes.ITEMS then
				-- Draw selected clone items
				if self.SelectedClone ~= nil and self.SelectedClone > 0 then
					-- Print inventory
					CF_DrawString(self.Clones[self.SelectedClone]["Preset"]..": "..#self.Clones[self.SelectedClone]["Items"].."/"..CF_MaxItems, pos + Vector(-141 + 12,-60) , 300, 10)
				
					for i = 1, #self.Clones[self.SelectedClone]["Items"] do
						if self.ClonesControlMode == self.ClonesControlPanelModes.INVENTORY and self.ClonesInventorySelectedItem == i then
							CF_DrawString("> "..self.Clones[self.SelectedClone]["Items"][i]["Preset"], pos + Vector(-141 + 12,-40) + Vector(0, (i - 1) * 12), 120, 10)
							self.ClonesControlPanelModesTexts[self.ClonesControlPanelModes.INVENTORY] = self.Clones[self.SelectedClone]["Items"][i]["Preset"] .. " - Inventory"
						else
							CF_DrawString(self.Clones[self.SelectedClone]["Items"][i]["Preset"], pos + Vector(-141 + 12,-40) + Vector(0, (i - 1) * 12), 120, 10)
						end
					end
				end

				local liststart = self.ClonesStorageSelectedItem - (self.ClonesStorageSelectedItem - 1) % self.ClonesControlPanelLinesPerPage

				-- Draw items list
				for i = liststart, liststart + self.ClonesControlPanelLinesPerPage - 1 do
					if i <= #self.StorageFilters[self.StorageControlPanelModes.EVERYTHING] then
						local itm = self.StorageFilters[self.StorageControlPanelModes.EVERYTHING][i]
						local loc = i - liststart
						
						
						if self.ClonesControlMode == self.ClonesControlPanelModes.ITEMS and self.ClonesStorageSelectedItem == i then
							CF_DrawString("> "..self.StorageItems[itm]["Preset"], pos + Vector(12,-40) + Vector(0, (loc) * 12), 110, 10)
							self.ClonesControlPanelModesTexts[self.ClonesControlPanelModes.ITEMS] = self.StorageItems[itm]["Preset"] .. " - Items"

						else
							CF_DrawString(self.StorageItems[itm]["Preset"], pos + Vector(12,-40) + Vector(0, (loc) * 12), 110, 10)
						end
						
						CF_DrawString(tostring(self.StorageItems[itm]["Count"]), pos + Vector(12,-40) + Vector(110, (loc) * 12), 110, 10)
					end
				end
				
				-- Print storage capacity
				CF_DrawString("Capacity: "..CF_CountUsedStorageInArray(self.StorageItems).."/"..self.GS["Player0VesselStorageCapacity"], pos + Vector(12,-60) , 300, 10)
			end
			
			-- Draw generic UI
			if self.ClonesControlMode ~= self.ClonesControlPanelModes.SELL then
				self:PutGlow("ControlPanel_Clones_Left", pos + Vector(-71,0))
				self:PutGlow("ControlPanel_Clones_Right", pos + Vector(70,0))
				self:PutGlow("ControlPanel_Clones_HorizontalPanel", pos + Vector(0,-77))
			else
				self:PutGlow("ControlPanel_Clones_Left_Red", pos + Vector(-71,0))
				self:PutGlow("ControlPanel_Clones_Right_Red", pos + Vector(70,0))
				self:PutGlow("ControlPanel_Clones_HorizontalPanel_Red", pos + Vector(0,-77))
			end
			
			-- Print help text or error message text
			if self.Time < self.ClonesControlLastMessageTime + self.ClonesControlMessageIntrval then
				self:PutGlow("ControlPanel_Clones_HorizontalPanel_Red", pos + Vector(0,78))
				CF_DrawString(self.ClonesControlMessageText, pos + Vector(-130,78) , 300, 10)
			else
				if self.ClonesControlMode ~= self.ClonesControlPanelModes.SELL then
					self:PutGlow("ControlPanel_Clones_HorizontalPanel", pos + Vector(0,78))
				else
					self:PutGlow("ControlPanel_Clones_HorizontalPanel_Red", pos + Vector(0,78))
				end
					
				CF_DrawString(self.ClonesControlPanelModesHelpTexts[self.ClonesControlMode], pos + Vector(-130,78) , 300, 10)
			end
			
			-- Print Selected mode text
			CF_DrawString(self.ClonesControlPanelModesTexts[self.ClonesControlMode], pos + Vector(-130,-77) , 250, 10)
		end
	end
	
	if showidle and self.ClonesControlPanelPos ~= nil and self.ClonesControlPanelActor ~= nil then
		self.ClonesControlPanelInitialized = false
		self:PutGlow("ControlPanel_Clones", self.ClonesControlPanelPos)
		--CF_DrawString("CLONES",self.ClonesControlPanelPos + Vector(-16,0),120,20 )
		--print (self.ClonesControlPanelActor)
	end
	
	-- Process clones input
	if self.ClonesInputPos ~= nil and self.ClonesControlPanelActor ~= nil then
		local count = CF_CountUsedClonesInArray(self.Clones)
		local toresettimer = true
	
		if  count < tonumber(self.GS["Player0VesselClonesCapacity"]) then
			local hasactor = false
			
			-- Search for body and put it in storage
			for actor in MovableMan.Actors do
				if CF_Dist(actor.Pos, self.ClonesInputPos) <= self.ClonesInputRange and actor.PresetName ~= "Clones Control Panel" then
					toresettimer = false
				
					if self.ClonesLastDetectedBodyTime ~= nil then
						-- Put clone to storage
						if self.Time >= self.ClonesLastDetectedBodyTime + self.ClonesInputDelay and CF_CountUsedClonesInArray(self.Clones) < tonumber(self.GS["Player0VesselClonesCapacity"]) then
							local c = #self.Clones + 1
							
							self.Clones[c] = {}
							self.Clones[c]["Preset"] = actor.PresetName
							self.Clones[c]["Class"] = actor.ClassName
							
							-- Store inventory
							local inv, cls = CF_GetInventory(actor)
							
							self.Clones[c]["Items"] = {}
							
							for i = 1, #inv do
								-- First store items in clone storage
								if i <= CF_MaxItems then
									self.Clones[c]["Items"][i] = {}
									self.Clones[c]["Items"][i]["Preset"] = inv[i]
									self.Clones[c]["Items"][i]["Class"] = cls[i]
								else
									-- Try to store other items in items storage
									-- If we have free space add items to storage, spawn nearby otherwise
									if CF_CountUsedStorageInArray(self.StorageItems) < tonumber(self.GS["Player0VesselStorageCapacity"]) then
										-- Put item to storage array
										CF_PutItemToStorageArray(self.StorageItems, inv[i], cls[i])
										
										-- Store everything
										CF_SetStorageArray(self.GS, self.StorageItems)
										
										-- Refresh storage items array and filters
										self.StorageItems, self.StorageFilters = CF_GetStorageArray(self.GS, true)
									else
										local itm = CF_MakeItem2(inv[i], cls[i])
										if itm ~= nil then
											itm.Pos = self.ClonesInputPos
											MovableMan:AddItem(itm)
										end
									end
								end
							end
							
							actor.ToDelete = true
							
							-- Store everything
							CF_SetClonesArray(self.GS, self.Clones)
							
							-- Refresh storage items array and filters
							self.Clones = CF_GetClonesArray(self.GS, true)
							
							self.ClonesLastDetectedBodyTime = nil
						end
						
						hasactor = true
					else
						self.ClonesLastDetectedBodyTime = self.Time
					end
				end
			end
			
			if showidle then
				if hasactor and self.ClonesLastDetectedBodyTime ~= nil then
					self:AddObjectivePoint("Store in "..self.ClonesLastDetectedBodyTime + self.ClonesInputDelay - self.Time, self.ClonesInputPos , CF_PlayerTeam, GameActivity.ARROWDOWN);
				else
					self:AddObjectivePoint("Stand here to store body\n"..count.." / "..self.GS["Player0VesselClonesCapacity"], self.ClonesInputPos , CF_PlayerTeam, GameActivity.ARROWDOWN);
				end
			end
		else
			self:AddObjectivePoint("Clone storage is full", self.ClonesInputPos + Vector(0,-40) , CF_PlayerTeam, GameActivity.ARROWUP);
			self.ClonesLastDetectedBodyTime = nil
		end
		
		if toresettimer then
			self.ClonesLastDetectedBodyTime = nil
		end
	end
	
	
	if MovableMan:IsActor(self.CloneControlPanelActor) then
		self.CloneControlPanelActor.Health = 100
	end
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
