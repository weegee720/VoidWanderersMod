-- S.H.I.E.L.D. http://forums.datarealms.com/viewtopic.php?f=61&t=11062 by Gotcha! 
-- UL2-VW Compatible version https://dl.dropboxusercontent.com/u/1741337/VoidWanderers/SupportedMods/UniTec_VW_UL2_B01.zip
-- Faction file by weegee
--
-- Unique Faction ID
local factionid = "S.H.I.E.L.D.";
--print ("Loading "..factionid)

CF_Factions[#CF_Factions + 1] = factionid
	
-- Faction name
CF_FactionNames[factionid] = "S.H.I.E.L.D.";
-- Faction description
CF_FactionDescriptions[factionid] = "SHIELD has better things to do than fighting over planets, but a recent budget cut from Earth's government brought SHIELD on the edge of bankruptcy. Thinking it will be easy, Jack has commanded his people to maintain several gold mines to keep his organization running.";
-- Set true if faction is selectable by player or AI
CF_FactionPlayable[factionid] = true;

-- Modules needed for this faction
CF_RequiredModules[factionid] = {"Base.rte", "UniTec.rte", "UT_SHIELD.rte"}

-- Set faction nature
-- Available values ORGANIC, SYNTHETIC
CF_FactionNatures[factionid] = CF_FactionTypes.ORGANIC;


-- Define faction bonuses, in percents
-- Scan price reduction
CF_ScanBonuses[factionid] = 0
-- Relation points increase
CF_RelationsBonuses[factionid] = 50
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
CF_HospitalBonuses[factionid] = 50
-- Hack time decrease
CF_HackTimeBonuses[factionid] = 50
-- Hack reward increase
CF_HackRewardBonuses[factionid] = 25

-- Percentage of troops sent to brainhunt or attack player LZ when AI is defending (default - CF_DefaultBrainHuntRatio)
-- If this value is less then default then faction is marked as Defensive if it's more, then as Offensive
CF_BrainHuntRatios[factionid] = 40
	
-- Prefered brain inventory items. Brain gets the best available items of the classes specified in list for free.
-- Default - {CF_WeaponTypes.DIGGER, CF_WeaponTypes.RIFLE}
CF_PreferedBrainInventory[factionid] = {CF_WeaponTypes.HEAVY, CF_WeaponTypes.RIFLE}

-- Define brain unit
CF_Brains[factionid] = "Jack";
CF_BrainModules[factionid] = "UT_SHIELD.rte";
CF_BrainClasses[factionid] = "AHuman";
CF_BrainPrices[factionid] = 500;

-- Define dropship	
CF_Crafts[factionid] = "Drop Ship MK1";
CF_CraftModules[factionid] = "Base.rte";
CF_CraftClasses[factionid] = "ACDropShip";
CF_CraftPrices[factionid] = 120;

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
CF_ActNames[factionid][i] = "Mike"
CF_ActPresets[factionid][i] = "Mike"
CF_ActModules[factionid][i] = "UT_Shield.rte"
CF_ActPrices[factionid][i] = 120
CF_ActDescriptions[factionid][i] = "S.H.I.E.L.D. member. Ranking: Private. Specialization: Assault."
CF_ActUnlockData[factionid][i] = 0
CF_ActTypes[factionid][i] = CF_ActorTypes.LIGHT;
CF_ActPowers[factionid][i] = 3
--if CF_ItemsToRemove then
--	CF_ItemsToRemove["Mike"] = {"FN Five-seveN"}
--end

local i = 0
i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Jess"
CF_ActPresets[factionid][i] = "Jess"
CF_ActModules[factionid][i] = "UT_Shield.rte"
CF_ActPrices[factionid][i] = 150
CF_ActDescriptions[factionid][i] = "S.H.I.E.L.D. member. Ranking: Corporal. Specialization: Combat Medic."
CF_ActUnlockData[factionid][i] = 0
CF_ActTypes[factionid][i] = CF_ActorTypes.LIGHT;
CF_ActPowers[factionid][i] = 3
--if CF_ItemsToRemove then
--	CF_ItemsToRemove["Jess"] = {"FN Five-seveN", "MedKit","MedKit"}
--end

local i = 0
i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Cougar"
CF_ActPresets[factionid][i] = "Cougar"
CF_ActModules[factionid][i] = "UT_Shield.rte"
CF_ActPrices[factionid][i] = 120
CF_ActDescriptions[factionid][i] = "S.H.I.E.L.D. member. Ranking: Private. Specialization: Fire Support."
CF_ActUnlockData[factionid][i] = 0
CF_ActTypes[factionid][i] = CF_ActorTypes.LIGHT;
CF_ActPowers[factionid][i] = 3
--if CF_ItemsToRemove then
--	CF_ItemsToRemove["Cougar"] = {"Desert Eagle"}
--end

local i = 0
i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Shadow"
CF_ActPresets[factionid][i] = "Shadow"
CF_ActModules[factionid][i] = "UT_Shield.rte"
CF_ActPrices[factionid][i] = 120
CF_ActDescriptions[factionid][i] = "S.H.I.E.L.D. member. Ranking: Corporal. Specialization: Stealth."
CF_ActUnlockData[factionid][i] = 0
CF_ActTypes[factionid][i] = CF_ActorTypes.LIGHT;
CF_ActPowers[factionid][i] = 3
--if CF_ItemsToRemove then
--	CF_ItemsToRemove["Shadow"] = {"Knife"}
--end

local i = 0
i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Tanya"
CF_ActPresets[factionid][i] = "Tanya"
CF_ActModules[factionid][i] = "UT_Shield.rte"
CF_ActPrices[factionid][i] = 120
CF_ActDescriptions[factionid][i] = "S.H.I.E.L.D. member. Ranking: Sergeant. Specialization: Sniper."
CF_ActUnlockData[factionid][i] = 500
CF_ActTypes[factionid][i] = CF_ActorTypes.LIGHT;
CF_ActPowers[factionid][i] = 3
--if CF_ItemsToRemove then
--	CF_ItemsToRemove["Tanya"] = {"Beretta 93R"}
--end

local i = 0
i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Gus"
CF_ActPresets[factionid][i] = "Gus"
CF_ActModules[factionid][i] = "UT_Shield.rte"
CF_ActPrices[factionid][i] = 140
CF_ActDescriptions[factionid][i] = "S.H.I.E.L.D. member. Ranking: Staff Sergeant. Specialization: Assault."
CF_ActUnlockData[factionid][i] = 800
CF_ActTypes[factionid][i] = CF_ActorTypes.LIGHT;
CF_ActPowers[factionid][i] = 4
--if CF_ItemsToRemove then
--	CF_ItemsToRemove["Gus"] = {"Taurus Raging Bull"}
--end

local i = 0
i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Grizzly"
CF_ActPresets[factionid][i] = "Grizzly"
CF_ActModules[factionid][i] = "UT_Shield.rte"
CF_ActPrices[factionid][i] = 140
CF_ActDescriptions[factionid][i] = "S.H.I.E.L.D. member. Ranking: Corporal. Specialization: Heavy Weapons."
CF_ActUnlockData[factionid][i] = 800
CF_ActTypes[factionid][i] = CF_ActorTypes.LIGHT;
CF_ActPowers[factionid][i] = 4
--if CF_ItemsToRemove then
--	CF_ItemsToRemove["Grizzly"] = {"Ingram M10"}
--end

local i = 0
i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Blood"
CF_ActPresets[factionid][i] = "Blood"
CF_ActModules[factionid][i] = "UT_Shield.rte"
CF_ActPrices[factionid][i] = 160
CF_ActDescriptions[factionid][i] = "S.H.I.E.L.D. member. Ranking: Corporal. Specialization: Fire Support."
CF_ActUnlockData[factionid][i] = 1200
CF_ActTypes[factionid][i] = CF_ActorTypes.LIGHT;
CF_ActPowers[factionid][i] = 5
--if CF_ItemsToRemove then
--	CF_ItemsToRemove["Blood"] = {"Taurus Raging Bull"}
--end

local i = 0
i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Lynx"
CF_ActPresets[factionid][i] = "Lynx"
CF_ActModules[factionid][i] = "UT_Shield.rte"
CF_ActPrices[factionid][i] = 160
CF_ActDescriptions[factionid][i] = "S.H.I.E.L.D. member. Ranking: Lieutenant. Specialization: Sniper."
CF_ActUnlockData[factionid][i] = 1500
CF_ActTypes[factionid][i] = CF_ActorTypes.HEAVY;
CF_ActPowers[factionid][i] = 6
--if CF_ItemsToRemove then
--	CF_ItemsToRemove["Lynx"] = {"Desert Eagle"}
--end

local i = 0
i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Scarlett"
CF_ActPresets[factionid][i] = "Scarlett"
CF_ActModules[factionid][i] = "UT_Shield.rte"
CF_ActPrices[factionid][i] = 160
CF_ActDescriptions[factionid][i] = "S.H.I.E.L.D. member. Ranking: Colonel. Specialization: Assault."
CF_ActUnlockData[factionid][i] = 2000
CF_ActTypes[factionid][i] = CF_ActorTypes.HEAVY;
CF_ActPowers[factionid][i] = 7
--if CF_ItemsToRemove then
--	CF_ItemsToRemove["Scarlett"] = {"HK MP7"}
--end

local i = 0
i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Bunker"
CF_ActPresets[factionid][i] = "Bunker"
CF_ActModules[factionid][i] = "UT_Shield.rte"
CF_ActPrices[factionid][i] = 180
CF_ActDescriptions[factionid][i] = "A very durable stationary bunker for defending strategic areas. Place on solid and flat ground if possible."
CF_ActUnlockData[factionid][i] = 1800
CF_ActClasses[factionid][i] = "ACrab"
CF_ActTypes[factionid][i] = CF_ActorTypes.TURRET;
CF_ActPowers[factionid][i] = 7

local i = 0
i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Missile Barrage"
CF_ActPresets[factionid][i] = "Missile Barrage"
CF_ActModules[factionid][i] = "UT_Shield.rte"
CF_ActPrices[factionid][i] = 250
CF_ActDescriptions[factionid][i] = "This modified SAM launches a barrage of dumbfire missiles. Place on flat and solid ground if possible."
CF_ActUnlockData[factionid][i] = 2500
CF_ActClasses[factionid][i] = "ACrab"
CF_ActTypes[factionid][i] = CF_ActorTypes.TURRET;
CF_ActPowers[factionid][i] = 9



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
CF_ItmNames[factionid][i] = "Riot Shield XL"
CF_ItmPresets[factionid][i] = "Riot Shield XL"
CF_ItmModules[factionid][i] = "UT_Shield.rte"
CF_ItmPrices[factionid][i] = 6
CF_ItmDescriptions[factionid][i] = "A riot shield with an added extension to keep your troops' scalps intact."
CF_ItmUnlockData[factionid][i] = 500
CF_ItmClasses[factionid][i] = "HeldDevice"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SHIELD;
CF_ItmPowers[factionid][i] = 1

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Titanium Shield"
CF_ItmPresets[factionid][i] = "Titanium Shield"
CF_ItmModules[factionid][i] = "UT_Shield.rte"
CF_ItmPrices[factionid][i] = 10
CF_ItmDescriptions[factionid][i] = "Protect yourself from the elements: Wind, fire, rain and bullets!"
CF_ItmUnlockData[factionid][i] = 800
CF_ItmClasses[factionid][i] = "HeldDevice"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SHIELD;
CF_ItmPowers[factionid][i] = 3

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
CF_ItmNames[factionid][i] = "Desert Eagle"
CF_ItmPresets[factionid][i] = "Desert Eagle"
CF_ItmModules[factionid][i] = "UT_Shield.rte"
CF_ItmPrices[factionid][i] = 10
CF_ItmDescriptions[factionid][i] = "When a warship's cannon is not readily available, why not try a handheld one?"
CF_ItmUnlockData[factionid][i] = 0
CF_ItmTypes[factionid][i] = CF_WeaponTypes.PISTOL;
CF_ItmPowers[factionid][i] = 3

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "FN Five-seveN"
CF_ItmPresets[factionid][i] = "FN Five-seveN"
CF_ItmModules[factionid][i] = "UT_Shield.rte"
CF_ItmPrices[factionid][i] = 10
CF_ItmDescriptions[factionid][i] = "Small, fast-firing and reliable. Keep one at your side at all times; you won't regret it."
CF_ItmUnlockData[factionid][i] = 0
CF_ItmTypes[factionid][i] = CF_WeaponTypes.PISTOL;
CF_ItmPowers[factionid][i] = 3

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Taurus Raging Bull"
CF_ItmPresets[factionid][i] = "Taurus Raging Bull"
CF_ItmModules[factionid][i] = "UT_Shield.rte"
CF_ItmPrices[factionid][i] = 10
CF_ItmDescriptions[factionid][i] = "This pistol is supposedly strong enough to kill an elephant. We love elephants so we ask you to empty these towards humans instead."
CF_ItmUnlockData[factionid][i] = 0
CF_ItmTypes[factionid][i] = CF_WeaponTypes.PISTOL;
CF_ItmPowers[factionid][i] = 4

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Beretta 93R"
CF_ItmPresets[factionid][i] = "Beretta 93R"
CF_ItmModules[factionid][i] = "UT_Shield.rte"
CF_ItmPrices[factionid][i] = 20
CF_ItmDescriptions[factionid][i] = "Semi-automatic, wielding one of these makes you a force to be reckoned with."
CF_ItmUnlockData[factionid][i] = 0
CF_ItmTypes[factionid][i] = CF_WeaponTypes.PISTOL;
CF_ItmPowers[factionid][i] = 4

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "HK MP7"
CF_ItmPresets[factionid][i] = "HK MP7"
CF_ItmModules[factionid][i] = "UT_Shield.rte"
CF_ItmPrices[factionid][i] = 25
CF_ItmDescriptions[factionid][i] = "Small enough to be conceilable. Surprise your enemy with a spray of bullets coming from under your coat!"
CF_ItmUnlockData[factionid][i] = 0
CF_ItmTypes[factionid][i] = CF_WeaponTypes.PISTOL;
CF_ItmPowers[factionid][i] = 5

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Ingram M10"
CF_ItmPresets[factionid][i] = "Ingram M10"
CF_ItmModules[factionid][i] = "UT_Shield.rte"
CF_ItmPrices[factionid][i] = 30
CF_ItmDescriptions[factionid][i] = " One of the best-known machine pistols in the galaxy. Some say even Huraiian soldiers used them while raiding planet Nubiri back in 2037."
CF_ItmUnlockData[factionid][i] = 0
CF_ItmTypes[factionid][i] = CF_WeaponTypes.PISTOL;
CF_ItmPowers[factionid][i] = 5





i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "HK MP5K"
CF_ItmPresets[factionid][i] = "HK MP5K"
CF_ItmModules[factionid][i] = "UT_Shield.rte"
CF_ItmPrices[factionid][i] = 30
CF_ItmDescriptions[factionid][i] = "Loved by terrorists and counter-terrorists alike; we are sure that you will love these too!"
CF_ItmUnlockData[factionid][i] = 500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 3

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "FAMAE SAF"
CF_ItmPresets[factionid][i] = "FAMAE SAF"
CF_ItmModules[factionid][i] = "UT_Shield.rte"
CF_ItmPrices[factionid][i] = 35
CF_ItmDescriptions[factionid][i] = "These SMGs come equipped with integral silencers. Combined with a ridiculous rate of fire these make quite potent silent assassins."
CF_ItmUnlockData[factionid][i] = 500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 3

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "HK UMP"
CF_ItmPresets[factionid][i] = "HK UMP"
CF_ItmModules[factionid][i] = "UT_Shield.rte"
CF_ItmPrices[factionid][i] = 40
CF_ItmDescriptions[factionid][i] = "Sized like an SMG but packing an assault rifle's punch."
CF_ItmUnlockData[factionid][i] = 600
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 4

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "FN P90"
CF_ItmPresets[factionid][i] = "FN P90"
CF_ItmModules[factionid][i] = "UT_Shield.rte"
CF_ItmPrices[factionid][i] = 40
CF_ItmDescriptions[factionid][i] = "The design might be over a century old, but they are still high-tech compared with today's technology."
CF_ItmUnlockData[factionid][i] = 700
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 4





i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Serbu Super Shorty"
CF_ItmPresets[factionid][i] = "Serbu Super Shorty"
CF_ItmModules[factionid][i] = "UT_Shield.rte"
CF_ItmPrices[factionid][i] = 15
CF_ItmDescriptions[factionid][i] = "A small gun with a small magazine and a small range. What makes up for it? It's light, deadly up close and... you can carry two!"
CF_ItmUnlockData[factionid][i] = 400
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SHOTGUN;
CF_ItmPowers[factionid][i] = 3

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Franchi SPAS-12"
CF_ItmPresets[factionid][i] = "Franchi SPAS-12"
CF_ItmModules[factionid][i] = "UT_Shield.rte"
CF_ItmPrices[factionid][i] = 25
CF_ItmDescriptions[factionid][i] = "Suitable for lockpicking, clubbing, maiming and killing... A versatile weapon we say."
CF_ItmUnlockData[factionid][i] = 600
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SHOTGUN;
CF_ItmPowers[factionid][i] = 5

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Pancor Jackhammer"
CF_ItmPresets[factionid][i] = "Pancor Jackhammer"
CF_ItmModules[factionid][i] = "UT_Shield.rte"
CF_ItmPrices[factionid][i] = 30
CF_ItmDescriptions[factionid][i] = "Back when it was developed it was both modern and it kicked serious behind. Nowadays we're stuck with just the latter, but who's complaining?"
CF_ItmUnlockData[factionid][i] = 1000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SHOTGUN;
CF_ItmPowers[factionid][i] = 6

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "HK CAWS"
CF_ItmPresets[factionid][i] = "HK CAWS"
CF_ItmModules[factionid][i] = "UT_Shield.rte"
CF_ItmPrices[factionid][i] = 40
CF_ItmDescriptions[factionid][i] = "This is about the most powerful shotgun for sale in our arsenal. A weapon of this magnitude deserves to be feared."
CF_ItmUnlockData[factionid][i] = 1200
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SHOTGUN;
CF_ItmPowers[factionid][i] = 7

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "AA-12"
CF_ItmPresets[factionid][i] = "AA-12"
CF_ItmModules[factionid][i] = "UT_Shield.rte"
CF_ItmPrices[factionid][i] = 60
CF_ItmDescriptions[factionid][i] = "These shotguns are delivered with free FRAG-12 magazines, which leave quite a mess to be honest."
CF_ItmUnlockData[factionid][i] = 1500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SHOTGUN;
CF_ItmPowers[factionid][i] = 9





i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "FN FAL"
CF_ItmPresets[factionid][i] = "FN FAL"
CF_ItmModules[factionid][i] = "UT_Shield.rte"
CF_ItmPrices[factionid][i] = 50
CF_ItmDescriptions[factionid][i] = "The Fabrique Nationale FAL 50.63 has a shorter barrel and light folding butt but retains its deadliness."
CF_ItmUnlockData[factionid][i] = 0
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 4

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "HK G36"
CF_ItmPresets[factionid][i] = "HK G36"
CF_ItmModules[factionid][i] = "UT_Shield.rte"
CF_ItmPrices[factionid][i] = 60
CF_ItmDescriptions[factionid][i] = "Brilliant design. Comes with a free integrated reflex scope and underslung shotgun."
CF_ItmUnlockData[factionid][i] = 600
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 5

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Tavor TAR-21"
CF_ItmPresets[factionid][i] = "Tavor TAR-21"
CF_ItmModules[factionid][i] = "UT_Shield.rte"
CF_ItmPrices[factionid][i] = 55
CF_ItmDescriptions[factionid][i] = "This compact and lightweight assault rifle has a very fast rate of fire. We've attached a custom suppressor on it for no extra charge."
CF_ItmUnlockData[factionid][i] = 600
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 5

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "FAMAS G2"
CF_ItmPresets[factionid][i] = "FAMAS G2"
CF_ItmModules[factionid][i] = "UT_Shield.rte"
CF_ItmPrices[factionid][i] = 60
CF_ItmDescriptions[factionid][i] = "The FAMAS G2 has, among other things, an improved rate of fire over its predecessor. Emptying a clip at this speed is a frightening sight to behold."
CF_ItmUnlockData[factionid][i] = 700
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 5

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "FN F2000"
CF_ItmPresets[factionid][i] = "FN F2000"
CF_ItmModules[factionid][i] = "UT_Shield.rte"
CF_ItmPrices[factionid][i] = 60
CF_ItmDescriptions[factionid][i] = "Firing both standard 5.56 bullets and grenades makes this rifle a suitable gift for even the most spoiled soldier."
CF_ItmUnlockData[factionid][i] = 1000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 6

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "HK G11"
CF_ItmPresets[factionid][i] = "HK G11"
CF_ItmModules[factionid][i] = "UT_Shield.rte"
CF_ItmPrices[factionid][i] = 60
CF_ItmDescriptions[factionid][i] = "Caseless 4.7 mm ammunition fired at dazzling speeds; It was our product of the year in 2028 and is still a very popular toy this very day."
CF_ItmUnlockData[factionid][i] = 1250
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 6





i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Saco M60"
CF_ItmPresets[factionid][i] = "Saco M60"
CF_ItmModules[factionid][i] = "UT_Shield.rte"
CF_ItmPrices[factionid][i] = 60
CF_ItmDescriptions[factionid][i] = "Rambo, one of Earth's greatest fictional heroes, used one of these once. So what are you waiting for? Buy buy buy!"
CF_ItmUnlockData[factionid][i] = 1500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 7

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "HK 21"
CF_ItmPresets[factionid][i] = "HK 21"
CF_ItmModules[factionid][i] = "UT_Shield.rte"
CF_ItmPrices[factionid][i] = 70
CF_ItmDescriptions[factionid][i] = "This reliable Heckler & Koch light machine gun is the ultimate gift that keeps on giving. (Death, that is.)"
CF_ItmUnlockData[factionid][i] = 1800
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 8

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Browning M2"
CF_ItmPresets[factionid][i] = "Browning M2"
CF_ItmModules[factionid][i] = "UT_Shield.rte"
CF_ItmPrices[factionid][i] = 80
CF_ItmDescriptions[factionid][i] = "The very heavy .50 Browning M2 will surely leave a lasting impression on any unfortunate person standing in front of the barrel. Usually through loss of limbs."
CF_ItmUnlockData[factionid][i] = 2000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 9






i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "HK PSG-1"
CF_ItmPresets[factionid][i] = "HK PSG-1"
CF_ItmModules[factionid][i] = "UT_Shield.rte"
CF_ItmPrices[factionid][i] = 60
CF_ItmDescriptions[factionid][i] = "H&K's police force sniper rifle variant. Trust us when we say that it's effective in the military as well."
CF_ItmUnlockData[factionid][i] = 800
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SNIPER;
CF_ItmPowers[factionid][i] = 4

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "AI AWM"
CF_ItmPresets[factionid][i] = "AI AWM"
CF_ItmModules[factionid][i] = "UT_Shield.rte"
CF_ItmPrices[factionid][i] = 70
CF_ItmDescriptions[factionid][i] = "This sniper rifle fires .338 Lapua Magnum rounds, giving it accurate death at a great range."
CF_ItmUnlockData[factionid][i] = 900
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SNIPER;
CF_ItmPowers[factionid][i] = 5

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Barrett M82"
CF_ItmPresets[factionid][i] = "Barrett M82"
CF_ItmModules[factionid][i] = "UT_Shield.rte"
CF_ItmPrices[factionid][i] = 85
CF_ItmDescriptions[factionid][i] = "This M82A2 bullpup anti-materiel rifle never made it into full production, until we started producing it that is. Handy to use versus tough targets!"
CF_ItmUnlockData[factionid][i] = 1500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SNIPER;
CF_ItmPowers[factionid][i] = 7

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Gepard M1"
CF_ItmPresets[factionid][i] = "Gepard M1"
CF_ItmModules[factionid][i] = "UT_Shield.rte"
CF_ItmPrices[factionid][i] = 75
CF_ItmDescriptions[factionid][i] = "Reloading this anti-materiel rifle is a pain, but the amazing range makes up for this. This rifle really shines when used against drop ships."
CF_ItmUnlockData[factionid][i] = 1800
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SNIPER;
CF_ItmPowers[factionid][i] = 6

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "CheyTac M200"
CF_ItmPresets[factionid][i] = "CheyTac M200"
CF_ItmModules[factionid][i] = "UT_Shield.rte"
CF_ItmPrices[factionid][i] = 100
CF_ItmDescriptions[factionid][i] = "Well, this is awkward. We seem to have lost all regular .408 ammo shipments. All we have left is explosive ordnance. We apologize for any inconvenience this might have caused."
CF_ItmUnlockData[factionid][i] = 2000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SNIPER;
CF_ItmPowers[factionid][i] = 8






i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Springfield M79"
CF_ItmPresets[factionid][i] = "Springfield M79"
CF_ItmModules[factionid][i] = "UT_Shield.rte"
CF_ItmPrices[factionid][i] = 40
CF_ItmDescriptions[factionid][i] = "These old grenade launchers are still quite potent and can be used in a convenient angle. Fused grenades with bouncing potential are included."
CF_ItmUnlockData[factionid][i] = 800
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 4

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "XM25 Grenade Launcher"
CF_ItmPresets[factionid][i] = "XM25 Grenade Launcher"
CF_ItmModules[factionid][i] = "UT_Shield.rte"
CF_ItmPrices[factionid][i] = 100
CF_ItmDescriptions[factionid][i] = "This rapid firing grenade launcher is perfect for killing people hiding behind obstacles."
CF_ItmUnlockData[factionid][i] = 1000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 6

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Milkor MGL"
CF_ItmPresets[factionid][i] = "Milkor MGL"
CF_ItmModules[factionid][i] = "UT_Shield.rte"
CF_ItmPrices[factionid][i] = 120
CF_ItmDescriptions[factionid][i] = "A 40mm grenade launcher, and an automatic one at that."
CF_ItmUnlockData[factionid][i] = 1200
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 7

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "M72 LAW"
CF_ItmPresets[factionid][i] = "M72 LAW"
CF_ItmModules[factionid][i] = "UT_Shield.rte"
CF_ItmPrices[factionid][i] = 70
CF_ItmDescriptions[factionid][i] = "Anti-tank, anti-personnel, anti-drop ship; a rocket won't mind what it is aimed at. Fire away!"
CF_ItmUnlockData[factionid][i] = 700
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 6

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "M202"
CF_ItmPresets[factionid][i] = "M202"
CF_ItmModules[factionid][i] = "UT_Shield.rte"
CF_ItmPrices[factionid][i] = 150
CF_ItmDescriptions[factionid][i] = "If you'll ever feel the need to fire four missiles within the timespan of a second, definitely try this!"
CF_ItmUnlockData[factionid][i] = 1000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 8

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Stinger"
CF_ItmPresets[factionid][i] = "Stinger"
CF_ItmModules[factionid][i] = "UT_Shield.rte"
CF_ItmPrices[factionid][i] = 200
CF_ItmDescriptions[factionid][i] = "Annoying dropships buzzing around like flies. It can ruin one's day. Do something about it! Aim, fire and let the stinger missile sort it out. Oh, personnel aren't dropships, but we failed to mention this to this device."
CF_ItmUnlockData[factionid][i] = 1000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 0



i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Blast Grenade Belt"
CF_ItmPresets[factionid][i] = "Blast Grenade Belt"
CF_ItmModules[factionid][i] = "UT_Shield.rte"
CF_ItmPrices[factionid][i] = 25
CF_ItmDescriptions[factionid][i] = "Lethal glows packed inside tight little packages. Timer: 4 seconds."
CF_ItmUnlockData[factionid][i] = 600
CF_ItmClasses[factionid][i] = "TDExplosive"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.GRENADE;
CF_ItmPowers[factionid][i] = 6

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Thermal Grenade Belt"
CF_ItmPresets[factionid][i] = "Thermal Grenade Belt"
CF_ItmModules[factionid][i] = "UT_Shield.rte"
CF_ItmPrices[factionid][i] = 25
CF_ItmDescriptions[factionid][i] = "Surprise your enemies with the warmth from a thermal grenade. It'll surely keep them warm for the rest of their lives. Timer: 4 seconds."
CF_ItmUnlockData[factionid][i] = 600
CF_ItmClasses[factionid][i] = "TDExplosive"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.GRENADE;
CF_ItmPowers[factionid][i] = 7

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Nail Grenade Belt"
CF_ItmPresets[factionid][i] = "Nail Grenade Belt"
CF_ItmModules[factionid][i] = "UT_Shield.rte"
CF_ItmPrices[factionid][i] = 40
CF_ItmDescriptions[factionid][i] = "Nail your enemies to the wall, literally. Watch out though, The nails have quite a range. Timer: 4 seconds."
CF_ItmUnlockData[factionid][i] = 8000
CF_ItmClasses[factionid][i] = "TDExplosive"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.GRENADE;
CF_ItmPowers[factionid][i] = 8

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Incendiary Grenade Belt"
CF_ItmPresets[factionid][i] = "Incendiary Grenade Belt"
CF_ItmModules[factionid][i] = "UT_Shield.rte"
CF_ItmPrices[factionid][i] = 50
CF_ItmDescriptions[factionid][i] = "These grenades burn their way through almost anything, be it dirt, concrete or flesh. Timer: 4 seconds."
CF_ItmUnlockData[factionid][i] = 1000
CF_ItmClasses[factionid][i] = "TDExplosive"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.GRENADE;
CF_ItmPowers[factionid][i] = 9
