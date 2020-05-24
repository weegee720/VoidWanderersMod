-----------------------------------------------------------------------------------------
-- Initializes all game data when new game started and returns new config
-----------------------------------------------------------------------------------------
function CF_MakeNewConfig(difficulty, playerfaction, allyfaction, cpus)
	local config = {};
	local gameplay = true;

	-- Init game time
	config["Time"] = 0;
	
	-- Set save timestamp
	local os = require("os");
	config["TimeStamp"] = os.date("%d.%m.%y %H:%M");

	local PositiveIndex;
	local NegativeIndex;
	
	local aiscience = 0;
	
	-- Difficulty related variables
	if difficulty <= GameActivity.CAKEDIFFICULTY then
		PositiveIndex = 1.5;
		NegativeIndex = 0.5;
		
		config["AIMineCoeff"] = 0.8
		config["AIScienceCoeff"] = 0.8
		config["AIBuildCoeff"] = 1.2
		config["AISpawnCoeff"] = 1.5
		config["AIBaseAggression"] = 0
	elseif difficulty <= GameActivity.EASYDIFFICULTY then
		PositiveIndex = 1.25;
		NegativeIndex = 0.75;
		
		config["AIMineCoeff"] = 0.9
		config["AIScienceCoeff"] = 0.9
		config["AIBuildCoeff"] = 1.1
		config["AISpawnCoeff"] = 1.2
		config["AIBaseAggression"] = 0.1
	elseif difficulty <= GameActivity.MEDIUMDIFFICULTY then
		PositiveIndex = 1.0;
		NegativeIndex = 1.0;
		
		config["AIMineCoeff"] = 1.0
		config["AIScienceCoeff"] = 1.5
		config["AIBuildCoeff"] = 1.0
		config["AISpawnCoeff"] = 1.0
		config["AIBaseAggression"] = 0.15
	elseif difficulty <= GameActivity.HARDDIFFICULTY then
		PositiveIndex = 0.85;
		NegativeIndex = 1.15;	
		
		config["AIMineCoeff"] = 1.2
		config["AIScienceCoeff"] = 2.0
		config["AIBuildCoeff"] = 0.8
		config["AISpawnCoeff"] = 0.9
		config["AIBaseAggression"] = 0.2
		
		aiscience = 500;
	elseif difficulty <= GameActivity.NUTSDIFFICULTY then
		PositiveIndex = 0.70;
		NegativeIndex = 1.3;
		
		config["AIMineCoeff"] = 1.5
		config["AIScienceCoeff"] = 2.5
		config["AIBuildCoeff"] = 0.55
		config["AISpawnCoeff"] = 0.7
		config["AIBaseAggression"] = 0.3

		aiscience = 1000;
	elseif difficulty <= GameActivity.MAXDIFFICULTY then
		PositiveIndex = 0.55;
		NegativeIndex = 1.45;
		
		config["AIMineCoeff"] = 2.0
		config["AIScienceCoeff"] = 3.5
		config["AIBuildCoeff"] = 0.35
		config["AISpawnCoeff"] = 0.5
		config["AIBaseAggression"] = 0.4

		aiscience = 2000;
	end			
	
	config["PositiveIndex"] = PositiveIndex
	config["NegativeIndex"] = NegativeIndex
	
	-- Set up players
	config["Player0Faction"] = playerfaction
	config["Player0AllyFaction"] = allyfaction
	config["Player0Active"] = "True"
	config["Player0Type"] = "Player"
	config["Player0Gold"] = math.floor(4000 * PositiveIndex)
	config["Player0Science"] = math.floor(0 * PositiveIndex)
	config["Player0Relations"] = math.floor(0 * PositiveIndex)
	config["Player0Intel"] = math.floor(0 * PositiveIndex)

	for i = 1, CF_MaxCPUPlayers do
		if cpus[i] then
			config["Player".. i .."Faction"] = cpus[i]
			config["Player".. i .."Active"] = "True"
			config["Player".. i .."Type"] = "CPU"
			config["Player".. i .."Gold"] = math.floor(4000 * NegativeIndex)
			config["Player".. i .."Science"] = aiscience
			config["Player".. i .."Relations"] = math.floor(0 * NegativeIndex)
			config["Player".. i .."Intel"] = math.floor(0 * NegativeIndex)
			config["Player".. i .."AllyFaction"] = allyfaction -- TODO Change to some randm
		else
			config["Player".. i .."Faction"] = "Nobody"
			config["Player".. i .."Active"] = "False"
			config["Player".. i .."Type"] = "None"
			config["Player".. i .."Gold"] = 0
			config["Player".. i .."Science"] = 0
			config["Player".. i .."Relations"] = 0
			config["Player".. i .."Intel"] = 0
		end
	end
	
	-- Setup available player weapons and actors
	for i = 0, CF_MaxCPUPlayers do
		if config["Player"..i.."Active"] == "True" then
			local f = config["Player".. i .."Faction"]
		
			-- Mark all weapons with data == 0 as available
			for j = 1,  #CF_ItmNames[f] do
				if CF_ItmUnlockData[f][j] == 0 then
					config["Player".. i .."Item"..j.."Unlocked"] = "True"
				else
					config["Player".. i .."Item"..j.."Unlocked"] = "False"
				end
			end

			-- Mark all actors with data == 0 as available
			for j = 1,  #CF_ActNames[f] do
				if CF_ActUnlockData[f][j] == 0 then
					config["Player".. i .."Actor"..j.."Unlocked"] = "True"
				else
					config["Player".. i .."Actor"..j.."Unlocked"] = "False"
				end
			end
			
			-- Mark ally weapons and actors
			-- Mark all weapons with data == 0 as available
			if allyfaction ~= "None" then
				for j = 1,  #CF_ItmNames[allyfaction] do
					config["Player".. i .."AllyItem"..j.."Unlocked"] = "False"
				end

				-- Mark all actors with data == 0 as available
				for j = 1,  #CF_ActNames[allyfaction] do
					config["Player".. i .."AllyActor"..j.."Unlocked"] = "False"
				end
			end
		end
	end

	-- Debug
	-- Testing foreign items
	--[[config["Player0ForeignActor1Unlocked"] = "False"
	config["Player0ForeignActor1Faction"] = "Dummy"
	config["Player0ForeignActor1Preset"] = "1"
	config["Player0ForeignActor1UnlockData"] = "100"
	
	config["Player0ForeignItem1Unlocked"] = "False"
	config["Player0ForeignItem1Faction"] = "Dummy"
	config["Player0ForeignItem1Preset"] = "7"
	config["Player0ForeignItem1UnlockData"] = "100"]]--
	
	-- Defenders
	config["MaxDefenders"] = 8;
	
	-- Facilities properties
	-- Mine income per mine level
	config["MaxMineLevel"] = 5;
	config["MineIncome0"] = 0
	config["MineIncome1"] = 30
	config["MineIncome2"] = 35
	config["MineIncome3"] = 40
	config["MineIncome4"] = 45
	config["MineIncome5"] = 50
	
	-- Lab science points per lab level
	config["MaxLabLevel"] = 5
	config["LabIncome0"] = 0
	config["LabIncome1"] = 5
	config["LabIncome2"] = 6
	config["LabIncome3"] = 7
	config["LabIncome4"] = 8
	config["LabIncome5"] = 10

	-- Time to deliver troops per airfield level, seconds
	config["MaxAirfieldLevel"] = 5
	config["AirfieldTime0"] = 30
	config["AirfieldTime1"] = 15
	config["AirfieldTime2"] = 12
	config["AirfieldTime3"] = 10
	config["AirfieldTime4"] = 8
	config["AirfieldTime5"] = 5

	-- Time to recharge superweapon per superweapon level, seconds
	config["MaxSuperWeaponLevel"] = 5
	config["SuperWeaponTime0"] = 9999 -- Unavailable
	config["SuperWeaponTime1"] = 140
	config["SuperWeaponTime2"] = 115
	config["SuperWeaponTime3"] = 100
	config["SuperWeaponTime4"] = 85
	config["SuperWeaponTime5"] = 70
	
	-- Price to reduce per every factory level, percents
	config["MaxFactoryLevel"] = 5
	config["FactoryReduce0"] = 0
	config["FactoryReduce1"] = -25 
	config["FactoryReduce2"] = -30 
	config["FactoryReduce3"] = -35 
	config["FactoryReduce4"] = -40 
	config["FactoryReduce5"] = -50 

	-- Price to reduce per every clone level, percents
	config["MaxCloneLevel"] = 5
	config["CloneReduce0"] = 0
	config["CloneReduce1"] = -25 
	config["CloneReduce2"] = -30 
	config["CloneReduce3"] = -35 
	config["CloneReduce4"] = -40 
	config["CloneReduce5"] = -50 

	-- Health to restore per every hospital level, hp's
	config["MaxHospitalLevel"] = 5
	config["HospitalRestore0"] = 0 -- Not available
	config["HospitalRestore1"] = 5 
	config["HospitalRestore2"] = 7 
	config["HospitalRestore3"] = 9 
	config["HospitalRestore4"] = 15 
	config["HospitalRestore5"] = 20 
	
	-- Facilities prices
	-- HQ
	config["HQPrice"] = 2000
	
	-- Mine price per level
	config["MinePrice1"] = 1000
	config["MinePrice2"] = 100
	config["MinePrice3"] = 100
	config["MinePrice4"] = 100
	config["MinePrice5"] = 100
	
	-- Lab price per level
	config["LabPrice1"] = 3000
	config["LabPrice2"] = 500
	config["LabPrice3"] = 500
	config["LabPrice4"] = 500
	config["LabPrice5"] = 500

	-- Airfield price per level
	config["AirfieldPrice1"] = 2000
	config["AirfieldPrice2"] = 750
	config["AirfieldPrice3"] = 750
	config["AirfieldPrice4"] = 750
	config["AirfieldPrice5"] = 750

	-- Targeting price per level
	config["SuperWeaponPrice1"] = 3000
	config["SuperWeaponPrice2"] = 500
	config["SuperWeaponPrice3"] = 500
	config["SuperWeaponPrice4"] = 500
	config["SuperWeaponPrice5"] = 500	
	
	-- Factory price per level
	config["FactoryPrice1"] = 3000
	config["FactoryPrice2"] = 500
	config["FactoryPrice3"] = 500
	config["FactoryPrice4"] = 500
	config["FactoryPrice5"] = 500

	-- Clone price per level
	config["ClonePrice1"] = 3000
	config["ClonePrice2"] = 500
	config["ClonePrice3"] = 500
	config["ClonePrice4"] = 500
	config["ClonePrice5"] = 500

	-- Hospital price per level
	config["HospitalPrice1"] = 2000
	config["HospitalPrice2"] = 250
	config["HospitalPrice3"] = 250
	config["HospitalPrice4"] = 250
	config["HospitalPrice5"] = 250

	-- Create bonuses array
	local bonuses = {75, 50, 50, 25, 25, 25, 0 , 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -25, -25, -25, -25, -50}
	
	-- Set up territories
	for i = 1, 10 do
		-- Owners
		config["Terr"..i.."Owner"] = -1
		
		-- Facilities
		config["Terr"..i.."MineLevel"] = 0--math.random(6) - 1
		config["Terr"..i.."LabLevel"] = 0--math.random(6) - 1
		config["Terr"..i.."AirfieldLevel"] = 0--math.random(6) - 1
		config["Terr"..i.."SuperWeaponLevel"] = 0--math.random(6) - 1
		config["Terr"..i.."FactoryLevel"] = 0--math.random(6) - 1
		config["Terr"..i.."CloneLevel"] = 0--math.random(6) - 1
		config["Terr"..i.."HospitalLevel"] = 0--math.random(6) - 1
		
		-- Defences
		config["Terr"..i.."MineDefence"] = 0--math.random(5) - 1
		config["Terr"..i.."LabDefence"] = 0--math.random(5) - 1
		config["Terr"..i.."AirfieldDefence"] = 0--math.random(5) - 1
		config["Terr"..i.."SuperWeaponDefence"] = 0--math.random(5) - 1
		config["Terr"..i.."FactoryDefence"] = 0--math.random(5) - 1
		config["Terr"..i.."CloneDefence"] = 0--math.random(5) - 1
		config["Terr"..i.."HospitalDefence"] = 0--math.random(5) - 1
		config["Terr"..i.."HQDefence"] = 0--math.random(5) - 1
		
		-- Bonuses
		config["Terr"..i.."MineBonus"] = bonuses[math.random(#bonuses)]
		config["Terr"..i.."LabBonus"] = bonuses[math.random(#bonuses)]
		config["Terr"..i.."AirfieldBonus"] = bonuses[math.random(#bonuses)]
		config["Terr"..i.."SuperWeaponBonus"] = bonuses[math.random(#bonuses)]
		config["Terr"..i.."FactoryBonus"] = bonuses[math.random(#bonuses)]
		config["Terr"..i.."CloneBonus"] = bonuses[math.random(#bonuses)]
		config["Terr"..i.."HospitalBonus"] = bonuses[math.random(#bonuses)]
	end
	
	-- Activities variables
	-- Intelligence points per scan
	config["ScanPrice"] = 1000
	-- Intelligence points per hacked console
	config["IntelligenceReward"] = 350
	-- How many ticks scan data will be available
	config["ScanDuration"] = 10;

	-- How much diplomacy points to give on suceess of ally mission
	config["AllyMissionReward"] = 500;

	-- How much diplomacy points to give on success of ally console hack
	config["AllyConsoleReward"] = 350;

	-- How much diplomacy points to give on suceess of ally item retrieval
	config["AllyItemReward"] = 250;
	
	-- How much diplomacy points spent per one ally dropship full of troops
	config["AllyPrice"] = CF_AllyReinforcementsBasePrice
	
	-- Determine random initial owners
	local terrs = {}
	
	for i = 0, CF_MaxCPUPlayers do
		terrs[i] = 0;
	end
	
	for i = 0, CF_MaxCPUPlayers do
		local ok = false
		
		while (not ok) do
			ok = true
			--print (r)
			local r = math.random(10)
		
			-- Check that we don't chose same territories
			for j = 0, #terrs do
				if r == terrs[j] then
					ok = false;
				end
			end
			
			terrs[i] = r;
		end
	end

	-- Disable offline cpu players
	for i = 1, CF_MaxCPUPlayers do
		if not cpus[i] then
			terrs[i] = 0;
		end
	end
	
	-- Assign selected owners
	for i = 0, CF_MaxCPUPlayers do
		if terrs[i] > 0 then
			config["Terr"..terrs[i].."Owner"] = i
		end
	end
	
	-- Assign scenes to territories
	local Scenes = {}
	
	-- Define available scenes
	local generic = {
		"UL2 WG Burraki Desert", 
		"UL2 WG Rhias Forest", 
		"UL2 WG Vesod Plains", 
		"UL2 WG Mt. Imdunt", 
		"UL2 WG Dvorak Caves", 
		"UL2 WG Slodran Wilderness", 
		"UL2 WG Fredeleig Plains", 
		"UL2 WG Rayvord Tundra", 
		"UL2 WG Metankora Highlands", 
		"UL2 WG2 Vesod Plains", 
		"UL2 WG2 Zekarra Lowlands",
		"UL2 WG2 Slodran Wilderness",
		"UL2 WG2 Ketanot Hills",
		"UL2 WG2 Rhias Forest",
		"UL2 WG2 Yskely Mountains", 
		"UL2 WG2 Fredeleig Plains",
		"UL2 WG2 Dvorak Caves",
		"UL2 WG2 Metankora Highlands", 
		"UL2 WG2 Rayvord Tundra"}
	
	Scenes[T_MINE] = generic
	Scenes[T_LAB] = generic
	Scenes[T_AIR] = {"UL2 WG Zekarra Lowlands", "UL2 WG Ketanot Hills", "UL2 WG Yskely Mountains"}
	Scenes[T_SUPER] = generic
	Scenes[T_FACT] = generic
	Scenes[T_CLONE] = generic
	Scenes[T_HOSP] = generic
	Scenes[T_HQ] = generic
	
	-- Assign scenes to territories
	for t = 1, 10 do
		for f = 1, 8 do
			config["Terr"..t.."Facility"..f.."Scene"] = Scenes[f][math.random(#Scenes[f])]
		end
	end
	
	return config;
end
-----------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------
































