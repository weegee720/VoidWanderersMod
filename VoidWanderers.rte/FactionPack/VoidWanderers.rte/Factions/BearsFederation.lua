-- Unique Faction ID
local factionid = "Bears Federation";
print ("Loading "..factionid)

CF_Factions[#CF_Factions + 1] = factionid

-- Faction name
CF_FactionNames[factionid] = "Bears Federation";
-- Faction description
CF_FactionDescriptions[factionid] = "A group of ex-marines mercenaries";
-- Set true if faction is selectable by player or AI
CF_FactionPlayable[factionid] = true;

-- Main module used to check if mod is installed and as backward compatibility layer with v1-faction files enabled missions
CF_RequiredModules[factionid] = {"Base.rte", "BF.rte"}

-- Set faction nature
CF_FactionNatures[factionid] = CF_FactionTypes.ORGANIC;


-- Define faction bonuses, in percents
CF_ScanBonuses[factionid] = 75
CF_RelationsBonuses[factionid] = 0
CF_ExpansionBonuses[factionid] = 25

CF_MineBonuses[factionid] = 0
CF_LabBonuses[factionid] = 0
CF_AirfieldBonuses[factionid] = 0
CF_SuperWeaponBonuses[factionid] = 0
CF_FactoryBonuses[factionid] = 0
CF_CloneBonuses[factionid] = 0
CF_HospitalBonuses[factionid] = 10


-- Define brain unit
CF_Brains[factionid] = "Armscheif Shrikov";
CF_BrainModules[factionid] = "BF.rte";
CF_BrainClasses[factionid] = "AHuman";
CF_BrainPrices[factionid] = 1000;

-- Define dropship	
CF_Crafts[factionid] = "BF Drop Ship";
CF_CraftModules[factionid] = "BF.rte";
CF_CraftClasses[factionid] = "ACDropShip";
CF_CraftPrices[factionid] = 120;

-- Define superweapon script
CF_SuperWeaponScripts[factionid] = "UnmappedLands2.rte/SuperWeapons/MineBombing.lua"

-- Define default tactical AI model
CF_FactionAIModels[factionid] = "SQUAD"

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
CF_ActNames[factionid][i] = "BF Conscript 1"
CF_ActPresets[factionid][i] = "BF Conscript 1"
CF_ActModules[factionid][i] = "BF.rte"
CF_ActPrices[factionid][i] = 80
CF_ActDescriptions[factionid][i] = ""
CF_ActUnlockData[factionid][i] = 0
CF_ActTypes[factionid][i] = CF_ActorTypes.LIGHT;
CF_ActPowers[factionid][i] = 1

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "BF Conscript 2"
CF_ActPresets[factionid][i] = "BF Conscript 2"
CF_ActModules[factionid][i] = "BF.rte"
CF_ActPrices[factionid][i] = 80
CF_ActDescriptions[factionid][i] = ""
CF_ActUnlockData[factionid][i] = 100
CF_ActTypes[factionid][i] = CF_ActorTypes.LIGHT;
CF_ActPowers[factionid][i] = 1

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "BF Conscript 3"
CF_ActPresets[factionid][i] = "BF Conscript 3"
CF_ActModules[factionid][i] = "BF.rte"
CF_ActPrices[factionid][i] = 80
CF_ActDescriptions[factionid][i] = ""
CF_ActUnlockData[factionid][i] = 100
CF_ActTypes[factionid][i] = CF_ActorTypes.LIGHT;
CF_ActPowers[factionid][i] = 1

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "BF Spetsnaz 1"
CF_ActPresets[factionid][i] = "BF Spetsnaz 1"
CF_ActModules[factionid][i] = "BF.rte"
CF_ActPrices[factionid][i] = 80
CF_ActDescriptions[factionid][i] = ""
CF_ActUnlockData[factionid][i] = 200
CF_ActTypes[factionid][i] = CF_ActorTypes.HEAVY;
CF_ActPowers[factionid][i] = 1

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "BF Spetsnaz 2"
CF_ActPresets[factionid][i] = "BF Spetsnaz 2"
CF_ActModules[factionid][i] = "BF.rte"
CF_ActPrices[factionid][i] = 80
CF_ActDescriptions[factionid][i] = ""
CF_ActUnlockData[factionid][i] = 200
CF_ActTypes[factionid][i] = CF_ActorTypes.HEAVY;
CF_ActPowers[factionid][i] = 1

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "BF Spetsnaz 3"
CF_ActPresets[factionid][i] = "BF Spetsnaz 3"
CF_ActModules[factionid][i] = "BF.rte"
CF_ActPrices[factionid][i] = 80
CF_ActDescriptions[factionid][i] = ""
CF_ActUnlockData[factionid][i] = 200
CF_ActTypes[factionid][i] = CF_ActorTypes.HEAVY;
CF_ActPowers[factionid][i] = 1

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "BF Officer"
CF_ActPresets[factionid][i] = "BF Officer"
CF_ActModules[factionid][i] = "BF.rte"
CF_ActPrices[factionid][i] = 80
CF_ActDescriptions[factionid][i] = ""
CF_ActUnlockData[factionid][i] = 300
CF_ActTypes[factionid][i] = CF_ActorTypes.HEAVY;
CF_ActPowers[factionid][i] = 3


i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "ST1"
CF_ActPresets[factionid][i] = "ST1"
CF_ActModules[factionid][i] = "BF.rte"
CF_ActPrices[factionid][i] = 200
CF_ActDescriptions[factionid][i] = ""
CF_ActUnlockData[factionid][i] = 2500
CF_ActTypes[factionid][i] = CF_ActorTypes.ARMOR;
CF_ActPowers[factionid][i] = 6
CF_ActOffsets[factionid][i] = Vector(0,-10)

-- Void wanderers pre-equipped weapons compatibility
if CF_DiscardableItems then
	CF_DiscardableItems["ST1"] = {"APR-t \"Dyatel\""}
end

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "ST2"
CF_ActPresets[factionid][i] = "ST2"
CF_ActModules[factionid][i] = "BF.rte"
CF_ActPrices[factionid][i] = 450
CF_ActDescriptions[factionid][i] = ""
CF_ActUnlockData[factionid][i] = 4000
CF_ActTypes[factionid][i] = CF_ActorTypes.ARMOR;
CF_ActPowers[factionid][i] = 8
CF_ActOffsets[factionid][i] = Vector(0,-10)

-- Void wanderers pre-equipped weapons compatibility
if CF_DiscardableItems then
	CF_DiscardableItems["ST2"] = {"Dolbak-5m", "Anyusha-D7"}
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
CF_ItmNames[factionid][i] = "PMa"
CF_ItmPresets[factionid][i] = "PMa"
CF_ItmModules[factionid][i] = "BF.rte"
CF_ItmPrices[factionid][i] = 5
CF_ItmDescriptions[factionid][i] = "Standard issue handgun, simple and reliable, though not very accurate"
CF_ItmUnlockData[factionid][i] = 0
CF_ItmTypes[factionid][i] = CF_WeaponTypes.PISTOL;
CF_ItmPowers[factionid][i] = 1

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "F1 granade"
CF_ItmPresets[factionid][i] = "F1 granade"
CF_ItmModules[factionid][i] = "BF.rte"
CF_ItmPrices[factionid][i] = 5
CF_ItmDescriptions[factionid][i] = "The Soviet F-1 hand grenade, nicknamed the limonka (lemon grenade) is an anti-personnel fragmentation, or 'defensive' grenade."
CF_ItmUnlockData[factionid][i] = 450
CF_ItmClasses[factionid][i] = "TDExplosive"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.GRENADE;
CF_ItmPowers[factionid][i] = 2

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "PPC-3"
CF_ItmPresets[factionid][i] = "PPC-3"
CF_ItmModules[factionid][i] = "BF.rte"
CF_ItmPrices[factionid][i] = 25
CF_ItmDescriptions[factionid][i] = "Shortened variant of the AKS-74. It is intended for use mainly with special forces, airborne infantry, rear-echelon support units and armored vehicle crews."
CF_ItmUnlockData[factionid][i] = 500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 2

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "AK-101"
CF_ItmPresets[factionid][i] = "AK-101"
CF_ItmModules[factionid][i] = "BF.rte"
CF_ItmPrices[factionid][i] = 25
CF_ItmDescriptions[factionid][i] = "The AK-101 is an assault rifle of the Kalashnikov series. It is designed with modern and composite materials, including plastics that reduce weight and improve accuracy."
CF_ItmUnlockData[factionid][i] = 0
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 4

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "VSS"
CF_ItmPresets[factionid][i] = "VSS"
CF_ItmModules[factionid][i] = "BF.rte"
CF_ItmPrices[factionid][i] = 32
CF_ItmDescriptions[factionid][i] = "VSS (Vinovka Snaiperskaja Spetsialnaya = Special Sniper Rifle) was designed for special operations."
CF_ItmUnlockData[factionid][i] = 1500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SNIPER;
CF_ItmPowers[factionid][i] = 5

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "SVDh"
CF_ItmPresets[factionid][i] = "SVDh"
CF_ItmModules[factionid][i] = "BF.rte"
CF_ItmPrices[factionid][i] = 32
CF_ItmDescriptions[factionid][i] = "Standard issue sniper rifle"
CF_ItmUnlockData[factionid][i] = 1300
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SNIPER;
CF_ItmPowers[factionid][i] = 4

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "RPm-4k"
CF_ItmPresets[factionid][i] = "RPm-4k"
CF_ItmModules[factionid][i] = "BF.rte"
CF_ItmPrices[factionid][i] = 32
CF_ItmDescriptions[factionid][i] = "Anti ork weapon"
CF_ItmUnlockData[factionid][i] = 1500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 6

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "RG-6"
CF_ItmPresets[factionid][i] = "RG-6"
CF_ItmModules[factionid][i] = "BF.rte"
CF_ItmPrices[factionid][i] = 100
CF_ItmDescriptions[factionid][i] = "It is basically a GP-25 grenade launcher with a rotating cylinder mechanism behind the barrel."
CF_ItmUnlockData[factionid][i] = 1000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 4

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "RPG-7"
CF_ItmPresets[factionid][i] = "RPG-7"
CF_ItmModules[factionid][i] = "BF.rte"
CF_ItmPrices[factionid][i] = 110
CF_ItmDescriptions[factionid][i] = "The RPG-7 is a widely-produced, portable, shoulder-launched, anti-tank rocket propelled grenade weapon."
CF_ItmUnlockData[factionid][i] = 1750
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 8

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "VGe Gauss Rifle"
CF_ItmPresets[factionid][i] = "VGe Gauss Rifle"
CF_ItmModules[factionid][i] = "BF.rte"
CF_ItmPrices[factionid][i] = 32
CF_ItmDescriptions[factionid][i] = "Experimental Gauss Rifle. It uses an electromagnetic field to propel rounds at tremendous speed and pierce almost any obstacle."
CF_ItmUnlockData[factionid][i] = 2000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 8
