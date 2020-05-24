--[[
	Novamind by p3lbox
	http://forums.datarealms.com/viewtopic.php?f=61&t=16238
	Supported out of the box
]]--

-- Integrity checks
local extension = "Artifact_Novamind" 
local modules = {"NovaMind.rte"}

for m = 1, #modules do
	if PresetMan:GetModuleID(modules[m]) == -1 then
		error (extension..": ".."Can't  load module - "..modules[m])
	end
end

-- Add items
local id = #CF_ArtItmPresets + 1
CF_ArtItmPresets[id] = "Johnson Railgun"
CF_ArtItmModules[id] = "NovaMind.rte"
CF_ArtItmClasses[id] = "HDFirearm"

local id = #CF_ArtItmPresets + 1
CF_ArtItmPresets[id] = "SN-15"
CF_ArtItmModules[id] = "NovaMind.rte"
CF_ArtItmClasses[id] = "HDFirearm"

local id = #CF_ArtItmPresets + 1
CF_ArtItmPresets[id] = "Garrett LMG"
CF_ArtItmModules[id] = "NovaMind.rte"
CF_ArtItmClasses[id] = "HDFirearm"

-- Add actors
local id = #CF_ArtActPresets + 1
CF_ArtActPresets[id] = "NovaMind Light"
CF_ArtActModules[id] = "NovaMind.rte"
CF_ArtActClasses[id] = "AHuman"

local id = #CF_ArtActPresets + 1
CF_ArtActPresets[id] = "Nova Mind Medium"
CF_ArtActModules[id] = "NovaMind.rte"
CF_ArtActClasses[id] = "AHuman"