-------------------------------------------------------------------------------
--[[local id = "TEST";

CF_RandomEncounters[#CF_RandomEncounters + 1] = id
	
CF_RandomEncountersInitialTexts[id] = "TEST ENCOUNTER"
CF_RandomEncountersInitialVariants[id] = {"Variant 1", "Variant 2", "Variant 3"}
CF_RandomEncountersVariantsInterval[id] = 12
CF_RandomEncountersOneTime[id] = false
CF_RandomEncountersFunctions[id] = 

function (self, variant) 
	if variant ~= 0 then
		self.MissionReport = {}
		
		self.MissionReport[#self.MissionReport + 1] = "SELECTED VARIANT "..variant
		
		-- Finish encounter
		self.RandomEncounterID = nil
		CF_SaveMissionReport(self.GS, self.MissionReport)
	end
end--]]--
-------------------------------------------------------------------------------
-- Define pirate identities
CF_RandomEncounterPirates = {}

-- Generic organic mid-heavy pirates
local pid = #CF_RandomEncounterPirates + 1
CF_RandomEncounterPirates[pid] = {}
CF_RandomEncounterPirates[pid]["Captain"] = "Apone"
CF_RandomEncounterPirates[pid]["Ship"] = "Sulako"
CF_RandomEncounterPirates[pid]["Org"] = "The Free Galactic Brotherhood"
CF_RandomEncounterPirates[pid]["FeeInc"] = 500

CF_RandomEncounterPirates[pid]["Act"] = 	{"Ronin Soldier", 	"Ronin Heavy", 	"Soldier Light", 	"Soldier Heavy", 	"Browncoat Light", 	"Browncoat Heavy"}
CF_RandomEncounterPirates[pid]["ActMod"] = 	{"Ronin.rte", 		"Ronin.rte" , 	"Coalition.rte" , 	"Coalition.rte", 	"Browncoats.rte" , 	"Browncoats.rte"}	

CF_RandomEncounterPirates[pid]["Itm"] = 	{"AR-25 Hammerfist", 	"PY-07 Trailblazer", 	"Compact Assault Rifle", 	"Assault Rifle", 	"Shotgun", 			"Uzi", 			"MP5K", 		"AK-47", 		"Thumper"}
CF_RandomEncounterPirates[pid]["ItmMod"] = 	{"Browncoats.rte", 		"Browncoats.rte",		"Coalition.rte",			"Coalition.rte",	"Coalition.rte",	"Ronin.rte",	"Ronin.rte",	"Ronin.rte",	"Ronin.rte"}

CF_RandomEncounterPirates[pid]["Units"] = 12
CF_RandomEncounterPirates[pid]["Burst"] = 3
CF_RandomEncounterPirates[pid]["Interval"] = 18

local pid = #CF_RandomEncounterPirates + 1
CF_RandomEncounterPirates[pid] = {}
CF_RandomEncounterPirates[pid]["Captain"] = "SHODAN"
CF_RandomEncounterPirates[pid]["Ship"] = "Von Braun"
CF_RandomEncounterPirates[pid]["Org"] = "The Free Nexus"
CF_RandomEncounterPirates[pid]["FeeInc"] = 500

CF_RandomEncounterPirates[pid]["Act"] = 	{"Dummy", 		"Scouting Robot", 	"All Purpose Robot", 	"Combat Robot", 	"Whitebot", 	"Silver Man"}
CF_RandomEncounterPirates[pid]["ActMod"] = 	{"Dummy.rte", 	"Imperatus.rte" , 	"Imperatus.rte" , 		"Imperatus.rte", 	"Techion.rte" ,	"Techion.rte"}	

CF_RandomEncounterPirates[pid]["Itm"] = 	{"Blaster", 	"Repeater", 	"Bullpup AR-14", 	"Mauler SG-23", 	"Pulse Rifle", 	"Nucleo Swarm"}
CF_RandomEncounterPirates[pid]["ItmMod"] = 	{"Dummy.rte", 	"Dummy.rte",	"Imperatus.rte",	"Imperatus.rte",	"Techion.rte",	"Techion.rte"}

CF_RandomEncounterPirates[pid]["Units"] = 12
CF_RandomEncounterPirates[pid]["Burst"] = 3
CF_RandomEncounterPirates[pid]["Interval"] = 18


local id = "PIRATE_GENERIC";
CF_RandomEncounters[#CF_RandomEncounters + 1] = id
CF_RandomEncountersInitialTexts[id] = ""
CF_RandomEncountersInitialVariants[id] = {"I'm at your mercy, take whatever you want.", "Kid, don't threaten me. There are worse things than death and I can do all of them."}
CF_RandomEncountersVariantsInterval[id] = 24
CF_RandomEncountersOneTime[id] = false
CF_RandomEncountersFunctions[id] = 

function (self, variant)
	if not self.RandomEncounterIsInitialized then
		-- Select random pirate party
		self.RandomEncounterSelectedPirate = math.random(#CF_RandomEncounterPirates)
		self.RandomEncounterPirate = CF_RandomEncounterPirates[self.RandomEncounterSelectedPirate]
		
		local fee = self.GS["RandomEncounter"..self.RandomEncounterID..self.RandomEncounterPirate["Captain"].."Fee"]
		if fee == nil then
			fee = self.RandomEncounterPirate["FeeInc"]
		else
			fee = tonumber(fee)
		end
		
		-- If we killed selected pirate then show some info and give player some gold
		if fee == -1 then
			local gold = math.random(self.RandomEncounterPirate["FeeInc"])
		
			self.MissionReport = {}
			self.MissionReport[#self.MissionReport + 1] = "Dead pirate vessel floats nearby, it was raided endless times, but you managed to scavenege "..gold.."oz of gold from it."
			CF_SaveMissionReport(self.GS, self.MissionReport)
			
			self.RandomEncounterText = ""
			
			CF_SetPlayerGold(self.GS, 0, CF_GetPlayerGold(self.GS, 0) + gold)
			
			-- Finish encounter
			self.RandomEncounterID = nil
		else
		-- If captain is still alive then initiate negotiations
			fee = fee + self.RandomEncounterPirate["FeeInc"]
			
			self.GS["RandomEncounter"..self.RandomEncounterID..self.RandomEncounterPirate["Captain"].."Fee"] = fee
			
			if fee > CF_GetPlayerGold(self.GS, 0) then
				fee = CF_GetPlayerGold(self.GS, 0)
			end
			
			self.RandomEncounterPirateFee = fee
			self.RandomEncounterPirateUnits = self.RandomEncounterPirate["Units"]
			
			-- Change initial text
			self.RandomEncounterText = "This is captain "..self.RandomEncounterPirate["Captain"].." of ".. self.RandomEncounterPirate["Ship"] .." speaking. You are in the vicinity of "..self.RandomEncounterPirate["Org"].." and have to pay a small fee of "..self.RandomEncounterPirateFee .."oz of gold to pass. Comply at once and no one will get hurt."
		end
		
		self.RandomEncounterPirateAttackLaunched = false
		self.RandomEncounterIsInitialized = true
	end

	if not self.RandomEncounterPirateAttackLaunched then
		if variant == 1 then
			self.MissionReport = {}
			self.MissionReport[#self.MissionReport + 1] = self.RandomEncounterPirate["Org"].." is always at your service. "..self.RandomEncounterPirate["Captain"].." out."
			
			CF_SetPlayerGold(self.GS, 0, CF_GetPlayerGold(self.GS, 0) - self.RandomEncounterPirateFee)
			
			-- Finish encounter
			self.RandomEncounterID = nil
			CF_SaveMissionReport(self.GS, self.MissionReport)
		end
		
		if variant == 2 then
			self.RandomEncounterText = "Prepare to be punished! "..self.RandomEncounterPirate["Captain"].." out."
			self.RandomEncounterVariants = {}
			
			-- Indicate thet we fought this pirate and defeated him
			self.GS["RandomEncounter"..self.RandomEncounterID..self.RandomEncounterPirate["Captain"].."Fee"] = -1		
			self.RandomEncounterPirateAttackLaunched = true

			-- Disable consoles
			self:DestroyStorageControlPanelUI()
			self:DestroyClonesControlPanelUI()
			self:DestroyBeamControlPanelUI()
			
			-- Set up assault
			self.AssaultNextSpawnTime = self.Time + self.RandomEncounterPirate["Interval"]
			self.AssaultNextSpawnPos = self.EnemySpawn[math.random(#self.EnemySpawn)]
		end
	else
		local count = 0
		
		for actor in MovableMan.Actors do
			if actor.Team == CF_CPUTeam then
				count = count + 1
				if actor.AIMode ~= Actor.AIMODE_BRAINHUNT then
					actor.AIMode = Actor.AIMODE_BRAINHUNT
				end
			end
		end
	
		if self.RandomEncounterPirateUnits == 0 then
		
			if count == 0 then
				self.MissionReport = {}
				self.MissionReport[#self.MissionReport + 1] = "Fine, looks like you're a tough one. You can pass for free. "..self.RandomEncounterPirate["Captain"].." out."
				
				-- Finish encounter
				self.RandomEncounterID = nil
				CF_SaveMissionReport(self.GS, self.MissionReport)
				-- Rebuild destroyed consoles
				self:InitStorageControlPanelUI()
				self:InitClonesControlPanelUI()
				self:InitBeamControlPanelUI()
			end
		end
	
		if self.AssaultNextSpawnTime == self.Time then
			--print ("Spawn")
			self.AssaultNextSpawnTime = self.Time + self.RandomEncounterPirate["Interval"]
			
			local cnt = math.random(self.RandomEncounterPirate["Burst"])
			
			for j = 1, cnt do
				if MovableMan:GetMOIDCount() < CF_MOIDLimit and self.RandomEncounterPirateUnits > 0 then
					self.RandomEncounterPirateUnits = self.RandomEncounterPirateUnits - 1
					pos = self.AssaultNextSpawnPos
					
					local r1 = math.random(#self.RandomEncounterPirate["Act"])
					local r2 = math.random(#self.RandomEncounterPirate["Itm"])
				
					local act = CreateAHuman(self.RandomEncounterPirate["Act"][r1], self.RandomEncounterPirate["ActMod"][r1])
					if act then
						local weap = CreateHDFirearm(self.RandomEncounterPirate["Itm"][r2], self.RandomEncounterPirate["ItmMod"][r2])
						if weap then
							act:AddInventoryItem(weap)
						end
					
						act.Pos = self.AssaultNextSpawnPos
						act.Team = CF_CPUTeam
						act.AIMode = Actor.AIMODE_BRAINHUNT
						MovableMan:AddActor(act)
						
						local fxb = CreateAEmitter("Teleporter Effect A");
						fxb.Pos = act.Pos;
						MovableMan:AddParticle(fxb);
						
						act:FlashWhite(1500);
					end
				end
			end
			
			self.AssaultNextSpawnPos = self.EnemySpawn[math.random(#self.EnemySpawn)]
		end
		
		if self.Time % 10 == 0 and self.RandomEncounterPirateUnits > 0 then
			FrameMan:SetScreenText("Remaining assault bots: "..self.RandomEncounterPirateUnits, 0, 0, 1500, true);
		end
		
		-- Create teleportation effect
		if self.RandomEncounterPirateUnits > 0 and self.AssaultNextSpawnTime - self.Time < 6 then
			self:AddObjectivePoint("INTRUDER\nALERT", self.AssaultNextSpawnPos , CF_PlayerTeam, GameActivity.ARROWDOWN);
		
			if self.TeleportEffectTimer:IsPastSimMS(50) then
				-- Create particle
				local p = CreateMOSParticle("Tiny Blue Glow", self.ModuleName)
				p.Pos = self.AssaultNextSpawnPos + Vector(-20 + math.random(40), 30 - math.random(20))
				p.Vel = Vector(0,-2)
				MovableMan:AddParticle(p)
				self.TeleportEffectTimer:Reset()
			end
		end
	end
end
-------------------------------------------------------------------------------
-- Abandoned ship exploration
local id = "ABANDONED_VESSEL_GENERIC";
CF_RandomEncounters[#CF_RandomEncounters + 1] = id
CF_RandomEncountersInitialTexts[id] = "A dead vessel floats in an asteroid field, it might have been abandoned for years, though it does not mean that it's empty."
CF_RandomEncountersInitialVariants[id] = {"Send away team immediately!", "Just cut off everything valuable from the hull.", "Leave it alone..."}
CF_RandomEncountersVariantsInterval[id] = 24
CF_RandomEncountersOneTime[id] = false
CF_RandomEncountersFunctions[id] = 

function (self, variant)
	if not self.RandomEncounterIsInitialized then
		local locations = {}
	
		-- Find usable scene
		for i = 1, #CF_Location do
			local id = CF_Location[i]
			if CF_IsLocationHasAttribute(id, CF_LocationAttributeTypes.ABANDONEDVESSEL) then
				locations[#locations + 1] = id
			end
		end
		
		self.AbandonedVesselLocation = locations[math.random(#locations)]

		self.RandomEncounterIsInitialized = true
	end

	if variant == 1 then
		self.GS["Location"] = self.AbandonedVesselLocation
		
		self.RandomEncounterText = "Deploy your away team to the abandoned ship."
		self.RandomEncounterVariants = {}
		self.RandomEncounterChosenVariant = 0
	end
	
	if variant == 2 then
		local devices = {"a zrbite reactor", "an elerium reactor", "a solar panel", "a warp projector", "an observation lens", "a hangar door", "a dust filter", "a neutrino collector", "a Higgs boson detector", "a microwave heater"}
		if math.random() < 0.125 then
			local losstext
			local r = math.random(5)
			
			for p = 0 , self.PlayerCount - 1 do
				FrameMan:FlashScreen(p, 13, 1000)
			end
			
			local charge = CreateMOSRotating("Explosion Sound "..math.random(10))
			charge.Pos = self.ShipControlPanelPos
			MovableMan:AddParticle(charge)
			charge:GibThis();
			
			if r == 1 then
				-- Destroy stored clone if any
				if #self.Clones > 0 then
					local rclone = math.random(tonumber(self.GS["Player0VesselClonesCapacity"]))
					-- If damaged cell hit the clone then remove actor from array
					local newarr = {}
					local ii = 1
					
					for i = 1, #self.Clones do
						if i ~= rclone then
							newarr[ii] = self.Clones[i]
							ii = ii + 1
						end
					end
					
					self.Clones = newarr
				end
				CF_SetClonesArray(self.GS, self.Clones)
				
				self.GS["Player0VesselClonesCapacity"] = tonumber(self.GS["Player0VesselClonesCapacity"]) - 1
				
				if self.GS["Player0VesselClonesCapacity"] <=0 then
					self.GS["Player0VesselClonesCapacity"] = 1
				end
				
				losstext = "and destroyed one of our cryo-chambers." 
			elseif r == 2 then
				-- Destroy storage cells
				for i = 1 ,7 do
					local rweap = math.random(#self.StorageItems * 2)
					if rweap <= #self.StorageItems then
						if self.StorageItems[rweap]["Count"] > 0 then
							self.StorageItems[rweap]["Count"] = self.StorageItems[rweap]["Count"] - 1
						end
					end
				end

				self.GS["Player0VesselStorageCapacity"] = tonumber(self.GS["Player0VesselStorageCapacity"]) - 7
				
				if self.GS["Player0VesselStorageCapacity"] <=0 then
					self.GS["Player0VesselStorageCapacity"] = 1
				end
				
				-- If we have some items left in nonexisting cell then throw them around
				while CF_CountUsedStorageInArray(self.StorageItems) > self.GS["Player0VesselStorageCapacity"] do
					local rweap = math.random(#self.StorageItems)
					if self.StorageItems[rweap]["Count"] > 0 then
						self.StorageItems[rweap]["Count"] = self.StorageItems[rweap]["Count"] - 1
						
						if self.StorageInputPos ~= nil then
							local itm = CF_MakeItem2(self.StorageItems[rweap]["Preset"], self.StorageItems[rweap]["Class"])
							if itm then
								itm.Pos = self.StorageInputPos
								local a = math.random(360)
								local r = 10 + math.random(40)
								itm.Vel = Vector(math.cos(a / (180 / 3.14)) * r, math.sin(a / (180 / 3.14) * r))
								MovableMan:AddItem(itm)
							end
						end
					end
				end
				
				CF_SetStorageArray(self.GS, self.StorageItems)
				self.StorageItems, self.StorageFilters = CF_GetStorageArray(self.GS, true)
				
				losstext = "and destroyed five of our storage cells." 
			elseif r == 3 then
				-- Destroy life support
				self.GS["Player0VesselLifeSupport"] = tonumber(self.GS["Player0VesselLifeSupport"]) - 1
				
				if self.GS["Player0VesselLifeSupport"] <=0 then
					self.GS["Player0VesselLifeSupport"] = 1
				end
				
				losstext = "and destroyed our oxygen regeneration tank. Our life support system degraded." 
			elseif r == 4 then
				-- Destroy life support
				self.GS["Player0VesselCommunication"] = tonumber(self.GS["Player0VesselCommunication"]) - 1
				
				if self.GS["Player0VesselCommunication"] <=0 then
					self.GS["Player0VesselCommunication"] = 1
				end
				
				losstext = "and destroyed one of our antennas." 
			elseif r == 5 then
				-- Destroy engine
				self.GS["Player0VesselSpeed"] = tonumber(self.GS["Player0VesselSpeed"]) - 5
				
				if self.GS["Player0VesselSpeed"] <=5 then
					self.GS["Player0VesselSpeed"] = 5
				end
				
				losstext = "and damaged our engine. We've lost some speed." 
			end
		
			self.MissionReport = {}
			self.MissionReport[#self.MissionReport + 1] = "We tried to cut off "..devices[math.random(#devices)].." but it exploded "..losstext
			CF_SaveMissionReport(self.GS, self.MissionReport)
		else
			local gold = math.random(1250)
			CF_SetPlayerGold(self.GS, 0, CF_GetPlayerGold(self.GS, 0) + gold)
			
			self.MissionReport = {}
			self.MissionReport[#self.MissionReport + 1] = "We managed to find some uncorrupted parts of "..devices[math.random(#devices)].." worth "..gold.." oz of gold."
			CF_SaveMissionReport(self.GS, self.MissionReport)
		end
		
		-- Finish encounter
		self.RandomEncounterID = nil
	end
	
	if variant == 3 then
		self.MissionReport = {}
		self.MissionReport[#self.MissionReport + 1] = "Farewell silent wanderer of the void."
		CF_SaveMissionReport(self.GS, self.MissionReport)
		
		-- Finish encounter
		self.RandomEncounterID = nil
	end
	
end
-------------------------------------------------------------------------------

