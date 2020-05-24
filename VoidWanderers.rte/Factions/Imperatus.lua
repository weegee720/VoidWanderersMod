-- Unique Faction ID
local factionid = "Imperatus";
--print ("Loading "..factionid)

CF_Factions[#CF_Factions + 1] = factionid
	
-- Faction name
CF_FactionNames[factionid] = "Imperatus";
-- Faction description
CF_FactionDescriptions[factionid] = "The Imperatus rely on pure brute force and the reliability of their sturdy and easy to produce armored units. They use simple low rate of fire guns and cannons which tirelessly deals out good damage.";
-- Set true if faction is selectable by player or AI
CF_FactionPlayable[factionid] = true;

-- Modules needed for this faction
CF_RequiredModules[factionid] = {"Base.rte", "Imperatus.rte"}

-- Set faction nature
CF_FactionNatures[factionid] = CF_FactionTypes.SYNTHETIC;


-- Define faction bonuses, in percents
CF_ScanBonuses[factionid] = 0
CF_RelationsBonuses[factionid] = 0
CF_ExpansionBonuses[factionid] = 0

CF_MineBonuses[factionid] = 35
CF_LabBonuses[factionid] = 0
CF_AirfieldBonuses[factionid] = 0
CF_SuperWeaponBonuses[factionid] = 0
CF_FactoryBonuses[factionid] = 35
CF_CloneBonuses[factionid] = 0
CF_HospitalBonuses[factionid] = 0


-- Define brain unit
CF_Brains[factionid] = "Imperatus Brain Robot";
CF_BrainModules[factionid] = "Imperatus.rte";
CF_BrainClasses[factionid] = "AHuman";
CF_BrainPrices[factionid] = 500;

-- Define dropship	
CF_Crafts[factionid] = "Drop Ship MK1";
CF_CraftModules[factionid] = "Base.rte";
CF_CraftClasses[factionid] = "ACDropShip";
CF_CraftPrices[factionid] = 300;

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
CF_ActNames[factionid][i] = "Scouting Robot"
CF_ActPresets[factionid][i] = "Scouting Robot"
CF_ActModules[factionid][i] = "Imperatus.rte"
CF_ActPrices[factionid][i] = 100
CF_ActDescriptions[factionid][i] = "A light-weight robot designed for scouting operations. It's fragile, but can easily get around the battlefield with its extended jetpack fuel supply."
CF_ActUnlockData[factionid][i] = 0
CF_ActTypes[factionid][i] = CF_ActorTypes.LIGHT;
CF_ActPowers[factionid][i] = 1

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "All Purpose Robot"
CF_ActPresets[factionid][i] = "All Purpose Robot"
CF_ActModules[factionid][i] = "Imperatus.rte"
CF_ActPrices[factionid][i] = 160
CF_ActDescriptions[factionid][i] = "Standard all-purpose Imperatus frame, not suitable for prolonged assaults."
CF_ActUnlockData[factionid][i] = 1000
CF_ActTypes[factionid][i] = CF_ActorTypes.LIGHT;
CF_ActPowers[factionid][i] = 3

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Combat Robot"
CF_ActPresets[factionid][i] = "Combat Robot"
CF_ActModules[factionid][i] = "Imperatus.rte"
CF_ActPrices[factionid][i] = 200
CF_ActDescriptions[factionid][i] = "A stronger, more specialized version of the All Purpose Robot, this frame is capable of widthstanding a higher amount of gunshots without shutting down at the cost of lower jetpack power output."
CF_ActUnlockData[factionid][i] = 1500
CF_ActTypes[factionid][i] = CF_ActorTypes.HEAVY;
CF_ActPowers[factionid][i] = 5



i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Anti-Air Drone"
CF_ActPresets[factionid][i] = "Anti-Air Drone"
CF_ActModules[factionid][i] = "Base.rte"
CF_ActPrices[factionid][i] = 225
CF_ActDescriptions[factionid][i] = "Tradstar's Anti-Air Drone sports a machine gun plus a pair of fully automated surface to air missiles for bringing down any unwanted visitors above your landing zone."
CF_ActUnlockData[factionid][i] = 750
CF_ActClasses[factionid][i] = "ACrab"
CF_ActTypes[factionid][i] = CF_ActorTypes.ARMOR;
CF_ActPowers[factionid][i] = 3
CF_ActOffsets[factionid][i] = Vector(0,12)

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Medic Drone"
CF_ActPresets[factionid][i] = "Medic Drone"
CF_ActModules[factionid][i] = "Coalition.rte"
CF_ActPrices[factionid][i] = 110
CF_ActDescriptions[factionid][i] = "Send this into the battlefield and place it near a unit to create a forcefield around it that heals nearby actors."
CF_ActUnlockData[factionid][i] = 500
CF_ActClasses[factionid][i] = "ACrab"
CF_ActTypes[factionid][i] = CF_ActorTypes.ARMOR;
CF_ActPowers[factionid][i] = 0
CF_ActOffsets[factionid][i] = Vector(0,12)


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

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Chunker SP-44"
CF_ItmPresets[factionid][i] = "Chunker SP-44"
CF_ItmModules[factionid][i] = "Imperatus.rte"
CF_ItmPrices[factionid][i] = 25
CF_ItmDescriptions[factionid][i] = "All (or at least most of) the power of a shotgun crammed into a pistol. Excellent for short-range targets."
CF_ItmUnlockData[factionid][i] = 0
CF_ItmTypes[factionid][i] = CF_WeaponTypes.PISTOL;
CF_ItmPowers[factionid][i] = 4

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Slugger GP-03"
CF_ItmPresets[factionid][i] = "Slugger GP-03"
CF_ItmModules[factionid][i] = "Imperatus.rte"
CF_ItmPrices[factionid][i] = 30
CF_ItmDescriptions[factionid][i] = "Some refer to the Desert Eagle as a \"handcannon,\" but the Slugger is far more deserving of the nickname. Firing tiny grenades instead of bullets, this pistol packs some serious power in its unassumingly small frame."
CF_ItmUnlockData[factionid][i] = 650
CF_ItmTypes[factionid][i] = CF_WeaponTypes.PISTOL;
CF_ItmPowers[factionid][i] = 6

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Bullpup AR-14"
CF_ItmPresets[factionid][i] = "Bullpup AR-14"
CF_ItmModules[factionid][i] = "Imperatus.rte"
CF_ItmPrices[factionid][i] = 65
CF_ItmDescriptions[factionid][i] = "Backbone of every Imperatus armored platoon, a nice heavy 8.2x45mm round that penetrates armored targets with ease."
CF_ItmUnlockData[factionid][i] = 0
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 6

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Mauler SG-23"
CF_ItmPresets[factionid][i] = "Mauler SG-23"
CF_ItmModules[factionid][i] = "Imperatus.rte"
CF_ItmPrices[factionid][i] = 90
CF_ItmDescriptions[factionid][i] = "An unbelievably powerful shotgun which takes the term \"chaingun\" seriously by literally firing hot chunks of chain at your enemies."
CF_ItmUnlockData[factionid][i] = 850
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SHOTGUN;
CF_ItmPowers[factionid][i] = 8

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Bulldog GG-49"
CF_ItmPresets[factionid][i] = "Bulldog GG-49"
CF_ItmModules[factionid][i] = "Imperatus.rte"
CF_ItmPrices[factionid][i] = 140
CF_ItmDescriptions[factionid][i] = "Slow-firing, but incredibly powerful, this gatling gun is sure to destroy your opponents."
CF_ItmUnlockData[factionid][i] = 1000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 7

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Banshee HSR-02"
CF_ItmPresets[factionid][i] = "Banshee HSR-02"
CF_ItmModules[factionid][i] = "Imperatus.rte"
CF_ItmPrices[factionid][i] = 145
CF_ItmDescriptions[factionid][i] = "The sniper rifle's big brother.  You only get three rounds to a mag, but why settle for a headshot when you can blow the head clean off with a giant 12.7x130mm cartridge?"
CF_ItmUnlockData[factionid][i] = 1250
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SNIPER;
CF_ItmPowers[factionid][i] = 8

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Devastator CN-72"
CF_ItmPresets[factionid][i] = "Devastator CN-72"
CF_ItmModules[factionid][i] = "Imperatus.rte"
CF_ItmPrices[factionid][i] = 150
CF_ItmDescriptions[factionid][i] = "A devastating anti-air weapon, it can take out a dropship from a nice distance easily with little aim. The proximity fuse on the flak shells insure that they explode at the right distance for maximum damage."
CF_ItmUnlockData[factionid][i] = 1500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SNIPER;
CF_ItmPowers[factionid][i] = 9

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Marauder CN-05"
CF_ItmPresets[factionid][i] = "Marauder CN-05"
CF_ItmModules[factionid][i] = "Imperatus.rte"
CF_ItmPrices[factionid][i] = 120
CF_ItmDescriptions[factionid][i] = "A brutal and powerful automatic cannon. Launches heavy slugs at high velocities that smash the living hell out of their targets. You get 5 shots, but before you get to use them all every opponent will be dead and thus the long reload time won't even bother you."
CF_ItmUnlockData[factionid][i] = 2000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 9
