-- Define Gryphon vessel
local id = "Gryphon"
CF_Vessel[#CF_Vessel + 1] = id
CF_VesselPrice[id] = 35000
CF_VesselName[id] = "Gryphon"
CF_VesselScene[id] = "Vessel Gryphon"
CF_VesselModule[id] = "VoidWanderers.rte"

CF_VesselMaxClonesCapacity[id] = 20
CF_VesselStartClonesCapacity[id] = 6

CF_VesselMaxStorageCapacity[id] = 100
CF_VesselStartStorageCapacity[id] = 20

CF_VesselMaxLifeSupport[id] = 8
CF_VesselStartLifeSupport[id] = 4

CF_VesselMaxCommunication[id] = 8
CF_VesselStartCommunication[id] = 4

CF_VesselMaxSpeed[id] = 40
CF_VesselStartSpeed[id] = 20