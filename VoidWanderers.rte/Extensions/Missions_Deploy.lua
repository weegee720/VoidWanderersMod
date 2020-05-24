-- DEPLOY MISSION IS ESSENTIAL!!! NEVER TURN IT OFF!!!
-- It is used by scene editor to put deployment, ambient enemies and crates marks
local id = "Deploy"
CF_Mission[#CF_Mission + 1] = id

CF_MissionName[id] = "Deploy"
CF_Script[id] = ""
CF_MinReputation[id] = 0
CF_BriefingText[id] = ""
CF_RequiredData[id] = {}

local i = 1
CF_RequiredData[id][i] = {}
CF_RequiredData[id][i]["Name"] = "PlayerLZ"
CF_RequiredData[id][i]["Type"] = "Vector"
CF_RequiredData[id][i]["Max"] = 8

local i = 2
CF_RequiredData[id][i] = {}
CF_RequiredData[id][i]["Name"] = "AmbientEnemy"
CF_RequiredData[id][i]["Type"] = "Vector"
CF_RequiredData[id][i]["Max"] = 16

local i = 3
CF_RequiredData[id][i] = {}
CF_RequiredData[id][i]["Name"] = "Crates"
CF_RequiredData[id][i]["Type"] = "Vector"
CF_RequiredData[id][i]["Max"] = 16