-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:InitShipControlPanelUI()
	-- Ship Control Panel
	local x,y;
			
	x = tonumber(self.LS["ShipControlPanelX"])
	y = tonumber(self.LS["ShipControlPanelY"])
	if x~= nil and y ~= nil then
		self.ShipControlPanelPos = Vector(x,y)
	else
		self.ShipControlPanelPos = nil
	end

	-- Create actor
	-- Ship
	if self.ShipControlPanelPos ~= nil then
		if not MovableMan:IsActor(self.ShipControlPanelActor) then
			self.ShipControlPanelActor = CreateActor("Ship Control Panel")
			if self.ShipControlPanelActor ~= nil then
				self.ShipControlPanelActor.Pos = self.ShipControlPanelPos
				self.ShipControlPanelActor.Team = CF_PlayerTeam
				MovableMan:AddActor(self.ShipControlPanelActor)
			end
		end
	end
	
	-- Init variables
	self.ShipControlPanelModes = {LOCATION = 0, PLANET = 1}
	
	self.ShipControlMode = self.ShipControlPanelModes.LOCATION
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:ProcessShipControlPanelUI()
	local showidle = true
	local resetlists = false;
	
	for plr = 0 , self.PlayerCount - 1 do
		local act = self:GetControlledActor(plr);
	
		if MovableMan:IsActor(act) and act.PresetName == "Ship Control Panel" then
			showidle = false
			
			-- Fill planet list
			self.ShipControlPlanetList = {}
			for i = 1, #CF_Planet do
				if CF_Planet[i] ~= self.GS["Planet"] then
					self.ShipControlPlanetList[#self.ShipControlPlanetList + 1] = CF_Planet[i]
				end
			end
			
			-- Fill location list
			self.ShipControlLocationList = {}
			for i = 1, #CF_Location do
				if CF_LocationPlanet[CF_Location[i]] == self.GS["Planet"] and CF_Location[i] ~= self.GS["Location"] then
					self.ShipControlLocationList[#self.ShipControlLocationList + 1] = CF_Location[i]
				end
			end
			
			local cont = act:GetController()

			if cont:IsState(Controller.PRESS_UP) then
				if self.ShipControlMode == self.ShipControlPanelModes.LOCATION then
					-- Select location
					self.ShipControlSelectedLocation = self.ShipControlSelectedLocation - 1
					if self.ShipControlSelectedLocation < 1 then
						self.ShipControlSelectedLocation = 1
					end
				elseif self.ShipControlMode == self.ShipControlPanelModes.PLANET then
					-- Select planet
					self.ShipControlSelectedPlanet = self.ShipControlSelectedPlanet - 1
					if self.ShipControlSelectedPlanet < 1 then
						self.ShipControlSelectedPlanet = 1
					end
				end
			end

			if cont:IsState(Controller.PRESS_DOWN) then
				if self.ShipControlMode == self.ShipControlPanelModes.LOCATION then
					-- Select planet
					self.ShipControlSelectedLocation = self.ShipControlSelectedLocation + 1
					if self.ShipControlSelectedLocation > #self.ShipControlLocationList then
						self.ShipControlSelectedLocation = #self.ShipControlLocationList
					end
				elseif self.ShipControlMode == self.ShipControlPanelModes.PLANET then
					-- Select planet
					self.ShipControlSelectedPlanet = self.ShipControlSelectedPlanet + 1
					if self.ShipControlSelectedPlanet > #self.ShipControlPlanetList then
						self.ShipControlSelectedPlanet = #self.ShipControlPlanetList
					end
				end
			end
			
			-- Scroll the lists
			self.ShipControlPlanetListStart = self.ShipControlSelectedPlanet - (self.ShipControlSelectedPlanet - 1) % 3
			self.ShipControlLocationListStart = self.ShipControlSelectedLocation - (self.ShipControlSelectedLocation - 1) % 3

			if cont:IsState(Controller.PRESS_LEFT) or cont:IsState(Controller.PRESS_RIGHT) then
				if self.ShipControlMode == self.ShipControlPanelModes.PLANET then
					self.ShipControlMode = self.ShipControlPanelModes.LOCATION
				else
					self.ShipControlMode = self.ShipControlPanelModes.PLANET
				end
			end
			
			if cont:IsState(Controller.WEAPON_FIRE) then
				if not self.FirePressed then
					self.FirePressed = true;
					
					if self.ShipControlMode == self.ShipControlPanelModes.LOCATION then
						self.GS["Location"] = self.ShipControlLocationList [ self.ShipControlSelectedLocation ]
						-- Recreate all lists
						resetlists = true
					elseif self.ShipControlMode == self.ShipControlPanelModes.PLANET then
						-- Travel to another planet
						self.GS["Planet"] = self.ShipControlPlanetList [ self.ShipControlSelectedPlanet ]
						self.GS["Location"] = nil
						-- Recreate all lists
						resetlists = true
						
						if self.GS["Planet"] ~= "TradeStar" then
							self:TriggerShipAssault()
						end
					end
				end
			else
				self.FirePressed = false
			end
			
			-- Draw generic UI
			local plntpreset = CF_PlanetGlow[ self.GS["Planet"] ]
			local plntmodeule = CF_PlanetGlowModule[ self.GS["Planet"] ]
			local pos = act.Pos
			self:PutGlow("ControlPanel_Ship_PlanetBack", pos)
			self:PutGlow("ControlPanel_Ship_LocationList", pos + Vector(0, 89))
			self:PutGlow(plntpreset, pos, plntmodeule)
			
			if self.ShipControlMode == self.ShipControlPanelModes.LOCATION then
				-- Draw mode specific elements
				-- Write current location
				local locname = CF_LocationName[ self.GS["Location"] ]
				if locname ~= nil then
					CF_DrawString(locname, pos + Vector(-62, -52), 130, 40)
				else
					CF_DrawString("Distant orbit", pos + Vector(-62, -52), 130, 40)
				end
				CF_DrawString("CURRENT LOCATION:", pos + Vector(-62, -62), 130, 40)
				
				-- Show current location dot
				local locpos = CF_LocationPos[ self.GS["Location"] ]
				if locpos ~= nil then
					self:PutGlow("ControlPanel_Ship_CurrentLocation", pos + locpos)
				end
				
				-- Show selected location dot
				local locpos = CF_LocationPos[ self.ShipControlLocationList[ self.ShipControlSelectedLocation ] ]
				if locpos ~= nil then
					self:PutGlow("ControlPanel_Ship_LocationDot", pos + locpos)
				end
				
				-- Show location list
				if #self.ShipControlLocationList > 0 then
					for i = self.ShipControlLocationListStart, self.ShipControlLocationListStart + 2 do
						local pname = CF_LocationName[ self.ShipControlLocationList[i] ]
						if pname ~= nil then
							if i == self.ShipControlSelectedLocation then
								CF_DrawString("> " .. pname, pos + Vector(-62, 77 + (i - self.ShipControlLocationListStart) * 11), 130, 12)
							else
								CF_DrawString(pname, pos + Vector(-62, 77 + (i - self.ShipControlLocationListStart) * 11), 130, 12)
							end
						end
					end
				else
					CF_DrawString("NO OTHER LOCATIONS", pos + Vector(-62, 77), 130, 12)
				end
			elseif self.ShipControlMode == self.ShipControlPanelModes.PLANET then
				-- Show current planet
				local locname = CF_PlanetName[ self.GS["Planet"] ]
				if locname ~= nil then
					CF_DrawString(locname, pos + Vector(-62, -52), 130, 40)
				end
				CF_DrawString("NOW ORBITING:", pos + Vector(-62, -62), 130, 40)
				
				-- Show planet list
				for i = self.ShipControlPlanetListStart, self.ShipControlPlanetListStart + 2 do
					local pname = CF_PlanetName[ self.ShipControlPlanetList[i] ]
					if pname ~= nil then
						if i == self.ShipControlSelectedPlanet then
							CF_DrawString("> " .. pname, pos + Vector(-62, 77 + (i - self.ShipControlPlanetListStart) * 11), 130, 12)
						else
							CF_DrawString(pname, pos + Vector(-62, 77 + (i - self.ShipControlPlanetListStart) * 11), 130, 12)
						end
					end
				end
			end
		end
	end
	
	if showidle and self.ShipControlPanelPos ~= nil then
		self:PutGlow("ControlPanel_Ship", self.ShipControlPanelPos)
		resetlists = true
	end
	
	if resetlists then
		self.ShipControlMode = self.ShipControlPanelModes.LOCATION
		
		self.ShipControlSelectedLocation = 1
		self.ShipControlLocationList = nil
		self.ShipControlLocationListStart = 1
		
		self.ShipControlSelectedPlanet = 1
		self.ShipControlPlanetListStart = 1
		self.ShipControlPlanetList = nil
	end
end