--	Mission description
-- 	Uses generic 'Enemy' data to place enemies
local id = "Assault"
CF_Mission[#CF_Mission + 1] = id

CF_MissionName[id] = "Assault"
CF_MissionScript[id] = "VoidWanderers.rte/Scripts/Mission_Assault.lua"
CF_MissionMinReputation[id] = -10000 -- This mission is always available
CF_MissionBriefingText[id] = "Attack the enemy installation and wipe out any enemy forces."
CF_MissionGoldRewardPerDifficulty[id] = 0
CF_MissionReputationRewardPerDifficulty[id] = 20
CF_MissionMaxSets[id] = 6
CF_MissionRequiredData[id] = {}
