--[[
	Map Pack 3 by Gotcha!
	http://forums.datarealms.com/viewtopic.php?f=24&t=12224
	Supported out of the box
]]--

-- Integrity checks
local extension = "Scenes_MP3_Maps_Snow" 
local modules = {"Maps - Snow.rte"}

for m = 1, #modules do
	if PresetMan:GetModuleID(modules[m]) == -1 then
		error (extension..": ".."Can't  load module - "..modules[m])
	end
end

-- Define planet
local id = "MP3-GTC-SNW"
CF_Planet[#CF_Planet + 1] = id
CF_PlanetName[id] = "MP3-GTC-SNW"
CF_PlanetGlow[id] = "MP3-GTC-SNW"
CF_PlanetPos[id] = Vector(-26 , 0)
CF_PlanetGlowModule[id] = "VoidWanderers.rte"

-- Planet locations
local id = "Arctic Pole"
CF_Location[#CF_Location + 1] = id
CF_LocationName[id] = "Arctic Pole"
CF_LocationPos[id] = Vector(-6 , -9)
CF_LocationRemoveDoors[id] = true
CF_LocationDescription[id] = ""
CF_LocationSecurity[id] = 0
CF_LocationGoldPresent[id] = true
CF_LocationScenes[id] = {"Arctic Pole"}
CF_LocationPlanet[id] = "MP3-GTC-SNW"
CF_LocationMissions[id] = {"Assault", "Assassinate", "Dropships", "Mine", "Zombies", "Defend", "Destroy"}

local id = "Summit"
CF_Location[#CF_Location + 1] = id
CF_LocationName[id] = "Summit"
CF_LocationPos[id] = Vector(-0 , -22)
CF_LocationRemoveDoors[id] = true
CF_LocationDescription[id] = ""
CF_LocationSecurity[id] = 0
CF_LocationGoldPresent[id] = true
CF_LocationScenes[id] = {"Summit"}
CF_LocationPlanet[id] = "MP3-GTC-SNW"
CF_LocationMissions[id] = {"Assault", "Assassinate", "Dropships", "Mine", "Zombies", "Defend", "Destroy"}

local id = "Snow Cave"
CF_Location[#CF_Location + 1] = id
CF_LocationName[id] = "Snow Cave"
CF_LocationPos[id] = Vector(-2 , -46)
CF_LocationRemoveDoors[id] = true
CF_LocationDescription[id] = ""
CF_LocationSecurity[id] = 0
CF_LocationGoldPresent[id] = true
CF_LocationScenes[id] = {"Snow Cave"}
CF_LocationPlanet[id] = "MP3-GTC-SNW"
CF_LocationMissions[id] = {"Assault", "Assassinate", "Dropships", "Mine", "Zombies", "Defend", "Destroy"}

-- Enable only if MP3 patch installed
-- Will crash the game due to Base.rte/Mine if MP3 is not patched
--[[local id = "Missile Silo"
CF_Location[#CF_Location + 1] = id
CF_LocationName[id] = "Missile Silo"
CF_LocationPos[id] = Vector(-43 , 9)
CF_LocationRemoveDoors[id] = true
CF_LocationDescription[id] = ""
CF_LocationSecurity[id] = 0
CF_LocationGoldPresent[id] = false
CF_LocationScenes[id] = {"Missile Silo"}
CF_LocationPlanet[id] = "MP3-GTC-SNW"
CF_LocationMissions[id] = {"Assault", "Assassinate", "Zombies", "Defend", "Destroy"}]]--

local id = "Glacier"
CF_Location[#CF_Location + 1] = id
CF_LocationName[id] = "Glacier"
CF_LocationPos[id] = Vector(-26 , 13)
CF_LocationRemoveDoors[id] = true
CF_LocationDescription[id] = ""
CF_LocationSecurity[id] = 0
CF_LocationGoldPresent[id] = true
CF_LocationScenes[id] = {"Glacier"}
CF_LocationPlanet[id] = "MP3-GTC-SNW"
CF_LocationMissions[id] = {"Assault", "Assassinate", "Dropships", "Mine", "Zombies", "Defend", "Destroy"}

local id = "Ice Caves"
CF_Location[#CF_Location + 1] = id
CF_LocationName[id] = "Ice Caves"
CF_LocationPos[id] = Vector(23 , -2)
CF_LocationRemoveDoors[id] = true
CF_LocationDescription[id] = ""
CF_LocationSecurity[id] = 0
CF_LocationGoldPresent[id] = false
CF_LocationScenes[id] = {"Ice Caves"}
CF_LocationPlanet[id] = "MP3-GTC-SNW"
CF_LocationMissions[id] = {"Assault", "Assassinate", "Zombies", "Destroy"}

local id = "Cold Slabs"
CF_Location[#CF_Location + 1] = id
CF_LocationName[id] = "Cold Slabs"
CF_LocationPos[id] = Vector(-6 , 6)
CF_LocationRemoveDoors[id] = true
CF_LocationDescription[id] = ""
CF_LocationSecurity[id] = 0
CF_LocationGoldPresent[id] = true
CF_LocationScenes[id] = {"Cold Slabs"}
CF_LocationPlanet[id] = "MP3-GTC-SNW"
CF_LocationMissions[id] = {"Assault", "Assassinate", "Dropships", "Mine", "Zombies", "Defend", "Destroy"}


