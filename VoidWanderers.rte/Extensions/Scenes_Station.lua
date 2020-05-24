-- Add planets
-- Define station
local id = "TradeStar"
CF_Planet[#CF_Planet + 1] = id
CF_PlanetName[id] = "FreeTrade TradeStar"
CF_PlanetGlow[id] = "Station"
CF_PlanetGlowModule[id] = "VoidWanderers.rte"


-- Add locations
local id = "TradeStar Pier #792"
CF_Location[#CF_Location + 1] = id
CF_LocationName[id] = "TradeStar Pier #792"
CF_LocationPos[id] = nil
CF_LocationSecurity[id] = 0
CF_LocationScene[id] = "TradeStar Pier #792"
CF_LocationPlanet[id] = "TradeStar"
