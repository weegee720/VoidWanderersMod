-- Unique Faction ID
local factionid = "Coalition";
--print ("Loading "..factionid)

CF_Factions[#CF_Factions + 1] = factionid
	
-- Faction name
CF_FactionNames[factionid] = "Coalition";
-- Faction description
CF_FactionDescriptions[factionid] = "A militarized organization, the Coalition produce a large array of units and weaponry to choose from. They are versatile and powerful, making them a strong ally or a dangerous foe.";
-- Set true if faction is selectable by player or AI
CF_FactionPlayable[factionid] = true;

-- Modules needed for this faction
CF_RequiredModules[factionid] = {"Base.rte", "Coalition.rte"}

-- Set faction nature
-- Available values ORGANIC, SYNTHETIC
CF_FactionNatures[factionid] = CF_FactionTypes.ORGANIC;


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
CF_AirfieldBonuses[factionid] = 25
-- Superweapon targeting reduction
CF_SuperWeaponBonuses[factionid] = 25
-- Unit price reduction
CF_FactoryBonuses[factionid] = 0
-- Body price reduction
CF_CloneBonuses[factionid] = 10
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
CF_Crafts[factionid] = "Drop Ship MK1";
CF_CraftModules[factionid] = "Base.rte";
CF_CraftClasses[factionid] = "ACDropShip";
CF_CraftPrices[factionid] = 300;

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
CF_ActNames[factionid][i] = "Soldier Light"
CF_ActPresets[factionid][i] = "Soldier Light"
CF_ActModules[factionid][i] = "Coalition.rte"
CF_ActPrices[factionid][i] = 105
CF_ActDescriptions[factionid][i] = "Standard Coalition soldier equipped with armor and a jetpack.  Very resilient and quick."
CF_ActUnlockData[factionid][i] = 0 -- 0 means available at start
CF_ActTypes[factionid][i] = CF_ActorTypes.LIGHT;
CF_ActPowers[factionid][i] = 3

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Soldier Heavy"
CF_ActPresets[factionid][i] = "Soldier Heavy"
CF_ActModules[factionid][i] = "Coalition.rte"
CF_ActPrices[factionid][i] = 130
CF_ActDescriptions[factionid][i] = "A Coalition trooper upgraded with stronger armor.  A bit heavier and a bit less agile than the Light Soldier, but more than makes up for it with its strength."
CF_ActUnlockData[factionid][i] = 750
CF_ActTypes[factionid][i] = CF_ActorTypes.HEAVY;
CF_ActPowers[factionid][i] = 6

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Gatling Drone"
CF_ActPresets[factionid][i] = "Gatling Drone"
CF_ActModules[factionid][i] = "Coalition.rte"
CF_ActPrices[factionid][i] = 200
CF_ActDescriptions[factionid][i] = "Heavily armored drone equipped with a Gatling Gun.  This tank can mow down waves of enemy soldiers and can take a beating."
CF_ActUnlockData[factionid][i] = 4000
CF_ActClasses[factionid][i] = "ACrab"
CF_ActTypes[factionid][i] = CF_ActorTypes.ARMOR;
CF_ActPowers[factionid][i] = 8
CF_ActOffsets[factionid][i] = Vector(0,12)

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Gatling Turret"
CF_ActPresets[factionid][i] = "Gatling Turret"
CF_ActModules[factionid][i] = "Coalition.rte"
CF_ActPrices[factionid][i] = 250
CF_ActDescriptions[factionid][i] = "Heavily armored turret equipped with a Gatling Gun. Like the Gatling Drone, but without legs and with more ammo."
CF_ActUnlockData[factionid][i] = 3000
CF_ActClasses[factionid][i] = "ACrab"
CF_ActTypes[factionid][i] = CF_ActorTypes.TURRET;
CF_ActPowers[factionid][i] = 8
CF_ActOffsets[factionid][i] = Vector(0,12)



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
CF_ItmPrices[factionid][i] = 18
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
CF_ItmNames[factionid][i] = "Grenade"
CF_ItmPresets[factionid][i] = "Grenade"
CF_ItmModules[factionid][i] = "Coalition.rte"
CF_ItmPrices[factionid][i] = 10
CF_ItmDescriptions[factionid][i] = "Explosive fragmentation grenade. Perfect for clearing awkward bunkers. Blows up after a 4 second delay."
CF_ItmUnlockData[factionid][i] = 200
CF_ItmClasses[factionid][i] = "TDExplosive"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.GRENADE;
CF_ItmPowers[factionid][i] = 1

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Cluster Grenade"
CF_ItmPresets[factionid][i] = "Cluster Grenade"
CF_ItmModules[factionid][i] = "Coalition.rte"
CF_ItmPrices[factionid][i] = 30
CF_ItmDescriptions[factionid][i] = "Explosive cluster grenade.  Awesome power!  Blows up spreading many explosive clusters after a 4 second delay."
CF_ItmUnlockData[factionid][i] = 500
CF_ItmClasses[factionid][i] = "TDExplosive"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.GRENADE;
CF_ItmPowers[factionid][i] = 3

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Incendiary Grenade"
CF_ItmPresets[factionid][i] = "Incendiary Grenade"
CF_ItmModules[factionid][i] = "Coalition.rte"
CF_ItmPrices[factionid][i] = 25
CF_ItmDescriptions[factionid][i] = "Upon detonation, this grenade produces molten iron by means of a chemical reaction.  In other words: use the three seconds you have to get out of its way!"
CF_ItmUnlockData[factionid][i] = 350
CF_ItmClasses[factionid][i] = "TDExplosive"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.GRENADE;
CF_ItmPowers[factionid][i] = 2

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Timed Explosive"
CF_ItmPresets[factionid][i] = "Timed Explosive"
CF_ItmModules[factionid][i] = "Coalition.rte"
CF_ItmPrices[factionid][i] = 25
CF_ItmDescriptions[factionid][i] = "Destructive plantable explosive charge.  You can stick this into a wall, door or anything else stationary.  After planting, run for your life, as it explodes after 10 seconds."
CF_ItmUnlockData[factionid][i] = 300
CF_ItmClasses[factionid][i] = "TDExplosive"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.GRENADE;
CF_ItmPowers[factionid][i] = 0

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Compact Assault Rifle"
CF_ItmPresets[factionid][i] = "Compact Assault Rifle"
CF_ItmModules[factionid][i] = "Coalition.rte"
CF_ItmPrices[factionid][i] = 30
CF_ItmDescriptions[factionid][i] = "Sacrifices stopping power and accuracy for a higher rate of fire.  It also fits easier into your backpack."
CF_ItmUnlockData[factionid][i] = 0
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 4

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Assault Rifle"
CF_ItmPresets[factionid][i] = "Assault Rifle"
CF_ItmModules[factionid][i] = "Coalition.rte"
CF_ItmPrices[factionid][i] = 50
CF_ItmDescriptions[factionid][i] = "Workhorse of the Coalition army, satisfaction guaranteed or your money back!"
CF_ItmUnlockData[factionid][i] = 600
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 6

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Shotgun"
CF_ItmPresets[factionid][i] = "Shotgun"
CF_ItmModules[factionid][i] = "Coalition.rte"
CF_ItmPrices[factionid][i] = 40
CF_ItmDescriptions[factionid][i] = "A light shotgun with six shots and moderate reload time."
CF_ItmUnlockData[factionid][i] = 550
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SHOTGUN;
CF_ItmPowers[factionid][i] = 4

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Auto Shotgun"
CF_ItmPresets[factionid][i] = "Auto Shotgun"
CF_ItmModules[factionid][i] = "Coalition.rte"
CF_ItmPrices[factionid][i] = 60
CF_ItmDescriptions[factionid][i] = "Fully automatic shotgun.  This thing is a blast, but with be wary of the reload times!"
CF_ItmUnlockData[factionid][i] = 950
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SHOTGUN;
CF_ItmPowers[factionid][i] = 7

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Remote-GL"
CF_ItmPresets[factionid][i] = "Remote-GL"
CF_ItmModules[factionid][i] = "Coalition.rte"
CF_ItmPrices[factionid][i] = 90
CF_ItmDescriptions[factionid][i] = "Automatic grenade launcher. Upon impact with anything, the grenades don't explode. Instead, they stick to terrain and objects and can be remotely detonated."
CF_ItmUnlockData[factionid][i] = 2000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 0

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Gatling Gun"
CF_ItmPresets[factionid][i] = "Gatling Gun"
CF_ItmModules[factionid][i] = "Coalition.rte"
CF_ItmPrices[factionid][i] = 110
CF_ItmDescriptions[factionid][i] = "Coalition's feared heavy weapon that features a large magazine and amazing firepower. Reloading is not an issue because there is enough ammo to kill everyone even remotely close."
CF_ItmUnlockData[factionid][i] = 2500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 8

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Sniper Rifle"
CF_ItmPresets[factionid][i] = "Sniper Rifle"
CF_ItmModules[factionid][i] = "Coalition.rte"
CF_ItmPrices[factionid][i] = 80
CF_ItmDescriptions[factionid][i] = "Coalition special issue, semi-automatic precision rifle.  Complete with scope for long distance shooting."
CF_ItmUnlockData[factionid][i] = 1500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SNIPER;
CF_ItmPowers[factionid][i] = 5

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Auto Cannon"
CF_ItmPresets[factionid][i] = "Auto Cannon"
CF_ItmModules[factionid][i] = "Coalition.rte"
CF_ItmPrices[factionid][i] = 130
CF_ItmDescriptions[factionid][i] = "Auto cannon for your heavy soldiers to use. Devastating power, high rate and lots of rounds to fire. Reloading this thing might take some time though."
CF_ItmUnlockData[factionid][i] = 2000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 7

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Missile Launcher"
CF_ItmPresets[factionid][i] = "Missile Launcher"
CF_ItmModules[factionid][i] = "Coalition.rte"
CF_ItmPrices[factionid][i] = 150
CF_ItmDescriptions[factionid][i] = "Can fire powerful, manually guided missiles or weaker but faster unguided rockets. Switch between ammunition types using the buttons in the Pie Menu."
CF_ItmUnlockData[factionid][i] = 3000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 10

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Uber Cannon"
CF_ItmPresets[factionid][i] = "Uber Cannon"
CF_ItmModules[factionid][i] = "Coalition.rte"
CF_ItmPrices[factionid][i] = 150
CF_ItmDescriptions[factionid][i] = "Uber Cannon. A shoulder mounted, tactical artillery weapon that fires air-bursting cluster bombs. Features a trajectory guide to help with long-ranged shots."
CF_ItmUnlockData[factionid][i] = 1500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 0
