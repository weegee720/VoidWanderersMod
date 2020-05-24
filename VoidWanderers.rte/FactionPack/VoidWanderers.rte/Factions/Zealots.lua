-- Unique Faction ID
local factionid = "Zealots";
--print ("Loading "..factionid)

CF_Factions[#CF_Factions + 1] = factionid
	
-- Faction name
CF_FactionNames[factionid] = "Zealots";
-- Faction description
CF_FactionDescriptions[factionid] = "";
-- Set true if faction is selectable by player or AI
CF_FactionPlayable[factionid] = true;

-- Modules needed for this faction
CF_RequiredModules[factionid] = {"Base.rte", "UniTec.rte", "UT_Zealots.rte"}

-- Set faction nature
-- Available values ORGANIC, SYNTHETIC
CF_FactionNatures[factionid] = CF_FactionTypes.ORGANIC;


-- Define faction bonuses, in percents
-- Scan price reduction
CF_ScanBonuses[factionid] = 90
-- Relation points increase
CF_RelationsBonuses[factionid] = 0
-- Hew HQ build price reduction
CF_ExpansionBonuses[factionid] = 0

-- Gold per turn increase
CF_MineBonuses[factionid] = 0
-- Science per turn increase
CF_LabBonuses[factionid] = 0
-- Delivery time reduction
CF_AirfieldBonuses[factionid] = 25
-- Superweapon targeting reduction
CF_SuperWeaponBonuses[factionid] = 0
-- Unit price reduction
CF_FactoryBonuses[factionid] = 0
-- Body price reduction
CF_CloneBonuses[factionid] = 0
-- HP regeneration increase
CF_HospitalBonuses[factionid] = 0
-- Hack time decrease
CF_HackTimeBonuses[factionid] = 25
-- Hack reward increase
CF_HackRewardBonuses[factionid] = 25

-- Percentage of troops sent to brainhunt or attack player LZ when AI is defending (default - CF_DefaultBrainHuntRatio)
-- If this value is less then default then faction is marked as Defensive if it's more, then as Offensive
CF_BrainHuntRatios[factionid] = 40
	
-- Prefered brain inventory items. Brain gets the best available items of the classes specified in list for free.
-- Default - {CF_WeaponTypes.DIGGER, CF_WeaponTypes.RIFLE}
CF_PreferedBrainInventory[factionid] = {CF_WeaponTypes.HEAVY, CF_WeaponTypes.RIFLE}

-- Define brain unit
CF_Brains[factionid] = "Xux";
CF_BrainModules[factionid] = "UT_Zealots.rte";
CF_BrainClasses[factionid] = "AHuman";
CF_BrainPrices[factionid] = 500;

-- Define dropship	
CF_Crafts[factionid] = "Zealot Saucer";
CF_CraftModules[factionid] = "UT_Zealots.rte";
CF_CraftClasses[factionid] = "ACDropShip";
CF_CraftPrices[factionid] = 200;

-- Define superweapon script
CF_SuperWeaponScripts[factionid] = "UnmappedLands2.rte/SuperWeapons/Bombing.lua"

-- Set this flag to indicate that actors of this faction come with pre-equipped weapons
-- Although shield members are pre-equipped they hold only light and pretty useless weapons
-- so I'll just leave them as ordinary faction
--CF_PreEquippedActors[factionid] = true

-- Define prefered presets to choose from when deploying troops in tactical mode
CF_PreferedTacticalPresets[factionid] = {
		CF_PresetTypes.INFANTRY1,	-- Light + Rifle / Pistol / Grenade
		CF_PresetTypes.INFANTRY2,	-- Heavy + Rifle / Pistol / Grenade
		CF_PresetTypes.SNIPER, 		-- Light + Sniper / Pistol / Grenade
		CF_PresetTypes.SHOTGUN, 	-- Heavy + Shotgun / Pistol / Grenade
		CF_PresetTypes.HEAVY1, 		-- Heavy + Heavy / Rifle / Grenade
		CF_PresetTypes.HEAVY2, 		-- Heavy + Heavy / Grenade / Grenade
		CF_PresetTypes.ARMOR2, 		-- Heavy + Shield / Pistol / Grenade
		CF_PresetTypes.ENGINEER	    -- Light + Digger / Rifle / Grenade
	}


-- Define default tactical AI model
-- Coalition operates using squads
CF_FactionAIModels[factionid] = "CONSOLE HUNTERS"

-- Define research queue. This queue controls how AI will research available tech
-- Weapon, item and actor ID's:
-- PS - pistol
-- RF - rifle
-- SH - shotgun
-- SN - sniper
-- HV - heavy
-- SD - shield
-- DG - digger
-- GR - grenade
-- LA - light actor
-- HA - heavy actor
-- AA - armoured actor
-- TA - turret actor
-- Syntax is simple, for example:
-- PS1-RF2+ = try to research any pistol with power level 1 if it's not available then try to research 
-- any rifle with power level 2 or higher. When ai finishes queue it starts from the begining. You can
-- leave queue unspecified in this case UL2 will use it's default queue.
CF_ResearchQueues[factionid] = "PS1+SH1+GR1+SH2+SD1+HA1+DG1+SN1+HV1+RF1+AA1+TA1+LA1+";

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
CF_ActNames[factionid][i] = "Xaii"
CF_ActPresets[factionid][i] = "Xaii"
CF_ActModules[factionid][i] = "UT_Zealots.rte"
CF_ActPrices[factionid][i] = 195
CF_ActDescriptions[factionid][i] = "Zealotian. Xaii, one of many blue maniacal bigheads with a taste for blood."
CF_ActUnlockData[factionid][i] = 0
CF_ActTypes[factionid][i] = CF_ActorTypes.LIGHT;
CF_ActPowers[factionid][i] = 3

local i = 0
i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Xiin"
CF_ActPresets[factionid][i] = "Xiin"
CF_ActModules[factionid][i] = "UT_Zealots.rte"
CF_ActPrices[factionid][i] = 195
CF_ActDescriptions[factionid][i] = "Zealotian. Xiin and her brethren are very fanatical, protecting the gold-rich planet. No one knows why."
CF_ActUnlockData[factionid][i] = 600
CF_ActTypes[factionid][i] = CF_ActorTypes.LIGHT;
CF_ActPowers[factionid][i] = 900

local i = 0
i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Plox"
CF_ActPresets[factionid][i] = "Plox"
CF_ActModules[factionid][i] = "UT_Zealots.rte"
CF_ActPrices[factionid][i] = 225
CF_ActDescriptions[factionid][i] = "Zealotian. Plox' fanaticism goes far, risking death by having his body infused with green crystal residue for a greater physique."
CF_ActUnlockData[factionid][i] = 900
CF_ActTypes[factionid][i] = CF_ActorTypes.LIGHT;
CF_ActPowers[factionid][i] = 1200

local i = 0
i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Rhix"
CF_ActPresets[factionid][i] = "Rhix"
CF_ActModules[factionid][i] = "UT_Zealots.rte"
CF_ActPrices[factionid][i] = 275
CF_ActDescriptions[factionid][i] = "Zealotian. Rhix wears a state-of-the-art thin zealotianium mask, greatly increasing his head's damage resistance."
CF_ActUnlockData[factionid][i] = 1500
CF_ActTypes[factionid][i] = CF_ActorTypes.HEAVY;
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
CF_ItmNames[factionid][i] = "Zealot Shield"
CF_ItmPresets[factionid][i] = "Zealot Shield"
CF_ItmModules[factionid][i] = "UT_Zealots.rte"
CF_ItmPrices[factionid][i] = 30
CF_ItmDescriptions[factionid][i] = "Zealotian ingenuity. These things even beat our high-end Force Shields."
CF_ItmUnlockData[factionid][i] = 700
CF_ItmClasses[factionid][i] = "HeldDevice"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SHIELD;
CF_ItmPowers[factionid][i] = 4

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
CF_ItmNames[factionid][i] = "Zealot Repeater"
CF_ItmPresets[factionid][i] = "Zealot Repeater"
CF_ItmModules[factionid][i] = "UT_Zealots.rte"
CF_ItmPrices[factionid][i] = 60
CF_ItmDescriptions[factionid][i] = "A rather small gun; Zealot standard issue."
CF_ItmUnlockData[factionid][i] = 0
CF_ItmTypes[factionid][i] = CF_WeaponTypes.PISTOL;
CF_ItmPowers[factionid][i] = 5

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Zealot Punisher"
CF_ItmPresets[factionid][i] = "Zealot Punisher"
CF_ItmModules[factionid][i] = "UT_Zealots.rte"
CF_ItmPrices[factionid][i] = 80
CF_ItmDescriptions[factionid][i] = "This Zealot gun behaves similar to a shotgun."
CF_ItmUnlockData[factionid][i] = 500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SHOTGUN;
CF_ItmPowers[factionid][i] = 3

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Zealot Equalizer"
CF_ItmPresets[factionid][i] = "Zealot Equalizer"
CF_ItmModules[factionid][i] = "UT_Zealots.rte"
CF_ItmPrices[factionid][i] = 120
CF_ItmDescriptions[factionid][i] = "A fast-firing energy weapon. It fires two bolts per shot."
CF_ItmUnlockData[factionid][i] = 0
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 6

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Zealot Eraser"
CF_ItmPresets[factionid][i] = "Zealot Eraser"
CF_ItmModules[factionid][i] = "UT_Zealots.rte"
CF_ItmPrices[factionid][i] = 180
CF_ItmDescriptions[factionid][i] = "This heavy gun buzzes with power, ready to conjure something devastating."
CF_ItmUnlockData[factionid][i] = 1000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 6

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Zealot Executioner"
CF_ItmPresets[factionid][i] = "Zealot Executioner"
CF_ItmModules[factionid][i] = "UT_Zealots.rte"
CF_ItmPrices[factionid][i] = 120
CF_ItmDescriptions[factionid][i] = "This gun appears to be a long range energy sniper rifle."
CF_ItmUnlockData[factionid][i] = 1200
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SNIPER;
CF_ItmPowers[factionid][i] = 6

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Zealot Avenger"
CF_ItmPresets[factionid][i] = "Zealot Avenger"
CF_ItmModules[factionid][i] = "UT_Zealots.rte"
CF_ItmPrices[factionid][i] = 200
CF_ItmDescriptions[factionid][i] = "My oh my. A continuous stream of green death."
CF_ItmUnlockData[factionid][i] = 2500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 9

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Zealot Redeemer"
CF_ItmPresets[factionid][i] = "Zealot Redeemer"
CF_ItmModules[factionid][i] = "UT_Zealots.rte"
CF_ItmPrices[factionid][i] = 250
CF_ItmDescriptions[factionid][i] = "A wonderful Zealot surprise kept in a neat giant package. TAP FIRE to launch homing missiles. You can also control the missiles manually by holding FIRE. Direct the missile when controlling it by aiming in the direction you want it to go. Tap FIRE to detonate the missile and CROUCH to return control back to your unit."
CF_ItmUnlockData[factionid][i] = 2000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 0

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Zealot Grenade Belt"
CF_ItmPresets[factionid][i] = "Zealot Grenade Belt"
CF_ItmModules[factionid][i] = "UT_Zealots.rte"
CF_ItmPrices[factionid][i] = 25
CF_ItmDescriptions[factionid][i] = ""
CF_ItmUnlockData[factionid][i] = 1000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.GRENADE;
CF_ItmPowers[factionid][i] = 6


