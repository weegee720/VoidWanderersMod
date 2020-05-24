-- Add planets
-- Define station
local id = "TradeStar"
CF_Planet[#CF_Planet + 1] = id
CF_PlanetName[id] = "FreeTrade TradeStar"
CF_PlanetGlow[id] = "Station"
CF_PlanetPos[id] = Vector(25 , -20)
CF_PlanetGlowModule[id] = "VoidWanderers.rte"
CF_PlanetScale[id] = 0.05

-- Add locations
local id = "TradeStar Pier #792"
CF_Location[#CF_Location + 1] = id
CF_LocationName[id] = "TradeStar Pier #792"
CF_LocationPos[id] = Vector(25,20)
CF_LocationSecurity[id] = 60
CF_LocationGoldPresent[id] = false
CF_LocationScenes[id] = {"TradeStar Pier #792"}
CF_LocationPlanet[id] = "TradeStar"
CF_LocationPlayable[id] = false
CF_LocationAttributes[id] = {CF_LocationAttributeTypes.TRADESTAR}

local id = "TradeStar Pier #625"
CF_Location[#CF_Location + 1] = id
CF_LocationName[id] = "TradeStar Pier #625"
CF_LocationPos[id] = Vector(-25,20)
CF_LocationSecurity[id] = 60
CF_LocationGoldPresent[id] = false
CF_LocationScenes[id] = {"TradeStar Pier #625"}
CF_LocationPlanet[id] = "TradeStar"
CF_LocationPlayable[id] = false
CF_LocationAttributes[id] = {CF_LocationAttributeTypes.TRADESTAR}
