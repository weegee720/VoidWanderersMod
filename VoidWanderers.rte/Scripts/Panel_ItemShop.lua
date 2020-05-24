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

	x = tonumber(self.LS["ItemShopInputX"])
	y = tonumber(self.LS["ItemShopInputY"])
	if x~= nil and y ~= nil then
		self.ItemShopInputPos = Vector(x,y)
	else
		self.ItemShopInputPos = nil
	end
	
	x = tonumber(self.LS["ItemShopDeployX"])
	y = tonumber(self.LS["ItemShopDeployY"])
	if x~= nil and y ~= nil then
		self.ItemShopDeployPos = Vector(x,y)
	else
		self.ItemShopDeployPos = nil
	end
	
	-- Create actor
	if self.ItemShopControlPanelPos ~= nil then
		if not MovableMan:IsActor(self.ItemShopControlPanelActor) then
			self.ItemShopControlPanelActor = CreateActor("ItemShop Control Panel")
			if self.ItemShopControlPanelActor ~= nil then
				self.ItemShopControlPanelActor.Pos = self.ItemShopControlPanelPos
				self.ItemShopControlPanelActor.Team = CF_PlayerTeam
				MovableMan:AddActor(self.ItemShopControlPanelActor)
			end
		end
		
		-- Crate debug
		--local crt = CreateMOSRotating("Case", self.ModuleName)
		--[[local crt = CreateMOSRotating("Crate", self.ModuleName)
		if crt then
			crt.Pos = self.ItemShopControlPanelPos
			MovableMan:AddParticle(crt)
		end		--]]--
	end
	
	self.ItemShopControlPanelItemsPerPage = 9
	
	self.ItemShopInputRange = 50
	self.ItemShopInputDelay = 3
	
	-- Init variables
	self.ItemShopControlPanelModes = {SELL = -3, UNKNOWN = -2, EVERYTHING = -1, PISTOL = 0, RIFLE = 1, SHOTGUN = 2, SNIPER = 3, HEAVY = 4, SHIELD = 5, DIGGER = 6, GRENADE = 7, TOOL = 8}
	self.ItemShopControlPanelModesTexts = {}
	
	self.ItemShopControlPanelModesTexts[self.ItemShopControlPanelModes.SELL] = "SELL ITEMS"
	self.ItemShopControlPanelModesTexts[self.ItemShopControlPanelModes.UNKNOWN] = "Unknown items"
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
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:ProcessItemShopControlPanelUI()
	local showidle = true

	for plr = 0 , self.PlayerCount - 1 do
		local act = self:GetControlledActor(plr);
	
		if MovableMan:IsActor(act) and act.PresetName == "ItemShop Control Panel" then
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
			if self.ItemShopControlMode ~= self.ItemShopControlPanelModes.SELL then
				self:PutGlow("ControlPanel_ItemShop_List", pos + Vector(-71,0))
				self:PutGlow("ControlPanel_ItemShop_Description", pos + Vector(90,0))
				self:PutGlow("ControlPanel_ItemShop_HorizontalPanel", pos + Vector(20,-77))
				self:PutGlow("ControlPanel_ItemShop_HorizontalPanel", pos + Vector(20,78))
				
				-- Print help text
				CF_DrawString("L/R - Change filter, U/D - Select, FIRE - Dispense", pos + Vector(-130,78) , 300, 10)
			else
				self:PutGlow("ControlPanel_ItemShop_ListRed", pos + Vector(-71,0))
				self:PutGlow("ControlPanel_ItemShop_DescriptionRed", pos + Vector(90,0))
				self:PutGlow("ControlPanel_ItemShop_HorizontalPanelRed", pos + Vector(20,-77))
				self:PutGlow("ControlPanel_ItemShop_HorizontalPanelRed", pos + Vector(20,78))
				
				self.ItemShopControlPanelModesTexts[self.ItemShopControlPanelModes.SELL] = "DUMP ITEMS"
				
				if self.GS["Planet"] == "TradeStar" and self.GS["Location"] ~= nil then
					self.ItemShopControlPanelModesTexts[self.ItemShopControlPanelModes.SELL] = "SELL ITEMS Gold: "..CF_GetPlayerGold(self.GS, 0).."oz"
					CF_DrawString("L/R - Change filter, U/D - Select, FIRE - Sell", pos + Vector(-130,78) , 300, 10)
				else
					CF_DrawString("L/R - Change filter, U/D - Select, FIRE - Dump", pos + Vector(-130,78) , 300, 10)
				end
			end


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
				
				if self.ItemShopControlMode == -4 then
					self.ItemShopControlMode = self.ItemShopControlPanelModes.TOOL
				end
			end	

			if cont:IsState(Controller.PRESS_RIGHT) then
				self.ItemShopControlMode = self.ItemShopControlMode + 1
				self.ItemShopSelectedItem = 1
				self.LastItemShopSelectedItem = 0
				
				if self.ItemShopControlMode == 9 then
					self.ItemShopControlMode = self.ItemShopControlPanelModes.SELL
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
					local f, i = CF_FindItemInFactions(self.ItemShopItems[itm]["Preset"], self.ItemShopItems[itm]["Class"])
					
					if f ~= nil and i ~= nil then
						self.ItemShopSelectedItemDescription = CF_ItmDescriptions[f][i]
						self.ItemShopSelectedItemManufacturer = CF_FactionNames[f]
						self.ItemShopSelectedItemPrice =  math.ceil(CF_ItmPrices[f][i] * CF_SellPriceCoeff)
					else
						self.ItemShopSelectedItemDescription = "Unknown item"
						self.ItemShopSelectedItemManufacturer = "Unknown"
						self.ItemShopSelectedItemPrice = CF_UnknownItemPrice
					end
					
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
						
						if self.ItemShopItems[itm]["Count"] > 0 then
							-- Remove item from ItemShop and spawn it
							self.ItemShopItems[itm]["Count"] = self.ItemShopItems[itm]["Count"] - 1
							
							if self.ItemShopControlMode ~= self.ItemShopControlPanelModes.SELL then
								local hasactor = false
								local foundactor = nil
								
								-- Try to find actor or put item as is otherwise
								for actor in MovableMan.Actors do
									if CF_Dist(actor.Pos, self.ItemShopInputPos) <= self.ItemShopInputRange then
										hasactor = true
										foundactor = actor
										break;
									end
								end
								
								local item = CF_MakeItem2(self.ItemShopItems[itm]["Preset"], self.ItemShopItems[itm]["Class"])
								if item ~= nil then
									if hasactor then
										foundactor:AddInventoryItem(item)
										foundactor:FlashWhite(250)
									else
										item.Pos = self.ItemShopDeployPos
										MovableMan:AddItem(item)
									end
								end
							else
								if self.GS["Planet"] == "TradeStar" and self.GS["Location"] ~= nil then
									if self.ItemShopSelectedItemPrice ~= nil then
										CF_SetPlayerGold(self.GS, 0, CF_GetPlayerGold(self.GS, 0) + self.ItemShopSelectedItemPrice)
									end
								end
							end
							-- Update game state
							CF_SetItemShopArray(self.GS, self.ItemShopItems)
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
						CF_DrawString("> "..self.ItemShopItems[itm]["Preset"], pos + Vector(-130,-40) + Vector(0, (loc) * 12), 90, 10)
					else
						CF_DrawString(self.ItemShopItems[itm]["Preset"], pos + Vector(-130,-40) + Vector(0, (loc) * 12), 90, 10)
					end
					CF_DrawString(tostring(self.ItemShopItems[itm]["Count"]), pos + Vector(-130,-40) + Vector(110, (loc) * 12), 90, 10)
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
				CF_DrawString(self.ItemShopSelectedItemDescription, pos + Vector(10,-10) , 170, 120)
			end

			-- Print manufacturer or price
			if self.ItemShopControlMode ~= self.ItemShopControlPanelModes.SELL then
				if self.ItemShopSelectedItemManufacturer ~= nil then
					CF_DrawString("Manufacturer: "..self.ItemShopSelectedItemManufacturer, pos + Vector(10,-25) , 170, 120)
				end
			else
				if self.GS["Planet"] == "TradeStar" and self.GS["Location"] ~= nil then
					if self.ItemShopSelectedItemPrice ~= nil then
						CF_DrawString("Sell price: "..self.ItemShopSelectedItemPrice.." oz", pos + Vector(10,-25) , 170, 120)
					end
				end
			end
			
			-- Print Selected mode text
			CF_DrawString(self.ItemShopControlPanelModesTexts[self.ItemShopControlMode], pos + Vector(-130,-77) , 170, 10)
			
			-- Print ItemShop capacity
			CF_DrawString("Capacity: "..CF_CountUsedItemShopInArray(self.ItemShopItems).."/"..self.GS["Player0VesselItemShopCapacity"], pos + Vector(-130,-60) , 300, 10)
		end
	end
	
	if showidle and self.ItemShopControlPanelPos ~= nil then
		self:PutGlow("ControlPanel_ItemShop", self.ItemShopControlPanelPos)
		CF_DrawString("ItemShop",self.ItemShopControlPanelPos + Vector(-16,0), 120, 20)

		self.ItemShopControlPanelInitialized = false
		
		-- Delete sample weapon
		if self.ItemShopControlPanelObject ~= nil then
			if MovableMan:IsDevice(self.ItemShopControlPanelObject) then
				self.ItemShopControlPanelObject.ToDelete = true
				self.ItemShopControlPanelObject = nil
			end
		end
	end
	
	-- Process weapons input
	if self.ClonesInputPos ~= nil then
		local count = CF_CountUsedItemShopInArray(self.ItemShopItems)
	
		if  count < tonumber(self.GS["Player0VesselItemShopCapacity"]) then
			local hasitem = false
			local toreset = true
			
			-- Search for item and put it in ItemShop
			for item in MovableMan.Items do
				--if CF_Dist(item.Pos, self.ItemShopInputPos) <= self.ItemShopInputRange then
				local storable = true
				
				if self.ItemShopControlPanelObject~= nil and item.ID == self.ItemShopControlPanelObject.ID then
					storable = false
				end
					
				if storable then
					toreset = false
				
					-- Debug
					--self:AddObjectivePoint("X", item.Pos , CF_PlayerTeam, GameActivity.ARROWDOWN);
				
					if self.ItemShopLastDetectedItemTime ~= nil then
						self:AddObjectivePoint("Store in "..self.ItemShopLastDetectedItemTime + self.ItemShopInputDelay - self.Time, item.Pos + Vector(0,-40) , CF_PlayerTeam, GameActivity.ARROWDOWN);

						-- Put item to ItemShop
						if self.Time >= self.ItemShopLastDetectedItemTime + self.ItemShopInputDelay and CF_CountUsedItemShopInArray(self.ItemShopItems) < tonumber(self.GS["Player0VesselItemShopCapacity"]) then
							local needrefresh = CF_PutItemToItemShopArray(self.ItemShopItems, item.PresetName, item.ClassName)
							
							item.ToDelete = true

							-- Store everything
							CF_SetItemShopArray(self.GS, self.ItemShopItems)
							
							-- Refresh ItemShop items array and filters
							if needrefresh then
								self.ItemShopItems, self.ItemShopFilters = CF_GetItemShopArray(self.GS, true)
							end
							
							self.ItemShopLastDetectedItemTime = nil
						end
						
						hasitem = true
						break
					else
						self.ItemShopLastDetectedItemTime = self.Time
					end
				end
				--end
			end
			
			if toreset then
				self.ItemShopLastDetectedItemTime = nil
			end
			
			if showidle then
				if hasitem and self.ItemShopLastDetectedItemTime ~= nil then
					
				else
					--self:AddObjectivePoint("Stand here to receive items\nor place items here to store\n"..count.." / "..self.GS["Player0VesselItemShopCapacity"], self.ItemShopDeployPos , CF_PlayerTeam, GameActivity.ARROWDOWN);
					self:AddObjectivePoint("Stand here to receive items\n"..count.." / "..self.GS["Player0VesselItemShopCapacity"], self.ItemShopDeployPos , CF_PlayerTeam, GameActivity.ARROWDOWN);
				end
			end
		else
			self:AddObjectivePoint("ItemShop is full", self.ItemShopInputPos + Vector(0,-40), CF_PlayerTeam, GameActivity.ARROWUP);
			self.ItemShopLastDetectedItemTime = nil
		end
	end
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
















