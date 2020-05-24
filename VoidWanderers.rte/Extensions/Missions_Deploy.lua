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
CF_MissionRequiredData[id][i]["Name"] = "AmbientEnemy"
CF_MissionRequiredData[id][i]["Type"] = "Vector"
CF_MissionRequiredData[id][i]["Max"] = 16

local i = 3
CF_MissionRequiredData[id][i] = {}
CF_MissionRequiredData[id][i]["Name"] = "Crates"
CF_MissionRequiredData[id][i]["Type"] = "Vector"
CF_MissionRequiredData[id][i]["Max"] = 16