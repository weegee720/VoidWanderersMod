--[[
	Miranda Zone Reavers by Major
	https://dl.dropboxusercontent.com/u/1741337/VoidWanderers/MZR.rte.zip
	Supported out of the box
]]--

if PresetMan:GetModuleID("Deployable Turret.rte") ~= -1 then
	local id = "REAVERS";
	CF_RandomEncounters[#CF_RandomEncounters + 1] = id
	CF_RandomEncountersInitialTexts[id] = ""
	CF_RandomEncountersInitialVariants[id] = {"Fight the basterds!", "Stay low", "RUN!!!"}
	CF_RandomEncountersVariantsInterval[id] = 24
	CF_RandomEncountersOneTime[id] = false
	CF_RandomEncountersFunctions[id] = 

	function (self, variant)
		if not self.RandomEncounterIsInitialized then
			self.RandomEncounterReavers = {}

			self.RandomEncounterReaversAct = 	{"Reaver", "Bone Reaver"}
			self.RandomEncounterReaversActMod = {"MZR.rte", "MZR.rte"}

			self.RandomEncounterReaversLight = 	{"JPL 10 Auto", "K-LDP 7.7mm"}
			self.RandomEncounterReaversLightMod = 	{"MZR.rte", "MZR.rte"}

			self.RandomEncounterReaversHeavy = 	{"K-HAR 10mm", "Shrike Mdl.G", "PBL Maw"}
			self.RandomEncounterReaversHeavyMod = 	{"MZR.rte", "MZR.rte", "MZR.rte"}
			
			self.RandomEncounterReaversInterval = 8
			
			self.RandomEncounterDistance = math.random(200, 350)
			
			
			local id = CF_Vessel[ math.random(#CF_Vessel) ]
			
			self.RandomEncounterShipId = id
			self.RandomEncounterSpeed = math.random(CF_VesselStartSpeed[id] , CF_VesselMaxSpeed[id])
			self.RandomEncounterReaversUnitCount =  math.random(math.ceil(CF_VesselStartClonesCapacity[id] / 1.5) , math.ceil(CF_VesselMaxClonesCapacity[id] / 1.5))
			
			self.RandomEncounterDifficulty = math.floor(self.RandomEncounterReaversUnitCount / 5)
			if self.RandomEncounterDifficulty < 0 then
				self.RandomEncounterDifficulty = 0
			end
			
			if self.RandomEncounterDifficulty > CF_MaxDifficulty then
				self.RandomEncounterDifficulty = CF_MaxDifficulty
			end
			
			self.RandomEncounterText = "An unknown ".. CF_VesselName[id].." class ship detected, it must be Reavers!!! If we hide everything and stay low they might think it's a dead ship."
			
			self.RandomEncounterScanTime = 23
			
			if SceneMan.Scene:HasArea("LeftGates") then
				self.RandomEncounterLeftGates = SceneMan.Scene:GetArea("LeftGates")
			else
				self.RandomEncounterLeftGates = nil
			end

			if SceneMan.Scene:HasArea("RightGates") then
				self.RandomEncounterRightGates = SceneMan.Scene:GetArea("RightGates")
			else
				self.RandomEncounterRightGates = nil
			end
			
			self.RandomEncounterAttackLaunched = false
			self.RandomEncounterScanLaunched = false
			self.RandomEncounterRunLaunched = false
			self.RandomEncounterFightSelected = false
			self.RandomEncounterAbortChase = false
			self.RandomEncounterIsInitialized = true
		end

		if variant == 1 then
			self.RandomEncounterText = "BATTLE STATIONS!!!"
			self.RandomEncounterVariants = {}
			self.RandomEncounterChosenVariant = 0
			self.RandomEncounterRunLaunched = true
			self.RandomEncounterRunStarted = self.Time
			self.RandomEncounterFightSelected = true
			self.RandomEncounterChaseTimer = Timer()
		end
		
		if variant == 2 then
			self.RandomEncounterText = "They scanning us..."
			self.RandomEncounterVariants = {}
			self.RandomEncounterChosenVariant = 0
			self.RandomEncounterScanLaunched = true
			self.RandomEncounterScanStarted = self.Time
		end	

		if variant == 3 then
			self.RandomEncounterText = "Let's pray we're faster..."
			self.RandomEncounterVariants = {}
			self.RandomEncounterChosenVariant = 0
			self.RandomEncounterRunLaunched = true
			self.RandomEncounterBoostTriggered = false
			self.RandomEncounterRunStarted = self.Time
			self.RandomEncounterChaseTimer = Timer()
		end	
		
		if self.RandomEncounterScanLaunched == true then
			local act = CF_CountActors(CF_PlayerTeam)
			local prob = math.floor(act * 6.5)
			
			local progress = self.Time - self.RandomEncounterScanStarted
		
			FrameMan:SetScreenText("Scan progress "..math.floor(progress / self.RandomEncounterScanTime * 100).."%\nProbability to detect life signs: "..prob.."%", 0, 0, 1500, true);
			
			if self.Time >= self.RandomEncounterScanStarted + self.RandomEncounterScanTime then
				local r = math.random(100)
				
				if r < prob then
					self.RandomEncounterText = "BATTLE STATIONS!!!"
					self.RandomEncounterVariants = {}
					self.RandomEncounterChosenVariant = 0
					self.RandomEncounterRunLaunched = true
					self.RandomEncounterScanLaunched = false
					self.RandomEncounterRunStarted = self.Time
					self.RandomEncounterFightSelected = true
					self.RandomEncounterChaseTimer = Timer()
				else
					self.MissionReport = {}
					self.MissionReport[#self.MissionReport + 1] = "We tricked them. Lucky we are."
					CF_SaveMissionReport(self.GS, self.MissionReport)
					
					self.RandomEncounterText = ""
					
					-- Finish encounter
					self.RandomEncounterID = nil			
				end
			end
		end

		if self.RandomEncounterRunLaunched == true then
			FrameMan:SetScreenText("Distance: "..self.RandomEncounterDistance.."km", 0, 0, 1500, true);
		
			if self.RandomEncounterChaseTimer:IsPastSimMS(350) then
				if self.RandomEncounterFightSelected then
					self.RandomEncounterDistance = self.RandomEncounterDistance - self.RandomEncounterSpeed
				else
					self.RandomEncounterDistance = self.RandomEncounterDistance - self.RandomEncounterSpeed + tonumber(self.GS["Player0VesselSpeed"])
				end
				self.RandomEncounterChaseTimer:Reset()
				
				-- Boost reavers if they're too far
				if not self.RandomEncounterBoostTriggered then
					if self.RandomEncounterDistance > 400 or self.RandomEncounterSpeed == tonumber(self.GS["Player0VesselSpeed"]) then
						self.RandomEncounterBoostTriggered = true
						self.RandomEncounterSpeed = self.RandomEncounterSpeed + math.random(3,7)
						
						self.RandomEncounterText = self.RandomEncounterText.." Oh crap, they overloaded their reactor to boost engines!!!"
						
						if self.RandomEncounterSpeed <= tonumber(self.GS["Player0VesselSpeed"]) then
							self.RandomEncounterAbortChase = true
						end
					end
				end
				
				-- Stop chasing if it's too long
				if not self.RandomEncounterFightSelected then
					if (self.Time > self.RandomEncounterRunStarted + 40 and self.RandomEncounterDistance > 150) or self.RandomEncounterDistance > 500 or self.RandomEncounterAbortChase then
						self.MissionReport = {}
						self.MissionReport[#self.MissionReport + 1] = "They stopped chasing us. Lucky we are."
						CF_SaveMissionReport(self.GS, self.MissionReport)
						
						self.RandomEncounterText = ""
						
						-- Finish encounter
						self.RandomEncounterID = nil
					end
				end
				
				if self.RandomEncounterDistance <= 0 then
					self.RandomEncounterAttackLaunched = true
					self.RandomEncounterRunLaunched = false
					self.RandomEncounterNextAttackTime = self.Time

					--Deploy turrets
					self:DeployTurrets()
					
					-- Disable consoles
					self:DestroyStorageControlPanelUI()
					self:DestroyClonesControlPanelUI()
					self:DestroyBeamControlPanelUI()
					self:DestroyTurretsControlPanelUI()
				end
			end
		end
		
		if self.RandomEncounterAttackLaunched then
			if self.Time % 10 == 0 and self.RandomEncounterReaversUnitCount > 0 then
				FrameMan:SetScreenText("Remaining reavers: "..self.RandomEncounterReaversUnitCount, 0, 0, 1500, true);
			end
		
			if self.Time >= self.RandomEncounterNextAttackTime then
				self.RandomEncounterNextAttackTime = self.Time + self.RandomEncounterReaversInterval
				
				-- Create assault bot
				if MovableMan:GetMOIDCount() < CF_MOIDLimit and self.RandomEncounterReaversUnitCount > 0 then
					local isleft
				
					if self.RandomEncounterLeftGates and self.RandomEncounterRightGates then
						if math.random() < 0.5 then
							isleft = true
						else
							isleft = false
						end
					elseif self.RandomEncounterLeftGates then
						isleft = true
					elseif self.RandomEncounterRightGates then
						isleft = false
					end
					
					rocket = CreateACRocket("Rocklet", "Dummy.lua")
					if rocket then
						if isleft then
							rocket.Pos = Vector(0, self.RandomEncounterLeftGates:GetRandomPoint().Y)
							rocket.Vel = Vector(35,0)
							rocket.RotAngle = math.rad(270);
						else
							rocket.Pos = Vector(SceneMan.Scene.Width, self.RandomEncounterRightGates:GetRandomPoint().Y)
							rocket.Vel = Vector(-35,0)
							rocket.RotAngle = math.rad(90);
						end
						rocket.Team = CF_CPUTeam
						rocket.AIMode = Actor.AIMODE_DELIVER
						
						for i = 1, 3 do
							if self.RandomEncounterReaversUnitCount > 0 then
								local r1 = math.random(#self.RandomEncounterReaversAct)
								local r2 = math.random(#self.RandomEncounterReaversLight)
								local r3 = math.random(#self.RandomEncounterReaversHeavy)
							
								local actor = CreateAHuman(self.RandomEncounterReaversAct[r1], self.RandomEncounterReaversActMod[r1])
								if actor then
									actor.Team = CF_CPUTeam
									actor.AIMode = Actor.AIMODE_BRAINHUNT
									
									local itm = CreateHDFirearm(self.RandomEncounterReaversHeavy[r3], self.RandomEncounterReaversHeavyMod[r3])
									if itm then
										actor:AddInventoryItem(itm)
									end

									local itm = CreateHDFirearm(self.RandomEncounterReaversLight[r2], self.RandomEncounterReaversLightMod[r2])
									if itm then
										actor:AddInventoryItem(itm)
									end

									rocket:AddInventoryItem(actor)
									self.RandomEncounterReaversUnitCount = self.RandomEncounterReaversUnitCount - 1
								end
							end
						end
						
						MovableMan:AddActor(rocket)
					
						self.RandomEncounterRocket = rocket
					end--]]--
				end
			end
			
			if self.RandomEncounterRocket ~= nil then
				if MovableMan:IsActor(self.RandomEncounterRocket) then
					self.RandomEncounterRocket.Vel.Y = 0
					
					if self.RandomEncounterLeftGates then
						if self.RandomEncounterLeftGates:IsInside(self.RandomEncounterRocket.Pos) then
							self.RandomEncounterRocket.Vel.X = self.RandomEncounterRocket.Vel.X / 3
							self.RandomEncounterRocket:GibThis()
							self.RandomEncounterRocket = nil
						end
					end

					if self.RandomEncounterRightGates then
						if self.RandomEncounterRightGates:IsInside(self.RandomEncounterRocket.Pos) then
							self.RandomEncounterRocket.Vel.X = self.RandomEncounterRocket.Vel.X / 3
							self.RandomEncounterRocket:GibThis()
							self.RandomEncounterRocket = nil
						end
					end
				else
					self.RandomEncounterRocket = nil
				end
			end
			
			-- Check wining conditions
			if self.RandomEncounterReaversUnitCount <= 0 and self.RandomEncounterRocket == nil and CF_CountActors(CF_CPUTeam) == 0 then
				self.MissionReport = {}
				self.MissionReport[#self.MissionReport + 1] = "Those were the last of them."

				self:GiveRandomExperienceReward(self.RandomEncounterDifficulty)
				
				-- Finish encounter
				self.RandomEncounterID = nil
				CF_SaveMissionReport(self.GS, self.MissionReport)
				-- Rebuild destroyed consoles
				self:InitStorageControlPanelUI()
				self:InitClonesControlPanelUI()
				self:InitBeamControlPanelUI()		
				self:InitTurretsControlPanelUI()		
			end
		end
	end
end
-------------------------------------------------------------------------------

