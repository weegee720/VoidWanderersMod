-- Unique Faction ID
local factionid = "Dummy";
print ("Loading "..factionid)

CF_Factions[#CF_Factions + 1] = factionid
	
-- Faction name
CF_FactionNames[factionid] = "Dummy";
-- Faction description
CF_FactionDescriptions[factionid] = "These robots were originally designed as test subjects for weapons, vehicle safety measures, and other lethal experiments, but an AI controller became sentient and broke off from its manufacturers, starting a new line of robots and weapons to defend itself.";
-- Set true if faction is selectable by player or AI
CF_FactionPlayable[factionid] = true;

-- Modules needed for this faction
CF_RequiredModules[factionid] = {"Base.rte", "Dummy.rte"}

-- Set faction nature
CF_FactionNatures[factionid] = CF_FactionTypes.SYNTHETIC;


-- Define faction bonuses, in percents
CF_ScanBonuses[factionid] = 0
CF_RelationsBonuses[factionid] = 0
CF_ExpansionBonuses[factionid] = 50

CF_MineBonuses[factionid] = 0
CF_LabBonuses[factionid] = 0
CF_AirfieldBonuses[factionid] = 0
CF_SuperWeaponBonuses[factionid] = 0
CF_FactoryBonuses[factionid] = 35
CF_CloneBonuses[factionid] = 25
CF_HospitalBonuses[factionid] = 0

-- How many more troops dropship can hold
CF_DropShipCapacityBonuses[factionid] = CF_MaxUnitsPerDropship * 2

-- Percentage of troops sent to brainhunt or attack player LZ when AI is defending (default - 50)
CF_BrainHuntRatios[factionid] = 75

-- Define brain unit
CF_Brains[factionid] = "Brain Robot";
CF_BrainModules[factionid] = "Base.rte";
CF_BrainClasses[factionid] = "AHuman";
CF_BrainPrices[factionid] = 250;

-- Define dropship	
CF_Crafts[factionid] = "Drop Ship";
CF_CraftModules[factionid] = "Dummy.rte";
CF_CraftClasses[factionid] = "ACDropShip";
CF_CraftPrices[factionid] = 110;

-- Define superweapon script
CF_SuperWeaponScripts[factionid] = "UnmappedLands2.rte/SuperWeapons/DummyParticle.lua"

-- Define prefered presets to choose from when deploying troops in tactical mode
CF_PreferedTacticalPresets[factionid] = {
		CF_PresetTypes.INFANTRY1,
		CF_PresetTypes.SNIPER, 
		CF_PresetTypes.SNIPER, 
		CF_PresetTypes.HEAVY1, 
		CF_PresetTypes.ARMOR1, 
		CF_PresetTypes.ARMOR1, 
		CF_PresetTypes.ENGINEER	
	}

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
CF_ActNames[factionid][i] = "Dummy"
CF_ActPresets[factionid][i] = "Dummy"
CF_ActModules[factionid][i] = "Dummy.rte"
CF_ActPrices[factionid][i] = 80
CF_ActDescriptions[factionid][i] = "Standard dummy soldier.  Quite resilient to impacts and falls, and very agile.  Made of plastic, it is weak to bullets."
CF_ActUnlockData[factionid][i] = 0
CF_ActTypes[factionid][i] = CF_ActorTypes.LIGHT;
CF_ActPowers[factionid][i] = 1

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Dreadnought"
CF_ActPresets[factionid][i] = "Dreadnought"
CF_ActModules[factionid][i] = "Dummy.rte"
CF_ActPrices[factionid][i] = 200
CF_ActDescriptions[factionid][i] = "Armored tank on 4 legs.  Armed with a machine gun and covered with multiple layers of armor."
CF_ActUnlockData[factionid][i] = 2500
CF_ActClasses[factionid][i] = "ACrab"
CF_ActTypes[factionid][i] = CF_ActorTypes.ARMOR;
CF_ActPowers[factionid][i] = 5
CF_ActOffsets[factionid][i] = Vector(0,8)

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Small MG Turret"
CF_ActPresets[factionid][i] = "Small MG Turret"
CF_ActModules[factionid][i] = "Dummy.rte"
CF_ActPrices[factionid][i] = 100
CF_ActDescriptions[factionid][i] = "Small turret with a machine gun for general base defense."
CF_ActUnlockData[factionid][i] = 2500
CF_ActClasses[factionid][i] = "ACrab"
CF_ActTypes[factionid][i] = CF_ActorTypes.TURRET;
CF_ActPowers[factionid][i] = 6
CF_ActOffsets[factionid][i] = Vector(0,16)



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
CF_ItmNames[factionid][i] = "Turbo Digger"
CF_ItmPresets[factionid][i] = "Turbo Digger"
CF_ItmModules[factionid][i] = "Dummy.rte"
CF_ItmPrices[factionid][i] = 80
CF_ItmDescriptions[factionid][i] = "Dummy mining tool. Works as a powerful close range weapon too."
CF_ItmUnlockData[factionid][i] = 250
CF_ItmTypes[factionid][i] = CF_WeaponTypes.DIGGER;
CF_ItmPowers[factionid][i] = 3

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Nailgun"
CF_ItmPresets[factionid][i] = "Nailgun"
CF_ItmModules[factionid][i] = "Dummy.rte"
CF_ItmPrices[factionid][i] = 15
CF_ItmDescriptions[factionid][i] = "A sidearm that fires heated nails at high velocities."
CF_ItmUnlockData[factionid][i] = 0
CF_ItmTypes[factionid][i] = CF_WeaponTypes.PISTOL;
CF_ItmPowers[factionid][i] = 1

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Rail Pistol"
CF_ItmPresets[factionid][i] = "Rail Pistol"
CF_ItmModules[factionid][i] = "Dummy.rte"
CF_ItmPrices[factionid][i] = 20
CF_ItmDescriptions[factionid][i] = "A compact sidearm for a good price and decent performance!"
CF_ItmUnlockData[factionid][i] = 250
CF_ItmTypes[factionid][i] = CF_WeaponTypes.PISTOL;
CF_ItmPowers[factionid][i] = 2

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Impulse Grenade"
CF_ItmPresets[factionid][i] = "Impulse Grenade"
CF_ItmModules[factionid][i] = "Dummy.rte"
CF_ItmPrices[factionid][i] = 10
CF_ItmDescriptions[factionid][i] = "Standard dummy grenade. Explodes into a devastating kinetic blast that will knock away or even tear apart its target."
CF_ItmUnlockData[factionid][i] = 450
CF_ItmClasses[factionid][i] = "TDExplosive"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.GRENADE;
CF_ItmPowers[factionid][i] = 2

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Disruptor Grenade"
CF_ItmPresets[factionid][i] = "Disruptor Grenade"
CF_ItmModules[factionid][i] = "Dummy.rte"
CF_ItmPrices[factionid][i] = 20
CF_ItmDescriptions[factionid][i] = "Area denial grenade.  Sets a deadly field upon detonation that lasts for 10 seconds."
CF_ItmUnlockData[factionid][i] = 550
CF_ItmClasses[factionid][i] = "TDExplosive"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.GRENADE;
CF_ItmPowers[factionid][i] = 3

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Blaster"
CF_ItmPresets[factionid][i] = "Blaster"
CF_ItmModules[factionid][i] = "Dummy.rte"
CF_ItmPrices[factionid][i] = 70
CF_ItmDescriptions[factionid][i] = "Energy based sub machine gun.  Has a much shorter range than ballistic weapons, but its power and fast reloading make it an effective weapon."
CF_ItmUnlockData[factionid][i] = 0
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 3

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Frag Nailer"
CF_ItmPresets[factionid][i] = "Frag Nailer"
CF_ItmModules[factionid][i] = "Dummy.rte"
CF_ItmPrices[factionid][i] = 60
CF_ItmDescriptions[factionid][i] = "A rapid-fire, four-barreled grenade launcher that lobs packets of nails that stick to objects and explode after a set time."
CF_ItmUnlockData[factionid][i] = 650
CF_ItmTypes[factionid][i] = CF_WeaponTypes.GRENADE;
CF_ItmPowers[factionid][i] = 5

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Nailer Cannon"
CF_ItmPresets[factionid][i] = "Nailer Cannon"
CF_ItmModules[factionid][i] = "Dummy.rte"
CF_ItmPrices[factionid][i] = 160
CF_ItmDescriptions[factionid][i] = "Rapid fire version of the Nail Gun. Fire lots of heated nails at an incredible rate!"
CF_ItmUnlockData[factionid][i] = 1500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 5

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Scouting Rifle"
CF_ItmPresets[factionid][i] = "Scouting Rifle"
CF_ItmModules[factionid][i] = "Dummy.rte"
CF_ItmPrices[factionid][i] = 50
CF_ItmDescriptions[factionid][i] = "Long range rifle with a scope. It has large ammo capacity and a steady rate of fire."
CF_ItmUnlockData[factionid][i] = 1000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SNIPER;
CF_ItmPowers[factionid][i] = 3

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Impulse Cannon"
CF_ItmPresets[factionid][i] = "Impulse Cannon"
CF_ItmModules[factionid][i] = "Dummy.rte"
CF_ItmPrices[factionid][i] = 90
CF_ItmDescriptions[factionid][i] = "Devastating weapon that fires concussive grenades. This weapon can take down heavy armored units with a small but powerful kinetic blast."
CF_ItmUnlockData[factionid][i] = 1500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 6

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Repeater"
CF_ItmPresets[factionid][i] = "Repeater"
CF_ItmModules[factionid][i] = "Dummy.rte"
CF_ItmPrices[factionid][i] = 120
CF_ItmDescriptions[factionid][i] = "Effective rapid fire support weapon. Doubles as a good assault weapon due to its large clip, but users should be warned of the long reload time."
CF_ItmUnlockData[factionid][i] = 2500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 9

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Destroyer Cannon"
CF_ItmPresets[factionid][i] = "Destroyer Cannon"
CF_ItmModules[factionid][i] = "Dummy.rte"
CF_ItmPrices[factionid][i] = 220
CF_ItmDescriptions[factionid][i] = "This cannon fires bolts of slowly advancing energy that mow down multiple enemies in a row without slowing."
CF_ItmUnlockData[factionid][i] = 1500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 7

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Annihiliator"
CF_ItmPresets[factionid][i] = "Annihiliator"
CF_ItmModules[factionid][i] = "Dummy.rte"
CF_ItmPrices[factionid][i] = 180
CF_ItmDescriptions[factionid][i] = "Destructive heavy laser cannon. Hold down fire to charge the laser, then release it to unleash hot laser death on your enemies!"
CF_ItmUnlockData[factionid][i] = 1500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 5

