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
	self.ShipControlPanelModes = {REPORT = 0, LOCATION = 1, PLANET = 2}

	-- Debug
	--for i = 1, CF_MaxMissionReportLines do
	--	self.GS["MissionReport"..i] = "STRING "..i
	--end		
	
	--self.MissionReport = {}
	
	if self.MissionReport ~= nil then
		self.ShipControlMode = self.ShipControlPanelModes.REPORT
	else
		self.ShipControlMode = self.ShipControlPanelModes.LOCATION
	end
	
	self.ShipControlSelectedLocation = 1
	self.ShipControlLocationList = nil
	self.ShipControlLocationListStart = 1
	
	self.ShipControlSelectedPlanet = 1
	self.ShipControlPlanetListStart = 1
	self.ShipControlPlanetList = nil
	
	self.ShipControlLocationsPerPage = 10
	self.ShipControlPlanetsPerPage = 10
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:DestroyShipControlPanelUI()
	if self.ShipControlPanelActor ~= nil then
		self.ShipControlPanelActor.ToDelete = true
		self.ShipControlPanelActor = nil
	end
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:ProcessShipControlPanelUI()
	local showidle = true
	local resetlists = false;
	
	-- Forc-show report if we have some report array left from previous mission
	if self.MissionReport ~= nil then
		self:SwitchToActor(self.ShipControlPanelActor, 0, CF_PlayerTeam)
		self.MissionReport = nil
	end

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

			-- Sort planet list
			for i = 1, #self.ShipControlPlanetList do
				for j = 1, #self.ShipControlPlanetList - 1 do
					if CF_PlanetName[ self.ShipControlPlanetList[j] ] > CF_PlanetName[ self.ShipControlPlanetList[j + 1] ] then
						local s = CF_PlanetName[ self.ShipControlPlanetList[j] ]
						CF_PlanetName[ self.ShipControlPlanetList[j] ] = CF_PlanetName[ self.ShipControlPlanetList[j + 1] ]
						CF_PlanetName[ self.ShipControlPlanetList[j + 1] ] = s
					end
				end
			end

			
			-- Fill location list
			self.ShipControlLocationList = {}
			for i = 1, #CF_Location do
				--if CF_LocationPlanet[CF_Location[i]] == self.GS["Planet"] and CF_Location[i] ~= self.GS["Location"] then
				if CF_LocationPlanet[CF_Location[i]] == self.GS["Planet"] then
					self.ShipControlLocationList[#self.ShipControlLocationList + 1] = CF_Location[i]
				end
			end
			
			-- Sort location list
			for i = 1, #self.ShipControlLocationList do
				for j = 1, #self.ShipControlLocationList - 1 do
					if CF_LocationName[ self.ShipControlLocationList[j] ] > CF_LocationName[ self.ShipControlLocationList[j + 1] ] then
						local s = CF_LocationName[ self.ShipControlLocationList[j] ]
						CF_LocationName[ self.ShipControlLocationList[j] ] = CF_LocationName[ self.ShipControlLocationList[j + 1] ]
						CF_LocationName[ self.ShipControlLocationList[j + 1] ] = s
					end
				end
			end
			
			local cont = act:GetController()
			local pos = act.Pos
			
---------------------------------------------------------------------------------------------------
			if self.ShipControlMode == self.ShipControlPanelModes.LOCATION then 
				if cont:IsState(Controller.PRESS_UP) then
					-- Select location
					self.ShipControlSelectedLocation = self.ShipControlSelectedLocation - 1
					if self.ShipControlSelectedLocation < 1 then
						self.ShipControlSelectedLocation = 1
					end
				end
			
				if cont:IsState(Controller.PRESS_DOWN) then
					-- Select location
					self.ShipControlSelectedLocation = self.ShipControlSelectedLocation + 1
					if self.ShipControlSelectedLocation > #self.ShipControlLocationList then
						self.ShipControlSelectedLocation = #self.ShipControlLocationList
					end
				end
				
				if cont:IsState(Controller.WEAPON_FIRE) then
					if not self.FirePressed then
						self.FirePressed = true;
						
						--self.GS["Location"] = self.ShipControlLocationList [ self.ShipControlSelectedLocation ]
						if self.GS["Location"] ~= nil then
							local locpos = CF_LocationPos[ self.GS["Location"] ]
							if locpos == nil then
								locpos = Vector(0,0)
							end

							self.GS["ShipX"] = math.floor(locpos.X)
							self.GS["ShipY"] = math.floor(locpos.Y)
						end
						
						self.GS["Location"] = nil
						self.GS["Destination"] = self.ShipControlLocationList [ self.ShipControlSelectedLocation ]

						local destpos = CF_LocationPos[ self.GS["Destination"] ]
						if destpos == nil then
							destpos = Vector(0,0)
						end
						
						self.GS["DestX"] = math.floor(destpos.X)
						self.GS["DestY"] = math.floor(destpos.Y)
						
						self.GS["Distance"] = CF_Dist(Vector(tonumber(self.GS["ShipX"]),tonumber(self.GS["ShipY"])), Vector(tonumber(self.GS["DestX"]),tonumber(self.GS["DestX"])))
						
						-- Recreate all lists
						--resetlists = true
					end
				else
					self.FirePressed = false
				end
				
				self.ShipControlLocationListStart = self.ShipControlSelectedLocation - (self.ShipControlSelectedLocation - 1) % self.ShipControlLocationsPerPage
				
				-- Draw mode specific elements
				-- Write current location
				if self.GS["Destination"] ~= nil then
					local dst = math.ceil(tonumber(self.GS["Distance"]) * CF_KmPerPixel)
				
					CF_DrawString("EN ROUTE TO: ", pos + Vector(-62-71, -78), 270, 40)
					local locname = CF_LocationName[ self.GS["Destination"] ]
					if locname ~= nil then
						CF_DrawString(locname .. " - "..dst.." km", pos + Vector(-64, -78), 180, 40)
					end
				else
					CF_DrawString("CURRENT LOCATION:", pos + Vector(-62-71, -78), 270, 40)
					local locname = CF_LocationName[ self.GS["Location"] ]
					if locname ~= nil then
						CF_DrawString(locname, pos + Vector(-34, -78), 130, 40)
					else
						CF_DrawString("Distant orbit", pos + Vector(-34, -78), 130, 40)
					end
				end

				CF_DrawString("FLY TO NEW LOCATION:", pos + Vector(-62-71, -60), 270, 40)
				
				CF_DrawString("U/D - Select location, FIRE - Fly", pos + Vector(-62-71, 78), 270, 40)
				
				local shippos = Vector(0,0)
				
				if self.GS["Destination"] ~= nil then
					local sx = tonumber(self.GS["ShipX"])
					local sy = tonumber(self.GS["ShipY"])

					local dx = tonumber(self.GS["DestX"])
					local dy = tonumber(self.GS["DestY"])
					
					local cx = pos.X + 70
					local cy = pos.Y
					
					self:PutGlow("ControlPanel_Ship_CurrentLocation", pos + Vector(sx,sy) + Vector(70,0))
					
					self:DrawDottedLine(cx + sx, cy + sy, cx + dx, cy + dy, "ControlPanel_Ship_DestDot",5)
					
					shippos = Vector(sx,sy)
				else
					local locpos = CF_LocationPos[ self.GS["Location"] ]
					if locpos ~= nil then
						self:PutGlow("ControlPanel_Ship_CurrentLocation", pos + locpos + Vector(70,0))
						shippos = locpos
					end
				end
				
				-- Show selected location dot
				local locpos = CF_LocationPos[ self.ShipControlLocationList[ self.ShipControlSelectedLocation ] ]
				if locpos ~= nil then
					self:PutGlow("ControlPanel_Ship_LocationDot", pos + locpos + Vector(70,0))
					
					-- Draw line to location
					local sx = shippos.X
					local sy = shippos.Y

					local dx = locpos.X
					local dy = locpos.Y
					
					local cx = pos.X + 70
					local cy = pos.Y
					
					self:DrawDottedLine(cx + sx, cy + sy, cx + dx, cy + dy, "ControlPanel_Ship_RouteDot",3)
				end
				
				-- Write security level
				local diff = CF_GetLocationDifficulty(self.GS, self.ShipControlLocationList[ self.ShipControlSelectedLocation ])
				CF_DrawString("SECURITY: "..string.upper(CF_LocationDifficultyTexts[diff]), pos + Vector(8, -60), 136, 182-34)
				
				-- Write gold status
				local gold = CF_LocationGoldPresent[ self.ShipControlLocationList[ self.ShipControlSelectedLocation ] ]
				if gold ~= nil then
					local s = "ABSENT"
					
					if gold == true then
						s = "PRESENT"
					end
					CF_DrawString("GOLD: "..s, pos + Vector(8, -48), 136, 182-34)
				else
					CF_DrawString("GOLD: UNKNOWN", pos + Vector(8, -48), 136, 182-34)
				end
				
				-- Show location list
				if #self.ShipControlLocationList > 0 then
					for i = self.ShipControlLocationListStart, self.ShipControlLocationListStart + self.ShipControlLocationsPerPage - 1 do
						local pname = CF_LocationName[ self.ShipControlLocationList[i] ]
						if pname ~= nil then
							if i == self.ShipControlSelectedLocation then
								CF_DrawString("> " .. pname, pos + Vector(-62 - 71, -40 + (i - self.ShipControlLocationListStart) * 11), 130, 12)
							else
								CF_DrawString(pname, pos + Vector(-62 - 71, -40 + (i - self.ShipControlLocationListStart) * 11), 130, 12)
							end
						end
					end
				else
					CF_DrawString("NO OTHER LOCATIONS", pos + Vector(-62, 77), 130, 12)
				end
				
				local plntpreset = CF_PlanetGlow[ self.GS["Planet"] ]
				local plntmodeule = CF_PlanetGlowModule[ self.GS["Planet"] ]
				self:PutGlow("ControlPanel_Ship_PlanetBack", pos + Vector(-71, 0))
				self:PutGlow("ControlPanel_Ship_PlanetBack", pos + Vector(70, 0))
				--self:PutGlow("ControlPanel_Ship_LocationList", pos + Vector(-71, 91))
				self:PutGlow(plntpreset, pos + Vector(70,0), plntmodeule)
				
				--self:PutGlow("ControlPanel_Ship_Description", pos + Vector(70,21))
				self:PutGlow("ControlPanel_Ship_HorizontalPanel", pos + Vector(0,-77))
				self:PutGlow("ControlPanel_Ship_HorizontalPanel", pos + Vector(0,78))				
			end
			
---------------------------------------------------------------------------------------------------
			if self.ShipControlMode == self.ShipControlPanelModes.PLANET then
				if cont:IsState(Controller.PRESS_UP) then
					-- Select planet
					self.ShipControlSelectedPlanet = self.ShipControlSelectedPlanet - 1
					if self.ShipControlSelectedPlanet < 1 then
						self.ShipControlSelectedPlanet = 1
					end
				end
			
				if cont:IsState(Controller.PRESS_DOWN) then
					-- Select planet
					self.ShipControlSelectedPlanet = self.ShipControlSelectedPlanet + 1
					if self.ShipControlSelectedPlanet > #self.ShipControlPlanetList then
						self.ShipControlSelectedPlanet = #self.ShipControlPlanetList
					end
				end
				
				if cont:IsState(Controller.WEAPON_FIRE) then
					if not self.FirePressed then
						self.FirePressed = true;
						
						-- Travel to another planet
						self.GS["Planet"] = self.ShipControlPlanetList [ self.ShipControlSelectedPlanet ]
						self.GS["Location"] = nil
						-- Recreate all lists
						resetlists = true
					end
				else
					self.FirePressed = false
				end

				self.ShipControlPlanetListStart = self.ShipControlSelectedPlanet - (self.ShipControlSelectedPlanet - 1) % self.ShipControlPlanetsPerPage

				-- Show current planet
				local locname = CF_PlanetName[ self.GS["Planet"] ]
				if locname ~= nil then
					CF_DrawString(locname, pos + Vector(-54, -78), 130, 40)
				end
				CF_DrawString("NOW ORBITING:", pos + Vector(-62-71, -78), 130, 40)

				CF_DrawString("WARP TO ANOTHER PLANET:", pos + Vector(-62-71, -60), 270, 40)

				CF_DrawString("U/D - Select location, FIRE - Fly", pos + Vector(-62-71, 78), 270, 40)
				
				-- Show current planet dot
				local locpos = CF_PlanetPos[ self.GS["Planet"] ]
				if locpos ~= nil then
					self:PutGlow("ControlPanel_Ship_CurrentLocation", pos + locpos + Vector(70,0))
				end
				
				-- Show selected planet dot
				local shppos = CF_PlanetPos[ self.ShipControlPlanetList[ self.ShipControlSelectedPlanet ] ]
				if shppos ~= nil then
					self:PutGlow("ControlPanel_Ship_LocationDot", pos + shppos + Vector(70,0))
				end

				if locpos ~= nil and shppos ~= nil then
					-- Draw line to location
					local sx = locpos.X
					local sy = locpos.Y

					local dx = shppos.X
					local dy = shppos.Y
					
					local cx = pos.X + 70
					local cy = pos.Y
					
					self:DrawDottedLine(cx + sx, cy + sy, cx + dx, cy + dy, "ControlPanel_Ship_RouteDot",3)
				end
				
				-- Show planet list
				for i = self.ShipControlPlanetListStart, self.ShipControlPlanetListStart + self.ShipControlPlanetsPerPage - 1 do
					local pname = CF_PlanetName[ self.ShipControlPlanetList[i] ]
					if pname ~= nil then
						if i == self.ShipControlSelectedPlanet then
							CF_DrawString("> " .. pname, pos + Vector(-62 - 71, -40 + (i - self.ShipControlPlanetListStart) * 11), 130, 12)
						else
							CF_DrawString(pname, pos + Vector(-62 - 71, -40 + (i - self.ShipControlPlanetListStart) * 11), 130, 12)
						end
					end
				end
				
				--local plntpreset = CF_PlanetGlow[ self.ShipControlPlanetList [ self.ShipControlSelectedPlanet ] ]
				--local plntmodeule = CF_PlanetGlowModule[ self.ShipControlPlanetList [ self.ShipControlSelectedPlanet ] ]

				self:PutGlow("ControlPanel_Ship_PlanetBack", pos + Vector(-71, 0))
				self:PutGlow("ControlPanel_Ship_GalaxyBack", pos + Vector(70,0))
				--self:PutGlow("ControlPanel_Ship_LocationList", pos + Vector(-71, 91))
				--self:PutGlow(plntpreset, pos + Vector(70,0), plntmodeule)
				
				--self:PutGlow("ControlPanel_Ship_Description", pos + Vector(70,21))
				self:PutGlow("ControlPanel_Ship_HorizontalPanel", pos + Vector(0,-77))
				self:PutGlow("ControlPanel_Ship_HorizontalPanel", pos + Vector(0,78))
				
			end
---------------------------------------------------------------------------------------------------
			-- Show last mission report
			if self.ShipControlMode == self.ShipControlPanelModes.REPORT then
				-- Show current planet
				self:PutGlow("ControlPanel_Ship_Report", pos)
				CF_DrawString("MISSION REPORT", pos + Vector(-34,-60), 262, 141)

				self:PutGlow("ControlPanel_Ship_HorizontalPanel", pos + Vector(0,78))
				CF_DrawString("Press FIRE to save game", pos + Vector(-60,77), 262, 141)
				
				for i = 1, CF_MaxMissionReportLines do
					if self.GS["MissionReport"..i] ~= nil then
						CF_DrawString(self.GS["MissionReport"..i], pos + Vector(-130,-56 + i * 10), 262, 141)
					else
						break
					end
				end
				
				if cont:IsState(Controller.WEAPON_FIRE) then
					if not self.FirePressed then
						self.FirePressed = true;
						
						self:SaveActors()
						self:SaveCurrentGameState()
						
						self:LaunchScript("VoidWanderers Strategy Screen", "StrategyScreenMain.lua")
						FORM_TO_LOAD = BASE_PATH.."FormSave.lua"
						self.EnableBrainSelection = false
						self:DestroyConsoles()
						return
					end
				else
					self.FirePressed = false
				end
			end
---------------------------------------------------------------------------------------------------
			
			if cont:IsState(Controller.PRESS_LEFT) then
				self.ShipControlMode = self.ShipControlMode - 1
				self.ShipSelectedItem = 1
				self.LastShipSelectedItem = 0
				
				if self.ShipControlMode == -1 then
					self.ShipControlMode = self.ShipControlPanelModes.REPORT
				end
			end	

			if cont:IsState(Controller.PRESS_RIGHT) then
				self.ShipControlMode = self.ShipControlMode + 1
				self.ShipSelectedItem = 1
				self.LastShipSelectedItem = 0
				
				if self.ShipControlMode == 3 then
					self.ShipControlMode = self.ShipControlPanelModes.PLANET
				end
			end			
		end
	end

	if showidle and self.ShipControlPanelPos ~= nil then
		self:PutGlow("ControlPanel_Ship", self.ShipControlPanelPos)
		CF_DrawString("BRIDGE",self.ShipControlPanelPos + Vector(-15,0),120,20 )
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