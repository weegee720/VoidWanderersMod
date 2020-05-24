-- Integrity checks
local extension = "Scenes_MP3_Maps_Earth" 
local modules = {"Maps - Earth.rte"}

for m = 1, #modules do
	if PresetMan:GetModuleID(modules[m]) == -1 then
		error (extension..": ".."Can't  load module - "..modules[m])
	end
end

-- Define planet
local id = "MP3-GTC-RTH"
CF_Planet[#CF_Planet + 1] = id
CF_PlanetName[id] = "MP3-GTC-RTH"
CF_PlanetGlow[id] = "MP3-GTC-RTH"
CF_PlanetPos[id] = Vector(-12 , 42)
CF_PlanetGlowModule[id] = "VoidWanderers.rte"

-- Planet locations
local id = "Wastelands"
CF_Location[#CF_Location + 1] = id
CF_LocationName[id] = "Wastelands"
CF_LocationPos[id] = Vector(-34 , 27)
CF_LocationDescription[id] = ""
CF_LocationSecurity[id] = 0
CF_LocationGoldPresent[id] = true
CF_LocationScenes[id] = {"Wastelands"}
CF_LocationPlanet[id] = "MP3-GTC-RTH"
CF_LocationMissions[id] = {"Assault", "Assassinate", "Dropships", "Mine"}

local id = "Excavation"
CF_Location[#CF_Location + 1] = id
CF_LocationName[id] = "Excavation"
CF_LocationPos[id] = Vector(-7 , 12)
CF_LocationDescription[id] = ""
CF_LocationSecurity[id] = 0
CF_LocationGoldPresent[id] = true
CF_LocationScenes[id] = {"Excavation"}
CF_LocationPlanet[id] = "MP3-GTC-RTH"
CF_LocationMissions[id] = {"Assault", "Assassinate", "Dropships", "Mine"}

local id = "Ragnarok"
CF_Location[#CF_Location + 1] = id
CF_LocationName[id] = "Ragnarok"
CF_LocationPos[id] = Vector(-14 , 31)
CF_LocationDescription[id] = ""
CF_LocationSecurity[id] = 0
CF_LocationGoldPresent[id] = true
CF_LocationScenes[id] = {"Ragnarok"}
CF_LocationPlanet[id] = "MP3-GTC-RTH"
CF_LocationMissions[id] = {"Assault", "Assassinate", "Dropships", "Mine"}

local id = "Gryphon"
CF_Location[#CF_Location + 1] = id
CF_LocationName[id] = "Gryphon"
CF_LocationPos[id] = Vector(25 , 9)
CF_LocationDescription[id] = "Gryphon"
CF_LocationSecurity[id] = 30
CF_LocationGoldPresent[id] = true
CF_LocationScenes[id] = {"Gryphon"}
CF_LocationPlanet[id] = "MP3-GTC-RTH"
CF_LocationMissions[id] = {"Assault", "Assassinate", "Dropships", "Mine"}

local id = "Old Dam"
CF_Location[#CF_Location + 1] = id
CF_LocationName[id] = "Old Dam"
CF_LocationPos[id] = Vector(23 , -22)
CF_LocationDescription[id] = ""
CF_LocationSecurity[id] = 20
CF_LocationGoldPresent[id] = false
CF_LocationScenes[id] = {"Old Dam"}
CF_LocationPlanet[id] = "MP3-GTC-RTH"
CF_LocationMissions[id] = {"Assault", "Assassinate"}

local id = "Station 134"
CF_Location[#CF_Location + 1] = id
CF_LocationName[id] = "Station 134"
CF_LocationPos[id] = Vector(14 , 8)
CF_LocationDescription[id] = ""
CF_LocationSecurity[id] = 0
CF_LocationGoldPresent[id] = true
CF_LocationScenes[id] = {"Station 134"}
CF_LocationPlanet[id] = "MP3-GTC-RTH"
CF_LocationMissions[id] = {"Assault", "Assassinate", "Dropships", "Mine"}

local id = "Dry Flats"
CF_Location[#CF_Location + 1] = id
CF_LocationName[id] = "Dry Flats"
CF_LocationPos[id] = Vector(-8 , -45)
CF_LocationDescription[id] = ""
CF_LocationSecurity[id] = 0
CF_LocationGoldPresent[id] = true
CF_LocationScenes[id] = {"Dry Flats"}
CF_LocationPlanet[id] = "MP3-GTC-RTH"
CF_LocationMissions[id] = {"Assault", "Assassinate", "Dropships", "Mine"}


