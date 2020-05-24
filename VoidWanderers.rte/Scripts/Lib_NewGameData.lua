-----------------------------------------------------------------------------------------
-- Initializes all game data when new game started and returns new config
-----------------------------------------------------------------------------------------
function CF_MakeNewConfig(difficulty, f, cpus)
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
		
	elseif difficulty <= GameActivity.EASYDIFFICULTY then
		PositiveIndex = 1.25;
		NegativeIndex = 0.75;
		
	elseif difficulty <= GameActivity.MEDIUMDIFFICULTY then
		PositiveIndex = 1.0;
		NegativeIndex = 1.0;
		
	elseif difficulty <= GameActivity.HARDDIFFICULTY then
		PositiveIndex = 0.85;
		NegativeIndex = 1.15;	
		
	elseif difficulty <= GameActivity.NUTSDIFFICULTY then
		PositiveIndex = 0.70;
		NegativeIndex = 1.3;
		
	elseif difficulty <= GameActivity.MAXDIFFICULTY then
		PositiveIndex = 0.55;
		NegativeIndex = 1.45;
		
	end			
	
	config["PositiveIndex"] = PositiveIndex
	config["NegativeIndex"] = NegativeIndex
	
	-- Set up players
	config["Player0Faction"] = f
	config["Player0Active"] = "True"
	config["Player0Type"] = "Player"
	config["Player0Gold"] = math.floor(4000 * PositiveIndex)
	
	-- Assign player ship
	config["Player0Vessel"] = "Gryphon"
	
	-- Set vessel attrs
	config["Player0VesselStorageCapacity"] = CF_VesselStartStorageCapacity[ config["Player0Vessel"] ]
	
	-- Set up initial location - Tradestar
	config["Planet"] = CF_Planet[1]
	config["Location"] = CF_Location[1]
	
	local found = 0
	
	-- Find available player actor
	for i = 1, #CF_ActNames[f] do
		if CF_ActUnlockData[f][i] == 0 then
			found = i
			break;
		end
	end

	-- Find available player weapon
	local weaps = {}
	
	-- Find available player items
	for i = 1, #CF_ItmNames[f] do
		if CF_ItmUnlockData[f][i] == 0 then
			weaps[#weaps + 1] = i
		end
	end
	
	-- DEBUG Add all available weapons
	--local weaps = {}
	--for i = 1, #CF_ItmNames[f] do
	--	weaps[#weaps + 1] = i
	--end
	
	-- Assign initial player actors in storage
	--[[for i = 1, 4 do
		config["CloneStorage"..i.."Preset"] = CF_ActPresets[f][found]
		config["CloneStorage"..i.."Class"] = CF_ActClasses[f][found]
		
		local slt = 1
		for j = #weaps, 1 , -1 do
			config[ "CloneStorage"..i.."Item"..slt.."Preset"] = CF_ItmPresets[f][weaps[j] ]
			config[ "CloneStorage"..i.."Item"..slt.."Class"] = CF_ItmClasses[f][weaps[j] ]
			slt = slt + 1
		end
	end]]--
	
	-- Put some weapons to ship storage
	local slt = 1
	
	for j = #weaps, 1 , -1 do
		config["ItemStorage"..slt.."Preset"] = CF_ItmPresets[f][weaps[j]]
		config["ItemStorage"..slt.."Class"] = CF_ItmClasses[f][weaps[j]]
		config["ItemStorage"..slt.."Count"] = 4
		slt = slt + 1
	end

	-- Create initial player actors in cockpit
	--[[for i = 1, 4 do
		config["PlayerActor"..i.."Preset"] = CF_ActPresets[f][found]
		config["PlayerActor"..i.."Class"] = CF_ActClasses[f][found]
		
		local slt = 1
		for j = #weaps, 1 , -1 do
			config[ "PlayerActor"..i.."Item"..slt.."Preset"] = CF_ItmPresets[f][weaps[j] ]
			config[ "PlayerActor"..i.."Item"..slt.."Class"] = CF_ItmClasses[f][weaps[j] ]
			slt = slt + 1
		end
	end]]--
	
	-- Set initial scene
	config["Scene"] = CF_VesselScene[config["Player0Vessel"]]
	
	-- Set initial scene type
	config["SceneType"] = "Vessel"

	-- Set operation mode
	config["Mode"] = "Vessel"

	
	for i = 1, CF_MaxCPUPlayers do
		if cpus[i] then
			config["Player".. i .."Faction"] = cpus[i]
			config["Player".. i .."Active"] = "True"
			config["Player".. i .."Type"] = "CPU"
		else
			config["Player".. i .."Faction"] = "Nobody"
			config["Player".. i .."Active"] = "False"
			config["Player".. i .."Type"] = "None"
		end
	end
	
	return config;
end
-----------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------
































