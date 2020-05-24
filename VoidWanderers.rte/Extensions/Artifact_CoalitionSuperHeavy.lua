--[[
	The Coalition SuperHeavy by ryry1237
	http://forums.datarealms.com/viewtopic.php?f=61&t=29649
	Supported out of the box
]]--

-- Integrity checks
local extension = "Artifact_CoalitionSuperheavy" 
local modules = {"CoalitionHeavy.rte"}

for m = 1, #modules do
	if PresetMan:GetModuleID(modules[m]) == -1 then
		error (extension..": ".."Can't  load module - "..modules[m])
	end
end

-- Add actors
--local id = #CF_ArtActPresets + 1
--CF_ArtActPresets[id] = "Soldier SuperHeavy"
--CF_ArtActModules[id] = "CoalitionHeavy.rte"
--CF_ArtActClasses[id] = "AHuman"

-- Add coalition unit to coalition faction
local factionid = "Coalition";
i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Soldier SuperHeavy"
CF_ActPresets[factionid][i] = "Soldier SuperHeavy"
CF_ActModules[factionid][i] = "CoalitionHeavy.rte"
CF_ActPrices[factionid][i] = 260
CF_ActDescriptions[factionid][i] = "Elite Coalition soldier equipped in full armor plating and outfitted with a reinforced metal helmet. Extra powerful jetpack also comes attached for better maneuverability."
CF_ActUnlockData[factionid][i] = 2750
CF_ActTypes[factionid][i] = CF_ActorTypes.HEAVY;
CF_ActPowers[factionid][i] = 8
