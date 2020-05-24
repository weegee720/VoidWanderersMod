-- Integrity checks
local extension = "Scenes_MP3_Maps_City" 
local modules = {"Maps - City.rte"}

for m = 1, #modules do
	if PresetMan:GetModuleID(modules[m]) == -1 then
		error (extension..": ".."Can't  load module - "..modules[m])
	end
end

-- Define planet
local id = "MP3-GTC-CTY"
CF_Planet[#CF_Planet + 1] = id
CF_PlanetName[id] = "MP3-GTC-CTY"
CF_PlanetGlow[id] = "MP3-GTC-CTY"
CF_PlanetPos[id] = Vector(-15 , 15)
CF_PlanetGlowModule[id] = "VoidWanderers.rte"

-- Planet locations
local id = "Suburbs"
CF_Location[#CF_Location + 1] = id
CF_LocationName[id] = "Suburbs"
CF_LocationPos[id] = Vector(27 , 22)
CF_LocationRemoveDoors[id] = true
CF_LocationDescription[id] = ""
CF_LocationSecurity[id] = 10
CF_LocationGoldPresent[id] = true
CF_LocationScenes[id] = {"Suburbs"}
CF_LocationPlanet[id] = "MP3-GTC-CTY"
CF_LocationMissions[id] = {"Assault", "Assassinate", "Dropships", "Mine", "Zombies"}

-- Enable only if MP3 patch installed
-- Will crash the game due to Brain Deployments if MP3 is not patched
--[[local id = "Tenements"
CF_Location[#CF_Location + 1] = id
CF_LocationName[id] = "Tenements"
CF_LocationPos[id] = Vector(-2 , 54)
CF_LocationRemoveDoors[id] = true
CF_LocationDescription[id] = ""
CF_LocationSecurity[id] = 0
CF_LocationGoldPresent[id] = true
CF_LocationScenes[id] = {"Tenements"}
CF_LocationPlanet[id] = "MP3-GTC-CTY"
CF_LocationMissions[id] = {"Assault", "Assassinate", "Dropships", "Mine", "Zombies"}

local id = "Towers"
CF_Location[#CF_Location + 1] = id
CF_LocationName[id] = "Towers"
CF_LocationPos[id] = Vector(-24 , -28)
CF_LocationRemoveDoors[id] = true
CF_LocationDescription[id] = ""
CF_LocationSecurity[id] = 0
CF_LocationGoldPresent[id] = true
CF_LocationScenes[id] = {"Towers"}
CF_LocationPlanet[id] = "MP3-GTC-CTY"
CF_LocationMissions[id] = {"Assault", "Assassinate", "Dropships", "Mine", "Zombies"}--]]--

local id = "City Prison"
CF_Location[#CF_Location + 1] = id
CF_LocationName[id] = "City Prison"
CF_LocationPos[id] = Vector(-45 , 19)
CF_LocationRemoveDoors[id] = true
CF_LocationDescription[id] = ""
CF_LocationSecurity[id] = 0
CF_LocationGoldPresent[id] = true
CF_LocationScenes[id] = {"City Prison"}
CF_LocationPlanet[id] = "MP3-GTC-CTY"
CF_LocationMissions[id] = {"Assault", "Assassinate", "Dropships", "Mine", "Zombies"}

local id = "The Bank"
CF_Location[#CF_Location + 1] = id
CF_LocationName[id] = "The Bank"
CF_LocationPos[id] = Vector(-10 , -22)
CF_LocationRemoveDoors[id] = true
CF_LocationDescription[id] = ""
CF_LocationSecurity[id] = 20
CF_LocationGoldPresent[id] = true
CF_LocationScenes[id] = {"The Bank"}
CF_LocationPlanet[id] = "MP3-GTC-CTY"
CF_LocationMissions[id] = {"Assault", "Assassinate", "Dropships", "Mine", "Zombies"}

local id = "Skyrise"
CF_Location[#CF_Location + 1] = id
CF_LocationName[id] = "Skyrise"
CF_LocationPos[id] = Vector(32 , 32)
CF_LocationRemoveDoors[id] = true
CF_LocationDescription[id] = ""
CF_LocationSecurity[id] = 0
CF_LocationGoldPresent[id] = true
CF_LocationScenes[id] = {"Skyrise"}
CF_LocationPlanet[id] = "MP3-GTC-CTY"
CF_LocationMissions[id] = {"Assault", "Assassinate", "Dropships", "Mine", "Zombies"}

local id = "Office"
CF_Location[#CF_Location + 1] = id
CF_LocationName[id] = "Office"
CF_LocationPos[id] = Vector(27 , -40)
CF_LocationRemoveDoors[id] = true
CF_LocationDescription[id] = ""
CF_LocationSecurity[id] = 10
CF_LocationGoldPresent[id] = true
CF_LocationScenes[id] = {"Office"}
CF_LocationPlanet[id] = "MP3-GTC-CTY"
CF_LocationMissions[id] = {"Assault", "Assassinate", "Dropships", "Mine", "Zombies"}


