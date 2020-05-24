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
			
			-- Fill location list
			self.ShipControlLocationList = {}
			for i = 1, #CF_Location do
				if CF_LocationPlanet[CF_Location[i]] == self.GS["Planet"] and CF_Location[i] ~= self.GS["Location"] then
					self.ShipControlLocationList[#self.ShipControlLocationList + 1] = CF_Location[i]
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
						
						self.GS["Location"] = self.ShipControlLocationList [ self.ShipControlSelectedLocation ]
						-- Recreate all lists
						resetlists = true
					end
				else
					self.FirePressed = false
				end
				
				self.ShipControlLocationListStart = self.ShipControlSelectedLocation - (self.ShipControlSelectedLocation - 1) % 3
				
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
				
				local plntpreset = CF_PlanetGlow[ self.GS["Planet"] ]
				local plntmodeule = CF_PlanetGlowModule[ self.GS["Planet"] ]
				self:PutGlow("ControlPanel_Ship_PlanetBack", pos)
				self:PutGlow("ControlPanel_Ship_LocationList", pos + Vector(0, 89))
				self:PutGlow(plntpreset, pos, plntmodeule)
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
						
						if self.GS["Planet"] ~= "TradeStar" then
							self:TriggerShipAssault()
						end
					end
				else
					self.FirePressed = false
				end

				self.ShipControlPlanetListStart = self.ShipControlSelectedPlanet - (self.ShipControlSelectedPlanet - 1) % 3

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
				
				local plntpreset = CF_PlanetGlow[ self.ShipControlPlanetList [ self.ShipControlSelectedPlanet ] ]
				local plntmodeule = CF_PlanetGlowModule[ self.ShipControlPlanetList [ self.ShipControlSelectedPlanet ] ]
				self:PutGlow("ControlPanel_Ship_PlanetBack", pos)
				self:PutGlow("ControlPanel_Ship_LocationList", pos + Vector(0, 89))
				self:PutGlow(plntpreset, pos, plntmodeule)
			end
			
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