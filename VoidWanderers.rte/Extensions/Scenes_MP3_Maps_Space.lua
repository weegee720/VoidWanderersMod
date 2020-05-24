--[[
	Map Pack 3 by Gotcha!
	http://forums.datarealms.com/viewtopic.php?f=24&t=12224
	Supported out of the box
]]--

-- Integrity checks
local extension = "Scenes_MP3_Maps_Space" 
local modules = {"Maps - Space.rte"}

for m = 1, #modules do
	if PresetMan:GetModuleID(modules[m]) == -1 then
		error (extension..": ".."Can't  load module - "..modules[m])
	end
end

-- Define planet
local id = "MP3-GTC-SPC"
CF_Planet[#CF_Planet + 1] = id
CF_PlanetName[id] = "MP3-GTC-SPC"
CF_PlanetGlow[id] = "MP3-GTC-SPC"
CF_PlanetPos[id] = Vector(28 , 22)
CF_PlanetGlowModule[id] = "VoidWanderers.rte"

-- Planet locations
local id = "Command"
CF_Location[#CF_Location + 1] = id
CF_LocationName[id] = "Command"
CF_LocationPos[id] = Vector(3 , -32)
CF_LocationRemoveDoors[id] = true
CF_LocationDescription[id] = ""
CF_LocationSecurity[id] = 0
CF_LocationGoldPresent[id] = true
CF_LocationScenes[id] = {"Command"}
CF_LocationPlanet[id] = "MP3-GTC-SPC"
CF_LocationMissions[id] = {"Assault", "Assassinate", "Dropships", "Mine", "Zombies", "Defend", "Destroy", "Squad"}

local id = "Craters"
CF_Location[#CF_Location + 1] = id
CF_LocationName[id] = "Craters"
CF_LocationPos[id] = Vector(29 , 17)
CF_LocationRemoveDoors[id] = true
CF_LocationDescription[id] = ""
CF_LocationSecurity[id] = 0
CF_LocationGoldPresent[id] = true
CF_LocationScenes[id] = {"Craters"}
CF_LocationPlanet[id] = "MP3-GTC-SPC"
CF_LocationMissions[id] = {"Assault", "Assassinate", "Dropships", "Mine", "Zombies", "Defend", "Destroy", "Squad"}

local id = "Asteroids"
CF_Location[#CF_Location + 1] = id
CF_LocationName[id] = "Asteroids"
CF_LocationPos[id] = Vector(-50 , 50)
CF_LocationRemoveDoors[id] = true
CF_LocationDescription[id] = ""
CF_LocationSecurity[id] = 0
CF_LocationGoldPresent[id] = true
CF_LocationScenes[id] = {"Asteroids"}
CF_LocationPlanet[id] = "MP3-GTC-SPC"
CF_LocationMissions[id] = {"Assault", "Assassinate", "Dropships", "Mine", "Zombies", "Defend", "Destroy"}

local id = "Outpost"
CF_Location[#CF_Location + 1] = id
CF_LocationName[id] = "Outpost"
CF_LocationPos[id] = Vector(6 , -16)
CF_LocationRemoveDoors[id] = true
CF_LocationDescription[id] = ""
CF_LocationSecurity[id] = 0
CF_LocationGoldPresent[id] = true
CF_LocationScenes[id] = {"Outpost"}
CF_LocationPlanet[id] = "MP3-GTC-SPC"
CF_LocationMissions[id] = {"Assault", "Assassinate", "Dropships", "Mine", "Zombies", "Defend", "Destroy", "Squad"}

local id = "Comm Tower"
CF_Location[#CF_Location + 1] = id
CF_LocationName[id] = "Comm Tower"
CF_LocationPos[id] = Vector(-28 , 27)
CF_LocationRemoveDoors[id] = true
CF_LocationDescription[id] = ""
CF_LocationSecurity[id] = 0
CF_LocationGoldPresent[id] = true
CF_LocationScenes[id] = {"Comm Tower"}
CF_LocationPlanet[id] = "MP3-GTC-SPC"
CF_LocationMissions[id] = {"Assault", "Assassinate", "Dropships", "Mine", "Zombies", "Defend", "Destroy", "Squad"}

local id = "The Dig"
CF_Location[#CF_Location + 1] = id
CF_LocationName[id] = "The Dig"
CF_LocationPos[id] = Vector(29 , -16)
CF_LocationRemoveDoors[id] = true
CF_LocationDescription[id] = ""
CF_LocationSecurity[id] = 0
CF_LocationGoldPresent[id] = true
CF_LocationScenes[id] = {"The Dig"}
CF_LocationPlanet[id] = "MP3-GTC-SPC"
CF_LocationMissions[id] = {"Assault", "Assassinate", "Dropships", "Mine", "Zombies", "Defend", "Destroy", "Squad"}

--[[local id = "In Flight"
CF_Location[#CF_Location + 1] = id
CF_LocationName[id] = "In Flight"
CF_LocationPos[id] = Vector(33 , -32)
CF_LocationRemoveDoors[id] = true
CF_LocationDescription[id] = ""
CF_LocationSecurity[id] = 0
CF_LocationGoldPresent[id] = true
CF_LocationScenes[id] = {"In Flight"}
CF_LocationPlanet[id] = "MP3-GTC-SPC"
CF_LocationMissions[id] = {"Assault", "Assassinate", "Dropships", "Mine", "Zombies", "Defend", "Destroy"}]]--
