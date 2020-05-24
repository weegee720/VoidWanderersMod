-- Unique Faction ID
local factionid = "New World Industries";
print ("Loading "..factionid)

CF_Factions[#CF_Factions + 1] = factionid

-- Faction name
CF_FactionNames[factionid] = "New World Industries";
-- Faction description
CF_FactionDescriptions[factionid] = "Created by a group of survivors, New World Industries specialize in mass production of high quality products using scrap parts left on battlefields, combining different strengths of all factions to generate a unique, all around fighting force.";
-- Set true if faction is selectable by player or AI
CF_FactionPlayable[factionid] = true;

-- Modules needed for this faction
CF_RequiredModules[factionid] = {"Base.rte", "NewWorldIndustries.rte"}

-- Set faction nature
CF_FactionNatures[factionid] = CF_FactionTypes.ORGANIC;


-- Define faction bonuses, in percents
CF_ScanBonuses[factionid] = 0
CF_RelationsBonuses[factionid] = 0
CF_ExpansionBonuses[factionid] = 0

CF_MineBonuses[factionid] = 0
CF_LabBonuses[factionid] = 10
CF_AirfieldBonuses[factionid] = 10
CF_SuperWeaponBonuses[factionid] = 0
CF_FactoryBonuses[factionid] = 30
CF_CloneBonuses[factionid] = 30
CF_HospitalBonuses[factionid] = 0


-- Define brain unit
CF_Brains[factionid] = "Recycled Brain Robot";
CF_BrainModules[factionid] = "NewWorldIndustries.rte";
CF_BrainClasses[factionid] = "AHuman";
CF_BrainPrices[factionid] = 500;

-- Define dropship	
CF_Crafts[factionid] = "Drop Pod";
CF_CraftModules[factionid] = "NewWorldIndustries.rte";
CF_CraftClasses[factionid] = "ACRocket";
CF_CraftPrices[factionid] = 20;

-- Define superweapon script
CF_SuperWeaponScripts[factionid] = "NewWorldIndustries.rte/UnmappedLands2/ColossusStrike.lua"

-- Define buyable actors available for purchase or unlocks
CF_ActNames[factionid] = {}
CF_ActPresets[factionid] = {}
CF_ActModules[factionid] = {}
CF_ActPrices[factionid] = {}
CF_ActDescriptions[factionid] = {}
CF_ActUnlockData[factionid] = {}
CF_ActClasses[factionid] = {}
CF_ActTypes[factionid] = {}
CF_ActPowers[factionid] = {}
CF_ActOffsets[factionid] = {}

local i = 0
i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Recycled Robot Light"
CF_ActPresets[factionid][i] = "Recycled Robot Light"
CF_ActModules[factionid][i] = "NewWorldIndustries.rte"
CF_ActPrices[factionid][i] = 80
CF_ActDescriptions[factionid][i] = "Robot made of Coalition, Dummy, and Browncoats salvaged parts. It's a bit tougher than a Dummy and slightly lighter than a Coalition light."
CF_ActUnlockData[factionid][i] = 0
CF_ActTypes[factionid][i] = CF_ActorTypes.LIGHT;
CF_ActPowers[factionid][i] = 3

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Recylced Robot Heavy"
CF_ActPresets[factionid][i] = "Recylced Robot Heavy"
CF_ActModules[factionid][i] = "NewWorldIndustries.rte"
CF_ActPrices[factionid][i] = 150
CF_ActDescriptions[factionid][i] = "More sturdy than the light one, this model also features armor, and is almost as strong as a Browncoat Light soldier. Who said recycling was lame?"
CF_ActUnlockData[factionid][i] = 1600
CF_ActTypes[factionid][i] = CF_ActorTypes.HEAVY;
CF_ActPowers[factionid][i] = 7

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Special Operations Unit"
CF_ActPresets[factionid][i] = "Special Operations Unit"
CF_ActModules[factionid][i] = "NewWorldIndustries.rte"
CF_ActPrices[factionid][i] = 230
CF_ActDescriptions[factionid][i] = "Special Operations Unit. New World Industries generated this unit based off of traded Coalition's Light Soldiers."
CF_ActUnlockData[factionid][i] = 3000
CF_ActClasses[factionid][i] = "AHuman"
CF_ActTypes[factionid][i] = CF_ActorTypes.HEAVY;
CF_ActPowers[factionid][i] = 8

-- Define buyable items available for purchase or unlocks
CF_ItmNames[factionid] = {}
CF_ItmPresets[factionid] = {}
CF_ItmModules[factionid] = {}
CF_ItmPrices[factionid] = {}
CF_ItmDescriptions[factionid] = {}
CF_ItmUnlockData[factionid] = {}
CF_ItmClasses[factionid] = {}
CF_ItmTypes[factionid] = {}
CF_ItmPowers[factionid] = {}

local i = 0
i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Light Digger"
CF_ItmPresets[factionid][i] = "Light Digger"
CF_ItmModules[factionid][i] = "Base.rte"
CF_ItmPrices[factionid][i] = 10
CF_ItmDescriptions[factionid][i] = "Lightest in the digger family. Cheapest of them all and works as a nice melee weapon on soft targets."
CF_ItmUnlockData[factionid][i] = 0 -- 0 means available at start
CF_ItmTypes[factionid][i] = CF_WeaponTypes.DIGGER;
CF_ItmPowers[factionid][i] = 1

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Medium Digger"
CF_ItmPresets[factionid][i] = "Medium Digger"
CF_ItmModules[factionid][i] = "Base.rte"
CF_ItmPrices[factionid][i] = 40
CF_ItmDescriptions[factionid][i] = "Stronger digger. This one can pierce rocks with some effort and dig impressive tunnels and its melee weapon capabilities are much greater."
CF_ItmUnlockData[factionid][i] = 500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.DIGGER;
CF_ItmPowers[factionid][i] = 4

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Heavy Digger"
CF_ItmPresets[factionid][i] = "Heavy Digger"
CF_ItmModules[factionid][i] = "Base.rte"
CF_ItmPrices[factionid][i] = 100
CF_ItmDescriptions[factionid][i] = "Heaviest and the most powerful of them all. Eats concrete with great hunger and allows you to make complex mining caves incredibly fast. Shreds anyone unfortunate who stand in its way."
CF_ItmUnlockData[factionid][i] = 1000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.DIGGER;
CF_ItmPowers[factionid][i] = 8

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "W-Digger"
CF_ItmPresets[factionid][i] = "W-Digger"
CF_ItmModules[factionid][i] = "NewWorldIndustries.rte"
CF_ItmPrices[factionid][i] = 65
CF_ItmDescriptions[factionid][i] = "Wide digger. Useful for digging big tunnels without too much effort. It might have problems digging in strong materials."
CF_ItmUnlockData[factionid][i] = 650
CF_ItmTypes[factionid][i] = CF_WeaponTypes.DIGGER;-- need some kind of misc tool class
CF_ItmPowers[factionid][i] = 0

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "NW Shield"
CF_ItmPresets[factionid][i] = "NW Shield"
CF_ItmModules[factionid][i] = "NewWorldIndustries.rte"
CF_ItmPrices[factionid][i] = 45
CF_ItmDescriptions[factionid][i] = "New World standard shield. Made of many types of metals, this shield is also bigger than most shields; it covers almost the entire body and offers full protection while crouching."
CF_ItmUnlockData[factionid][i] = 750
CF_ItmClasses[factionid][i] = "HeldDevice"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SHIELD;
CF_ItmPowers[factionid][i] = 1

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "NW DE"
CF_ItmPresets[factionid][i] = "NW DE"
CF_ItmModules[factionid][i] = "NewWorldIndustries.rte"
CF_ItmPrices[factionid][i] = 20
CF_ItmDescriptions[factionid][i] = "This heavily modified Desert Eagle is fitted with a supressor and .50 caliber rounds."
CF_ItmUnlockData[factionid][i] = 0
CF_ItmTypes[factionid][i] = CF_WeaponTypes.PISTOL;
CF_ItmPowers[factionid][i] = 1

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "NW Assault Blaster"
CF_ItmPresets[factionid][i] = "NW Assault Blaster"
CF_ItmModules[factionid][i] = "NewWorldIndustries.rte"
CF_ItmPrices[factionid][i] = 50
CF_ItmDescriptions[factionid][i] = "Using the parts of the Dummy Blaster and Coalition Assault Rifle, this is the standard Sub Machine Gun of the New World Industries."
CF_ItmUnlockData[factionid][i] = 0
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 2

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "NW Shotgun"
CF_ItmPresets[factionid][i] = "NW Shotgun"
CF_ItmModules[factionid][i] = "NewWorldIndustries.rte"
CF_ItmPrices[factionid][i] = 65
CF_ItmDescriptions[factionid][i] = "Heavy duty shotgun, excellent for close quarters combat. It can be held with one hand."
CF_ItmUnlockData[factionid][i] = 600
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SHOTGUN;
CF_ItmPowers[factionid][i] = 6

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "NW Battle Rifle"
CF_ItmPresets[factionid][i] = "NW Battle Rifle"
CF_ItmModules[factionid][i] = "NewWorldIndustries.rte"
CF_ItmPrices[factionid][i] = 85
CF_ItmDescriptions[factionid][i] = "Standard rifle for your troops. It's accurate and uses strong ammunition."
CF_ItmUnlockData[factionid][i] = 800
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 3


i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "NW Heavy Flamer"
CF_ItmPresets[factionid][i] = "NW Heavy Flamer"
CF_ItmModules[factionid][i] = "NewWorldIndustries.rte"
CF_ItmPrices[factionid][i] = 100
CF_ItmDescriptions[factionid][i] = "Using Dummy plastic as a fuel, this flamer generates a very strong blue flame. The only problem is that the plastic burns too quick."
CF_ItmUnlockData[factionid][i] = 1000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 2

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "NW Sniper Rifle"
CF_ItmPresets[factionid][i] = "NW Sniper Rifle"
CF_ItmModules[factionid][i] = "NewWorldIndustries.rte"
CF_ItmPrices[factionid][i] = 145
CF_ItmDescriptions[factionid][i] = "Using Coalition's abusive firepower and Ronin's portability and range, we created one of the best all around sniper rifles up to date."
CF_ItmUnlockData[factionid][i] = 1500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SNIPER;
CF_ItmPowers[factionid][i] = 3

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "NW Energy Mauler"
CF_ItmPresets[factionid][i] = "NW Energy Mauler"
CF_ItmModules[factionid][i] = "NewWorldIndustries.rte"
CF_ItmPrices[factionid][i] = 200
CF_ItmDescriptions[factionid][i] = "Using Coalition's cooling technology, we could create an hybrid between a shotgun and an energy cannon."
CF_ItmUnlockData[factionid][i] = 2000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 7

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "NW Hand-Held Colossus Launcher"
CF_ItmPresets[factionid][i] = "NW Hand-Held Colossus Launcher"
CF_ItmModules[factionid][i] = "NewWorldIndustries.rte"
CF_ItmPrices[factionid][i] = 230
CF_ItmDescriptions[factionid][i] = "Hand-Held Colossus Launcher. Fires a Colossus Rocket Type C, used as anti-armor. Uses cluster explosives to maximize damage against infantry."
CF_ItmUnlockData[factionid][i] = 2300
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 5