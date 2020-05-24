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
	self.ShipControlPanelModes = {REPORT = 0, LOCATION = 1, PLANET = 2, MISSIONS = 3, REPUTATION = 4, BRAIN = 5, UPGRADE = 6, SHIPYARD = 7}

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

	self.ShipControlLastMessageTime = -1000
	self.ShipControlMessageIntrval = 3
	self.ShipControlMessageText = ""
	
	self.ShipControlSelectedLocation = 1
	self.ShipControlLocationList = nil
	self.ShipControlLocationListStart = 1
	
	self.ShipControlSelectedPlanet = 1
	self.ShipControlPlanetListStart = 1
	self.ShipControlPlanetList = nil
	
	self.ShipControlLocationsPerPage = 10
	self.ShipControlPlanetsPerPage = 10
	
	self.ShipControlSelectedUpgrade = 1
	self.ShipControlSelectedSkillUpgrade = 1
	self.ShipControlSelectedFaction = 1
	self.ShipControlSelectedMission = 1
	self.ShipControlSelectedShip = 1

	self.ShipControlSelectedEncounterVariant = 1
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
	
	-- Force-show report if we have some report array left from previous mission
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
						local s = self.ShipControlPlanetList[j]
						self.ShipControlPlanetList[j] = self.ShipControlPlanetList[j + 1]
						self.ShipControlPlanetList[j + 1] = s
					end
				end
			end
			
			-- Fill location list
			self.ShipControlLocationList = {}
			for i = 1, #CF_Location do
				if CF_LocationPlanet[CF_Location[i]] == self.GS["Planet"] then
					self.ShipControlLocationList[#self.ShipControlLocationList + 1] = CF_Location[i]
				end
			end
			
			-- Sort location list
			for i = 1, #self.ShipControlLocationList do
				for j = 1, #self.ShipControlLocationList - 1 do
					if CF_LocationName[ self.ShipControlLocationList[j] ] > CF_LocationName[ self.ShipControlLocationList[j + 1] ] then
						local s = self.ShipControlLocationList[j]
						self.ShipControlLocationList[j] = self.ShipControlLocationList[j + 1] 
						self.ShipControlLocationList[j + 1] = s
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
						
						if self.RandomEncounterID == nil then
							if self.GS["Location"] == nil then
								if self.GS["ShipX"] == nil or self.GS["ShipY"] == nil then
									self.GS["ShipX"] = 0
									self.GS["ShipY"] = 0
								end
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
						end
					end
				else
					self.FirePressed = false
				end
				
				self.ShipControlLocationListStart = self.ShipControlSelectedLocation - (self.ShipControlSelectedLocation - 1) % self.ShipControlLocationsPerPage
				
				-- Draw mode specific elements
				-- Write current location
				if self.GS["Destination"] ~= nil then
					local scale = CF_PlanetScale[self.GS["Planet"]]
					if scale == nil then
						scale = 1
					end
				
					local dst = math.ceil(tonumber(self.GS["Distance"]) * CF_KmPerPixel * scale)
				
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
				
				--local shippos = Vector(0,0)
				
				-- Select green current location preset if we're on mission location
				local msn = false
			
				-- If we have mission in that location then draw red dot
				for m = 1, CF_MaxMissions do
					if self.GS["Location"] == self.GS["Mission"..m.."Location"] then
						msn = true
						break
					end
				end
				
				local shippreset = "ControlPanel_Ship_CurrentLocation"
				
				if msn then
					shippreset = "ControlPanel_Ship_CurrentMissionLocation"
				end
				
				local sx = tonumber(self.GS["ShipX"])
				local sy = tonumber(self.GS["ShipY"])

				local dx = tonumber(self.GS["DestX"])
				local dy = tonumber(self.GS["DestY"])
				
				local cx = pos.X + 70
				local cy = pos.Y
				
				self:PutGlow(shippreset, pos + Vector(sx,sy) + Vector(70,0))
				
				if dx ~= nil and dy ~= nil then
					self:DrawDottedLine(cx + sx, cy + sy, cx + dx, cy + dy, "ControlPanel_Ship_DestDot",5)
				end
				
				local shippos = Vector(sx,sy)

				local msn = false
				local msntype
				local msndiff
				local msntgt
			
				-- If we have mission in that location then draw red dot
				for m = 1, CF_MaxMissions do
					if self.ShipControlLocationList[ self.ShipControlSelectedLocation ] == self.GS["Mission"..m.."Location"] then
						msn = true
						msntype = self.GS["Mission"..m.."Type"]
						msndiff = CF_GetFullMissionDifficulty(self.GS, self.GS["Mission"..m.."Location"], m)--tonumber(self.GS["Mission"..m.."Difficulty"])
						msntgt = tonumber(self.GS["Mission"..m.."TargetPlayer"])
						break
					end
				end
				
				-- Show selected location dot
				local locpos = CF_LocationPos[ self.ShipControlLocationList[ self.ShipControlSelectedLocation ] ]
				if locpos ~= nil then
					if msn then
						self:PutGlow("ControlPanel_Ship_MissionDot", pos + locpos + Vector(70,0))
					else
						self:PutGlow("ControlPanel_Ship_LocationDot", pos + locpos + Vector(70,0))
					end
					
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
				local diff 
				
				if msn then
					CF_DrawString("MISSION: "..CF_MissionName[msntype], pos + Vector(8, 50), 140, 10)
					CF_DrawString("TARGET: "..CF_FactionNames[ CF_GetPlayerFaction(self.GS, msntgt) ], pos + Vector(8, 62), 130, 10)
					diff = msndiff
				else
					diff = CF_GetLocationDifficulty(self.GS, self.ShipControlLocationList[ self.ShipControlSelectedLocation ])
				end
				
				local playable = true
				
				if CF_LocationPlayable[self.ShipControlLocationList[ self.ShipControlSelectedLocation ]] ~= nil then
					playable = CF_LocationPlayable[ self.ShipControlLocationList[ self.ShipControlSelectedLocation ] ]
				end

				if playable then
					CF_DrawString("SECURITY: "..string.upper(CF_LocationDifficultyTexts[diff]), pos + Vector(8, -60), 136, 10)

					if self.ShipControlLocationList[ self.ShipControlSelectedLocation ] ~= nil then
						local rev = self.GS[self.ShipControlLocationList[ self.ShipControlSelectedLocation ].."-FogRevealPercentage"]
						if rev == nil then
							rev = 0
						end
						CF_DrawString("INTEL: "..rev.."%", pos + Vector(8, -36), 136, 10)
					end
					
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
				else
					if CF_IsLocationHasAttribute(self.ShipControlLocationList[ self.ShipControlSelectedLocation ], CF_LocationAttributeTypes.TRADESTAR) then
						CF_DrawString("TRADE STAR", pos + Vector(8, -60), 136, 10)
					end
					
					if CF_IsLocationHasAttribute(self.ShipControlLocationList[ self.ShipControlSelectedLocation ], CF_LocationAttributeTypes.BLACKMARKET) then
						CF_DrawString("BLACK MARKET", pos + Vector(8, -60), 136, 10)
					end

					if CF_IsLocationHasAttribute(self.ShipControlLocationList[ self.ShipControlSelectedLocation ], CF_LocationAttributeTypes.SHIPYARD) then
						CF_DrawString("SHIPYARD", pos + Vector(8, -60), 136, 10)
					end
				end
				
				-- Show location list
				if #self.ShipControlLocationList > 0 then
					for i = self.ShipControlLocationListStart, self.ShipControlLocationListStart + self.ShipControlLocationsPerPage - 1 do
						local pname = CF_LocationName[ self.ShipControlLocationList[i] ]
						if pname ~= nil then
							if i == self.ShipControlSelectedLocation then
								CF_DrawString("> " .. pname, pos + Vector(-62 - 71, -40 + (i - self.ShipControlLocationListStart) * 11), 130, 10)
							else
								CF_DrawString(pname, pos + Vector(-62 - 71, -40 + (i - self.ShipControlLocationListStart) * 11), 130, 10)
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
				self:PutGlow(plntpreset, pos + Vector(70,0), plntmodeule)
				
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
						
						if self.RandomEncounterID == nil then
							-- Travel to another planet
							self.GS["Planet"] = self.ShipControlPlanetList [ self.ShipControlSelectedPlanet ]
							self.GS["Location"] = nil
							self.GS["Destination"] = nil

							self.GS["DestX"] = nil
							self.GS["DestY"] = nil
							
							self.GS["ShipX"] = 0
							self.GS["ShipY"] = 0
							-- Recreate all lists
							resetlists = true
						end
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
				
				self:PutGlow("ControlPanel_Ship_PlanetBack", pos + Vector(-71, 0))
				self:PutGlow("ControlPanel_Ship_GalaxyBack", pos + Vector(70,0))
				self:PutGlow("ControlPanel_Ship_HorizontalPanel", pos + Vector(0,-77))
				self:PutGlow("ControlPanel_Ship_HorizontalPanel", pos + Vector(0,78))
			end
---------------------------------------------------------------------------------------------------
			-- Show last mission report
			if self.ShipControlMode == self.ShipControlPanelModes.REPORT then
				-- Show current planet
				self:PutGlow("ControlPanel_Ship_Report", pos)
				self:PutGlow("ControlPanel_Ship_HorizontalPanel", pos + Vector(0,-77))
				self:PutGlow("ControlPanel_Ship_HorizontalPanel", pos + Vector(0,78))
				
				if self.RandomEncounterID == nil then
					CF_DrawString("REPORT", pos + Vector(-10,-77), 262, 141)
					CF_DrawString("AVAILABLE GOLD: "..CF_GetPlayerGold(self.GS, 0), pos + Vector(-130,-60), 262, 141)
					
					CF_DrawString("Press DOWN to save game", pos + Vector(-60,77), 262, 141)
					
					for i = 1, CF_MaxMissionReportLines do
						--CF_DrawString("LINE"..i, pos + Vector(-130,-70 + i * 10), 262, 141) -- Debug
						if self.GS["MissionReport"..i] ~= nil then
							CF_DrawString(self.GS["MissionReport"..i], pos + Vector(-130,-56 + i * 10), 262, 141)
						else
							break
						end
					end
					
					if cont:IsState(Controller.PRESS_DOWN) then
						self:SaveActors(false)
						self:SaveCurrentGameState()
						
						self:LaunchScript("VoidWanderers Strategy Screen", "StrategyScreenMain.lua")
						FORM_TO_LOAD = BASE_PATH.."FormSave.lua"
						self.EnableBrainSelection = false
						self:DestroyConsoles()
						return
					end
				else
					CF_DrawString("INCOMING TRANSMISSION", pos + Vector(-56,-77), 262, 141)
					CF_DrawString(self.RandomEncounterText, pos + Vector(-130,-56), 262, 141)
					
					if self.RandomEncounterVariants ~= nil and self.RandomEncounterDelayTimer:IsPastSimMS(750) then
						if cont:IsState(Controller.PRESS_UP) then
							-- Select planet
							self.ShipControlSelectedEncounterVariant = self.ShipControlSelectedEncounterVariant - 1
							if self.ShipControlSelectedEncounterVariant < 1 then
								self.ShipControlSelectedEncounterVariant = 1
							end
						end
					
						if cont:IsState(Controller.PRESS_DOWN) then
							-- Select planet
							self.ShipControlSelectedEncounterVariant = self.ShipControlSelectedEncounterVariant + 1
							if self.ShipControlSelectedEncounterVariant > #self.RandomEncounterVariants then
								self.ShipControlSelectedEncounterVariant = #self.RandomEncounterVariants
							end
						end
						
						if cont:IsState(Controller.WEAPON_FIRE) then
							if not self.FirePressed then
								self.FirePressed = true;
								
								self.RandomEncounterChosenVariant = self.ShipControlSelectedEncounterVariant;
							end
						else
							self.FirePressed = false
						end

						CF_DrawString("U/D - Select, FIRE - Accept", pos + Vector(-62-71, 78), 270, 40)
						
						local l = #self.RandomEncounterVariants * self.RandomEncounterVariantsInterval + (self.RandomEncounterVariantsInterval / 2)
					
						for i = 1, #self.RandomEncounterVariants do
							if self.ShipControlSelectedEncounterVariant == i then
								CF_DrawString(">", pos + Vector(-130,58 - l + i * self.RandomEncounterVariantsInterval), 262, 141)
								CF_DrawString(self.RandomEncounterVariants[i], pos + Vector(-120,58 - l + i * self.RandomEncounterVariantsInterval), 262, 141)
							else
								CF_DrawString(self.RandomEncounterVariants[i], pos + Vector(-130,58 - l + i * self.RandomEncounterVariantsInterval), 262, 141)
							end
						end
					end
				end
			end
---------------------------------------------------------------------------------------------------
			if self.ShipControlMode == self.ShipControlPanelModes.MISSIONS then
				-- Create upgrades list
				local cpus = tonumber(self.GS["ActiveCPUs"])
				
				self.ShipControlMissions = {}
				for i = 1, CF_MaxMissions do
					self.ShipControlMissions[i] = {}
					self.ShipControlMissions[i]["SourcePlayer"] = tonumber(self.GS["Mission"..i.."SourcePlayer"])
					self.ShipControlMissions[i]["TargetPlayer"] = tonumber(self.GS["Mission"..i.."TargetPlayer"])
					self.ShipControlMissions[i]["Difficulty"] = CF_GetFullMissionDifficulty(self.GS, self.GS["Mission"..i.."Location"], i)--tonumber(self.GS["Mission"..i.."Difficulty"])
					self.ShipControlMissions[i]["Location"] = self.GS["Mission"..i.."Location"]
					self.ShipControlMissions[i]["Type"] = self.GS["Mission"..i.."Type"]
					
					local rep = tonumber(self.GS["Player"..self.ShipControlMissions[i]["SourcePlayer"].."Reputation"])
					local srep = ""
					if rep > 0 then
						srep = "+"..tostring(rep)
					else
						srep = tostring(rep)
					end
					self.ShipControlMissions[i]["SourceFactionRaputation"] = srep
					self.ShipControlMissions[i]["SourceFaction"] = CF_FactionNames[CF_GetPlayerFaction(self.GS, self.ShipControlMissions[i]["SourcePlayer"])] 

					local rep = tonumber(self.GS["Player"..self.ShipControlMissions[i]["TargetPlayer"].."Reputation"])
					local srep = ""
					if rep > 0 then
						srep = "+"..tostring(rep)
					else
						srep = tostring(rep)
					end
					self.ShipControlMissions[i]["TargetFactionRaputation"] = srep
					self.ShipControlMissions[i]["TargetFaction"] = CF_FactionNames[CF_GetPlayerFaction(self.GS, self.ShipControlMissions[i]["TargetPlayer"])]

					self.ShipControlMissions[i]["Description"] = CF_MissionBriefingText[ self.ShipControlMissions[i]["Type"] ]
					
					self.ShipControlMissions[i]["GoldReward"] = CF_CalculateReward( CF_MissionGoldRewardPerDifficulty[ self.ShipControlMissions[i]["Type"] ] , self.ShipControlMissions[i]["Difficulty"])
					self.ShipControlMissions[i]["RepReward"] = CF_CalculateReward( CF_MissionReputationRewardPerDifficulty[ self.ShipControlMissions[i]["Type"] ] , self.ShipControlMissions[i]["Difficulty"])
				end
				
				if cont:IsState(Controller.PRESS_UP) then
					-- Select planet
					self.ShipControlSelectedMission = self.ShipControlSelectedMission - 1
					if self.ShipControlSelectedMission < 1 then
						self.ShipControlSelectedMission = 1
					end
				end
			
				if cont:IsState(Controller.PRESS_DOWN) then
					-- Select planet
					self.ShipControlSelectedMission = self.ShipControlSelectedMission + 1
					if self.ShipControlSelectedMission > #self.ShipControlMissions then
						self.ShipControlSelectedMission = #self.ShipControlMissions
					end
				end

				if cont:IsState(Controller.WEAPON_FIRE) then
					if not self.FirePressed then
						self.FirePressed = true;
						
						-- Find planet where mission is
						local planet = CF_LocationPlanet [ self.ShipControlMissions[self.ShipControlSelectedMission]["Location"] ]
						
						if self.GS["Planet"] ~= planet then
							-- Move to planet if we're not there
							self.GS["Planet"] = planet
							self.GS["Location"] = nil
							self.GS["Destination"] = nil
							
							self.GS["ShipX"] = 0
							self.GS["ShipY"] = 0
							-- Recreate all lists
							resetlists = true
						end

						if self.GS["Location"] ~= nil then
							local locpos = CF_LocationPos[ self.GS["Location"] ]
							if locpos == nil then
								locpos = Vector(0,0)
							end

							self.GS["ShipX"] = math.floor(locpos.X)
							self.GS["ShipY"] = math.floor(locpos.Y)
						else
							if self.GS["ShipX"] == nil or self.GS["ShipY"] == nil then
								self.GS["ShipX"] = 0
								self.GS["ShipY"] = 0
							end
						end
						
						-- Fly to location
						self.GS["Location"] = nil
						self.GS["Destination"] = self.ShipControlMissions[self.ShipControlSelectedMission]["Location"]

						local destpos = CF_LocationPos[ self.GS["Destination"] ]
						if destpos == nil then
							destpos = Vector(0,0)
						end
						
						self.GS["DestX"] = math.floor(destpos.X)
						self.GS["DestY"] = math.floor(destpos.Y)
						
						self.GS["Distance"] = CF_Dist(Vector(tonumber(self.GS["ShipX"]),tonumber(self.GS["ShipY"])), Vector(tonumber(self.GS["DestX"]),tonumber(self.GS["DestX"])))

						self.ShipControlMode = self.ShipControlPanelModes.LOCATION
					end
				else
					self.FirePressed = false
				end
				
				-- Show faction list
				for i = 1, #self.ShipControlMissions do
					if i == self.ShipControlSelectedMission then
						CF_DrawString("> "..self.ShipControlMissions[i]["SourceFaction"], pos + Vector(-62 - 71, -86 + i * 25), 150, 12)
						CF_DrawString(">   VS "..self.ShipControlMissions[i]["TargetFaction"], pos + Vector(-62 - 71, -86 + i * 25 + 10), 150, 12)
					else
						CF_DrawString(self.ShipControlMissions[i]["SourceFaction"], pos + Vector(-62 - 71, -86 + i * 25), 150, 12)
						CF_DrawString("VS "..self.ShipControlMissions[i]["TargetFaction"], pos + Vector(-62 - 71 + 14, -86 + i * 25 + 10), 150, 12)
					end
				end

				-- Show selected mission info
				CF_DrawString("TARGET: "..self.ShipControlMissions[self.ShipControlSelectedMission]["TargetFaction"], pos + Vector(10, -61), 270, 40)
				CF_DrawString("AT: "..self.ShipControlMissions[self.ShipControlSelectedMission]["Location"], pos + Vector(10, -51), 270, 40)
				CF_DrawString("SECURITY: "..CF_LocationDifficultyTexts[ self.ShipControlMissions[self.ShipControlSelectedMission]["Difficulty"] ], pos + Vector(10, -41), 270, 40)
				
				CF_DrawString("GOLD: "..self.ShipControlMissions[self.ShipControlSelectedMission]["GoldReward"].." oz", pos + Vector(10, -31), 270, 40)
				CF_DrawString("REPUTATION: "..self.ShipControlMissions[self.ShipControlSelectedMission]["RepReward"], pos + Vector(10, -21), 270, 40)
				
				CF_DrawString(self.ShipControlMissions[self.ShipControlSelectedMission]["Description"], pos + Vector(10, -5), 135, 80)
				
				
				CF_DrawString("Available missions", pos + Vector(-62-71, -78), 270, 40)
				CF_DrawString("U/D - Select mission, FIRE - Fly to location", pos + Vector(-62-71, 78), 270, 40)
				self:PutGlow("ControlPanel_Ship_PlanetBack", pos + Vector(-71, 0))
				self:PutGlow("ControlPanel_Ship_PlanetBack", pos + Vector(70, 0))
				self:PutGlow("ControlPanel_Ship_HorizontalPanel", pos + Vector(0,-77))
				self:PutGlow("ControlPanel_Ship_HorizontalPanel", pos + Vector(0,78))
			end
---------------------------------------------------------------------------------------------------
			if self.ShipControlMode == self.ShipControlPanelModes.REPUTATION then
				-- Create upgrades list
				local cpus = tonumber(self.GS["ActiveCPUs"])
				
				self.ShipControlFactions = {}
				for i = 1, cpus do
					self.ShipControlFactions[i] = {}
					self.ShipControlFactions[i]["Faction"] = CF_FactionNames[CF_GetPlayerFaction(self.GS, i)]
					self.ShipControlFactions[i]["Reputation"] = tonumber(self.GS["Player"..i.."Reputation"])
					
					if self.ShipControlFactions[i]["Reputation"] > 0 then
						self.ShipControlFactions[i]["ReputationStr"] = "+"..tostring(self.ShipControlFactions[i]["Reputation"])
					else
						self.ShipControlFactions[i]["ReputationStr"] = tostring(self.ShipControlFactions[i]["Reputation"])
					end
				end
				
				if cont:IsState(Controller.PRESS_UP) then
					-- Select faction
					self.ShipControlSelectedFaction = self.ShipControlSelectedFaction - 1
					if self.ShipControlSelectedFaction < 1 then
						self.ShipControlSelectedFaction = 1
					end
				end
			
				if cont:IsState(Controller.PRESS_DOWN) then
					-- Select faction
					self.ShipControlSelectedFaction = self.ShipControlSelectedFaction + 1
					if self.ShipControlSelectedFaction > #self.ShipControlFactions then
						self.ShipControlSelectedFaction = #self.ShipControlFactions
					end
				end

				-- Show faction list
				for i = 1, #self.ShipControlFactions do
					CF_DrawString(self.ShipControlFactions[i]["Faction"], pos + Vector(-62 - 71, -76 + i * 15), 80, 10)
					CF_DrawString(self.ShipControlFactions[i]["ReputationStr"], pos + Vector(-62 - 71 + 80, -76 + i * 15), 130, 10)
					
					if self.ShipControlFactions[i]["Reputation"] < CF_ReputationHuntTreshold then
						local diff = math.floor(math.abs(self.ShipControlFactions[i]["Reputation"] / CF_ReputationPerDifficulty))
						
						if diff <= 0 then
							diff = 1
						end
						
						if diff > CF_MaxDifficulty then
							diff = CF_MaxDifficulty
						end
						
						--diff = 6 -- Debug!!!

						local s = "Sent "..CF_AssaultDifficultyTexts[diff].."s after you!"
						CF_DrawString(s, pos + Vector(-62 - 71 + 120, -76 + i * 15), 160, 12)
					end
				end

				CF_DrawString("Reputation intelligence report", pos + Vector(-62-71, -78), 270, 40)
				self:PutGlow("ControlPanel_Ship_Report", pos)
				self:PutGlow("ControlPanel_Ship_HorizontalPanel", pos + Vector(0,-77))
				self:PutGlow("ControlPanel_Ship_HorizontalPanel", pos + Vector(0,78))
			end
---------------------------------------------------------------------------------------------------
			if self.ShipControlMode == self.ShipControlPanelModes.BRAIN then
				if self.GS["Brain"..plr.."Detached"] == "True" then
					if self.Time % 2 == 0 then
						CF_DrawString("PLAYER ".. plr + 1 .." BRAIN DETACHED, ROBOT IN USE!", pos + Vector(-106, -6), 270, 40)
						CF_DrawString(self.GS["Brain"..plr.."SkillPoints"].." POINTS AVAILABLE", pos + Vector(-46, 6), 270, 40)
					end
					self:PutGlow("ControlPanel_Ship_Report", pos)
				else
			
				self.ShipControlSkillUpgrades = {}
				-- Toughness
				local nm = #self.ShipControlSkillUpgrades + 1
				self.ShipControlSkillUpgrades[nm] = {}
				self.ShipControlSkillUpgrades[nm]["Name"] = "Toughness"
				self.ShipControlSkillUpgrades[nm]["Variable"] = "Brain"..plr.."Tougness"
				self.ShipControlSkillUpgrades[nm]["Description"] = "How much punishment your brain robot can take."
				local val = tonumber(self.GS[ self.ShipControlSkillUpgrades[nm]["Variable"] ])
				self.GS[self.ShipControlSkillUpgrades[nm]["Variable"]] = val
				self.ShipControlSkillUpgrades[nm]["Price"] = (val + 1) * 2

				
				local nm = #self.ShipControlSkillUpgrades + 1
				self.ShipControlSkillUpgrades[nm] = {}
				self.ShipControlSkillUpgrades[nm]["Name"] = "Force field"
				self.ShipControlSkillUpgrades[nm]["Variable"] = "Brain"..plr.."Field"
				self.ShipControlSkillUpgrades[nm]["Description"] = "Regeneration speed of force field."
				self.ShipControlSkillUpgrades[nm]["Price"] = CF_StoragePrice
				local val = tonumber(self.GS[ self.ShipControlSkillUpgrades[nm]["Variable"] ])
				self.GS[self.ShipControlSkillUpgrades[nm]["Variable"]] = val
				self.ShipControlSkillUpgrades[nm]["Price"] = val + 1

				
				local nm = #self.ShipControlSkillUpgrades + 1
				self.ShipControlSkillUpgrades[nm] = {}
				self.ShipControlSkillUpgrades[nm]["Name"] = "Telekinesis"
				self.ShipControlSkillUpgrades[nm]["Variable"] = "Brain"..plr.."Telekinesis"
				self.ShipControlSkillUpgrades[nm]["Description"] = "Telekinesis abilities and their power."
				self.ShipControlSkillUpgrades[nm]["Price"] = CF_StoragePrice
				local val = tonumber(self.GS[ self.ShipControlSkillUpgrades[nm]["Variable"] ])
				self.GS[self.ShipControlSkillUpgrades[nm]["Variable"]] = val
				self.ShipControlSkillUpgrades[nm]["Price"] = val + 1

				
				--[[local nm = #self.ShipControlSkillUpgrades + 1
				self.ShipControlSkillUpgrades[nm] = {}
				self.ShipControlSkillUpgrades[nm]["Name"] = "Scaning"
				self.ShipControlSkillUpgrades[nm]["Variable"] = "Brain"..plr.."Scanner"
				self.ShipControlSkillUpgrades[nm]["Description"] = "Built-in scanner range."
				self.ShipControlSkillUpgrades[nm]["Price"] = CF_StoragePrice
				local val = tonumber(self.GS[ self.ShipControlSkillUpgrades[nm]["Variable"] ])
				self.GS[ self.ShipControlSkillUpgrades[nm]["Variable"] ] = val
				self.ShipControlSkillUpgrades[nm]["Price"] = val + 1
				
				
				local nm = #self.ShipControlSkillUpgrades + 1
				self.ShipControlSkillUpgrades[nm] = {}
				self.ShipControlSkillUpgrades[nm]["Name"] = "Healing"
				self.ShipControlSkillUpgrades[nm]["Variable"] = "Brain"..plr.."Heal"
				self.ShipControlSkillUpgrades[nm]["Description"] = "How many times brain-robot can fully heal a unit."
				self.ShipControlSkillUpgrades[nm]["Price"] = CF_StoragePrice
				local val = tonumber(self.GS[ self.ShipControlSkillUpgrades[nm]["Variable"] ])
				self.GS[ self.ShipControlSkillUpgrades[nm]["Variable"] ] = val
				self.ShipControlSkillUpgrades[nm]["Price"] = val + 1


				local nm = #self.ShipControlSkillUpgrades + 1
				self.ShipControlSkillUpgrades[nm] = {}
				self.ShipControlSkillUpgrades[nm]["Name"] = "Engineering"
				self.ShipControlSkillUpgrades[nm]["Variable"] = "Brain"..plr.."Fix"
				self.ShipControlSkillUpgrades[nm]["Description"] = "How many times brain-robot can fix a weapon."
				self.ShipControlSkillUpgrades[nm]["Price"] = CF_StoragePrice
				local val = tonumber(self.GS[ self.ShipControlSkillUpgrades[nm]["Variable"] ])
				self.GS[ self.ShipControlSkillUpgrades[nm]["Variable"] ] = val
				self.ShipControlSkillUpgrades[nm]["Price"] = val + 1--]]--

				
				if cont:IsState(Controller.PRESS_UP) then
					self.ShipControlSelectedSkillUpgrade = self.ShipControlSelectedSkillUpgrade - 1
					if self.ShipControlSelectedSkillUpgrade < 1 then
						self.ShipControlSelectedSkillUpgrade = 1
					end
				end
			
				if cont:IsState(Controller.PRESS_DOWN) then
					self.ShipControlSelectedSkillUpgrade = self.ShipControlSelectedSkillUpgrade + 1
					if self.ShipControlSelectedSkillUpgrade > #self.ShipControlSkillUpgrades then
						self.ShipControlSelectedSkillUpgrade = #self.ShipControlSkillUpgrades
					end
				end

				local current = tonumber(self.GS[ self.ShipControlSkillUpgrades[self.ShipControlSelectedSkillUpgrade]["Variable"] ])
				local maximum = 5
				local price = self.ShipControlSkillUpgrades[self.ShipControlSelectedSkillUpgrade]["Price"]
				local sklpts = tonumber(self.GS["Brain"..plr.."SkillPoints"])

				CF_DrawString("LEVEL: "..self.GS["Brain"..plr.."Level"], pos + Vector(-62-71, -60), 270, 40)
				CF_DrawString("EXP: "..self.GS["Brain"..plr.."Exp"], pos + Vector(-62, -60), 270, 40)
				
				if price > sklpts then
					if self.Time % 2 == 0 then
						CF_DrawString("POINTS: "..sklpts, pos + Vector(-62-71, -46), 270, 40)
					end
				else
					CF_DrawString("POINTS: "..sklpts, pos + Vector(-62-71, -46), 270, 40)
				end
				
				CF_DrawString("Current level: "..current, pos + Vector(10, -30), 270, 40)
				CF_DrawString("Maximum level: "..maximum, pos + Vector(10, -20), 270, 40)
				if current < maximum then
					CF_DrawString("Points needed: "..self.ShipControlSkillUpgrades[self.ShipControlSelectedSkillUpgrade]["Price"], pos + Vector(10, -10), 270, 40)
				end

				CF_DrawString(self.ShipControlSkillUpgrades[self.ShipControlSelectedSkillUpgrade]["Description"], pos + Vector(10, 10), 130, 80)
				
				if cont:IsState(Controller.WEAPON_FIRE) then
					if not self.FirePressed then
						self.FirePressed = true;
						
						if current < maximum and price <= sklpts then
							self.GS[ self.ShipControlSkillUpgrades[self.ShipControlSelectedSkillUpgrade]["Variable"] ] = current + 1
							sklpts = sklpts - price
							self.GS["Brain"..plr.."SkillPoints"] = sklpts
						end
					end
				else
					self.FirePressed = false
				end				

				-- Show list
				for i = 1, #self.ShipControlSkillUpgrades do
					if i == self.ShipControlSelectedSkillUpgrade then
						CF_DrawString("> " .. self.ShipControlSkillUpgrades[i]["Name"], pos + Vector(-62 - 71, -40 + i * 11), 130, 12)
					else
						CF_DrawString(self.ShipControlSkillUpgrades[i]["Name"], pos + Vector(-62 - 71, -40 + i * 11), 130, 12)
					end
				end
				
				CF_DrawString("U/D - Select upgrade, FIRE - Upgrade", pos + Vector(-62-71, 78), 270, 40)
				self:PutGlow("ControlPanel_Ship_PlanetBack", pos + Vector(-71, 0))
				self:PutGlow("ControlPanel_Ship_PlanetBack", pos + Vector(70, 0))
				end

				CF_DrawString("Player ".. plr + 1 .." brain robot maintenance", pos + Vector(-62-71, -78), 270, 40)
				
				self:PutGlow("ControlPanel_Ship_HorizontalPanel", pos + Vector(0,-77))
				self:PutGlow("ControlPanel_Ship_HorizontalPanel", pos + Vector(0,78))
			end
-------------------------------------------------------------------------------
			if self.ShipControlMode == self.ShipControlPanelModes.UPGRADE then
				-- Create upgrades list
				self.ShipControlUpgrades = {}
				self.ShipControlUpgrades[1] = {}
				self.ShipControlUpgrades[1]["Name"] = "Cryo-chambers"
				self.ShipControlUpgrades[1]["Variable"] = "Player0VesselClonesCapacity"
				self.ShipControlUpgrades[1]["Max"] = CF_VesselMaxClonesCapacity[ self.GS["Player0Vessel"] ]
				self.ShipControlUpgrades[1]["Description"] = "How many bodies you can store"
				self.ShipControlUpgrades[1]["Price"] = CF_ClonePrice

				self.ShipControlUpgrades[2] = {}
				self.ShipControlUpgrades[2]["Name"] = "Storage"
				self.ShipControlUpgrades[2]["Variable"] = "Player0VesselStorageCapacity"
				self.ShipControlUpgrades[2]["Max"] = CF_VesselMaxStorageCapacity[ self.GS["Player0Vessel"] ]
				self.ShipControlUpgrades[2]["Description"] = "How many items you can store"
				self.ShipControlUpgrades[2]["Price"] = CF_StoragePrice

				self.ShipControlUpgrades[3] = {}
				self.ShipControlUpgrades[3]["Name"] = "Life support"
				self.ShipControlUpgrades[3]["Variable"] = "Player0VesselLifeSupport"
				self.ShipControlUpgrades[3]["Max"] = CF_VesselMaxLifeSupport[ self.GS["Player0Vessel"] ]
				self.ShipControlUpgrades[3]["Description"] = "How many bodies can be active on ship simultaneously"
				self.ShipControlUpgrades[3]["Price"] = CF_LifeSupportPrice

				self.ShipControlUpgrades[4] = {}
				self.ShipControlUpgrades[4]["Name"] = "Communication"
				self.ShipControlUpgrades[4]["Variable"] = "Player0VesselCommunication"
				self.ShipControlUpgrades[4]["Max"] = CF_VesselMaxCommunication[ self.GS["Player0Vessel"] ]
				self.ShipControlUpgrades[4]["Description"] = "How many bodies you can control on planet surface"
				self.ShipControlUpgrades[4]["Price"] = CF_CommunicationPrice

				self.ShipControlUpgrades[5] = {}
				self.ShipControlUpgrades[5]["Name"] = "Engine"
				self.ShipControlUpgrades[5]["Variable"] = "Player0VesselSpeed"
				self.ShipControlUpgrades[5]["Max"] = CF_VesselMaxSpeed[ self.GS["Player0Vessel"] ]
				self.ShipControlUpgrades[5]["Description"] = "Speed of the vessel. Faster ships are harder to intercept."
				self.ShipControlUpgrades[5]["Price"] = CF_EnginePrice
				
				if cont:IsState(Controller.PRESS_UP) then
					-- Select planet
					self.ShipControlSelectedUpgrade = self.ShipControlSelectedUpgrade - 1
					if self.ShipControlSelectedUpgrade < 1 then
						self.ShipControlSelectedUpgrade = 1
					end
				end
			
				if cont:IsState(Controller.PRESS_DOWN) then
					-- Select planet
					self.ShipControlSelectedUpgrade = self.ShipControlSelectedUpgrade + 1
					if self.ShipControlSelectedUpgrade > #self.ShipControlUpgrades then
						self.ShipControlSelectedUpgrade = #self.ShipControlUpgrades
					end
				end

				-- Show planet list
				for i = 1, #self.ShipControlUpgrades do
					if i == self.ShipControlSelectedUpgrade then
						CF_DrawString("> " .. self.ShipControlUpgrades[i]["Name"], pos + Vector(-62 - 71, -40 + i * 11), 130, 12)
					else
						CF_DrawString(self.ShipControlUpgrades[i]["Name"], pos + Vector(-62 - 71, -40 + i * 11), 130, 12)
					end
				end

				CF_DrawString("SELECT UPGRADE:", pos + Vector(-62-71, -60), 270, 40)
				
				local current = tonumber(self.GS[ self.ShipControlUpgrades[self.ShipControlSelectedUpgrade]["Variable"] ])
				local maximum = self.ShipControlUpgrades[self.ShipControlSelectedUpgrade]["Max"]
				local price = self.ShipControlUpgrades[self.ShipControlSelectedUpgrade]["Price"]

				if price > CF_GetPlayerGold(self.GS, 0) then
					if self.Time % 2 == 0 then
						CF_DrawString("FUNDS: "..CF_GetPlayerGold(self.GS, 0).." oz", pos + Vector(-62-71, -46), 270, 40)
					end
				else
					CF_DrawString("FUNDS: "..CF_GetPlayerGold(self.GS, 0).." oz", pos + Vector(-62-71, -46), 270, 40)
				end
				
				CF_DrawString("Current: "..current, pos + Vector(10, -30), 270, 40)
				CF_DrawString("Maximum: "..maximum, pos + Vector(10, -20), 270, 40)
				if current < maximum then
					CF_DrawString("Upgrade price: "..self.ShipControlUpgrades[self.ShipControlSelectedUpgrade]["Price"].." oz", pos + Vector(10, -10), 270, 40)
				end

				CF_DrawString(self.ShipControlUpgrades[self.ShipControlSelectedUpgrade]["Description"], pos + Vector(10, 10), 130, 80)
				
				if cont:IsState(Controller.WEAPON_FIRE) then
					if not self.FirePressed then
						self.FirePressed = true;
						
						if current < maximum and price <= CF_GetPlayerGold(self.GS, 0) then
							self.GS[ self.ShipControlUpgrades[self.ShipControlSelectedUpgrade]["Variable"] ] = current + 1
							CF_SetPlayerGold(self.GS, 0, CF_GetPlayerGold(self.GS, 0) - price)
						end
					end
				else
					self.FirePressed = false
				end

				CF_DrawString("Upgrade ship", pos + Vector(-62-71, -78), 270, 40)
				CF_DrawString("U/D - Select upgrade, FIRE - Upgrade", pos + Vector(-62-71, 78), 270, 40)
				self:PutGlow("ControlPanel_Ship_PlanetBack", pos + Vector(-71, 0))
				self:PutGlow("ControlPanel_Ship_PlanetBack", pos + Vector(70, 0))
				
				self:PutGlow("ControlPanel_Ship_HorizontalPanel", pos + Vector(0,-77))
				self:PutGlow("ControlPanel_Ship_HorizontalPanel", pos + Vector(0,78))
			end
---------------------------------------------------------------------------------------------------
			if self.ShipControlMode == self.ShipControlPanelModes.SHIPYARD then
				-- Create ship list
				self.ShipControlShips = {}
				for i = 1, #CF_Vessel do
					local id = CF_Vessel[i]
					
					if self.GS["Player0Vessel"] ~= id then
						local nv = #self.ShipControlShips + 1
					
						self.ShipControlShips[nv] = id
					end
				end
				
				if cont:IsState(Controller.PRESS_UP) then
					-- Select planet
					self.ShipControlSelectedShip = self.ShipControlSelectedShip - 1
					if self.ShipControlSelectedShip < 1 then
						self.ShipControlSelectedShip = 1
					end
				end
			
				if cont:IsState(Controller.PRESS_DOWN) then
					-- Select planet
					self.ShipControlSelectedShip = self.ShipControlSelectedShip + 1
					if self.ShipControlSelectedShip > #self.ShipControlShips then
						self.ShipControlSelectedShip = #self.ShipControlShips
					end
				end

				-- Show ship list
				for i = 1, #self.ShipControlShips do
					local id = self.ShipControlShips[i]
				
					if i == self.ShipControlSelectedShip then
						CF_DrawString("> " .. CF_VesselName[id], pos + Vector(-62 - 71, -40 + i * 11), 130, 12)
					else
						CF_DrawString(CF_VesselName[id], pos + Vector(-62 - 71, -40 + i * 11), 130, 12)
					end
				end

				CF_DrawString("SELECT SHIP:", pos + Vector(-62-71, -60), 140, 40)
				CF_DrawString("SPECIFICATIONS:", pos + Vector(8, -60), 140, 40)
				
				-- Show specs
				local id = self.ShipControlShips[self.ShipControlSelectedShip]
				local price = CF_VesselPrice[id]
				local bonus = CF_VesselPrice[self.GS["Player0Vessel"]] * CF_ShipSellCoeff
				local instl = 0
				
				-- Cryo chambers
				local newcryo = CF_VesselStartClonesCapacity[id]
				local oldcryo = tonumber(self.GS["Player0VesselClonesCapacity"])
				local maxcryo = CF_VesselMaxClonesCapacity[id]
				local actcryo = newcryo + oldcryo
				local exccryo = 0
				if actcryo > maxcryo then
					exccryo = newcryo + oldcryo - maxcryo
					actcryo = maxcryo
				end

				local inscryo = actcryo - newcryo
				if inscryo < 0 then
					inscryo = 0
				end
				
				bonus = bonus + exccryo * CF_ClonePrice * CF_ShipSellCoeff
				instl = instl + inscryo * CF_ClonePrice * CF_ShipDevInstallCoeff
				
				--print (inscryo)
				--print (instl)
				
				CF_DrawString("Cryo:", pos + Vector(8, -48), 140, 40)
				CF_DrawString(""..actcryo.."/"..maxcryo, pos + Vector(8 + 86, -48), 140, 40)

				-- Storage
				local newstor = CF_VesselStartStorageCapacity[id]
				local oldstor = tonumber(self.GS["Player0VesselStorageCapacity"])
				local maxstor = CF_VesselMaxStorageCapacity[id]
				local actstor = newstor + oldstor
				local excstor = 0
				if actstor > maxstor then
					excstor = newstor + oldstor - maxstor
					actstor = maxstor
				end

				local insstor = actstor - newstor
				if insstor < 0 then
					insstor = 0
				end
				
				bonus = bonus + excstor * CF_StoragePrice * CF_ShipSellCoeff
				instl = instl + insstor * CF_StoragePrice * CF_ShipDevInstallCoeff

				--print (insstor)
				--print (instl)

				
				CF_DrawString("Storage:", pos + Vector(8, -36), 140, 40)
				CF_DrawString(""..actstor.."/"..maxstor, pos + Vector(8 + 86, -36), 140, 40)

				-- Life support
				local newlife = CF_VesselStartLifeSupport[id]
				local oldlife = tonumber(self.GS["Player0VesselLifeSupport"])
				local maxlife = CF_VesselMaxLifeSupport[id]
				local actlife = newlife + oldlife
				local exclife = 0
				if actlife > maxlife then
					exclife = newlife + oldlife - maxlife
					actlife = maxlife
				end

				local inslife = actlife - newlife
				if inslife < 0 then
					inslife = 0
				end
				
				bonus = bonus + exclife * CF_LifeSupportPrice * CF_ShipSellCoeff
				instl = instl + inslife * CF_LifeSupportPrice * CF_ShipDevInstallCoeff

				--print (inslife)
				--print (instl)
				
				CF_DrawString("Life support:", pos + Vector(8, -24), 140, 40)
				CF_DrawString(""..actlife.."/"..maxlife, pos + Vector(8 + 86, -24), 140, 40)
				
				-- Communcation
				local newcomm = CF_VesselStartCommunication[id]
				local oldcomm = tonumber(self.GS["Player0VesselCommunication"])
				local maxcomm = CF_VesselMaxCommunication[id]
				local actcomm = newcomm + oldcomm
				local exccomm = 0
				if actcomm > maxcomm then
					exccomm = newcomm + oldcomm - maxcomm
					actcomm = maxcomm
				end

				local inscomm = actcomm - newcomm
				if inscomm < 0 then
					inscomm = 0
				end
				
				bonus = bonus + exccomm * CF_CommunicationPrice* CF_ShipSellCoeff
				instl = instl + inscomm * CF_CommunicationPrice * CF_ShipDevInstallCoeff

				--print (inscomm)
				--print (instl)
				
				CF_DrawString("Communication:", pos + Vector(8, -12), 140, 40)
				CF_DrawString(""..actcomm.."/"..maxcomm, pos + Vector(8 + 86, -12), 140, 40)
				
				-- Engine
				local actengn = CF_VesselStartSpeed[id]
				local maxengn = CF_VesselMaxSpeed[id]
				local excengn = tonumber(self.GS["Player0VesselEngine"])
					
				
				CF_DrawString("Engine:", pos + Vector(8, 0), 140, 40)
				CF_DrawString(""..actengn.."/"..maxengn, pos + Vector(8 + 86, 0), 140, 40)
				
				bonus = math.floor(bonus)
				instl = math.floor(instl)
				
				total = price + instl - bonus
				
				CF_DrawString("BASE:", pos + Vector(8, 24), 140, 40)
				CF_DrawString(tostring(price).."oz", pos + Vector(70, 24), 140, 40)

				CF_DrawString("INSTALL:", pos + Vector(8, 36), 140, 40)
				CF_DrawString(tostring(instl).."oz", pos + Vector(70, 36), 140, 40)

				CF_DrawString("TRADE-IN:", pos + Vector(8, 48), 140, 40)
				CF_DrawString(tostring(bonus).."oz", pos + Vector(70, 48), 140, 40)

				CF_DrawString("TOTAL:", pos + Vector(8, 60), 140, 40)
				CF_DrawString(tostring(total).."oz", pos + Vector(70, 60), 140, 40)
				
				if total > CF_GetPlayerGold(self.GS, 0) then
					if self.Time % 2 == 0 then
						CF_DrawString("FUNDS: "..CF_GetPlayerGold(self.GS, 0).." oz", pos + Vector(-62-71, -46), 270, 40)
					end
				else
					CF_DrawString("FUNDS: "..CF_GetPlayerGold(self.GS, 0).." oz", pos + Vector(-62-71, -46), 270, 40)
				end
				
				if cont:IsState(Controller.WEAPON_FIRE) then
					if not self.FirePressed then
						self.FirePressed = true;
						
						local ok = true
						
						if CF_CountUsedClonesInArray(self.Clones) > actcryo then
							self.ShipControlLastMessageTime = self.Time
							self.ShipControlMessageText = "Not enough storage to transfer clones"
							ok = false
						end
						
						if CF_CountUsedStorageInArray(self.StorageItems) > actstor then
							self.ShipControlLastMessageTime = self.Time
							self.ShipControlMessageText = "Not enough storage to transfer items"
							ok = false
						end

						if CF_GetPlayerGold(self.GS, 0) < total then
							self.ShipControlLastMessageTime = self.Time
							self.ShipControlMessageText = "Not enough gold"
							ok = false
						end
						
						if ok then
							-- Pay
							CF_SetPlayerGold(self.GS, 0, CF_GetPlayerGold(self.GS, 0) - total)
						
							-- Assign new ship
							self.GS["Player0Vessel"] = id
							
							self.GS["Player0VesselStorageCapacity"] = actstor
							self.GS["Player0VesselClonesCapacity"] = actcryo
							self.GS["Player0VesselLifeSupport"] = actlife
							self.GS["Player0VesselCommunication"] = actcomm
							self.GS["Player0VesselSpeed"] = actengn
							
							self.GS["Scene"] = CF_VesselScene[self.GS["Player0Vessel"]]
							
							-- Save everything and restart script
							self:SaveActors(true)
							
							self:SaveCurrentGameState()
							self.EnableBrainSelection = false
							self:DestroyConsoles()

							self:LoadCurrentGameState()
							self:LaunchScript(self.GS["Scene"], "Tactics.lua")							
							return							
						end
					end
				else
					self.FirePressed = false
				end

				CF_DrawString("Buy new ship", pos + Vector(-62-71, -78), 270, 40)
				self:PutGlow("ControlPanel_Ship_PlanetBack", pos + Vector(-71, 0))
				self:PutGlow("ControlPanel_Ship_PlanetBack", pos + Vector(70, 0))

				if self.Time < self.ShipControlLastMessageTime + self.ShipControlMessageIntrval then
					self:PutGlow("ControlPanel_Ship_HorizontalPanelRed", pos + Vector(0,78))
					CF_DrawString(self.ShipControlMessageText, pos + Vector(-130,78) , 300, 10)
				else
					CF_DrawString("U/D - Select upgrade, FIRE - Buy ship", pos + Vector(-62-71, 78), 270, 40)
					self:PutGlow("ControlPanel_Ship_HorizontalPanel", pos + Vector(0,78))
				end

				self:PutGlow("ControlPanel_Ship_HorizontalPanel", pos + Vector(0,-77))
			end
---------------------------------------------------------------------------------------------------

			if self.RandomEncounterID == nil then
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
					
					if CF_IsLocationHasAttribute(self.GS["Location"], CF_LocationAttributeTypes.SHIPYARD) then
						if self.ShipControlMode == 8 then
							self.ShipControlMode = self.ShipControlPanelModes.SHIPYARD
						end
					else
						if self.ShipControlMode == 6 then
							self.ShipControlMode = self.ShipControlPanelModes.BRAIN
						end
					end
				end
			else
				self.ShipControlMode = self.ShipControlPanelModes.REPORT
			end
		end
	end

	if showidle and self.ShipControlPanelPos ~= nil and self.ShipControlPanelActor ~= nil then
		self:PutGlow("ControlPanel_Ship", self.ShipControlPanelPos)
		--CF_DrawString("BRIDGE",self.ShipControlPanelPos + Vector(-15,0),120,20 )
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
	
	
	if MovableMan:IsActor(self.ShipControlPanelActor) then
		self.ShipControlPanelActor.Health = 100
	end
end