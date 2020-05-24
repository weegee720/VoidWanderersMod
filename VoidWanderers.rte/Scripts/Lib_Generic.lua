-----------------------------------------------------------------------------------------
-- Generic functions to add to library
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-- Initialize global faction lists
-----------------------------------------------------------------------------------------
function CF_InitFactions(activity)
	print ("CF_InitFactions");
   	CF_CPUTeam = Activity.TEAM_2;
	CF_PlayerTeam = Activity.TEAM_1;
	CF_RogueTeam = -1;
	CF_MOIDLimit = 220;
	CF_ModuleName = "VoidWanderers.rte"
	
	-- Used in flight mode
	CF_KmPerPixel = 100
	
	CF_SellPriceCoeff = 0.25

	CF_BlackMarketRefreshInterval = 3000
	CF_BlackMarketPriceMultiplier = 5
	
	CF_MissionResultShowInterval = 10
	
	CF_UnknownItemPrice = 25
	CF_UnknownActorPrice = 50
	
	CF_ReputationErosionInterval = 50
	
	CF_MaxMissions = 5
	
	CF_MaxHolograms = 18
	
	CF_BombsPerBay = 5
	CF_BombInterval = 1
	CF_BombLoadInterval = 2
	CF_BombFlightInterval = 10
	CF_BombSeenRange = 150
	CF_BombUnseenRange = 400
	
	CF_MaxLevel = 100
	CF_ExpPerLevel = 500
	
	CF_QuantumCapacityPerLevel = 50
	CF_QuantumSplitterEffectiveness = 0.2
	
	CF_SecurityIncrementPerMission = 10
	CF_SecurityIncrementPerDeployment = 2
	
	CF_ReputationPerDifficulty = 1000
	
	CF_DistanceToAttemptEvent = 50
	CF_RandomEncounterProbability = 0.1 -- 1 -- DEBUG
	
	-- When reputation below this level enemy starts sending crafts after player
	CF_ReputationHuntTreshold = -500
	
	-- When mission completed defines how many reputation points will be subtracted from target reputation	
	CF_ReputationPenaltyRatio = 1.65

	-- When mission failed defines how many reputation points will be subtracted from both reputations
	CF_MissionFailedReputationPenaltyRatio = 0.25
	
	CF_EnableIcons = true
	
	-- When enabled UL2 will use special rendering techniques to improve UI rendering
	-- performance on weaker machines. Some artifacts may appear though.
	CF_LowPerformance = false
	
	-- The idea behind this optimization is that creation of particles eats most of the time. 
	-- To avoid that we draw some words and buttons on odd frames and some on even frames.
	-- When in LowPerformance mode CF_DrawString and DrawButton functions will use special Ln-prefixed
	-- versions of UI glows, which live twice longer. In order to work main execution thread must 
	-- count frames so other function can decide if it's odd or even frame right now
	CF_FrameCounter = 0
	
	CF_ShipAssaultDelay = 30
	CF_ShipCounterattackDelay = 20
	
	CF_TeamReturnDelay = 5
	
	CF_CratesRate = 0.35 -- Percentage of cases among available case spawn points
	CF_ActorCratesRate = 0.15 -- Percentage of actor-cases among all deployed cases
	CF_AmbientEnemyRate = 0.55
	CF_ArtifactItemRate = 0.20--1.0 -- DEBUG
	CF_ArtifactActorRate = 0.20--1.0 -- DEBUG
	CF_AmbientEnemyDoubleSpawn = 0.25
	CF_AmbientReinforcementsInterval = 80 -- In ticks
	
	CF_EvacDist = 650
	
	CF_MaxMissionReportLines = 13
	
	CF_ClonePrice = 1500
	CF_StoragePrice = 200
	CF_LifeSupportPrice = 2500
	CF_CommunicationPrice = 3000
	CF_EnginePrice = 500
	CF_TurretPrice = 4000
	CF_TurretStoragePrice = 2000
	CF_BombBayPrice = 6000
	CF_BombStoragePrice = 200
	
	CF_ShipSellCoeff = 0.25
	CF_ShipDevInstallCoeff = 0.05
	
	CF_AssaultDifficultyTexts = {}
	CF_AssaultDifficultyTexts[1] = "scout"
	CF_AssaultDifficultyTexts[2] = "corvette"
	CF_AssaultDifficultyTexts[3] = "frigate"
	CF_AssaultDifficultyTexts[4] = "destroyer"
	CF_AssaultDifficultyTexts[5] = "cruiser"
	CF_AssaultDifficultyTexts[6] = "battleship"

	CF_LocationDifficultyTexts = {}
	CF_LocationDifficultyTexts[1] = "minimum"
	CF_LocationDifficultyTexts[2] = "low"
	CF_LocationDifficultyTexts[3] = "moderate"
	CF_LocationDifficultyTexts[4] = "high"
	CF_LocationDifficultyTexts[5] = "extreme"
	CF_LocationDifficultyTexts[6] = "maximum"
	
	CF_AssaultDifficultyUnitCount = {}
	CF_AssaultDifficultyUnitCount[1] = 4
	CF_AssaultDifficultyUnitCount[2] = 8
	CF_AssaultDifficultyUnitCount[3] = 12
	CF_AssaultDifficultyUnitCount[4] = 16
	CF_AssaultDifficultyUnitCount[5] = 22
	CF_AssaultDifficultyUnitCount[6] = 30

	CF_AssaultDifficultySpawnInterval = {}
	CF_AssaultDifficultySpawnInterval[1] = 10
	CF_AssaultDifficultySpawnInterval[2] = 9
	CF_AssaultDifficultySpawnInterval[3] = 8
	CF_AssaultDifficultySpawnInterval[4] = 7
	CF_AssaultDifficultySpawnInterval[5] = 8
	CF_AssaultDifficultySpawnInterval[6] = 9

	CF_AssaultDifficultySpawnBurst = {}
	CF_AssaultDifficultySpawnBurst[1] = 1
	CF_AssaultDifficultySpawnBurst[2] = 2
	CF_AssaultDifficultySpawnBurst[3] = 2
	CF_AssaultDifficultySpawnBurst[4] = 3
	CF_AssaultDifficultySpawnBurst[5] = 3
	CF_AssaultDifficultySpawnBurst[6] = 3
	
	CF_MaxDifficulty = 6
	
	CF_MaxCPUPlayers = 8
	CF_MaxSaveGames = 6
	CF_MaxItems = 6 -- Max items per clone in clone storage
	CF_MaxItemsPerPreset = 2 -- Max items per AI unit preset
	CF_MaxStorageItems = 1000
	CF_MaxClones = 1000 -- Max clones in clone storage
	CF_MaxTurrets = 1000
	CF_MaxBombs = 1000
	CF_MaxUnitsPerDropship = 3
	
	CF_MaxSavedActors = 40
	CF_MaxSavedItemsPerActor = 20
	
	-- Set this to true to stop any UI processing. Useful when debuging and need to disable UI error message spam.
	CF_StopUIProcessing = false
	
	CF_LaunchActivities = true
	CF_MissionReturnInterval = 2500

	CF_TickInterval = 1000
	CF_FlightTickInterval = 25

	-- How much percents of price to add if player and ally factions natures are not the same
	CF_SynthetsToOrganicRatio = 0.70
	
	CF_EnableAssaults = true -- Set to false to disable assaults
	
	CF_FogOfWarEnabled = true -- Gameplay value
	CF_FogOfWarResolution = 144
	
	CF_Factions = {};
	
	CF_Nobody = "Nobody";
	CF_PlayerFaction = "Nobody";
	CF_CPUFaction = "Nobody";
	
	CF_MissionEndTimer = Timer();
	CF_StartReturnCountdown = false;
	CF_Activity = activity;
	
	CF_FactionIds = {};
	CF_FactionNames = {};
	CF_FactionDescriptions = {};
	CF_FactionPlayable = {};

	CF_ScanBonuses = {}
	CF_RelationsBonuses = {}
	CF_ExpansionBonuses = {}

	CF_MineBonuses = {}
	CF_LabBonuses = {}
	CF_AirfieldBonuses = {}
	CF_SuperWeaponBonuses = {}
	CF_FactoryBonuses = {}
	CF_CloneBonuses = {}
	CF_HospitalBonuses = {}

	CF_HackTimeBonuses = {}
	CF_HackRewardBonuses = {}

	
	CF_DropShipCapacityBonuses = {}
	
	-- Special arrays for factions with pre-equipped items
	-- Everything in this array (indexed by preset name) will not be included by inventory saving routines
	CF_DiscardableItems = {}
	-- Everything in this array will be marked for deletion after actor is created
	CF_ItemsToRemove = {}
	
	CF_BrainHuntRatios = {}
	
	CF_PreferedBrainInventory = {}
	
	CF_SuperWeaponScripts = {}

	CF_ResearchQueues = {}

	-- Specify presets which are not affected by tactical AI unit management
	CF_UnassignableUnits = {}
	
	-- Set this to true if your faction uses pre-equipped actors
	CF_PreEquippedActors = {}

	CF_PresetNames = {"Infantry 1", "Infantry 2", "Sniper", "Shotgun", "Heavy 1", "Heavy 2", "Armor 1", "Armor 2", "Engineer", "Defender"}
	CF_PresetTypes = {INFANTRY1 = 1, INFANTRY2 = 2, SNIPER = 3, SHOTGUN = 4, HEAVY1 = 5, HEAVY2 = 6, ARMOR1 = 7, ARMOR2 = 8, ENGINEER = 9, DEFENDER = 10}
	
	-- Arrays with a combination of presets used by this faction, script will randomly select presets for deployment from this arrays if available
	CF_PreferedTacticalPresets = {}
	
	-- Default presets array, everything is evenly selected by AI
	CF_DefaultTacticalPresets = {	
			CF_PresetTypes.INFANTRY1,
			CF_PresetTypes.INFANTRY2,
			CF_PresetTypes.SNIPER, 
			CF_PresetTypes.SHOTGUN, 
			CF_PresetTypes.HEAVY1, 
			CF_PresetTypes.HEAVY2, 
			CF_PresetTypes.ARMOR1, 
			CF_PresetTypes.ARMOR2, 
			CF_PresetTypes.ENGINEER	
		}
	
	CF_AIModels = {}
	CF_AIModels[1] = "RANDOM" -- Random model selected for every mission
	CF_AIModels[2] = "SIMPLE" -- Simple model like in previous versions
	CF_AIModels[3] = "CONSOLE HUNTERS" -- Will try to destroy devices and hack all consoles before killing brain
	CF_AIModels[4] = "SQUAD" -- AI operates squads of units. Commander receives orders, all other units just follow him
	
	CF_AIModelScripts = {}
	CF_AIModelScripts[CF_AIModels[1]] = BASE_PATH.."AI_Simple.lua"
	CF_AIModelScripts[CF_AIModels[2]] = BASE_PATH.."AI_Simple.lua"
	CF_AIModelScripts[CF_AIModels[3]] = BASE_PATH.."AI_ConsoleHunters.lua"
	CF_AIModelScripts[CF_AIModels[4]] = BASE_PATH.."AI_Squad.lua"

	CF_FactionAIModels = {}
	
	CF_WeaponTypes = {PISTOL = 0, RIFLE = 1, SHOTGUN = 2, SNIPER = 3, HEAVY = 4, SHIELD = 5, DIGGER = 6, GRENADE = 7, TOOL = 8, BOMB = 9}
	CF_ActorTypes = {LIGHT = 0, HEAVY = 1, ARMOR = 2, TURRET = 3}
	CF_FactionTypes = {ORGANIC = 0, SYNTHETIC = 1}

	CF_ItmNames = {}
	CF_ItmPresets = {}
	CF_ItmModules = {}
	CF_ItmPrices = {}
	CF_ItmDescriptions = {}
	CF_ItmUnlockData = {}
	CF_ItmClasses = {}
	CF_ItmTypes = {}
	CF_ItmPowers = {} -- AI will select weapons based on this value

	CF_ActNames = {}
	CF_ActPresets = {}
	CF_ActModules = {}
	CF_ActPrices = {}
	CF_ActDescriptions = {}
	CF_ActUnlockData = {}
	CF_ActClasses = {}
	CF_ActTypes = {}
	CF_EquipmentTypes = {} -- Factions with pre-equipped actors specify which weapons class this unit is equivalent
	CF_ActPowers = {}
	CF_ActOffsets = {}

	-- Bombs, used only by VoidWanderers
	CF_BombNames = {}
	CF_BombPresets = {}
	CF_BombModules = {}
	CF_BombClasses = {}
	CF_BombPrices = {}
	CF_BombDescriptions = {}
	CF_BombOwnerFactions = {}
	CF_BombUnlockData = {}
	
	CF_RequiredModules	 = {}

	CF_FactionNatures = {}
	
	CF_Brains = {};
	CF_BrainModules = {};
	CF_BrainClasses = {};
	CF_BrainPrices = {}
	
	CF_Crafts = {};
	CF_CraftModules = {};
	CF_CraftClasses = {};
	CF_CraftPrices = {}

	local factionstorage = "./"..CF_ModuleName.."/Factions/"
	
	-- Load factions
	if CF_IsFilePathExists("./Factions2/Factions.cfg") then
		CF_FactionFiles = CF_ReadFactionsList("Factions2/Factions.cfg")
		factionstorage = "./Factions2/"
		print ("USING FACTIONS2 FOLDER!")
	else
		CF_FactionFiles = CF_ReadFactionsList(CF_ModuleName.."/Factions/Factions.cfg")
	end
	
	-- Load factions data
	for i = 1, #CF_FactionFiles do
		--print("Loading "..CF_FactionFiles[i])
		f = loadfile(factionstorage..CF_FactionFiles[i])
		if f ~= nil then
			local lastfactioncount  = #CF_Factions
		
			-- Execute script
			f()
		
			-- Check for faction consistency only if it is a faction file
			if lastfactioncount ~= #CF_Factions then
				local id  = CF_Factions[#CF_Factions]
			
				--Check if faction modules installed. Check only works with old v1 or most new v2 faction files.
				--print(CF_InfantryModules[CF_Factions[#CF_Factions]])
				for m = 1, #CF_RequiredModules[id] do
					local module = CF_RequiredModules[id][m];
				
					if module ~= nil then
						if PresetMan:GetModuleID(module) == -1 then
							CF_FactionPlayable[id] = false;
							print ("ERROR!!! "..id.." DISABLED!!! "..CF_RequiredModules[id][m].." NOT FOUND!!!")
						end
					end
				end
				
				-- Assume that faction file is correct
				local factionok = true;
				local err = "";
				
				-- Verify faction file data and add mission values if any
				-- Verify items
				for i = 1, #CF_ItmNames[id] do
					if CF_ItmModules[id][i] == nil then
						factionok = false;
						err = "CF_ItmModules is missing."
					end

					if CF_ItmPrices[id][i] == nil then
						factionok = false;
						err = "CF_ItmPrices is missing."
					end

					if CF_ItmDescriptions[id][i] == nil then
						factionok = false;
						err = "CF_ItmDescriptions is missing."
					end
					
					if CF_ItmUnlockData[id][i] == nil then
						factionok = false;
						err = "CF_ItmUnlockData is missing."
					end

					if CF_ItmTypes[id][i] == nil then
						factionok = false;
						err = "CF_ItmTypes is missing."
					end

					if CF_ItmPowers[id][i] == nil then
						factionok = false;
						err = "CF_ItmPowers is missing."
					end
					
					-- If something is wrong then disable faction and print error message
					if not factionok then
						CF_FactionPlayable[id] = false;
						print ("ERROR!!! "..id.." DISABLED!!! "..CF_ItmNames[id][i].." : "..err)
						break;
					end
				end

				-- Assume that faction file is correct
				local info = {}
				local data = {}
				
				-- Verify faction generic data
				info[#info + 1] = "CF_FactionNames"
				data[#info] = CF_FactionNames[id]

				info[#info + 1] = "CF_FactionDescriptions"
				data[#info] = CF_FactionDescriptions[id]

				info[#info + 1] = "CF_FactionPlayable"
				data[#info] = CF_FactionPlayable[id]

				info[#info + 1] = "CF_RequiredModules"
				data[#info] = CF_RequiredModules[id]

				info[#info + 1] = "CF_FactionNatures"
				data[#info] = CF_FactionNatures[id]

				info[#info + 1] = "CF_ScanBonuses"
				data[#info] = CF_ScanBonuses[id]
				
				info[#info + 1] = "CF_RelationsBonuses"
				data[#info] = CF_RelationsBonuses[id]

				info[#info + 1] = "CF_ExpansionBonuses"
				data[#info] = CF_ExpansionBonuses[id]

				info[#info + 1] = "CF_MineBonuses"
				data[#info] = CF_MineBonuses[id]

				info[#info + 1] = "CF_LabBonuses"
				data[#info] = CF_LabBonuses[id]

				info[#info + 1] = "CF_AirfieldBonuses"
				data[#info] = CF_AirfieldBonuses[id]

				info[#info + 1] = "CF_SuperWeaponBonuses"
				data[#info] = CF_SuperWeaponBonuses[id]

				info[#info + 1] = "CF_FactoryBonuses"
				data[#info] = CF_FactoryBonuses[id]

				info[#info + 1] = "CF_CloneBonuses"
				data[#info] = CF_CloneBonuses[id]

				info[#info + 1] = "CF_HospitalBonuses"
				data[#info] = CF_HospitalBonuses[id]

				info[#info + 1] = "CF_Brains"
				data[#info] = CF_Brains[id]

				info[#info + 1] = "CF_BrainModules"
				data[#info] = CF_BrainModules[id]

				info[#info + 1] = "CF_BrainClasses"
				data[#info] = CF_BrainClasses[id]

				info[#info + 1] = "CF_BrainPrices"
				data[#info] = CF_BrainPrices[id]

				info[#info + 1] = "CF_Crafts"
				data[#info] = CF_Crafts[id]

				info[#info + 1] = "CF_CraftModules"
				data[#info] = CF_CraftModules[id]

				info[#info + 1] = "CF_CraftClasses"
				data[#info] = CF_CraftClasses[id]

				info[#info + 1] = "CF_CraftPrices"
				data[#info] = CF_CraftPrices[id]
				
				for i = 1, #info do
					if data[i] == nil then
						CF_FactionPlayable[id] = false;
						print ("ERROR!!! "..id.." DISABLED!!! "..info[i].." is missing")
						break;
					end
				end
				
				-- Assume that faction file is correct
				local factionok = true;
				local err = "";
				
				-- Verify actors
				for i = 1, #CF_ActNames[id] do
					if CF_ActModules[id][i] == nil then
						factionok = false;
						err = "CF_ActModules is missing."
					end

					if CF_ActPrices[id][i] == nil then
						factionok = false;
						err = "CF_ActPrices is missing."
					end

					if CF_ActDescriptions[id][i] == nil then
						factionok = false;
						err = "CF_ActDescriptions is missing."
					end
					
					if CF_ActUnlockData[id][i] == nil then
						factionok = false;
						err = "CF_ActUnlockData is missing."
					end

					if CF_ActTypes[id][i] == nil then
						factionok = false;
						err = "CF_ActTypes is missing."
					end

					if CF_ActPowers[id][i] == nil then
						factionok = false;
						err = "CF_ActPowers is missing."
					end
					
					-- If something is wrong then disable faction and print error message
					if not factionok then
						CF_FactionPlayable[id] = false;
						print ("ERROR!!! "..id.." DISABLED!!! "..CF_ActNames[id][i].." : "..err)
						break;
					end
				end
			end
		else
			print ("ERROR!!! Could not load: "..CF_FactionFiles[i])
		end
	end

	CF_InitExtensionsData(activity)
	
	-- Load extensions
	CF_ExtensionFiles = CF_ReadFactionsList(CF_ModuleName.."/Extensions/Extensions.cfg")
	
	local extensionstorage = "./"..CF_ModuleName.."/Extensions/"
	
	-- Load factions data
	for i = 1, #CF_ExtensionFiles do
		--[[f = loadfile(extensionstorage..CF_ExtensionFiles[i])
		if f ~= nil then
			-- Execute script
			f()
		else
			print ("ERROR!!! Could not load: "..CF_ExtensionFiles[i])
		end]]--
		dofile(extensionstorage..CF_ExtensionFiles[i])
	end
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function CF_GetPlayerFaction(config, p)
	return config["Player"..p.."Faction"];
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function CF_GetPlayerAllyFaction(config)
	return config["Player0AllyFaction"];
end
-----------------------------------------------------------------------------------------
-- Update mission stats to store in campaign
-----------------------------------------------------------------------------------------
function CF_UpdateGenericStats(config)
	print ("CF_UpdateGenericStats");

	config["Kills"] = tonumber(config["Kills"]) + CF_Activity:GetTeamDeathCount(CF_CPUTeam);
	config["Deaths"] = tonumber(config["Deaths"]) + CF_Activity:GetTeamDeathCount(CF_PlayerTeam);
end
-----------------------------------------------------------------------------------------
-- Initialize and reset mission variables
-----------------------------------------------------------------------------------------
function CF_InitMission(config)
	print ("CF_InitMission");
	CF_Activity:SetTeamFunds(tonumber(config["PlayerGold"]) , CF_PlayerTeam);
	CF_AIBudget = tonumber(config["LastMissionAIBudget"]);

	CF_PlayerFaction = CF_GetPlayerFaction(config);
	CF_CPUFaction = CF_GetCPUFaction(config);
end
-----------------------------------------------------------------------------------------
-- Transfers player to strategy screen after 3 second of victory message
-----------------------------------------------------------------------------------------
function CF_ReturnOnMissionEnd()
	if not CF_StartReturnCountdown then
		if CF_Activity.ActivityState == Activity.OVER then
			CF_StartReturnCountdown = true;
			CF_MissionEndTimer:Reset();
		end
	end
	
	if CF_StartReturnCountdown then
		if CF_MissionEndTimer:IsPastSimMS(CF_MissionReturnInterval) then
			--CF_LaunchMissionActivity("Unmapped Lands 2");
		end
	end
end
-----------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------
function CF_StartMusic(modulename , musicfile)
	local path = "./"..modulename.."/Music/"..musicfile

	if CF_IsFilePathExists(path) then
		AudioMan:ClearMusicQueue();
		AudioMan:PlayMusic(path, -1, -1);
	end	
end
-----------------------------------------------------------------------------------------
-- For a given char returns its index, width, vector offsset  if any
-----------------------------------------------------------------------------------------
function CF_GetCharData(char)
	if CF_Chars == nil then
		CF_Chars = {}
		CF_Chars[" "] = {1,8,nil};
		CF_Chars["!"] = {2,5,Vector(-3,0)};
		CF_Chars["\""] = {3,8,Vector(0,-2)};
		CF_Chars["#"] = {4,8,nil};
		CF_Chars["$"] = {5,8,nil};
		CF_Chars["%"] = {6,8,nil};
		CF_Chars["&"] = {7,6,Vector(-2,0)};
		CF_Chars["`"] = {8,5,Vector(-3,-2)};
		CF_Chars["("] = {9,6,Vector(-1,0)};
		CF_Chars[")"] = {10,6,Vector(-2,0)};
		CF_Chars["*"] = {11,6,Vector(-2,0)};
		CF_Chars["+"] = {12,8,nil};
		CF_Chars[","] = {13,5,Vector(-3,5)};
		CF_Chars["-"] = {14,9,nil};
		CF_Chars["."] = {15,5,Vector(-3,4)};
		CF_Chars["/"] = {16,6,Vector(-1,0)};
		CF_Chars["0"] = {17,9,nil};
		CF_Chars["1"] = {18,6,Vector(-2,0)};
		CF_Chars["2"] = {19,8,nil};
		CF_Chars["3"] = {20,8,nil};
		CF_Chars["4"] = {21,8,nil};
		CF_Chars["5"] = {22,8,nil};
		CF_Chars["6"] = {23,8,nil};
		CF_Chars["7"] = {24,8,nil};
		CF_Chars["8"] = {25,8,nil};
		CF_Chars["9"] = {26,8,nil};
		CF_Chars[":"] = {27,5,Vector(-3,-1)};
		CF_Chars[";"] = {28,5,Vector(-3,-1)};
		CF_Chars["<"] = {29,7,Vector(-1,0)};
		CF_Chars["="] = {30,8,Vector(0,-1)};
		CF_Chars[">"] = {31,7,Vector(-1,0)};
		CF_Chars["?"] = {32,8,nil};
		CF_Chars["@"] = {33,11,Vector(0,-1)};
		CF_Chars["A"] = {34,8,nil};
		CF_Chars["B"] = {35,8,nil};
		CF_Chars["C"] = {36,8,Vector(0,-3)};
		CF_Chars["D"] = {37,9,nil};
		CF_Chars["E"] = {38,8,nil};
		CF_Chars["F"] = {39,8,nil};
		CF_Chars["G"] = {40,8,nil};
		CF_Chars["H"] = {41,8,nil};
		CF_Chars["I"] = {42,6,Vector(-2,0)};
		CF_Chars["J"] = {43,8,nil};
		CF_Chars["K"] = {44,8,nil};
		CF_Chars["L"] = {45,8,Vector(0,3)};
		CF_Chars["M"] = {46,10,Vector(2,-1)};
		CF_Chars["N"] = {47,8,nil};
		CF_Chars["O"] = {48,8,nil};
		CF_Chars["P"] = {49,8,nil};
		CF_Chars["Q"] = {50,8,nil};
		CF_Chars["R"] = {51,8,nil};
		CF_Chars["S"] = {52,8,nil};
		CF_Chars["T"] = {53,7,Vector(-1,0)};
		CF_Chars["U"] = {54,8,nil};
		CF_Chars["V"] = {55,8,nil};
		CF_Chars["W"] = {56,10,Vector(2,0)};
		CF_Chars["X"] = {57,8,nil};
		CF_Chars["Y"] = {58,8,nil};
		CF_Chars["Z"] = {59,8,nil};
		CF_Chars["["] = {60,6,Vector(-1,0)};
		CF_Chars["\\"] = {61,6,Vector(-1,0)};
		CF_Chars["]"] = {62,6,Vector(-1,0)};
		CF_Chars["^"] = {63,8,Vector(-1,-3)};
		CF_Chars["_"] = {64,8,Vector(0,4)};
		CF_Chars["'"] = {65,8,Vector(0,-3)};
		CF_Chars["a"] = {66,8,nil};
		CF_Chars["b"] = {67,8,nil};
		CF_Chars["c"] = {68,8,nil};
		CF_Chars["d"] = {69,8,nil};
		CF_Chars["e"] = {70,8,nil};
		CF_Chars["f"] = {71,8,nil};
		CF_Chars["g"] = {72,8,nil};
		CF_Chars["h"] = {73,8,nil};
		CF_Chars["i"] = {74,5,Vector(-3,0)};
		CF_Chars["j"] = {75,6,Vector(-2,0)};
		CF_Chars["k"] = {76,8,nil};
		CF_Chars["l"] = {77,5,Vector(-3,0)};
		CF_Chars["m"] = {78,10,nil};
		CF_Chars["n"] = {79,8,nil};
		CF_Chars["o"] = {80,8,nil};
		CF_Chars["p"] = {81,8,nil};
		CF_Chars["q"] = {82,8,nil};
		CF_Chars["r"] = {83,9,Vector(1,0)};
		CF_Chars["s"] = {84,8,nil};
		CF_Chars["t"] = {85,8,nil};
		CF_Chars["u"] = {86,8,nil};
		CF_Chars["v"] = {87,8,nil};
		CF_Chars["w"] = {88,10,Vector(1,0)};
		CF_Chars["x"] = {89,8,nil};
		CF_Chars["y"] = {90,8,nil};
		CF_Chars["z"] = {91,8,nil};
		CF_Chars["{"] = {92,7,nil};
		CF_Chars["|"] = {93,7,nil};
		CF_Chars["}"] = {94,7,nil};
		CF_Chars["~"] = {95,8,nil};
	end
	
	local i = nil;
	
	i = CF_Chars[char];
	
	if i == nil then
		i = {96,8,nil};
	end

	return i[1], i[2] - 2, i[3];
end
--------------------------------------------------------------------------
-- Return size of string in pixels
-----------------------------------------------------------------------------
function CF_GetStringPixelWidth(str)
	local len = 0;
	for i = 1, #str do
		local cindex, cwidth, coffset = CF_GetCharData(string.sub(str , i , i))
		len = len + cwidth;
	end
	return len - #str;
end
-----------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
function CF_Split(str, pat)
   local t = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
	 table.insert(t , cap)
      end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   return t
end
-----------------------------------------------------------------------------
-- Draw string on screen at speicified pos not wider that width and not higher than height
-----------------------------------------------------------------------------
function CF_DrawString(str , pos , width , height)
	local x;
	local y;
	local chr;
	local drawthistime
	local letterpreset = "Ltr"
	
	x = pos.X
	y = pos.Y

	local words = CF_Split(str," ");
	for w = 1, #words do
		drawthistime = true
		
		if x + CF_GetStringPixelWidth(words[w]) > pos.X + width then
			x = pos.X
			y = y + 11
			
			if y > pos.Y + height then
				return
			end
		end
	
		for i = 1, #words[w] do
			chr = string.sub(words[w] , i , i);
			
			if chr == "\n" then
				x = pos.X
				y = y + 11
				
				if y > pos.Y + height then
					return
				end
			else
				local cindex, cwidth, coffset = CF_GetCharData(chr)
				
				local pix = CreateMOPixel(letterpreset..cindex);
				local offset = coffset
				if offset ~= nil then
					pix.Pos = Vector(x , y) + offset;
				else
					pix.Pos = Vector(x , y);
				end
				
				MovableMan:AddParticle(pix);
				
				x = x + cwidth
			end
		end
		
		-- Simulate space character, only if we're not at the begining of new line
		if x ~= pos.X then
			x = x + 6
		end
	end
end
-----------------------------------------------------------------------------
-- Converts time in second to string h:mm:ss
-----------------------------------------------------------------------------
function CF_ConvertTimeToString(timenum)
	local timestr = "";

	local hours = (timenum - timenum % 3600) / 3600;
	--print ("Hours "..hours)
	timenum = timenum - hours * 3600
	local minutes = (timenum - timenum % 60) / 60;
	--print ("Minutes "..minutes)
	timenum = timenum - minutes * 60
	local seconds = timenum
	--print ("Minutes "..seconds)
	
	if hours > 0 then
		timestr = timestr..string.format("%d", hours)..":"
	end

	local s; 
	s = tostring(minutes)
	if #s < 2 then
		s = "0"..s
	end
	timestr = timestr ..s..":"

	s = tostring(seconds)
	if #s < 2 then
		s = "0"..s
	end
	timestr = timestr .. s
	
	return timestr;
end
-----------------------------------------------------------------------------------------
-- Make item of specified preset, module and class
-----------------------------------------------------------------------------------------
function CF_MakeItem(item, class, module)
	-- print ("CF_MakeItem")
	if class == nil then
		class = "HDFirearm"
	end
	
	if class == "HeldDevice" then
		return CreateHeldDevice(item, module)
	elseif class == "HDFirearm" then
		return CreateHDFirearm(item, module)
	elseif class == "TDExplosive" then
		return CreateTDExplosive(item, module)
	elseif class == "ThrownDevice" then
		return CreateThrownDevice(item, module)
	end
	
	return nil;
end
-----------------------------------------------------------------------------------------
-- Make item of specified preset, module and class
-----------------------------------------------------------------------------------------
function CF_MakeItem2(item, class)
	-- print ("CF_MakeItem")
	if class == nil then
		class = "HDFirearm"
	end
	
	if class == "HeldDevice" then
		return CreateHeldDevice(item)
	elseif class == "HDFirearm" then
		return CreateHDFirearm(item)
	elseif class == "TDExplosive" then
		return CreateTDExplosive(item)
	elseif class == "ThrownDevice" then
		return CreateThrownDevice(item)
	end
	
	return nil;
end
-----------------------------------------------------------------------------------------
-- Make actor of specified preset, module and class
-----------------------------------------------------------------------------------------
function CF_MakeActor(item, class, module)
	-- print ("CF_MakeItem")
	if class == nil then
		class = "AHuman"
	end
	
	if class == "AHuman" then
		return CreateAHuman(item, module)
	elseif class == "ACrab" then
		return CreateACrab(item, module)
	elseif class == "Actor" then
		return CreateActor(item, module)
	elseif class == "ACDropShip" then
		return CreateACDropShip(item, module)
	elseif class == "ACRocket" then
		return CreateACRocket(item, module)
	end
	
	return nil;
end
-----------------------------------------------------------------------------------------
-- Make actor of specified preset, module and class
-----------------------------------------------------------------------------------------
function CF_MakeActor2(item, class)
	-- print ("CF_MakeItem")
	if class == nil then
		class = "AHuman"
	end
	
	if class == "AHuman" then
		return CreateAHuman(item)
	elseif class == "ACrab" then
		return CreateACrab(item)
	elseif class == "Actor" then
		return CreateActor(item)
	elseif class == "ACDropShip" then
		return CreateACDropShip(item)
	elseif class == "ACRocket" then
		return CreateACRocket(item)
	end
	
	return nil;
end
-----------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------
function CF_GetPlayerGold(c, p)
	local v = c["Player"..p.."Gold"]
	if v == nil then
		v = 0
	end
	
	return tonumber(v)
end
-----------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------
function CF_SetPlayerGold(c, p, funds)
	if funds < 0 then
		funds = 0
	end

	c["Player"..p.."Gold"] = math.ceil(funds)
end
-----------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------
function CF_CommitMissionResult(c, result)
	-- Set result
	c["LastMissionResult"] = result
end
-----------------------------------------------------------------------------
--	
-----------------------------------------------------------------------------
function CF_PayGold(c, p , amount)
	local gold = CF_GetPlayerGold(c, p) - amount
	if gold < 0 then 
		gold = 0
	end
	CF_SetPlayerGold(c, p, gold);
end
-----------------------------------------------------------------------------------------
-- Get table with inventory of actor, inventory cleared as a result
-----------------------------------------------------------------------------------------
function CF_GetInventory(actor)
	--print("GetInventory")
	local inventory = {}
	local classes = {}

	if MovableMan:IsActor(actor) then
		if actor.ClassName == "AHuman" then
			local human = ToAHuman(actor);
			
			if human ~= nil then
				if human.EquippedItem ~= nil then
					local skip = false
					
					if CF_DiscardableItems[actor.PresetName] ~= nil then
						for i = 1, #CF_DiscardableItems[actor.PresetName] do
							if CF_DiscardableItems[actor.PresetName][i] == human.EquippedItem.PresetName then
								skip = true
								break
							end
						end
					end
				
					if not skip then
						inventory[#inventory + 1] = human.EquippedItem.PresetName;
						classes[#classes + 1] = human.EquippedItem.ClassName;
					end
				end
				
				human:UnequipBGArm()
			end
		end
		
		if not actor:IsInventoryEmpty() then
			local enough = false;
			while not enough do
				local weap = nil;
			
				weap = actor:SwapNextInventory(weap, true);
				
				if weap == nil then
					enough = true;
				else
					local skip = false
					
					if CF_DiscardableItems[actor.PresetName] ~= nil then
						for i = 1, #CF_DiscardableItems[actor.PresetName] do
							if CF_DiscardableItems[actor.PresetName][i] == weap.PresetName then
								skip = true
								break
							end
						end
					end
					
					if not skip then
						inventory[#inventory + 1] = weap.PresetName;
						classes[#classes + 1] = weap.ClassName;
					end
				end
			end
		end
	else
		--print("Actor: ")
		--print(actor);
	end
	
	return inventory, classes;
end
-----------------------------------------------------------------------------------------
-- Calculate distance
-----------------------------------------------------------------------------------------
function CF_Dist(pos1 , pos2)
	return SceneMan:ShortestDistance(pos1, pos2, true).Magnitude
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function CF_CountActors(team)
	local c = 0

	for actor in MovableMan.Actors do
		if actor.Team == team and (actor.ClassName == "AHuman" or actor.ClassName == "ACrab") and not actor:IsInGroup("Brains") then
			c = c + 1
		end
	end
	
	return c
end
-----------------------------------------------------------------------------------------
--	Returns how many science points corresponds to selected difficulty level
-----------------------------------------------------------------------------------------
function CF_GetTechLevelFromDifficulty(c, p, diff, maxdiff)
	local maxpoints = 0
	local f = CF_GetPlayerFaction(c, p)
	
	
	for i = 1, #CF_ItmNames[f] do
		if CF_ItmUnlockData[f][i] > maxpoints then
			maxpoints = CF_ItmUnlockData[f][i]
		end
	end

	for i = 1, #CF_ActNames[f] do
		if CF_ActUnlockData[f][i] > maxpoints then
			maxpoints = CF_ActUnlockData[f][i]
		end
	end
	
	return math.floor(maxpoints / maxdiff * diff)
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function CF_CalculateReward(base, diff)
	local coeff = 1 + (diff - 1) * 0.35
	
	return math.floor(base * coeff)
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function CF_IsLocationHasAttribute(loc, attr)
	local attrs = CF_LocationAttributes[loc]
	
	if attrs ~= nil then
		for i = 1, #attrs do
			if attrs[i] == attr then
				return true
			end
		end
	end
	
	return false
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function CF_GiveExp(c, exppts)
	local levelup = false

	for p = 0, 3 do
		local curexp = tonumber(c["Brain"..p.."Exp"])
		local cursklpts = tonumber(c["Brain"..p.."SkillPoints"])
		local curlvl = tonumber(c["Brain"..p.."Level"])
		
		curexp = curexp + exppts
		
		while math.floor(curexp / CF_ExpPerLevel) > 0 do
			if curlvl < CF_MaxLevel then
				curexp = curexp - CF_ExpPerLevel
				cursklpts = cursklpts + 1
				curlvl = curlvl + 1
				levelup = true
			end
		end
	
		c["Brain"..p.."SkillPoints"] = cursklpts
		c["Brain"..p.."Exp"] = curexp
		c["Brain"..p.."Level"] = curlvl
	end
	
	return levelup
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
























