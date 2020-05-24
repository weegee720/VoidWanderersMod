--	Mission description
local id = "Assault"
CF_Mission[#CF_Mission + 1] = id

CF_MissionName[id] = "Assault"
CF_Script[id] = ""
CF_MinReputation[id] = 0
CF_BriefingText[id] = ""
CF_RequiredData[id] = {}

local i = 1
CF_RequiredData[id][i] = {}
CF_RequiredData[id][i]["Name"] = "EnemyAny"
CF_RequiredData[id][i]["Type"] = "Vector"
CF_RequiredData[id][i]["Max"] = 12

local i = 2
CF_RequiredData[id][i] = {}
CF_RequiredData[id][i]["Name"] = "EnemyRifle"
CF_RequiredData[id][i]["Type"] = "Vector"
CF_RequiredData[id][i]["Max"] = 8

local i = 3
CF_RequiredData[id][i] = {}
CF_RequiredData[id][i]["Name"] = "EnemyHeavy"
CF_RequiredData[id][i]["Type"] = "Vector"
CF_RequiredData[id][i]["Max"] = 4

local i = 4
CF_RequiredData[id][i] = {}
CF_RequiredData[id][i]["Name"] = "EnemyShotgun"
CF_RequiredData[id][i]["Type"] = "Vector"
CF_RequiredData[id][i]["Max"] = 4

local i = 5
CF_RequiredData[id][i] = {}
CF_RequiredData[id][i]["Name"] = "EnemyDefender"
CF_RequiredData[id][i]["Type"] = "Vector"
CF_RequiredData[id][i]["Max"] = 4

local i = 6
CF_RequiredData[id][i] = {}
CF_RequiredData[id][i]["Name"] = "EnemyArmor"
CF_RequiredData[id][i]["Type"] = "Vector"
CF_RequiredData[id][i]["Max"] = 4

local i = 7
CF_RequiredData[id][i] = {}
CF_RequiredData[id][i]["Name"] = "EnemySniper"
CF_RequiredData[id][i]["Type"] = "Vector"
CF_RequiredData[id][i]["Max"] = 4

local i = 8
CF_RequiredData[id][i] = {}
CF_RequiredData[id][i]["Name"] = "ClearArea"
CF_RequiredData[id][i]["Type"] = "Box"
CF_RequiredData[id][i]["Max"] = 1