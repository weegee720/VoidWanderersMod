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

