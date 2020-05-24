--	Mission description
-- 	Uses generic 'Enemy' data to place enemies
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
CF_MissionRequiredData[id][i]["Name"] = id.."_ClearAreaLeftCorner"
CF_MissionRequiredData[id][i]["Max"] = 4

local i = 2
CF_MissionRequiredData[id][i] = {}
CF_MissionRequiredData[id][i]["Name"] = id.."_ClearAreaRightCorner"
CF_MissionRequiredData[id][i]["Max"] = 4