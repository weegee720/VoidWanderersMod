-- Define Lynx vessel
local id = "Lynx"
CF_Vessel[#CF_Vessel + 1] = id
CF_VesselPrice[id] = 30000
CF_VesselName[id] = "Lynx"
CF_VesselScene[id] = "Vessel Lynx"
CF_VesselModule[id] = "VoidWanderers.rte"

CF_VesselMaxClonesCapacity[id] = 18
CF_VesselStartClonesCapacity[id] = 4

CF_VesselMaxStorageCapacity[id] = 200
CF_VesselStartStorageCapacity[id] = 40

CF_VesselMaxLifeSupport[id] = 10
CF_VesselStartLifeSupport[id] = 4

CF_VesselMaxCommunication[id] = 8
CF_VesselStartCommunication[id] = 4

CF_VesselMaxSpeed[id] = 56
CF_VesselStartSpeed[id] = 24

CF_VesselMaxTurrets[id] = 2
CF_VesselStartTurrets[id] = 0

CF_VesselMaxTurretStorage[id] = 6
CF_VesselStartTurretStorage[id] = 1


local id = "Gryphon"
CF_Vessel[#CF_Vessel + 1] = id
CF_VesselPrice[id] = 50000
CF_VesselName[id] = "Gryphon"
CF_VesselScene[id] = "Vessel Gryphon"
CF_VesselModule[id] = "VoidWanderers.rte"

CF_VesselMaxClonesCapacity[id] = 20
CF_VesselStartClonesCapacity[id] = 8

CF_VesselMaxStorageCapacity[id] = 140
CF_VesselStartStorageCapacity[id] = 40

CF_VesselMaxLifeSupport[id] = 8
CF_VesselStartLifeSupport[id] = 4

CF_VesselMaxCommunication[id] = 8
CF_VesselStartCommunication[id] = 4

CF_VesselMaxSpeed[id] = 40
CF_VesselStartSpeed[id] = 20

CF_VesselMaxTurrets[id] = 2
CF_VesselStartTurrets[id] = 0

CF_VesselMaxTurretStorage[id] = 6
CF_VesselStartTurretStorage[id] = 1



local id = "Titan"
CF_Vessel[#CF_Vessel + 1] = id
CF_VesselPrice[id] = 180000
CF_VesselName[id] = "Titan"
CF_VesselScene[id] = "Vessel Titan"
CF_VesselModule[id] = "VoidWanderers.rte"

CF_VesselMaxClonesCapacity[id] = 40
CF_VesselStartClonesCapacity[id] = 8

CF_VesselMaxStorageCapacity[id] = 400
CF_VesselStartStorageCapacity[id] = 40

CF_VesselMaxLifeSupport[id] = 12
CF_VesselStartLifeSupport[id] = 4

CF_VesselMaxCommunication[id] = 12
CF_VesselStartCommunication[id] = 4

CF_VesselMaxSpeed[id] = 30
CF_VesselStartSpeed[id] = 10

CF_VesselMaxTurrets[id] = 4
CF_VesselStartTurrets[id] = 0

CF_VesselMaxTurretStorage[id] = 14
CF_VesselStartTurretStorage[id] = 2


-- Abandoned vessel scenes
local id = "Abandoned Lynx Vessel"
CF_Location[#CF_Location + 1] = id
CF_LocationName[id] = "Abandoned Lynx Vessel"
CF_LocationPos[id] = Vector(0,0)
CF_LocationSecurity[id] = 0
CF_LocationGoldPresent[id] = false
CF_LocationScenes[id] = {"Abandoned Lynx Vessel"}
CF_LocationScript[id] = {	"VoidWanderers.rte/Scripts/Mission_AbandonedVessel_Faction.lua", 
							"VoidWanderers.rte/Scripts/Mission_AbandonedVessel_Zombies.lua",
							"VoidWanderers.rte/Scripts/Mission_AbandonedVessel_Firefight.lua"}
--CF_LocationScript[id] = {"VoidWanderers.rte/Scripts/Mission_AbandonedVessel_Faction.lua"} -- DEBUG
--CF_LocationScript[id] = {"VoidWanderers.rte/Scripts/Mission_AbandonedVessel_Zombies.lua"} -- DEBUG
--CF_LocationScript[id] = {"VoidWanderers.rte/Scripts/Mission_AbandonedVessel_Firefight.lua"} -- DEBUG
CF_LocationAmbientScript[id] = "VoidWanderers.rte/Scripts/Ambient_Smokes.lua"
CF_LocationPlanet[id] = ""
CF_LocationPlayable[id] = true
CF_LocationMissions[id] = {"Assassinate", "Zombies"}
CF_LocationAttributes[id] = {CF_LocationAttributeTypes.ABANDONEDVESSEL, CF_LocationAttributeTypes.NOTMISSIONASSIGNABLE, CF_LocationAttributeTypes.ALWAYSUNSEEN, CF_LocationAttributeTypes.TEMPLOCATION}


local id = "Abandoned Gryphon Vessel"
CF_Location[#CF_Location + 1] = id
CF_LocationName[id] = "Abandoned Gryphon Vessel"
CF_LocationPos[id] = Vector(0,0)
CF_LocationSecurity[id] = 0
CF_LocationGoldPresent[id] = false
CF_LocationScenes[id] = {"Abandoned Gryphon Vessel"}
CF_LocationScript[id] = {	"VoidWanderers.rte/Scripts/Mission_AbandonedVessel_Faction.lua", 
							"VoidWanderers.rte/Scripts/Mission_AbandonedVessel_Zombies.lua",
							"VoidWanderers.rte/Scripts/Mission_AbandonedVessel_Firefight.lua"}
CF_LocationAmbientScript[id] = "VoidWanderers.rte/Scripts/Ambient_Smokes.lua"
CF_LocationPlanet[id] = ""
CF_LocationPlayable[id] = true
CF_LocationMissions[id] = {"Assassinate", "Zombies"}
CF_LocationAttributes[id] = {CF_LocationAttributeTypes.ABANDONEDVESSEL, CF_LocationAttributeTypes.NOTMISSIONASSIGNABLE, CF_LocationAttributeTypes.ALWAYSUNSEEN, CF_LocationAttributeTypes.TEMPLOCATION}


local id = "Abandoned Titan Vessel"
CF_Location[#CF_Location + 1] = id
CF_LocationName[id] = "Abandoned Titan Vessel"
CF_LocationPos[id] = Vector(0,0)
CF_LocationSecurity[id] = 0
CF_LocationGoldPresent[id] = false
CF_LocationScenes[id] = {"Abandoned Titan Vessel"}
CF_LocationScript[id] = {	"VoidWanderers.rte/Scripts/Mission_AbandonedVessel_Faction.lua", 
							"VoidWanderers.rte/Scripts/Mission_AbandonedVessel_Zombies.lua",
							"VoidWanderers.rte/Scripts/Mission_AbandonedVessel_Firefight.lua"}
CF_LocationAmbientScript[id] = "VoidWanderers.rte/Scripts/Ambient_Smokes.lua"
CF_LocationPlanet[id] = ""
CF_LocationPlayable[id] = true
CF_LocationMissions[id] = {"Assassinate", "Zombies"}
CF_LocationAttributes[id] = {CF_LocationAttributeTypes.ABANDONEDVESSEL, CF_LocationAttributeTypes.NOTMISSIONASSIGNABLE, CF_LocationAttributeTypes.ALWAYSUNSEEN, CF_LocationAttributeTypes.TEMPLOCATION}
--]]--

-- Counterattack vessel scenes
local id = "Vessel Lynx"
CF_Location[#CF_Location + 1] = id
CF_LocationName[id] = "Lynx"
CF_LocationPos[id] = Vector(0,0)
CF_LocationSecurity[id] = 0
CF_LocationGoldPresent[id] = false
CF_LocationScenes[id] = {"Vessel Lynx"}
CF_LocationScript[id] = {"VoidWanderers.rte/Scripts/Mission_Counterattack.lua"}
CF_LocationAmbientScript[id] = "VoidWanderers.rte/Scripts/Ambient_Space.lua"
CF_LocationPlanet[id] = ""
CF_LocationPlayable[id] = true
CF_LocationMissions[id] = {"Assassinate", "Zombies"}
CF_LocationAttributes[id] = {CF_LocationAttributeTypes.VESSEL, CF_LocationAttributeTypes.NOTMISSIONASSIGNABLE, CF_LocationAttributeTypes.ALWAYSUNSEEN, CF_LocationAttributeTypes.TEMPLOCATION, CF_LocationAttributeTypes.SCOUT , CF_LocationAttributeTypes.CORVETTE}

local id = "Vessel Gryphon"
CF_Location[#CF_Location + 1] = id
CF_LocationName[id] = "Gryphon"
CF_LocationPos[id] = Vector(0,0)
CF_LocationSecurity[id] = 0
CF_LocationGoldPresent[id] = false
CF_LocationScenes[id] = {"Vessel Gryphon"}
CF_LocationScript[id] = {"VoidWanderers.rte/Scripts/Mission_Counterattack.lua"}
CF_LocationAmbientScript[id] = "VoidWanderers.rte/Scripts/Ambient_Space.lua"
CF_LocationPlanet[id] = ""
CF_LocationPlayable[id] = true
CF_LocationMissions[id] = {"Assassinate", "Zombies"}
CF_LocationAttributes[id] = {CF_LocationAttributeTypes.VESSEL, CF_LocationAttributeTypes.NOTMISSIONASSIGNABLE, CF_LocationAttributeTypes.ALWAYSUNSEEN, CF_LocationAttributeTypes.TEMPLOCATION, CF_LocationAttributeTypes.FRIGATE, CF_LocationAttributeTypes.DESTROYER}

local id = "Vessel Titan"
CF_Location[#CF_Location + 1] = id
CF_LocationName[id] = "Titan"
CF_LocationPos[id] = Vector(0,0)
CF_LocationSecurity[id] = 0
CF_LocationGoldPresent[id] = false
CF_LocationScenes[id] = {"Vessel Titan"}
CF_LocationScript[id] = {"VoidWanderers.rte/Scripts/Mission_Counterattack.lua"}
CF_LocationAmbientScript[id] = "VoidWanderers.rte/Scripts/Ambient_Space.lua"
CF_LocationPlanet[id] = ""
CF_LocationPlayable[id] = true
CF_LocationMissions[id] = {"Assassinate", "Zombies"}
CF_LocationAttributes[id] = {CF_LocationAttributeTypes.VESSEL, CF_LocationAttributeTypes.NOTMISSIONASSIGNABLE, CF_LocationAttributeTypes.ALWAYSUNSEEN, CF_LocationAttributeTypes.TEMPLOCATION , CF_LocationAttributeTypes.CRUISER, CF_LocationAttributeTypes.BATTLESHIP}




