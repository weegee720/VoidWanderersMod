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
	CF_MOIDLimit = 200;
	
	-- When enabled UL2 will use special rendering techniques to improve UI rendering
	-- performance on weaker machines. Some artifacts may appear though.
	CF_LowPerformance = false
	
	-- The idea behind this optimization is that creation of particles eats most of the time. 
	-- To avoid that we draw some words and buttons on odd frames and some on even frames.
	-- When in LowPerformance mode CF_DrawString and DrawButton functions will use special Ln-prefixed
	-- versions of UI glows, which live twice longer. In order to work main execution thread must 
	-- count frames so other function can decide if it's odd or even frame right now
	CF_FrameCounter = 0
	
	CF_MaxCPUPlayers = 8
	CF_MaxSaveGames = 6
	CF_MaxItems = 50
	CF_MaxUnitsPerDropship = 3
	
	CF_MaxAIEngineerCount = 3
	
	-- AI engineers won't dig if they're too close to lz
	CF_EngineerDigRange = 250
	
	-- AI Engineers will scan this many pixels for gold
	CF_EngineerDigDepth = 250
	
	-- How much gold AI must have before ordering engineers to dig gold
	CF_EngineerOrderThreshold = 750
	
	CF_AllyItemProbability = 0.15;--0.10
	-- Time in tactical ticks to show ally reward message
	CF_AllyRewardShowInterval = 3;
	
	CF_DisableAllyMissions = true
	
	CF_LZCompromiseRange = 250
	
	CF_EnableCCRTS = true
	CF_CCRTSKey = 75 -- Default CCRTS key - space (75)
	
	-- If this is true UL2 will use the new diplomacy model where player can order ally
	-- reinforcements using ally points
	CF_UseNewDiplomacyModel	= true
	CF_AllyReinforcementsBasePrice = 500
	
	-- How much time negative console effect lasts in tactical ticks
	CF_BasicConsoleHackNegativeEffectLength = 30
	
	CF_LaunchActivities = true
	CF_MissionReturnInterval = 2500

	CF_TacticalTickInterval = 1000
	CF_TacticalHackTime = 30
	-- Percentage of resources to steal when console is hacked
	CF_StealAmount = 15
	CF_ActiveConsolesRatio = 0.7
	-- Interval after which AI will surrender due to time out. Sometimes AI have low airfield level
	-- but big budget as a result defence missions become too long and player may consider 
	-- that something is broken and reset. To avoid this we'll just make AI lose no matter what
	-- if it's too slow.
	CF_MissionTimeoutInterval = 500	
	
	-- How many troops will be sent to brainhunt mode (IN "SIMPLE" AI MODE!)
	CF_DefaultBrainHuntRatio = 0.50
	-- How many brainhunt-selected troops will go to LZ instead (IN "SIMPLE" AI MODE!)
	CF_DefaultLZRatio = 0.20

	-- To make HQ assaults harder we'll boost AI defenders with more money
	-- If player didn't destroy facilities first, than AI will get more money for defence
	-- Total money will be Facilities * Levels * CF_BasicAIGoldBonusPerFacility * AI income bonus
	CF_BasicAIGoldBonusPerFacilityLevel = 200

	-- How much percents of price to add if player and ally factions natures are not the same
	CF_SynthetsToOrganicRatio = 0.70
	
	CF_FogOfWarEnabled = true -- Gameplay value
	CF_FogOfWarResolution = 100
	
	CF_DebugSuperWeapons = false -- Gameplay value
	CF_DebugEnableRandomActivity = false;--false -- Gameplay value
	
	CF_AIDebugOutput = false;--false -- Gameplay value
	CF_AIResourcesOutput = false;--false -- Gameplay value
	
	-- Auto save data to Current.dat every N ticks
	CF_AutoSaveInterval = 10
	
	-- Increase tick time when debugging to make it simpler to track the console messages
	if CF_AIDebugOutput then
		CF_TickInterval = CF_TickInterval * 2
	end
	
	-- Those id's used to identify data in array returned by CF_GetTerritoryValues
	-- Facilities types
	T_MINE = 1
	T_LAB = 2
	T_AIR = 3
	T_SUPER = 4
	T_FACT = 5
	T_CLONE = 6
	T_HOSP = 7
	T_HQ = 8
	
	-- Meaning of values
	V_LEVEL = 1 -- Level of facility
	V_VAL = 2 -- Actual value, e.g. gold per tick, science per tick and so on.
	V_BONUS = 3 -- Active total bonus in percents
	V_DEFEND = 4 -- Defenders count
	
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
	
	CF_WeaponTypes = {PISTOL = 0, RIFLE = 1, SHOTGUN = 2, SNIPER = 3, HEAVY = 4, SHIELD = 5, DIGGER = 6, GRENADE = 7, TOOL = 8}
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

	local factionstorage = "./VoidWanderers.rte/Factions/"
	
	-- Load factions
	if CF_IsFilePathExists("./Factions2/Factions.cfg") then
		CF_FactionFiles = CF_ReadFactionsList("Factions2/Factions.cfg")
		factionstorage = "./Factions2/"
		print ("USING FACTIONS2 FOLDER!")
	else
		CF_FactionFiles = CF_ReadFactionsList("VoidWanderers.rte/Factions/Factions.cfg")
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
	
	CF_InitShipsData(activity)
	CF_InitScenesData(activity)
	
	--print("Factions loaded:")
	--for i = 1 , #CF_Factions do
		--print(CF_Factions[i])
	--end	
end
-----------------------------------------------------------------------------------------
--	Create actor from preset pre, where c - config, p - player, t - territory, pay gold is pay == true
-- 	returns actor or nil, also returns actor ofsset, value wich you must add to default actor position to 
-- 	avoid actor hang in the air, used mainly for turrets
-----------------------------------------------------------------------------------------
function CF_MakeActorFromPreset(c, p, t, pre, pay)
	--print ("CF_MakeActorFromPreset");

	local actor = nil
	local offset = Vector(0,0)
	local weapon = nil;
	local price = 0;
	
	if t ~= nil then
		price = CF_GetPresetTerritoryPrice(c, p, pre, t);
	end
	
	if pay and CF_GetPlayerGold(c, p) < price then
		return nil
	end
	
	if MovableMan:GetMOIDCount() < CF_MOIDLimit then
		--print (pre)
		--print (c["Player"..p.."Preset"..pre.."Actor"])
		--print (c["Player"..p.."Preset"..pre.."Faction"])
		local a = c["Player"..p.."Preset"..pre.."Actor"]
		if a ~= nil then
			a = tonumber(a)
			local f = c["Player"..p.."Preset"..pre.."Faction"]
			
			actor = CF_MakeActor(CF_ActPresets[f][a], CF_ActClasses[f][a], CF_ActModules[f][a])
			
			offset = CF_ActOffsets[f][a]
			if offset == nil then
				offset = Vector(0,0)
			end			
			
			--print (actor)
			
			-- Give weapons to non-crab actors
			if actor ~= nil and CF_ActClasses[f][a] ~= "ACrab" then
				for i = 1, CF_MaxItemsPerPreset do 
					if c["Player"..p.."Preset"..pre.."Item"..i] ~= nil then
						
						local w = tonumber(c["Player"..p.."Preset"..pre.."Item"..i])
						local wf = c["Player"..p.."Preset"..pre.."ItemFaction"..i]
						
						weapon = CF_MakeItem(CF_ItmPresets[wf][w], CF_ItmClasses[wf][w], CF_ItmModules[wf][w]);
						--print (weapon)
						
						if weapon ~= nil then
							actor:AddInventoryItem(weapon)
						end
					end
				end
			end
			
			if actor ~= nil then
				-- Set default AI mode
				actor.AIMode = Actor.AIMODE_SENTRY;
				
				if pay then
					CF_SetPlayerGold(c, p, CF_GetPlayerGold(c, p) - price);
				end
			end
		end
	end
	
	return actor, offset;
end
-----------------------------------------------------------------------------------------
-- Spawns dropship loaded with selected presets
-----------------------------------------------------------------------------------------
function CF_SpawnDropShip(c, p, t, pres, pay, team)
	--print ("CF_SpawnDropship");
	local actor = nil;
	local f = CF_GetPlayerFaction(c, p);
	local payloadcount = 0

	-- Calculate dropship capacity
	local dcap = CF_MaxUnitsPerDropship;
	if CF_DropShipCapacityBonuses[f] ~= nil then
		dcap = CF_DropShipCapacityBonuses[f]
	end
	
	if MovableMan:GetMOIDCount() < CF_MOIDLimit then
		actor = CF_MakeActor(CF_Crafts[f] , CF_CraftClasses[f] , CF_CraftModules[f]);

		if actor ~= nil then
			actor.AIMode = Actor.AIMODE_DELIVER;
			actor:SetControllerMode(Controller.CIM_AI, -1);
			actor.Team = team;
			
			-- Create actors and fill dropship with them
			for i = 1, dcap do
				if pres[i] ~= nil then
					local load = CF_MakeActorFromPreset(c, p, t, pres[i], pay)
					
					if load ~= nil then
						-- Add ally mission chip if necessary
						if math.random() < CF_AllyItemProbability and p ~= 0 and team ~= CF_PlayerTeam and c["Player0AllyFaction"] ~= "None" then
							local chip = CreateHeldDevice("Chip", "VoidWanderers.rte");
							if chip ~= nil then
								load:AddInventoryItem(chip)
							end
						end

						load.Team = team;
						load.AIMode = Actor.AIMODE_SENTRY;
						actor:AddInventoryItem(load)
						payloadcount = payloadcount + 1
					
						if actor.MaxMass ~= nil and actor.MaxMass > 0 then
							if actor.Mass >= actor.MaxMass then
								print ("Dropship overloaded, will deliver only "..payloadcount.." units")
								break;
							end
						end
					end
				end
			end
			
			-- Pay for dropship
			if pay then
				CF_SetPlayerGold(c, p, CF_GetPlayerGold(c, p) - CF_CraftPrices[f]);
			end
		end
	end
	
	return actor, payloadcount
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function CF_SpawnRandomInfantry(team , pos , faction , aimode)
	--print ("CF_SpawnRandomInfantry");
	local actor = nil;
	local r1, r2;
	local item;
	
	if MovableMan:GetMOIDCount() < CF_MOIDLimit then
		-- Find AHuman
		local ok = false;
		-- Emergency counter in case we don't have AHumans in factions
		local counter = 0
		
		while (not ok) do
			ok = false;
			r1 = math.random(#CF_ActNames[faction])

			if (CF_ActClasses[faction][r1] == nil or CF_ActClasses[faction][r1] == "AHuman") and CF_ActTypes[faction][r1] ~= CF_ActorTypes.ARMOR then
				ok = true;
			end
			
			-- Break to avoid endless loop
			counter = counter + 1
			if counter > 20 then
				break
			end
		end
	
		actor = CF_MakeActor(CF_ActPresets[faction][r1] , CF_ActClasses[faction][r1], CF_ActModules[faction][r1]);
		
		if actor ~= nil then
			-- Check if this is pre-equipped faction
			local preequipped = false
			
			if CF_PreEquippedActors[faction] ~= nil and CF_PreEquippedActors[faction] then
				preequpped = true
			end			
		
			if not preequipped then
				-- Find rifle
				local ok = false;
				-- Emergency counter in case we don't have AHumans in factions
				local counter = 0
				
				while (not ok) do
					ok = false;
					r2 = math.random(#CF_ItmNames[faction])
			
					if CF_ItmTypes[faction][r2] == CF_WeaponTypes.RIFLE or CF_ItmTypes[faction][r2] == CF_WeaponTypes.SHOTGUN or CF_ItmTypes[faction][r2] == CF_WeaponTypes.SNIPER then
						ok = true;
					end
					
					-- Break to avoid endless loop
					counter = counter + 1
					if counter > 40 then
						break
					end
				end
			
				item = CF_MakeItem(CF_ItmPresets[faction][r2] , CF_ItmClasses[faction][r2], CF_ItmModules[faction][r2]);
				
				if item ~= nil then
					actor:AddInventoryItem(item);
				end
			end
			
			actor.AIMode = aimode;
			actor.Team = team;
			
			if pos ~= nil then
				actor.Pos = pos;
				MovableMan:AddActor(actor);
			else
				return actor
			end
		end
	end
	
	return nil
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
-- Launches new mission script without leaving current activity. Scene is case sensitive.
-----------------------------------------------------------------------------------------
function CF_LaunchMission(scene , script)
	print ("CF_LaunchMission: "..scene.." "..script)
	SCENE_TO_LAUNCH = scene
	SCRIPT_TO_LAUNCH = BASE_PATH..script
	TRANSFER_IN_PROGRESS = true
	
	MovableMan:PurgeAllMOs()
	
	dofile(BASE_PATH.."MissionLauncher.lua")
end
-----------------------------------------------------------------------------------------
-- Restarts activity 
-----------------------------------------------------------------------------------------
function CF_LaunchMissionActivity(activity)
	SCENE_TO_LAUNCH = nil
	SCRIPT_TO_LAUNCH = nil
	TRANSFER_IN_PROGRESS = false
	
	ActivityMan:StartActivity("GAScripted" , activity);
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
	return len;
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
-- Create list of weapons of wtype sorted by their power. c - config, p - player, wtype - weapon type
-----------------------------------------------------------------------------------------
function CF_MakeListOfMostPowerfulWeapons(c, p, wtype)
	local weaps = {};
	local itms, itmfs = CF_MakeListOfAvailableItems(c, p);

	-- Filter needed items
	for i = 1, #itms do
		if CF_ItmTypes[itmfs[i]][itms[i]] == wtype and CF_ItmPowers[itmfs[i]][itms[i]] > 0 then
			local n = #weaps + 1
			weaps[n] = {}
			weaps[n]["Item"] = itms[i]
			weaps[n]["Faction"] = itmfs[i]
			weaps[n]["Power"] = CF_ItmPowers[itmfs[i]][itms[i]]
		end
	end
	
	
	-- Sort them
	for j = 1, #weaps - 1 do
		for i = 1, #weaps - j do
			if weaps[i]["Power"] < weaps[i + 1]["Power"] then
				local temp = weaps[i];
				weaps[i] = weaps[i + 1]
				weaps[i + 1] = temp
			end
		end
	end
	
	if #weaps == 0 then
		return nil
	end
	
	return weaps;
end
-----------------------------------------------------------------------------------------
-- Create list of actors of atype sorted by their power. c - config, p - player, wtype - weapon type
-----------------------------------------------------------------------------------------
function CF_MakeListOfMostPowerfulActors(c, p, atype)
	local acts = {};
	local actors, actfs = CF_MakeListOfAvailableActors(c, p);
	
	-- Filter needed items
	for i = 1, #actors do
		if CF_ActTypes[actfs[i]][actors[i]] == atype and CF_ActPowers[actfs[i]][actors[i]] > 0 then
			local n = #acts + 1
			acts[n] = {}
			acts[n]["Actor"] = actors[i]
			acts[n]["Faction"] = actfs[i]
			acts[n]["Power"] = CF_ActPowers[actfs[i]][actors[i]]
		end
	end
	
	-- Sort them
	for j = 1, #acts - 1 do
		for i = 1, #acts - j do
			if acts[i]["Power"] < acts[i + 1]["Power"] then
				local temp = acts[i];
				acts[i] = acts[i + 1]
				acts[i + 1] = temp
			end
		end
	end
	
	if #acts == 0 then
		return nil
	end
	
	return acts;
end
-----------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------
function CF_MakeListOfAvailableItems(c, p)
	local f = CF_GetPlayerFaction(c, p)
	local itm = {}
	local fact = {}
	
	-- Add player items
	for i = 1, #CF_ItmNames[f] do
		if c["Player".. p .."Item"..i.."Unlocked"] == "True" then
			fact[#itm + 1] = f
			itm[#itm + 1] = i
		end
	end

	-- Add ally items
	if c["Player"..p.."AllyFaction"] ~= "None" then
		local f = CF_GetPlayerAllyFaction(c, p)
		for i = 1, #CF_ItmNames[f] do
			if c["Player".. p .."AllyItem"..i.."Unlocked"] == "True" then
				fact[#itm + 1] = f
				itm[#itm + 1] = i
			end
		end
	end

	-- Add foreign items
	local i = 1
	
	while c["Player"..p.."ForeignItem"..i.."Unlocked"] ~= nil do
		if c["Player"..p.."ForeignItem"..i.."Unlocked"] == "True" then
			fact[#itm + 1] = c["Player".. p .."ForeignItem"..i.."Faction"];
			itm[#itm + 1] = tonumber(c["Player".. p .."ForeignItem"..i.."Preset"])
		end
		i = i + 1
	end
	
	return itm, fact;
end
-----------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------
function CF_MakeListOfAvailableActors(c, p)
	local f = CF_GetPlayerFaction(c, p)
	local act = {}
	local fact = {}
	
	for i = 1, #CF_ActNames[f] do
		if c["Player".. p .."Actor"..i.."Unlocked"] == "True" then
			fact[#act + 1] = f
			act[#act + 1] = i
		end
	end

	if c["Player"..p.."AllyFaction"] ~= "None" then
		local f = CF_GetPlayerAllyFaction(c, p)
		for i = 1, #CF_ActNames[f] do
			if c["Player".. p .."AllyActor"..i.."Unlocked"] == "True" then
				fact[#act + 1] = f
				act[#act + 1] = i
			end
		end
	end

	-- Add foreign items
	local i = 1
	
	while c["Player"..p.."ForeignActor"..i.."Unlocked"] ~= nil do
		if c["Player"..p.."ForeignActor"..i.."Unlocked"] == "True" then
			fact[#act + 1] = c["Player".. p .."ForeignActor"..i.."Faction"];
			act[#act + 1] = tonumber(c["Player".. p .."ForeignActor"..i.."Preset"])
		end
		i = i + 1
	end
	
	return act, fact;
end
-----------------------------------------------------------------------------------------
-- Returns data with preset pr values for player p in config c
-----------------------------------------------------------------------------------------
function CF_GetPreset(c, p, pr)
	local actor = nil;
	local faction = nil;
	local items = {}
	local itemfactions = {}

	if c["Player"..p.."Preset"..pr.."Faction"] ~= nil then
		faction = c["Player"..p.."Preset"..pr.."Faction"];
		actor = tonumber(c["Player"..p.."Preset"..pr.."Actor"]);
	
		for i = 1, CF_MaxItemsPerPreset do
			items[i] = tonumber(c["Player"..p.."Preset"..pr.."Item"..i])
			itemfactions[i] = c["Player"..p.."Preset"..pr.."ItemFaction"..i]
		end
	end
	
	return actor, faction, items, itemfactions
end
-----------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------
function CF_CommitMissionResult(c, result)
	-- Set result
	c["LastMissionResult"] = result
end
-----------------------------------------------------------------------------------------
--	Creates units presets for specified AI where c - config, p - player
-----------------------------------------------------------------------------------------
function CF_CreateAIUnitPresets(c, p)
	--print ("CF_CreateAIUnitPresets "..p)
	-- Presets -            	"Infantry 1", 				"Infantry 2", 			"Sniper", 				"Shotgun", 				"Heavy 1", 				"Heavy 2", 				"Armor 1", 				"Armor 2", 				"Engineer", 			"Defender"
	local desiredactors = 		{CF_ActorTypes.LIGHT, 		CF_ActorTypes.HEAVY, 	CF_ActorTypes.LIGHT, 	CF_ActorTypes.HEAVY, 	CF_ActorTypes.HEAVY, 	CF_ActorTypes.HEAVY, 	CF_ActorTypes.ARMOR, 	CF_ActorTypes.HEAVY, 	CF_ActorTypes.LIGHT, 	CF_ActorTypes.TURRET}

	local desiredweapons = 		{CF_WeaponTypes.RIFLE, 		CF_WeaponTypes.RIFLE, 	CF_WeaponTypes.SNIPER, 	CF_WeaponTypes.SHOTGUN, CF_WeaponTypes.HEAVY, 	CF_WeaponTypes.HEAVY, 	CF_WeaponTypes.HEAVY, 	CF_WeaponTypes.SHIELD, 	CF_WeaponTypes.DIGGER, 	CF_WeaponTypes.SHOTGUN}
	local desiredsecweapons = 	{CF_WeaponTypes.PISTOL, 	CF_WeaponTypes.PISTOL, 	CF_WeaponTypes.PISTOL, 	CF_WeaponTypes.GRENADE,	CF_WeaponTypes.RIFLE, 	CF_WeaponTypes.GRENADE,	CF_WeaponTypes.PISTOL, 	CF_WeaponTypes.PISTOL, 	CF_WeaponTypes.RIFLE, 	CF_WeaponTypes.GRENADE}
	local desiredtretweapons = 	{CF_WeaponTypes.GRENADE, 	CF_WeaponTypes.GRENADE,	CF_WeaponTypes.GRENADE,	CF_WeaponTypes.GRENADE, CF_WeaponTypes.GRENADE, CF_WeaponTypes.GRENADE, CF_WeaponTypes.GRENADE, CF_WeaponTypes.GRENADE, CF_WeaponTypes.GREANDE, CF_WeaponTypes.GRENADE}
	
	local f = CF_GetPlayerFaction(c,p)
	local preequipped = false
	
	if CF_PreEquippedActors[f] ~= nil and CF_PreEquippedActors[f] then
		preequipped = true
	end
	
	if preequipped then
		--print ("Pre-equipped")
		--print ("")

		-- Fill presets for pre-equpped faction
		for i = 1, 10 do
			-- Select a suitable actor based on his equipment class
			local selected = 1
			local match = false;

			local actors
			local lastgoodactors
			
			-- Build a list of desired actors and weapons
			local da = {}
			local dw = {}
			
			da[1] = desiredactors[i]
			dw[1] = desiredweapons[i]
			da[2] = CF_ActorTypes.HEAVY
			dw[2] = desiredweapons[i]
			da[3] = CF_ActorTypes.LIGHT
			dw[3] = desiredweapons[i]
			da[4] = CF_ActorTypes.ARMOR
			dw[4] = desiredweapons[i]
			da[5] = CF_ActorTypes.HEAVY
			dw[5] = nil
			da[6] = CF_ActorTypes.LIGHT
			dw[6] = nil
			da[7] = CF_ActorTypes.ARMOR
			dw[7] = nil

			for k = 1, #da do
				actors = CF_MakeListOfMostPowerfulActors(c, p, da[k])
				
				if actors ~= nil and dw[k] ~= nil then
					for j = 1, #actors do
						if CF_EquipmentTypes[f][ actors[j]["Actor"] ] ~= nil then
							if CF_EquipmentTypes[f][ actors[j]["Actor"] ] == dw[k] then
								selected = j
								match = true
								break
							end
						end
					end
				end
				
				if match then
					break
				end
				
				if actors ~= nil then
					lastgoodactors = actors
				end
			end
			
			if actors == nil then
				actors = lastgoodactors
			end
			
			if actors ~= nil then
				c["Player"..p.."Preset"..i.."Actor"] = actors[selected]["Actor"];
				c["Player"..p.."Preset"..i.."Faction"] = actors[selected]["Faction"];

				--Reset all weapons
				for j = 1, CF_MaxItemsPerPreset do
					c["Player"..p.."Preset"..i.."Item"..j] = nil
					c["Player"..p.."Preset"..i.."ItemFaction"..j] = nil
				end
				
				-- If we didn't find a suitable engineer unit then try give digger to engineer preset
				if desiredweapons[i] == CF_WeaponTypes.DIGGER and not match then
					local weapons1
					weapons1 = CF_MakeListOfMostPowerfulWeapons(c, p, desiredweapons[i])
				
					local class = CF_ActClasses[actors[selected]["Faction"]][actors[selected]["Actor"]]
					-- Don't give weapons to ACrabs
					if class ~= "ACrab" then
						if weapons1 ~= nil then
							c["Player"..p.."Preset"..i.."Item"..1] = weapons1[1]["Item"];
							c["Player"..p.."Preset"..i.."ItemFaction"..1] = weapons1[1]["Faction"];
							--print (CF_PresetNames[i].." + Digger")
						end
					end
				end
				
				--print(CF_PresetNames[i].." "..CF_ActPresets[c["Player"..p.."Preset"..i.."Faction"]][c["Player"..p.."Preset"..i.."Actor"]] .." "..tostring(match))
				--print(c["Player"..p.."Preset"..i.."Item1"])
				--print(c["Player"..p.."Preset"..i.."Item2"])
				--print(c["Player"..p.."Preset"..i.."Item3"])
			end	
		end
	else
		--print ("Empty actors")

		-- Fill presets for generic faction
		for i = 1, 10 do
			local actors
			actors = CF_MakeListOfMostPowerfulActors(c, p, desiredactors[i])
			
			if actors == nil then
				actors = CF_MakeListOfMostPowerfulActors(c, p, CF_ActorTypes.LIGHT)
			end

			if actors == nil then
				actors = CF_MakeListOfMostPowerfulActors(c, p, CF_ActorTypes.HEAVY)
			end

			if actors == nil then
				actors = CF_MakeListOfMostPowerfulActors(c, p, CF_ActorTypes.ARMOR)
			end
			
			local weapons1
			weapons1 = CF_MakeListOfMostPowerfulWeapons(c, p, desiredweapons[i])

			if weapons1 == nil then
				weapons1 = CF_MakeListOfMostPowerfulWeapons(c, p, CF_WeaponTypes.RIFLE)
			end

			if weapons1 == nil then
				weapons1 = CF_MakeListOfMostPowerfulWeapons(c, p, CF_WeaponTypes.SHOTGUN)
			end

			if weapons1 == nil then
				weapons1 = CF_MakeListOfMostPowerfulWeapons(c, p, CF_WeaponTypes.SNIPER)
			end
			
			if weapons1 == nil then
				weapons1 = CF_MakeListOfMostPowerfulWeapons(c, p, CF_WeaponTypes.HEAVY)
			end
			
			if weapons1 == nil then
				weapons1 = CF_MakeListOfMostPowerfulWeapons(c, p, CF_WeaponTypes.PISTOL)
			end


			local weapons2
			weapons2 = CF_MakeListOfMostPowerfulWeapons(c, p, desiredsecweapons[i])

			if weapons2 == nil then
				weapons2 = CF_MakeListOfMostPowerfulWeapons(c, p, CF_WeaponTypes.PISTOL)
			end

			if weapons2 == nil then
				weapons2 = CF_MakeListOfMostPowerfulWeapons(c, p, CF_WeaponTypes.DIGGER)
			end

			local weapons3
			weapons3 = CF_MakeListOfMostPowerfulWeapons(c, p, desiredtretweapons[i])
			
			if actors ~= nil then
				c["Player"..p.."Preset"..i.."Actor"] = actors[1]["Actor"];
				c["Player"..p.."Preset"..i.."Faction"] = actors[1]["Faction"];
				
				local class = CF_ActClasses[actors[1]["Faction"]][actors[1]["Actor"]]
				
				-- Don't give weapons to ACrabs
				if class ~= "ACrab" then
					local weap = 1
					
					if weapons1 ~= nil then
						-- Add small random spread for primary weapons
						local spread = 2;
					
						if #weapons1 < spread then
							spread = 1;
						end
						
						local w = math.random(spread)
						--print ("Selected weapon: "..w)
					
						c["Player"..p.."Preset"..i.."Item"..weap] = weapons1[w]["Item"];
						c["Player"..p.."Preset"..i.."ItemFaction"..weap] = weapons1[w]["Faction"];
						weap = weap + 1
					end
					
					if weapons2 ~= nil then
						-- Add small random spread for secondary weapons
						local spread = 2;
					
						if #weapons2 < spread then
							spread = 1;
						end
						
						local w = math.random(spread)
						--print ("Selected sec weapon: "..w)

						c["Player"..p.."Preset"..i.."Item"..weap] = weapons2[w]["Item"];
						c["Player"..p.."Preset"..i.."ItemFaction"..weap] = weapons2[w]["Faction"];
						weap = weap + 1
					end

					if weapons3 ~= nil then
						-- Add small random spread for grenades
						local spread = 2;
					
						if #weapons3 < spread then
							spread = 1;
						end
						
						local w = math.random(spread)
						--print ("Selected tri weapon: "..w)

						c["Player"..p.."Preset"..i.."Item"..weap] = weapons3[w]["Item"];
						c["Player"..p.."Preset"..i.."ItemFaction"..weap] = weapons3[w]["Faction"];
						weap = weap + 1
					end
					
					if CF_AIDebugOutput then
						--print ("------")
						--print(CF_ActPresets[c["Player"..p.."Preset"..i.."Faction"]][c["Player"..p.."Preset"..i.."Actor"]])
						--print(CF_ItmPresets[c["Player"..p.."Preset"..i.."ItemFaction1"]][c["Player"..p.."Preset"..i.."Item1"]])
						--print(CF_ItmPresets[c["Player"..p.."Preset"..i.."ItemFaction2"]][c["Player"..p.."Preset"..i.."Item2"]])
						--print(CF_ItmPresets[c["Player"..p.."Preset"..i.."ItemFaction3"]][c["Player"..p.."Preset"..i.."Item3"]])
					end
				end
			end
		end
	end -- If preequipped
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
					inventory[#inventory + 1] = human.EquippedItem.PresetName;
					classes[#classes + 1] = human.EquippedItem.ClassName;
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
					inventory[#inventory + 1] = weap.PresetName;
					classes[#classes + 1] = weap.ClassName;
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
-----------------------------------------------------------------------------
--
-----------------------------------------------------------------------------




















