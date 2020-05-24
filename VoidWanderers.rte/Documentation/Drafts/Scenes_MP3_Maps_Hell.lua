-- Integrity checks
local extension = "Scenes_MP3_Maps_Hell" 
local modules = {"Maps - Hell.rte"}

for m = 1, #modules do
	if PresetMan:GetModuleID(modules[m]) == -1 then
		error (extension..": ".."Can't  load module - "..modules[m])
	end
end

-- Define planet
local id = "MP3-GTC-HLL"
CF_Planet[#CF_Planet + 1] = id
CF_PlanetName[id] = "MP3-GTC-HLL"
CF_PlanetGlow[id] = "MP3-GTC-HLL"
CF_PlanetPos[id] = Vector(-60 , 4)
CF_PlanetGlowModule[id] = "VoidWanderers.rte"

-- Planet locations
local id = "The Pit"
CF_Location[#CF_Location + 1] = id
CF_LocationName[id] = "The Pit"
CF_LocationPos[id] = Vector(-16 , 37)
CF_LocationDescription[id] = ""
CF_LocationSecurity[id] = 0
CF_LocationGoldPresent[id] = true
CF_LocationScenes[id] = {"The Pit"}
CF_LocationPlanet[id] = "MP3-GTC-HLL"
CF_LocationMissions[id] = {"Assault", "Assassinate", "Dropships"}

local id = "Limbo"
CF_Location[#CF_Location + 1] = id
CF_LocationName[id] = "Limbo"
CF_LocationPos[id] = Vector(-3 , 9)
CF_LocationDescription[id] = ""
CF_LocationSecurity[id] = 0
CF_LocationGoldPresent[id] = true
CF_LocationScenes[id] = {"Limbo"}
CF_LocationPlanet[id] = "MP3-GTC-HLL"
CF_LocationMissions[id] = {"Assault", "Assassinate", "Dropships"}

local id = "Furnace"
CF_Location[#CF_Location + 1] = id
CF_LocationName[id] = "Furnace"
CF_LocationPos[id] = Vector(35 , -24)
CF_LocationDescription[id] = ""
CF_LocationSecurity[id] = 0
CF_LocationGoldPresent[id] = true
CF_LocationScenes[id] = {"Furnace"}
CF_LocationPlanet[id] = "MP3-GTC-HLL"
CF_LocationMissions[id] = {"Assault", "Assassinate", "Dropships"}
