--[[
	Southlands by uberhen
	http://forums.datarealms.com/viewtopic.php?f=24&t=37713
	Supported out of the box
	
	Cliffside by Lizardheim
	http://forums.datarealms.com/viewtopic.php?f=24&t=19321
	Supported out of the box

	RETARDS by Squeegy Mackpy
	http://forums.datarealms.com/viewtopic.php?f=61&t=18915	
	Supported out of the box
	
	Bunker Breach + by burningsky25
	http://forums.datarealms.com/viewtopic.php?f=24&t=32135
	Supported out of the box
	
	Aspect's Scene Pack 1.0! by Aspect
	http://forums.datarealms.com/viewtopic.php?f=24&t=31954
	Supported out of the box
]]--

local activated = false

-- Planet locations
-- Requires Southlands.rte
if PresetMan:GetModuleID("Southlands.rte") ~= -1 then
	activated = true

	local id = "Southlands"
	CF_Location[#CF_Location + 1] = id
	CF_LocationName[id] = "Southlands"
	CF_LocationPos[id] = Vector(-12 ,52 )
	CF_LocationRemoveDoors[id] = true
	CF_LocationDescription[id] = ""
	CF_LocationSecurity[id] = 15
	CF_LocationGoldPresent[id] = false
	CF_LocationScenes[id] = {"Southlands"}
	CF_LocationPlanet[id] = "Miranda"
	CF_LocationMissions[id] = {"Assault", "Assassinate", "Defend", "Squad"}--]]--
end

-- Requires MiroCliffside.rte
if PresetMan:GetModuleID("MiroCliffside.rte") ~= -1 then
	activated = true

	local id = "Mirokan's Cliffside"
	CF_Location[#CF_Location + 1] = id
	CF_LocationName[id] = "Mirokan's Cliffside"
	CF_LocationPos[id] = Vector(51 , -25)
	CF_LocationRemoveDoors[id] = true
	CF_LocationDescription[id] = ""
	CF_LocationSecurity[id] = 25
	CF_LocationGoldPresent[id] = false
	CF_LocationScenes[id] = {"Mirokan's Cliffside"}
	CF_LocationPlanet[id] = "Miranda"
	CF_LocationMissions[id] = {"Assault", "Assassinate", "Zombies", "Defend", "Destroy", "Squad"}--]]--
end

-- Requires RETARDS.rte
if PresetMan:GetModuleID("RETARDS.rte") ~= -1 then
	activated = true

	local id = "Lake"
	CF_Location[#CF_Location + 1] = id
	CF_LocationName[id] = "Lake"
	CF_LocationPos[id] = Vector(0 , -32)
	CF_LocationRemoveDoors[id] = true
	CF_LocationDescription[id] = ""
	CF_LocationSecurity[id] = 35
	CF_LocationGoldPresent[id] = false
	CF_LocationScenes[id] = {"Lake"}
	CF_LocationPlanet[id] = "Miranda"
	CF_LocationMissions[id] = {"Assault", "Assassinate", "Zombies", "Defend", "Destroy", "Squad"}--]]--
end


-- Requires BB+.rte
if PresetMan:GetModuleID("BB+.rte") ~= -1 then
	activated = true

	local id = "Grasslands Garrison"
	CF_Location[#CF_Location + 1] = id
	CF_LocationName[id] = "Grasslands Garrison"
	CF_LocationPos[id] = Vector(10 , -15)
	CF_LocationRemoveDoors[id] = true
	CF_LocationDescription[id] = ""
	CF_LocationSecurity[id] = 35
	CF_LocationGoldPresent[id] = true
	CF_LocationScenes[id] = {"Grasslands Garrison"}
	CF_LocationPlanet[id] = "Miranda"
	CF_LocationMissions[id] = {"Assault", "Assassinate", "Dropships", "Mine", "Zombies", "Defend", "Destroy", "Squad"}--]]--

	local id = "Silverhill Stronghold"
	CF_Location[#CF_Location + 1] = id
	CF_LocationName[id] = "Silverhill Stronghold"
	CF_LocationPos[id] = Vector(-30 , 32)
	CF_LocationRemoveDoors[id] = true
	CF_LocationDescription[id] = ""
	CF_LocationSecurity[id] = 35
	CF_LocationGoldPresent[id] = true
	CF_LocationScenes[id] = {"Silverhill Stronghold"}
	CF_LocationPlanet[id] = "Miranda"
	CF_LocationMissions[id] = {"Assault", "Assassinate", "Zombies", "Defend", "Destroy", "Squad"}--]]--
end


-- Requires Bedrock.rte
if PresetMan:GetModuleID("Bedrock.rte") ~= -1 then
	activated = true
	
	local id = "Canyons"
	CF_Location[#CF_Location + 1] = id
	CF_LocationName[id] = "Canyons"
	CF_LocationPos[id] = Vector(29 , 5)
	CF_LocationRemoveDoors[id] = true
	CF_LocationDescription[id] = ""
	CF_LocationSecurity[id] = 35
	CF_LocationGoldPresent[id] = true
	CF_LocationScenes[id] = {"Canyons"}
	CF_LocationPlanet[id] = "Miranda"
	CF_LocationMissions[id] = {"Assault", "Assassinate", "Dropships", "Mine", "Defend", "Squad"}--]]--

	--[[local id = "Stone Mountain"
	CF_Location[#CF_Location + 1] = id
	CF_LocationName[id] = "Stone Mountain"
	CF_LocationPos[id] = Vector(-49 , -7)
	CF_LocationRemoveDoors[id] = true
	CF_LocationDescription[id] = ""
	CF_LocationSecurity[id] = 35
	CF_LocationGoldPresent[id] = true
	CF_LocationScenes[id] = {"Stone Mountain"}
	CF_LocationPlanet[id] = "Miranda"
	CF_LocationMissions[id] = {"Assault", "Assassinate", "Dropships", "Mine", "Zombies", "Defend", "Destroy", "Squad"}--]]--

	--[[local id = "Temple Cave"
	CF_Location[#CF_Location + 1] = id
	CF_LocationName[id] = "Temple Cave"
	CF_LocationPos[id] = Vector(26 , 29)
	CF_LocationRemoveDoors[id] = true
	CF_LocationDescription[id] = ""
	CF_LocationSecurity[id] = 35
	CF_LocationGoldPresent[id] = true
	CF_LocationScenes[id] = {"Temple Cave"}
	CF_LocationPlanet[id] = "Miranda"
	CF_LocationMissions[id] = {"Assault", "Assassinate", "Dropships", "Mine", "Zombies", "Defend", "Destroy", "Squad"}--]]--
end


if activated then
	-- Define planet
	local id = "Miranda"
	CF_Planet[#CF_Planet + 1] = id
	CF_PlanetName[id] = "Miranda"
	CF_PlanetGlow[id] = "Miranda"
	CF_PlanetPos[id] = Vector(-43 , 10)
	CF_PlanetGlowModule[id] = "VoidWanderers.rte"
end
