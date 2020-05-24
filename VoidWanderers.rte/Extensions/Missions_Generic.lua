-- DEPLOY MISSION IS ESSENTIAL!!! NEVER TURN IT OFF!!!
-- It is used by scene editor to put deployment, ambient enemies and crates marks
local id = "Deploy"
CF_Mission[#CF_Mission + 1] = id

CF_MissionName[id] = "Deploy"
CF_MissionScript[id] = ""
CF_MissionMinReputation[id] = 0
CF_MissionBriefingText[id] = ""
CF_MissionMaxSets[id] = 1
CF_MissionRequiredData[id] = {}

local i = 1
CF_MissionRequiredData[id][i] = {}
CF_MissionRequiredData[id][i]["Name"] = "PlayerLZ"
CF_MissionRequiredData[id][i]["Type"] = "Vector"
CF_MissionRequiredData[id][i]["Max"] = 8

local i = 2
CF_MissionRequiredData[id][i] = {}
CF_MissionRequiredData[id][i]["Name"] = "EnemyLZ"
CF_MissionRequiredData[id][i]["Type"] = "Vector"
CF_MissionRequiredData[id][i]["Max"] = 8

local i = 3
CF_MissionRequiredData[id][i] = {}
CF_MissionRequiredData[id][i]["Name"] = "PlayerUnit"
CF_MissionRequiredData[id][i]["Type"] = "Vector"
CF_MissionRequiredData[id][i]["Max"] = 16

local i = 4
CF_MissionRequiredData[id][i] = {}
CF_MissionRequiredData[id][i]["Name"] = "AmbientEnemy"
CF_MissionRequiredData[id][i]["Type"] = "Vector"
CF_MissionRequiredData[id][i]["Max"] = 16

local i = 5
CF_MissionRequiredData[id][i] = {}
CF_MissionRequiredData[id][i]["Name"] = "Crates"
CF_MissionRequiredData[id][i]["Type"] = "Vector"
CF_MissionRequiredData[id][i]["Max"] = 16


local id = "Enemy"
CF_Mission[#CF_Mission + 1] = id

CF_MissionName[id] = "Enemy"
CF_MissionScript[id] = ""
CF_MissionMinReputation[id] = 0
CF_MissionBriefingText[id] = ""
CF_MissionMaxSets[id] = 6
CF_MissionRequiredData[id] = {}

local i = 1
CF_MissionRequiredData[id][i] = {}
CF_MissionRequiredData[id][i]["Name"] = "Any"
CF_MissionRequiredData[id][i]["Type"] = "Vector"
CF_MissionRequiredData[id][i]["Max"] = 12

local i = 2
CF_MissionRequiredData[id][i] = {}
CF_MissionRequiredData[id][i]["Name"] = "Rifle"
CF_MissionRequiredData[id][i]["Type"] = "Vector"
CF_MissionRequiredData[id][i]["Max"] = 6

local i = 3
CF_MissionRequiredData[id][i] = {}
CF_MissionRequiredData[id][i]["Name"] = "Heavy"
CF_MissionRequiredData[id][i]["Type"] = "Vector"
CF_MissionRequiredData[id][i]["Max"] = 4

local i = 4
CF_MissionRequiredData[id][i] = {}
CF_MissionRequiredData[id][i]["Name"] = "Shotgun"
CF_MissionRequiredData[id][i]["Type"] = "Vector"
CF_MissionRequiredData[id][i]["Max"] = 4

local i = 5
CF_MissionRequiredData[id][i] = {}
CF_MissionRequiredData[id][i]["Name"] = "Defender"
CF_MissionRequiredData[id][i]["Type"] = "Vector"
CF_MissionRequiredData[id][i]["Max"] = 4

local i = 6
CF_MissionRequiredData[id][i] = {}
CF_MissionRequiredData[id][i]["Name"] = "Armor"
CF_MissionRequiredData[id][i]["Type"] = "Vector"
CF_MissionRequiredData[id][i]["Max"] = 4

local i = 7
CF_MissionRequiredData[id][i] = {}
CF_MissionRequiredData[id][i]["Name"] = "Sniper"
CF_MissionRequiredData[id][i]["Type"] = "Vector"
CF_MissionRequiredData[id][i]["Max"] = 4

local i = 8
CF_MissionRequiredData[id][i] = {}
CF_MissionRequiredData[id][i]["Name"] = "Base"
CF_MissionRequiredData[id][i]["Type"] = "Box"
CF_MissionRequiredData[id][i]["Max"] = 16

CF_GenericMissionCount = #CF_Mission