-- RETARDS (v 1.8) http://forums.datarealms.com/viewtopic.php?f=61&t=18915 by Squeegy Mackpy
-- Faction file by Weegee
-- Unique Faction ID
local factionid = "R.E.T.A.R.D.S.";
print ("Loading "..factionid)

CF_Factions[#CF_Factions + 1] = factionid
	
-- Faction name
CF_FactionNames[factionid] = "R.E.T.A.R.D.S.";
-- Faction description
CF_FactionDescriptions[factionid] = "";
-- Set true if faction is selectable by player or AI
CF_FactionPlayable[factionid] = true;

-- Modules needed for this faction
CF_RequiredModules[factionid] = {"Base.rte", "RETARDS.rte"}

-- Set faction nature
CF_FactionNatures[factionid] = CF_FactionTypes.SYNTHETIC;


-- Define faction bonuses, in percents
CF_ScanBonuses[factionid] = 0
CF_RelationsBonuses[factionid] = 0
CF_ExpansionBonuses[factionid] = 0

CF_MineBonuses[factionid] = 0
CF_LabBonuses[factionid] = 0
CF_AirfieldBonuses[factionid] = 80
CF_SuperWeaponBonuses[factionid] = 0
CF_FactoryBonuses[factionid] = 0
CF_CloneBonuses[factionid] = 0
CF_HospitalBonuses[factionid] = 100

CF_DropShipCapacityBonuses[factionid] = CF_MaxUnitsPerDropship * 3

-- Percentage of troops sent to brainhunt or attack player LZ when AI is defending (default - 50)
CF_BrainHuntRatios[factionid] = 80

-- Define brain unit
CF_Brains[factionid] = "AI Core Carrier";
CF_BrainModules[factionid] = "RETARDS.rte";
CF_BrainClasses[factionid] = "AHuman";
CF_BrainPrices[factionid] = 380;

-- Define dropship	
CF_Crafts[factionid] = "Drop Ship MK1";
CF_CraftModules[factionid] = "Base.rte";
CF_CraftClasses[factionid] = "ACDropShip";
CF_CraftPrices[factionid] = 120;

-- Define superweapon script
CF_SuperWeaponScripts[factionid] = "UnmappedLands2.rte/SuperWeapons/DummyParticle.lua"

-- Set this flag to indicate that actors of this faction come with pre-equipped weapons
CF_PreEquippedActors[factionid] = true


-- Define buyable actors available for purchase or unlocks
CF_ActNames[factionid] = {}
CF_ActPresets[factionid] = {}
CF_ActModules[factionid] = {}
CF_ActPrices[factionid] = {}
CF_ActDescriptions[factionid] = {}
CF_ActUnlockData[factionid] = {}
CF_ActClasses[factionid] = {}
CF_ActTypes[factionid] = {}
CF_EquipmentTypes[factionid] = {}
CF_ActPowers[factionid] = {}
CF_ActOffsets[factionid] = {}

local i = 0
i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Prime Hover Drone"
CF_ActPresets[factionid][i] = "Prime Hover Drone"
CF_ActModules[factionid][i] = "RETARDS.rte"
CF_ActPrices[factionid][i] = 50
CF_ActDescriptions[factionid][i] = "A small, agile assault drone. This variant is capable of direct control. A deployable, automated version is available in 'Bombs'."
CF_ActUnlockData[factionid][i] = 0
CF_ActTypes[factionid][i] = CF_ActorTypes.LIGHT;
CF_EquipmentTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ActPowers[factionid][i] = 3

if CF_DiscardableItems then
	CF_DiscardableItems["Prime Hover Drone"] = {"Hover Drone Laser","Hover Drone Digger"}
end

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Micro Hover Drone"
CF_ActPresets[factionid][i] = "Micro Hover Drone"
CF_ActModules[factionid][i] = "RETARDS.rte"
CF_ActPrices[factionid][i] = 20
CF_ActDescriptions[factionid][i] = "A very small, inexpensive disposable distraction"
CF_ActUnlockData[factionid][i] = 500
CF_ActTypes[factionid][i] = CF_ActorTypes.LIGHT;
CF_EquipmentTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ActPowers[factionid][i] = 1

if CF_DiscardableItems then
	CF_DiscardableItems["Micro Hover Drone"] = {"Micro Hover Drone Laser"}
end

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Micro Punter Hover Drone"
CF_ActPresets[factionid][i] = "Micro Punter Hover Drone"
CF_ActModules[factionid][i] = "RETARDS.rte"
CF_ActPrices[factionid][i] = 25
CF_ActDescriptions[factionid][i] = "Micro Drone equipped with a Punter Cannon."
CF_ActUnlockData[factionid][i] = 1000
CF_ActTypes[factionid][i] = CF_ActorTypes.LIGHT;
CF_EquipmentTypes[factionid][i] = CF_WeaponTypes.SHOTGUN;
CF_ActPowers[factionid][i] = 2

if CF_DiscardableItems then
	CF_DiscardableItems[""] = {"Micro Hover Drone Laser"}
end

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Longbow Hover Drone"
CF_ActPresets[factionid][i] = "Longbow Hover Drone"
CF_ActModules[factionid][i] = "RETARDS.rte"
CF_ActPrices[factionid][i] = 90
CF_ActDescriptions[factionid][i] = "A Heavier variant of the hover drone. Has an armour plate and a heavy calibur long range magnetoplasma slug launcher."
CF_ActUnlockData[factionid][i] = 1500
CF_ActTypes[factionid][i] = CF_ActorTypes.LIGHT;
CF_EquipmentTypes[factionid][i] = CF_WeaponTypes.SNIPER;
CF_ActPowers[factionid][i] = 4

if CF_DiscardableItems then
	CF_DiscardableItems["Longbow Hover Drone"] = {"Hover Drone Long Laser"}
end

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Heavy Hover Drone"
CF_ActPresets[factionid][i] = "Heavy Hover Drone"
CF_ActModules[factionid][i] = "RETARDS.rte"
CF_ActPrices[factionid][i] = 110
CF_ActDescriptions[factionid][i] = "A Heavier variant of the hover drone with sheilding and a repeating railgun."
CF_ActUnlockData[factionid][i] = 2000
CF_ActTypes[factionid][i] = CF_ActorTypes.HEAVY;
CF_EquipmentTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ActPowers[factionid][i] = 5

if CF_DiscardableItems then
	CF_DiscardableItems["Heavy Hover Drone"] = {"RailGun"}
end

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Rocket Hover Drone"
CF_ActPresets[factionid][i] = "Rocket Hover Drone"
CF_ActModules[factionid][i] = "RETARDS.rte"
CF_ActPrices[factionid][i] = 120
CF_ActDescriptions[factionid][i] = "A heavily armoured support variant of the hover drone. Comes armed with an anti-armour rocket launcher."
CF_ActUnlockData[factionid][i] = 2500
CF_ActTypes[factionid][i] = CF_ActorTypes.HEAVY;
CF_EquipmentTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ActPowers[factionid][i] = 6

if CF_DiscardableItems then
	CF_DiscardableItems["Rocket Hover Drone"] = {"Drone Rocket Launcher"}
end

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Thumper Turret"
CF_ActPresets[factionid][i] = "Thumper Turret"
CF_ActModules[factionid][i] = "RETARDS.rte"
CF_ActPrices[factionid][i] = 600
CF_ActDescriptions[factionid][i] = "Virtually indestructible, the Thumper is an all purpose defencive cannon. Each shot delivers a lethal cloud of hot metal pellets, at the center of which is a 12kg solid slug. This gun can deliver results while being fired at just about anything, be it aircraft, soliders or tanks."
CF_ActUnlockData[factionid][i] = 4000
CF_ActClasses[factionid][i] = "ACrab"
CF_ActTypes[factionid][i] = CF_ActorTypes.TURRET;
CF_EquipmentTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ActPowers[factionid][i] = 9
--CF_ActOffsets[factionid][i] = Vector(0,16)

if CF_DiscardableItems then
	CF_DiscardableItems["Thumper Turret"] = {"Thumper Cannon"}
end


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
