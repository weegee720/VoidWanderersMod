-- Unique Faction ID
local factionid = "TSA";
print ("Loading "..factionid)

CF_Factions[#CF_Factions + 1] = factionid
	
-- Faction name
CF_FactionNames[factionid] = "TSA";
-- Faction description
CF_FactionDescriptions[factionid] = "The Trans-System Authority (TSA) is an independent body funded by 37 trans-gov powers (governments or super-corporations that own and operate Phase Gates between solar systems), and given jurisdiction over trans-system affairs: as defined by a document called The Charter.";
-- Set true if faction is selectable by player or AI
CF_FactionPlayable[factionid] = true;

-- Modules needed for this faction
CF_RequiredModules[factionid] = {"Base.rte", "Dummy.rte", "Coalition.rte", "Ronin.rte", "TSA.rte"}

-- Set faction nature
-- Available values ORGANIC, SYNTHETIC
CF_FactionNatures[factionid] = CF_FactionTypes.ORGANIC;


-- Define faction bonuses, in percents
-- Scan price reduction
CF_ScanBonuses[factionid] = 50
-- Relation points increase
CF_RelationsBonuses[factionid] = 0
-- Hew HQ build price reduction
CF_ExpansionBonuses[factionid] = 0

-- Gold per turn increase
CF_MineBonuses[factionid] = 0
-- Science per turn increase
CF_LabBonuses[factionid] = 25
-- Delivery time reduction
CF_AirfieldBonuses[factionid] = 35
-- Superweapon targeting reduction
CF_SuperWeaponBonuses[factionid] = 0
-- Unit price reduction
CF_FactoryBonuses[factionid] = 0
-- Body price reduction
CF_CloneBonuses[factionid] = 5
-- HP regeneration increase
CF_HospitalBonuses[factionid] = 0
-- Hack time decrease
CF_HackTimeBonuses[factionid] = 0
-- Hack reward increase
CF_HackRewardBonuses[factionid] = 0

-- Percentage of troops sent to brainhunt or attack player LZ when AI is defending (default - CF_DefaultBrainHuntRatio)
-- If this value is less then default then faction is marked as Defensive if it's more, then as Offensive
CF_BrainHuntRatios[factionid] = 40
	
-- Prefered brain inventory items. Brain gets the best available items of the classes specified in list for free.
-- Default - {CF_WeaponTypes.DIGGER, CF_WeaponTypes.RIFLE}
CF_PreferedBrainInventory[factionid] = {CF_WeaponTypes.HEAVY, CF_WeaponTypes.RIFLE}

-- Define brain unit
CF_Brains[factionid] = "Brain Robot";
CF_BrainModules[factionid] = "Base.rte";
CF_BrainClasses[factionid] = "AHuman";
CF_BrainPrices[factionid] = 500;

-- Define dropship	
CF_Crafts[factionid] = "TSA Drop Ship Type II";
CF_CraftModules[factionid] = "TSA.rte";
CF_CraftClasses[factionid] = "ACDropShip";
CF_CraftPrices[factionid] = 185;

-- Define superweapon script
CF_SuperWeaponScripts[factionid] = "UnmappedLands2.rte/SuperWeapons/Bombing.lua"

-- Define buyable actors available for purchase or unlocks
CF_ActNames[factionid] = {}
CF_ActPresets[factionid] = {}
CF_ActModules[factionid] = {}
CF_ActPrices[factionid] = {}
CF_ActDescriptions[factionid] = {}
CF_ActUnlockData[factionid] = {}
CF_ActClasses[factionid] = {}
CF_ActTypes[factionid] = {} -- AI will select different weapons based on this value
CF_ActPowers[factionid] = {} -- AI will select weapons based on this value 1 - weakest, 10 toughest, 0 never use
CF_ActOffsets[factionid] = {}

-- Available actor types
-- LIGHT, HEAVY, ARMOR, TURRET

local i = 0
i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Standard Infantry"
CF_ActPresets[factionid][i] = "Standard Infantry"
CF_ActModules[factionid][i] = "TSA.rte"
CF_ActPrices[factionid][i] = 170
CF_ActDescriptions[factionid][i] = "Standard Frontiersmen soldier equipped with decent armor and a gravity enhancement belt for use on the battlefield, to overcome large terrain.  Nanotech armor makes them tougher against bullets than most other soldiers."
CF_ActUnlockData[factionid][i] = 0 -- 0 means available at start
CF_ActTypes[factionid][i] = CF_ActorTypes.LIGHT;
CF_ActPowers[factionid][i] = 3

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Jetpack Infantry"
CF_ActPresets[factionid][i] = "Jetpack Infantry"
CF_ActModules[factionid][i] = "TSA.rte"
CF_ActPrices[factionid][i] = 200
CF_ActDescriptions[factionid][i] = "Standard Frontiersmen soldier equipped with decent armor and a jetpack.  Nanotech armor makes them tougher against bullets than most other soldiers."
CF_ActUnlockData[factionid][i] = 750
CF_ActTypes[factionid][i] = CF_ActorTypes.LIGHT;
CF_ActPowers[factionid][i] = 6

-- Define buyable items available for purchase or unlocks
CF_ItmNames[factionid] = {}
CF_ItmPresets[factionid] = {}
CF_ItmModules[factionid] = {}
CF_ItmPrices[factionid] = {}
CF_ItmDescriptions[factionid] = {}
CF_ItmUnlockData[factionid] = {}
CF_ItmClasses[factionid] = {}
CF_ItmTypes[factionid] = {}
CF_ItmPowers[factionid] = {} -- AI will select weapons based on this value 1 - weakest, 10 toughest, 0 never use

-- Available weapon types
-- PISTOL, RIFLE, SHOTGUN, SNIPER, HEAVY, SHIELD, DIGGER, GRENADE

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
CF_ItmNames[factionid][i] = "Riot Shield"
CF_ItmPresets[factionid][i] = "Riot Shield"
CF_ItmModules[factionid][i] = "Base.rte"
CF_ItmPrices[factionid][i] = 20
CF_ItmDescriptions[factionid][i] = "This metal shield provides excellent additional frontal protection to the user and it can stop numerous hits before breaking up."
CF_ItmUnlockData[factionid][i] = 500
CF_ItmClasses[factionid][i] = "HeldDevice"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SHIELD;
CF_ItmPowers[factionid][i] = 1

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Light Scanner"
CF_ItmPresets[factionid][i] = "Light Scanner"
CF_ItmModules[factionid][i] = "Base.rte"
CF_ItmPrices[factionid][i] = 10
CF_ItmDescriptions[factionid][i] = "Lightest in the scanner family. Cheapest of them all and can only scan a small area."
CF_ItmUnlockData[factionid][i] = 150
CF_ItmTypes[factionid][i] = CF_WeaponTypes.TOOL;
CF_ItmPowers[factionid][i] = 0

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Medium Scanner"
CF_ItmPresets[factionid][i] = "Medium Scanner"
CF_ItmModules[factionid][i] = "Base.rte"
CF_ItmPrices[factionid][i] = 40
CF_ItmDescriptions[factionid][i] = "Medium scanner. This scanner is stronger and can reveal a larger area."
CF_ItmUnlockData[factionid][i] = 250
CF_ItmTypes[factionid][i] = CF_WeaponTypes.TOOL;
CF_ItmPowers[factionid][i] = 0

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Heavy Scanner"
CF_ItmPresets[factionid][i] = "Heavy Scanner"
CF_ItmModules[factionid][i] = "Base.rte"
CF_ItmPrices[factionid][i] = 70
CF_ItmDescriptions[factionid][i] = "Strongest scanner out of the three. Can reveal a large area."
CF_ItmUnlockData[factionid][i] = 450
CF_ItmTypes[factionid][i] = CF_WeaponTypes.TOOL;
CF_ItmPowers[factionid][i] = 0

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "TSA Pistol"
CF_ItmPresets[factionid][i] = "TSA Pistol"
CF_ItmModules[factionid][i] = "TSA.rte"
CF_ItmPrices[factionid][i] = 25
CF_ItmDescriptions[factionid][i] = "The TSA's standard issue side arm. Remarkably accurate and powerful. Helps scout ahead and lethal enough to take down lightly armoured units from a distance."
CF_ItmUnlockData[factionid][i] = 0
CF_ItmTypes[factionid][i] = CF_WeaponTypes.PISTOL;
CF_ItmPowers[factionid][i] = 2

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Hand Grenade"
CF_ItmPresets[factionid][i] = "Hand Grenade"
CF_ItmModules[factionid][i] = "TSA.rte"
CF_ItmPrices[factionid][i] = 10
CF_ItmDescriptions[factionid][i] = "A hand thrown TSA issue grenade. Has a 3-second fuze, including the time it takes you to throw it, so be careful."
CF_ItmUnlockData[factionid][i] = 200
CF_ItmClasses[factionid][i] = "TDExplosive"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.GRENADE;
CF_ItmPowers[factionid][i] = 1

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "TSA Land Mine"
CF_ItmPresets[factionid][i] = "TSA Land Mine"
CF_ItmModules[factionid][i] = "TSA.rte"
CF_ItmPrices[factionid][i] = 10
CF_ItmDescriptions[factionid][i] = "A plantable mine that detonates when enemy units interrupt its laser. Disarm with the Mine Disarmer. This mine must be placed by an actor before it detects enemies!"
CF_ItmUnlockData[factionid][i] = 300
CF_ItmClasses[factionid][i] = "TDExplosive"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.GRENADE;
CF_ItmPowers[factionid][i] = 3

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "TSA LMG"
CF_ItmPresets[factionid][i] = "TSA LMG"
CF_ItmModules[factionid][i] = "TSA.rte"
CF_ItmPrices[factionid][i] = 60
CF_ItmDescriptions[factionid][i] = "Light machine gun. Fair damage and range. Versatile and effective, more so in groups."
CF_ItmUnlockData[factionid][i] = 1000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 4

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "TSA Shotgun"
CF_ItmPresets[factionid][i] = "TSA Shotgun"
CF_ItmModules[factionid][i] = "TSA.rte"
CF_ItmPrices[factionid][i] = 75
CF_ItmDescriptions[factionid][i] = "A shotgun that carries power quite far down-range."
CF_ItmUnlockData[factionid][i] = 1500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SHOTGUN;
CF_ItmPowers[factionid][i] = 6

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "TSA HMG"
CF_ItmPresets[factionid][i] = "TSA HMG"
CF_ItmModules[factionid][i] = "TSA.rte"
CF_ItmPrices[factionid][i] = 110
CF_ItmDescriptions[factionid][i] = "Heavy machine gun. Not as accurate as the Machine Gun, but twice the punch and a bigger magazine."
CF_ItmUnlockData[factionid][i] = 2000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 8

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "TSA GL"
CF_ItmPresets[factionid][i] = "TSA GL"
CF_ItmModules[factionid][i] = "TSA.rte"
CF_ItmPrices[factionid][i] = 150
CF_ItmDescriptions[factionid][i] = "A 4-shot, shotgun-style reload, grenade launcher.  Can fire Bouncing (2-Sec Fuse) or Impact grenades."
CF_ItmUnlockData[factionid][i] = 2500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 10