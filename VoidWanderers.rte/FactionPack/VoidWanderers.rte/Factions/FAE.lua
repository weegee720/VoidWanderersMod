-- Unique Faction ID
local factionid = "FAE";
--print ("Loading "..factionid)

CF_Factions[#CF_Factions + 1] = factionid
	
-- Faction name
CF_FactionNames[factionid] = "FAE";
-- Faction description
CF_FactionDescriptions[factionid] = "A catcanid-felid establishment in MN's union pool. Part science community mod,  part black market clone-to-population hobby, all sold as a Assault Package. Their stage is built off the coattails of MN's TradeStar motives ";
-- Set true if faction is selectable by player or AI
CF_FactionPlayable[factionid] = true;

-- Modules needed for this faction
CF_RequiredModules[factionid] = {"Base.rte", "EAF.rte"}

-- Set faction nature
-- Available values ORGANIC, SYNTHETIC
CF_FactionNatures[factionid] = CF_FactionTypes. ORGANIC, SYNTHETIC;


-- Define faction bonuses, in percents
-- Scan price reduction
CF_ScanBonuses[factionid] = 100
-- Relation points increase
CF_RelationsBonuses[factionid] = 0
-- New HQ build price reduction
CF_ExpansionBonuses[factionid] = 0

-- Gold per turn increase
CF_MineBonuses[factionid] = -30
-- Science per turn increase
CF_LabBonuses[factionid] = 70
-- Delivery time reduction
CF_AirfieldBonuses[factionid] = 25
-- Superweapon targeting reduction
CF_SuperWeaponBonuses[factionid] = 0
-- Unit price reduction
CF_FactoryBonuses[factionid] = 25
-- Body price reduction
CF_CloneBonuses[factionid] = 100
-- HP regeneration increase
CF_HospitalBonuses[factionid] = 70
-- Hack time decrease
CF_HackTimeBonuses[factionid] = 30
-- Hack reward increase
CF_HackRewardBonuses[factionid] = 10

-- Percentage of troops sent to brainhunt or attack player LZ when AI is defending (default - CF_DefaultBrainHuntRatio)
-- If this value is less then default then faction is marked as Defensive if it's more, then as Offensive
CF_BrainHuntRatios[factionid] = 40
	
-- Prefered brain inventory items. Brain gets the best available items of the classes specified in list for free.
-- Default - {CF_WeaponTypes.DIGGER, CF_WeaponTypes.RIFLE}
CF_PreferedBrainInventory[factionid] = {CF_WeaponTypes.HEAVY, CF_WeaponTypes.RIFLE}

-- Define brain unit
CF_Brains[factionid] = "EAF Brain Bot";
CF_BrainModules[factionid] = "EAF.rte";
CF_BrainClasses[factionid] = "AHuman";
CF_BrainPrices[factionid] = 200;

-- Define dropship	
CF_Crafts[factionid] = "EAF Shuttle";
CF_CraftModules[factionid] = "EAF.rte";
CF_CraftClasses[factionid] = "ACDropShip";
CF_CraftPrices[factionid] = 0;

-- Define superweapon script
CF_SuperWeaponScripts[factionid] = "UnmappedLands2.rte/SuperWeapons/Bombing.lua"

-- Define prefered presets to choose from when deploying troops in tactical mode
CF_PreferedTacticalPresets[factionid] = {
		CF_PresetTypes.INFANTRY1,	-- Light + Rifle / Pistol / Grenade
		CF_PresetTypes.INFANTRY2,	-- Heavy + Rifle / Pistol / Grenade
		CF_PresetTypes.INFANTRY2,	-- Add more heavies to the mix
		CF_PresetTypes.INFANTRY2,	-- 
		CF_PresetTypes.SNIPER, 		-- Light + Sniper / Pistol / Grenade
		CF_PresetTypes.SHOTGUN, 	-- Heavy + Shotgun / Pistol / Grenade
		CF_PresetTypes.HEAVY1, 		-- Heavy + Heavy / Rifle / Grenade
		CF_PresetTypes.HEAVY2, 		-- Heavy + Heavy / Grenade / Grenade
		CF_PresetTypes.HEAVY2, 		-- And a bit more heavies
		CF_PresetTypes.ARMOR1, 		-- Armor + Heavy / Pistol / Grenade
		CF_PresetTypes.ARMOR1, 		-- And a bit more armor crabs
		CF_PresetTypes.ARMOR2, 		-- Heavy + Shield / Pistol / Grenade
		CF_PresetTypes.ENGINEER	    -- Light + Digger / Rifle / Grenade
	}


-- Define default tactical AI model
-- Coalition operates using squads
CF_FactionAIModels[factionid] = "SQUAD"

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
CF_ActNames[factionid][i] = "Striker"
CF_ActPresets[factionid][i] = "Strike Infantry"
CF_ActModules[factionid][i] = "EAF.rte"
CF_ActPrices[factionid][i] = 70
CF_ActDescriptions[factionid][i] = "Light, fast, and has a low profile."
CF_ActUnlockData[factionid][i] = 0 -- 0 means available at start
CF_ActTypes[factionid][i] = CF_ActorTypes.LIGHT;
CF_ActPowers[factionid][i] = 3

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Support"
CF_ActPresets[factionid][i] = "Field Medic"
CF_ActModules[factionid][i] = "EAF.rte"
CF_ActPrices[factionid][i] = 70
CF_ActDescriptions[factionid][i] = "Light, fast, and has a low healing rate, but can keep up with other infantry."
CF_ActUnlockData[factionid][i] = 0 -- 0 means available at start
CF_ActTypes[factionid][i] = CF_ActorTypes.LIGHT;
CF_ActPowers[factionid][i] = 3

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Stinger"
CF_ActPresets[factionid][i] = "Assault Infantry"
CF_ActModules[factionid][i] = "EAF.rte"
CF_ActPrices[factionid][i] = 90
CF_ActDescriptions[factionid][i] = "Has better Armor and can take more hits. Great for hitting, and hitting hard"
CF_ActUnlockData[factionid][i] = 200
CF_ActTypes[factionid][i] = CF_ActorTypes.HEAVY;
CF_ActPowers[factionid][i] = 6

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Superiority"
CF_ActPresets[factionid][i] = "Assault Mech"
CF_ActModules[factionid][i] = "EAF.rte"
CF_ActPrices[factionid][i] = 150
CF_ActDescriptions[factionid][i] = "A super armored attack unit. Developed to be used in multiple environments"
CF_ActUnlockData[factionid][i] = 400
CF_ActTypes[factionid][i] = CF_ActorTypes.ARMOR;
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
CF_ItmNames[factionid][i] = "Shield"
CF_ItmPresets[factionid][i] = "Riot Shield"
CF_ItmModules[factionid][i] = "Base.rte"
CF_ItmPrices[factionid][i] = 20
CF_ItmDescriptions[factionid][i] = "This tall shield provides excellent additional frontal protection to the user and it can stop numerous hits before breaking up."
CF_ItmUnlockData[factionid][i] = 0
CF_ItmClasses[factionid][i] = "HeldDevice"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SHIELD;
CF_ItmPowers[factionid][i] = 1

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
CF_ItmNames[factionid][i] = "Pulse Digger"
CF_ItmPresets[factionid][i] = "Pulse Digger"
CF_ItmModules[factionid][i] = "Coalition.rte"
CF_ItmPrices[factionid][i] = 80
CF_ItmDescriptions[factionid][i] = "Coalition's pulse digger. Digs in wide pulses unlike traditional diggers."
CF_ItmUnlockData[factionid][i] = 250
CF_ItmTypes[factionid][i] = CF_WeaponTypes.DIGGER;
CF_ItmPowers[factionid][i] = 3

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Pistol"
CF_ItmPresets[factionid][i] = "Pistol"
CF_ItmModules[factionid][i] = "Coalition.rte"
CF_ItmPrices[factionid][i] = 10
CF_ItmDescriptions[factionid][i] = "Cheap and reliable, the standard sidearm of the Coalition.  Quick reload times and good accuracy make up for the lack of stopping power."
CF_ItmUnlockData[factionid][i] = 0
CF_ItmTypes[factionid][i] = CF_WeaponTypes.PISTOL;
CF_ItmPowers[factionid][i] = 1

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Auto Pistol"
CF_ItmPresets[factionid][i] = "Auto Pistol"
CF_ItmModules[factionid][i] = "Coalition.rte"
CF_ItmPrices[factionid][i] = 25
CF_ItmDescriptions[factionid][i] = "Semi-auto not good enough for you? Now with improved ammo capacity over the standard model, this is the pistol for you! Fires in bursts of 3."
CF_ItmUnlockData[factionid][i] = 400
CF_ItmTypes[factionid][i] = CF_WeaponTypes.PISTOL;
CF_ItmPowers[factionid][i] = 2

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Heavy Pistol"
CF_ItmPresets[factionid][i] = "Heavy Pistol"
CF_ItmModules[factionid][i] = "Coalition.rte"
CF_ItmPrices[factionid][i] = 25
CF_ItmDescriptions[factionid][i] = "Offering more firepower than any other pistol on the market, the Heavy Pistol is a reliable sidearm. It fires slowly, but its shots have some serious stopping power."
CF_ItmUnlockData[factionid][i] = 600
CF_ItmTypes[factionid][i] = CF_WeaponTypes.PISTOL;
CF_ItmPowers[factionid][i] = 3

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "EM Grenade"
CF_ItmPresets[factionid][i] = "D65 EMP Grenade"
CF_ItmModules[factionid][i] = "Darkstorm.rte"
CF_ItmPrices[factionid][i] = 30
CF_ItmDescriptions[factionid][i] = "A grenade which is effectively a large flux compression generator, designed to release both shrapnel and a powerful electromagnetic pulse upon activation."
CF_ItmUnlockData[factionid][i] = 200
CF_ItmClasses[factionid][i] = "TDExplosive"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.GRENADE;
CF_ItmPowers[factionid][i] = 3

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Chaff Grenade"
CF_ItmPresets[factionid][i] = "D61 Chaff Grenade"
CF_ItmModules[factionid][i] = "Darkstorm.rte"
CF_ItmPrices[factionid][i] = 25
CF_ItmDescriptions[factionid][i] = "Upon detonation, this grenade produces clouds of reflective foil scraps. These scraps will confuse electronic detection systems "
CF_ItmUnlockData[factionid][i] = 100
CF_ItmClasses[factionid][i] = "TDExplosive"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.GRENADE;
CF_ItmPowers[factionid][i] = 2

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Plasma Rifle"
CF_ItmPresets[factionid][i] = "Plasma Rifle"
CF_ItmModules[factionid][i] = "EAF.rte"
CF_ItmPrices[factionid][i] = 40
CF_ItmDescriptions[factionid][i] = "High powered Plasma accelerator for medium battle engagment"
CF_ItmUnlockData[factionid][i] = 0
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 4

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Plasma Sub-Rifle"
CF_ItmPresets[factionid][i] = "Plasma Sub-Rifle"
CF_ItmModules[factionid][i] = "EAF.rte"
CF_ItmPrices[factionid][i] = 65
CF_ItmDescriptions[factionid][i] = "Medium powered Plasma accelerator on a Self-defense weapon frame"
CF_ItmUnlockData[factionid][i] = 0
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 6

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Particle Gatling Gun"
CF_ItmPresets[factionid][i] = "Particle Gatling Gun"
CF_ItmModules[factionid][i] = "EAF.rte"
CF_ItmPrices[factionid][i] = 210
CF_ItmDescriptions[factionid][i] = "High powered particle accelerator. Has a high rate-of-fire, an stream of energy"
CF_ItmUnlockData[factionid][i] = 2500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 8

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Plasma Sniper"
CF_ItmPresets[factionid][i] = "Plasma Sniper"
CF_ItmModules[factionid][i] = "EAF.rte"
CF_ItmPrices[factionid][i] = 90
CF_ItmDescriptions[factionid][i] = "High powered concentrated Plasma accelerator for long range use"
CF_ItmUnlockData[factionid][i] = 0
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SNIPER;
CF_ItmPowers[factionid][i] = 5

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Plasma Cannon"
CF_ItmPresets[factionid][i] = "Plasma Cannon"
CF_ItmModules[factionid][i] = "EAF.rte"
CF_ItmPrices[factionid][i] = 140
CF_ItmDescriptions[factionid][i] = "Super powered Plasma accelerator. Fires a super condensed bolt of accelerated plasma. Massive damage guaranteed on hit."
CF_ItmUnlockData[factionid][i] = 400
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 7

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Wave Cannon"
CF_ItmPresets[factionid][i] = "Wave Cannon"
CF_ItmModules[factionid][i] = "EAF.rte"
CF_ItmPrices[factionid][i] = 330
CF_ItmDescriptions[factionid][i] = "Fires three accelerated wave bolts. The wave bolts follows a path calculated by a sine function. On hit the three bolts can deal massive damage."
CF_ItmUnlockData[factionid][i] = 700
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 0
