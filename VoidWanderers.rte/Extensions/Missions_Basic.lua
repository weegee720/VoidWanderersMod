-- Uses: Enemy
local id = "Assault"
CF_Mission[#CF_Mission + 1] = id

CF_MissionName[id] = "Assault"
CF_MissionScript[id] = "VoidWanderers.rte/Scripts/Mission_Assault.lua"
CF_MissionMinReputation[id] = -10000 -- This mission is always available
CF_MissionBriefingText[id] = "Attack the enemy installation and wipe out any enemy forces."
CF_MissionGoldRewardPerDifficulty[id] = 0
CF_MissionReputationRewardPerDifficulty[id] = 75
CF_MissionMaxSets[id] = 6
CF_MissionRequiredData[id] = {}

-- Uses: Enemy, Asassinate
local id = "Assassinate"
CF_Mission[#CF_Mission + 1] = id

CF_MissionName[id] = "Assassinate"
CF_MissionScript[id] = "VoidWanderers.rte/Scripts/Mission_Assassinate.lua"
CF_MissionMinReputation[id] = 0
CF_MissionBriefingText[id] = "Locate and assassinate enemy commander."
CF_MissionGoldRewardPerDifficulty[id] = 750
CF_MissionReputationRewardPerDifficulty[id] = 50
CF_MissionMaxSets[id] = 6
CF_MissionRequiredData[id] = {}

local i = 1
CF_MissionRequiredData[id][i] = {}
CF_MissionRequiredData[id][i]["Name"] = "Commander"
CF_MissionRequiredData[id][i]["Type"] = "Vector"
CF_MissionRequiredData[id][i]["Max"] = 4


-- Uses: Enemy, Mine
local id = "Mine"
CF_Mission[#CF_Mission + 1] = id

CF_MissionName[id] = "Establish Mining"
CF_MissionScript[id] = "VoidWanderers.rte/Scripts/Mission_Mine.lua"
CF_MissionMinReputation[id] = 1000
CF_MissionBriefingText[id] = "Establish mining camp and protect enough miners from enemy."
CF_MissionGoldRewardPerDifficulty[id] = 0
CF_MissionReputationRewardPerDifficulty[id] = 150
CF_MissionMaxSets[id] = 6
CF_MissionRequiredData[id] = {}

local i = 1
CF_MissionRequiredData[id][i] = {}
CF_MissionRequiredData[id][i]["Name"] = "Miners"
CF_MissionRequiredData[id][i]["Type"] = "Vector"
CF_MissionRequiredData[id][i]["Max"] = 6

local i = 2
CF_MissionRequiredData[id][i] = {}
CF_MissionRequiredData[id][i]["Name"] = "MinerSentries"
CF_MissionRequiredData[id][i]["Type"] = "Vector"
CF_MissionRequiredData[id][i]["Max"] = 6

local i = 3
CF_MissionRequiredData[id][i] = {}
CF_MissionRequiredData[id][i]["Name"] = "MinerLZ"
CF_MissionRequiredData[id][i]["Type"] = "Vector"
CF_MissionRequiredData[id][i]["Max"] = 6


-- Uses: Enemy, Mine
local id = "Dropships"
CF_Mission[#CF_Mission + 1] = id

CF_MissionName[id] = "Disrupt Mining"
CF_MissionScript[id] = "VoidWanderers.rte/Scripts/Mission_Dropships.lua"
CF_MissionMinReputation[id] = 600
CF_MissionBriefingText[id] = "Disrupt enemy mining operations and destroy all incoming dropships."
CF_MissionGoldRewardPerDifficulty[id] = 1000
CF_MissionReputationRewardPerDifficulty[id] = 175
CF_MissionMaxSets[id] = 6
CF_MissionRequiredData[id] = {}

-- Uses: Zombies
local id = "Zombies"
CF_Mission[#CF_Mission + 1] = id

CF_MissionName[id] = "Zombie onslaught"
CF_MissionScript[id] = "VoidWanderers.rte/Scripts/Mission_Zombies.lua"
CF_MissionMinReputation[id] = 800
CF_MissionBriefingText[id] = "Destroy hacked cloning vats producing agressive unbacked bodies."
CF_MissionGoldRewardPerDifficulty[id] = 950
CF_MissionReputationRewardPerDifficulty[id] = 130
CF_MissionMaxSets[id] = 6
CF_MissionRequiredData[id] = {}

local i = 1
CF_MissionRequiredData[id][i] = {}
CF_MissionRequiredData[id][i]["Name"] = "Vat"
CF_MissionRequiredData[id][i]["Type"] = "Vector"
CF_MissionRequiredData[id][i]["Max"] = 8

