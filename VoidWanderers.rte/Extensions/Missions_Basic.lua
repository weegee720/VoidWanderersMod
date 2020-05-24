--	Mission description
local id = "Assault"
CF_Mission[#CF_Mission + 1] = id

CF_MissionName[id] = "Assault"
CF_MissionScript[id] = ""
CF_MissionMinReputation[id] = 0
CF_MissionBriefingText[id] = ""
CF_MissionMaxSets[id] = 6
CF_MissionRequiredData[id] = {}

local i = 1
CF_MissionRequiredData[id][i] = {}
CF_MissionRequiredData[id][i]["Name"] = "EnemyAny"
CF_MissionRequiredData[id][i]["Type"] = "Vector"
CF_MissionRequiredData[id][i]["Max"] = 12

local i = 2
CF_MissionRequiredData[id][i] = {}
CF_MissionRequiredData[id][i]["Name"] = "EnemyRifle"
CF_MissionRequiredData[id][i]["Type"] = "Vector"
CF_MissionRequiredData[id][i]["Max"] = 8

local i = 3
CF_MissionRequiredData[id][i] = {}
CF_MissionRequiredData[id][i]["Name"] = "EnemyHeavy"
CF_MissionRequiredData[id][i]["Type"] = "Vector"
CF_MissionRequiredData[id][i]["Max"] = 4

local i = 4
CF_MissionRequiredData[id][i] = {}
CF_MissionRequiredData[id][i]["Name"] = "EnemyShotgun"
CF_MissionRequiredData[id][i]["Type"] = "Vector"
CF_MissionRequiredData[id][i]["Max"] = 4

local i = 5
CF_MissionRequiredData[id][i] = {}
CF_MissionRequiredData[id][i]["Name"] = "EnemyDefender"
CF_MissionRequiredData[id][i]["Type"] = "Vector"
CF_MissionRequiredData[id][i]["Max"] = 4

local i = 6
CF_MissionRequiredData[id][i] = {}
CF_MissionRequiredData[id][i]["Name"] = "EnemyArmor"
CF_MissionRequiredData[id][i]["Type"] = "Vector"
CF_MissionRequiredData[id][i]["Max"] = 4

local i = 7
CF_MissionRequiredData[id][i] = {}
CF_MissionRequiredData[id][i]["Name"] = "EnemySniper"
CF_MissionRequiredData[id][i]["Type"] = "Vector"
CF_MissionRequiredData[id][i]["Max"] = 4

local i = 8
CF_MissionRequiredData[id][i] = {}
CF_MissionRequiredData[id][i]["Name"] = "ClearArea"
CF_MissionRequiredData[id][i]["Type"] = "Box"
CF_MissionRequiredData[id][i]["Max"] = 1