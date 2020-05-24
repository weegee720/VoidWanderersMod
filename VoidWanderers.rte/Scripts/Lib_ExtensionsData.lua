function CF_InitExtensionsData(activity)
	-- Init planet data structures
	CF_Planet = {}
	CF_PlanetName = {}
	CF_PlanetGlow = {}
	CF_PlanetGlowModule = {}
	
	-- Init locations data structures
	CF_Location = {}
	CF_LocationName = {}
	CF_LocationPos = {}
	CF_LocationSecurity = {}
	CF_LocationScene = {}
	CF_LocationPlanet = {}	

	-- Init ship data structures
	CF_Vessel = {}
	CF_VesselName = {}
	CF_VesselScene = {}
	CF_VesselModule = {}

	-- Price of the vesel
	CF_VesselPrice = {}
	
	-- Amount of bodies which can be stored on the ship
	CF_VesselMaxClonesCapacity = {}
	CF_VesselStartClonesCapacity = {}
	
	-- Amount of items which can be stored on the ship
	CF_VesselMaxStorageCapacity = {}
	CF_VesselStartStorageCapacity = {}

	-- How many units can be active on the ship simultaneously
	CF_VesselMaxLifeSupport = {}
	CF_VesselStartLifeSupport = {}

	-- How many units can be active on the planet surface simultaneously
	CF_VesselMaxCommunication = {}
	CF_VesselStartCommunication = {}

	CF_VesselMaxFuel = {}
	
	-- Mission types data
	CF_DataTypes = {VECTOR = 1, BOX = 2, MULTIBOX = 3}
	
	CF_Mission = {}
	
	CF_MissionName = {}
	CF_RequiredData = {}
	CF_Script = {}
	CF_MinReputation = {}
	CF_BriefingText = {}
end