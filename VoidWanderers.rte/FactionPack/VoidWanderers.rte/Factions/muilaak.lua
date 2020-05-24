-- Remnants of the Mu-Ilaak (v 3.1) http://forums.datarealms.com/viewtopic.php?f=61&t=31436 by Grimmcrypt
-- Faction file by <Faction file contributors here>
-- 
-- Unique Faction ID
local factionid = "Mu-Ilaak";
print ("Loading "..factionid)

CF_Factions[#CF_Factions + 1] = factionid

CF_FactionNames[factionid] = "Mu-Ilaak";
CF_FactionDescriptions[factionid] = "";
CF_FactionPlayable[factionid] = true;

CF_RequiredModules[factionid] = {"HELL.rte"}
-- Available values ORGANIC, SYNTHETIC
CF_FactionNatures[factionid] = CF_FactionTypes.SYNTHETIC;


-- Define faction bonuses, in percents
-- Scan price reduction
CF_ScanBonuses[factionid] = 0
-- Relation points increase
CF_RelationsBonuses[factionid] = 0
-- Hew HQ build price reduction
CF_ExpansionBonuses[factionid] = 0

-- Gold per turn increase
CF_MineBonuses[factionid] = 0
-- Science per turn increase
CF_LabBonuses[factionid] = 0
-- Delivery time reduction
CF_AirfieldBonuses[factionid] = 0
-- Superweapon targeting reduction
CF_SuperWeaponBonuses[factionid] = 0
-- Unit price reduction
CF_FactoryBonuses[factionid] = 0
-- Body price reduction
CF_CloneBonuses[factionid] = 0
-- HP regeneration increase
CF_HospitalBonuses[factionid] = 100


-- Define brain unit
CF_Brains[factionid] = "Mu-Ilaak Brain";
CF_BrainModules[factionid] = "HELL.rte";
CF_BrainClasses[factionid] = "AHuman";
CF_BrainPrices[factionid] = 500;

-- Define dropship
CF_Crafts[factionid] = "Ei-Dra";
CF_CraftModules[factionid] = "Base.rte";
CF_CraftClasses[factionid] = "ACDropShip";
CF_CraftPrices[factionid] = 110;

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
CF_ActTypes[factionid] = {}
CF_ActPowers[factionid] = {}
CF_ActOffsets[factionid] = {}

local i = 0
i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Mu-Ilaak Sentry"
CF_ActPresets[factionid][i] = "Mu-Ilaak Sentry"
CF_ActModules[factionid][i] = "HELL.rte"
CF_ActPrices[factionid][i] = 90
CF_ActDescriptions[factionid][i] = "Smaller then the Mauler but faster and more cunning"
CF_ActUnlockData[factionid][i] = 0
CF_ActTypes[factionid][i] = CF_ActorTypes.HEAVY;
CF_ActPowers[factionid][i] = 5

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Mu-Ilaak Mauler"
CF_ActPresets[factionid][i] = "Mu-Ilaak Mauler"
CF_ActModules[factionid][i] = "HELL.rte"
CF_ActPrices[factionid][i] = 125
CF_ActDescriptions[factionid][i] = "Heavier then the Sentry but it can take hit's."
CF_ActUnlockData[factionid][i] = 1200
CF_ActTypes[factionid][i] = CF_ActorTypes.HEAVY;
CF_ActPowers[factionid][i] = 7

--[[i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Mu-Ilaak Head Sentry"
CF_ActPresets[factionid][i] = "Mu-Ilaak Head Sentry"
CF_ActModules[factionid][i] = "HELL.rte"
CF_ActPrices[factionid][i] = 70
CF_ActDescriptions[factionid][i] = "Anti-infantry unit.  It seeks out enemies and tears them apart up close."
CF_ActUnlockData[factionid][i] = 0
CF_ActClasses[factionid][i] = "ACrab"
CF_ActTypes[factionid][i] = CF_ActorTypes.ARMOR;
CF_ActPowers[factionid][i] = 0

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Mu-Ilaak Head Mauler"
CF_ActPresets[factionid][i] = "Mu-Ilaak Head Mauler"
CF_ActModules[factionid][i] = "HELL.rte"
CF_ActPrices[factionid][i] = 70
CF_ActDescriptions[factionid][i] = "Anti-infantry unit.  It seeks out enemies and tears them apart up close."
CF_ActUnlockData[factionid][i] = 0
CF_ActClasses[factionid][i] = "ACrab"
CF_ActTypes[factionid][i] = CF_ActorTypes.ARMOR;
CF_ActPowers[factionid][i] = 0]]--

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
CF_ItmNames[factionid][i] = "Pi-Tol"
CF_ItmPresets[factionid][i] = "Pi-Tol"
CF_ItmModules[factionid][i] = "HELL.rte"
CF_ItmPrices[factionid][i] = 10
CF_ItmDescriptions[factionid][i] = "You ran out? pull out this one."
CF_ItmUnlockData[factionid][i] = 350
CF_ItmTypes[factionid][i] = CF_WeaponTypes.PISTOL;
CF_ItmPowers[factionid][i] = 3

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Pi-Tol Offhand"
CF_ItmPresets[factionid][i] = "Pi-Tol Offhand"
CF_ItmModules[factionid][i] = "HELL.rte"
CF_ItmPrices[factionid][i] = 10
CF_ItmDescriptions[factionid][i] = "Why have one when you can have two."
CF_ItmUnlockData[factionid][i] = 350
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SHIELD;
CF_ItmPowers[factionid][i] = 0

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Pi-Aoto"
CF_ItmPresets[factionid][i] = "Pi-Aoto"
CF_ItmModules[factionid][i] = "HELL.rte"
CF_ItmPrices[factionid][i] = 25
CF_ItmDescriptions[factionid][i] = "Prrra intead of bam."
CF_ItmUnlockData[factionid][i] = 450
CF_ItmTypes[factionid][i] = CF_WeaponTypes.PISTOL;
CF_ItmPowers[factionid][i] = 0

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Pi-Aoto Offhand"
CF_ItmPresets[factionid][i] = "Pi-Aoto Offhand"
CF_ItmModules[factionid][i] = "HELL.rte"
CF_ItmPrices[factionid][i] = 25
CF_ItmDescriptions[factionid][i] = "Prrra intead of bam."
CF_ItmUnlockData[factionid][i] = 450
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SHIELD;
CF_ItmPowers[factionid][i] = 0

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Pi-Hull"
CF_ItmPresets[factionid][i] = "Pi-Hull"
CF_ItmModules[factionid][i] = "HELL.rte"
CF_ItmPrices[factionid][i] = 25
CF_ItmDescriptions[factionid][i] = "Die."
CF_ItmUnlockData[factionid][i] = 0
CF_ItmTypes[factionid][i] = CF_WeaponTypes.PISTOL;
CF_ItmPowers[factionid][i] = 2

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Ki-Ratul"
CF_ItmPresets[factionid][i] = "Ki-Ratul "
CF_ItmModules[factionid][i] = "HELL.rte"
CF_ItmPrices[factionid][i] = 40
CF_ItmDescriptions[factionid][i] = "Small assault rifle"
CF_ItmUnlockData[factionid][i] = 0
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 4

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Ki-Raila"
CF_ItmPresets[factionid][i] = "Ki-Raila"
CF_ItmModules[factionid][i] = "HELL.rte"
CF_ItmPrices[factionid][i] = 65
CF_ItmDescriptions[factionid][i] = "Bursting assault rifle"
CF_ItmUnlockData[factionid][i] = 750
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 5

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Mu-Baoni"
CF_ItmPresets[factionid][i] = "Mu-Baoni"
CF_ItmModules[factionid][i] = "HELL.rte"
CF_ItmPrices[factionid][i] = 35
CF_ItmDescriptions[factionid][i] = "Sticky Grenade Launcher"
CF_ItmUnlockData[factionid][i] = 1200
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 8

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "So-Aoto"
CF_ItmPresets[factionid][i] = "So-Aoto"
CF_ItmModules[factionid][i] = "HELL.rte"
CF_ItmPrices[factionid][i] = 300
CF_ItmDescriptions[factionid][i] = "Its like a Lazer gun or Acid shooter maybe."
CF_ItmUnlockData[factionid][i] = 2000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 7

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Ki-Taka"
CF_ItmPresets[factionid][i] = "Ki-Taka"
CF_ItmModules[factionid][i] = "HELL.rte"
CF_ItmPrices[factionid][i] = 210
CF_ItmDescriptions[factionid][i] = "Plasma Generator Machingun or as the we now it Gatlingun"
CF_ItmUnlockData[factionid][i] = 1500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 0

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Ro-Raila"
CF_ItmPresets[factionid][i] = "Ro-Raila"
CF_ItmModules[factionid][i] = "HELL.rte"
CF_ItmPrices[factionid][i] = 90
CF_ItmDescriptions[factionid][i] = "Mu-Ilakk Carbine rifle"
CF_ItmUnlockData[factionid][i] = 750
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SNIPER;
CF_ItmPowers[factionid][i] = 5

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Ro-Railata"
CF_ItmPresets[factionid][i] = "Ro-Railata"
CF_ItmModules[factionid][i] = "HELL.rte"
CF_ItmPrices[factionid][i] = 120
CF_ItmDescriptions[factionid][i] = "One shot and your probably dead."
CF_ItmUnlockData[factionid][i] = 1750
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SNIPER;
CF_ItmPowers[factionid][i] = 7

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Mi-Bau"
CF_ItmPresets[factionid][i] = "Mi-Bau"
CF_ItmModules[factionid][i] = "HELL.rte"
CF_ItmPrices[factionid][i] = 350
CF_ItmDescriptions[factionid][i] = "Can fire powerful, manually guided missiles or weaker but faster unguided rockets.  Switch between ammunition types using the buttons in the Pie Menu."
CF_ItmUnlockData[factionid][i] = 1600
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 7

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Bau-Ratul"
CF_ItmPresets[factionid][i] = "Bau-Ratul"
CF_ItmModules[factionid][i] = "HELL.rte"
CF_ItmPrices[factionid][i] = 10
CF_ItmDescriptions[factionid][i] = "Explosive Plasma grenade. Perfect for clearing awkward bunkers. Blows up after a 4 second delay."
CF_ItmUnlockData[factionid][i] = 350
CF_ItmClasses[factionid][i] = "TDExplosive"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.GRENADE;
CF_ItmPowers[factionid][i] = 7

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Sticky Grenade"
CF_ItmPresets[factionid][i] = "Sticky Grenade"
CF_ItmModules[factionid][i] = "HELL.rte"
CF_ItmPrices[factionid][i] = 25
CF_ItmDescriptions[factionid][i] = "The name saysit all."
CF_ItmUnlockData[factionid][i] = 500
CF_ItmClasses[factionid][i] = "TDExplosive"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.GRENADE;
CF_ItmPowers[factionid][i] = 8
