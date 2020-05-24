-- GeneralIndustries http://forums.datarealms.com/viewtopic.php?f=61&t=29673 by Kettenkrad
-- Faction file by Weegee
-- Unique Faction ID
local factionid = "General Industries";
print ("Loading "..factionid)

CF_Factions[#CF_Factions + 1] = factionid
	
-- Faction name
CF_FactionNames[factionid] = "General Industries";
-- Faction description
CF_FactionDescriptions[factionid] = "Welcome to General Industries. We make stuff you buy.";
-- Set true if faction is selectable by player or AI
CF_FactionPlayable[factionid] = true;

-- Modules needed for this faction
CF_RequiredModules[factionid] = {"Base.rte", "GeneralIndustries.rte"}

-- Set faction nature
CF_FactionNatures[factionid] = CF_FactionTypes.ORGANIC;

-- Define faction bonuses, in percents
CF_ScanBonuses[factionid] = 75
CF_RelationsBonuses[factionid] = 0
CF_ExpansionBonuses[factionid] = 0

CF_MineBonuses[factionid] = 0
CF_LabBonuses[factionid] = 0
CF_AirfieldBonuses[factionid] = 50
CF_SuperWeaponBonuses[factionid] = 0
CF_FactoryBonuses[factionid] = 0
CF_CloneBonuses[factionid] = 0
CF_HospitalBonuses[factionid] = 0

-- Define brain unit
CF_Brains[factionid] = "Brain Robot";
CF_BrainModules[factionid] = "Base.rte";
CF_BrainClasses[factionid] = "AHuman";
CF_BrainPrices[factionid] = 500;

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
CF_ActNames[factionid][i] = "Mercenary"
CF_ActPresets[factionid][i] = "Mercenary"
CF_ActModules[factionid][i] = "GeneralIndustries.rte"
CF_ActPrices[factionid][i] = 130
CF_ActDescriptions[factionid][i] = "Professional mercenary, hired at your cost. Comes with an HK416 and Glock 17C."
CF_ActUnlockData[factionid][i] = 0
CF_ActTypes[factionid][i] = CF_ActorTypes.LIGHT;
CF_EquipmentTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ActPowers[factionid][i] = 6

if CF_ItemsToRemove then
	CF_ItemsToRemove["Mercenary"] = {"HK416", "G17C"}
end

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Point Man"
CF_ActPresets[factionid][i] = "Point Man"
CF_ActModules[factionid][i] = "GeneralIndustries.rte"
CF_ActPrices[factionid][i] = 95
CF_ActDescriptions[factionid][i] = "First man in, armed with an FP6 breaching shotgun and G17C."
CF_ActUnlockData[factionid][i] = 800
CF_ActTypes[factionid][i] = CF_ActorTypes.LIGHT;
CF_EquipmentTypes[factionid][i] = CF_WeaponTypes.SHOTGUN;
CF_ActPowers[factionid][i] = 5

if CF_ItemsToRemove then
	CF_ItemsToRemove["Point Man"] = {"FP6 Breaching Shotgun", "G17C"}
end

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Grenadier"
CF_ActPresets[factionid][i] = "Grenadier"
CF_ActModules[factionid][i] = "GeneralIndustries.rte"
CF_ActPrices[factionid][i] = 210
CF_ActDescriptions[factionid][i] = "Name says it all, equipped with a Milkor MGL and duel G18Cs."
CF_ActUnlockData[factionid][i] = 1800
CF_ActTypes[factionid][i] = CF_ActorTypes.LIGHT;
CF_EquipmentTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ActPowers[factionid][i] = 6

if CF_ItemsToRemove then
	CF_ItemsToRemove["Grenadier"] = {"G18C Offhand", "Milkor MGL", "G18C"}
end

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Scout Sniper"
CF_ActPresets[factionid][i] = "Scout Sniper"
CF_ActModules[factionid][i] = "GeneralIndustries.rte"
CF_ActPrices[factionid][i] = 195
CF_ActDescriptions[factionid][i] = "Trained to uh.. look further forward than other soldiers, these scout snipers will harass targets at range with their SVU sniper rifles."
CF_ActUnlockData[factionid][i] = 1200
CF_ActTypes[factionid][i] = CF_ActorTypes.LIGHT;
CF_EquipmentTypes[factionid][i] = CF_WeaponTypes.SNIPER;
CF_ActPowers[factionid][i] = 6

if CF_ItemsToRemove then
	CF_ItemsToRemove["Scout Sniper"] = {"OTs-03 SVU", "G18C"}
end

-- Disabled due to 1.05 incompatibility
--i = #CF_ActNames[factionid] + 1
--CF_ActNames[factionid][i] = "HevRec Marine"
--CF_ActPresets[factionid][i] = "HevRec Marine"
--CF_ActModules[factionid][i] = "GeneralIndustries.rte"
--CF_ActPrices[factionid][i] = 210
--CF_ActDescriptions[factionid][i] = "Heavy Reconnaissance light anti-armour Marine, armed with a P90 and M95 long range sniper rifle. "
--CF_ActUnlockData[factionid][i] = 2000
--CF_ActTypes[factionid][i] = CF_ActorTypes.HEAVY;
--CF_EquipmentTypes[factionid][i] = CF_WeaponTypes.SNIPER;
--CF_ActPowers[factionid][i] = 8

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Juggernaut"
CF_ActPresets[factionid][i] = "Juggernaut"
CF_ActModules[factionid][i] = "GeneralIndustries.rte"
CF_ActPrices[factionid][i] = 285
CF_ActDescriptions[factionid][i] = "Walking tank. Comes with an RPK-74 and M79 'Thumper'."
CF_ActUnlockData[factionid][i] = 2500
CF_ActTypes[factionid][i] = CF_ActorTypes.ARMOR;
CF_EquipmentTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ActPowers[factionid][i] = 9

if CF_ItemsToRemove then
	CF_ItemsToRemove["Juggernaut"] = {"RPK-74", "M79"}
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
