-----------------------------------------------------------------------------------------
-- Initialize global faction lists
-----------------------------------------------------------------------------------------
function CF_InitShipsData(activity)
	-- Init vessels data
	CF_Vessel = {}
	CF_VesselName = {}
	CF_VesselScene = {}
	CF_VesselModule = {}

	-- Price of the vesel
	CF_VesselPrice = {}
	
	-- Amount of bodies which can be stored on the ship
	CF_VesselMaxCloneCapacity = {}
	CF_VesselStartCloneCapacity = {}
	
	-- Amount of items which can be stored on the ship
	CF_VesselMaxCargoCapacity = {}
	CF_VesselStartCargoCapacity = {}

	-- How many units can be active on the ship simultaneously
	CF_VesselMaxLifeSupport = {}
	CF_VesselStartLifeSupport = {}

	-- How many units can be active on the planet surface simultaneously
	CF_VesselMaxCommunication = {}
	CF_VesselStartCommunication = {}

	CF_VesselMaxFuel = {}
	
	
	-- Define Gryphon vessel
	local id = "Gryphon"
	CF_Vessel[#CF_Vessel + 1] = id
	CF_VesselPrice[id] = 35000
	CF_VesselName[id] = "Gryphon"
	CF_VesselScene[id] = "Vessel Gryphon"
	CF_VesselModule[id] = "VoidWanderers.rte"
	
	CF_VesselMaxCloneCapacity[id] = 20
	CF_VesselStartCloneCapacity[id] = 6
	
	CF_VesselMaxCargoCapacity[id] = 100
	CF_VesselStartCargoCapacity[id] = 20
	
	CF_VesselMaxLifeSupport[id] = 8
	CF_VesselStartLifeSupport[id] = 4
	
	CF_VesselMaxCommunication[id] = 8
	CF_VesselStartCommunication[id] = 4
	
	CF_VesselMaxFuel = 30
end
