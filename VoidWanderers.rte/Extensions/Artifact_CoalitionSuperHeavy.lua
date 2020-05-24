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
local id = #CF_ArtActPresets + 1
CF_ArtActPresets[id] = "Soldier SuperHeavy"
CF_ArtActModules[id] = "CoalitionHeavy.rte"
CF_ArtActClasses[id] = "AHuman"
