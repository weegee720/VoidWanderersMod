-- Unique Faction ID
local factionid = "Ronin";
--print ("Loading "..factionid)

CF_Factions[#CF_Factions + 1] = factionid

-- Faction name
CF_FactionNames[factionid] = "Ronin";
-- Faction description
CF_FactionDescriptions[factionid] = "Rag-tag parties of bandits who prey on weak and unsuspecting explorers. Their soldiers are unarmored and weapons primitive, but they manage to get the job done.";
-- Set true if faction is selectable by player or AI
CF_FactionPlayable[factionid] = true;

-- Modules needed for this faction
CF_RequiredModules[factionid] = {"Base.rte", "Ronin.rte"}

-- Set faction nature
CF_FactionNatures[factionid] = CF_FactionTypes.ORGANIC;


-- Define faction bonuses, in percents
CF_ScanBonuses[factionid] = 0
CF_RelationsBonuses[factionid] = 25
CF_ExpansionBonuses[factionid] = 0

CF_MineBonuses[factionid] = 0
CF_LabBonuses[factionid] = 0
CF_AirfieldBonuses[factionid] = 0
CF_SuperWeaponBonuses[factionid] = 0
CF_FactoryBonuses[factionid] = 0
CF_CloneBonuses[factionid] = 35
CF_HospitalBonuses[factionid] = 25


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
		CF_PresetTypes.SNIPER, 		-- Add more snipers because Kar98 is great
		CF_PresetTypes.SNIPER, 		-- 
		CF_PresetTypes.SHOTGUN, 	-- Heavy + Shotgun / Pistol / Grenade
		CF_PresetTypes.HEAVY1, 		-- Heavy + Heavy / Rifle / Grenade
		CF_PresetTypes.HEAVY2, 		-- Heavy + Heavy / Grenade / Grenade
		CF_PresetTypes.ARMOR1, 		-- And a bit more armor crabs
		CF_PresetTypes.ARMOR2, 		-- Heavy + Shield / Pistol / Grenade
		CF_PresetTypes.ENGINEER	    -- Light + Digger / Rifle / Grenade
	}


-- Define default tactical AI model
-- Ronins are unpreidctable
CF_FactionAIModels[factionid] = "RANDOM"

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
CF_ActNames[factionid][i] = "Ronin Soldier"
CF_ActPresets[factionid][i] = "Ronin Soldier"
CF_ActModules[factionid][i] = "Ronin.rte"
CF_ActPrices[factionid][i] = 95
CF_ActDescriptions[factionid][i] = "Ronin human infantry unit. A random rag-tag soldier that comes equipped with a standard issue jetpack."
CF_ActUnlockData[factionid][i] = 0
CF_ActTypes[factionid][i] = CF_ActorTypes.LIGHT;
CF_ActPowers[factionid][i] = 1

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Ronin Heavy"
CF_ActPresets[factionid][i] = "Ronin Heavy"
CF_ActModules[factionid][i] = "Ronin.rte"
CF_ActPrices[factionid][i] = 115
CF_ActDescriptions[factionid][i] = "Ronin heavy infantry unit. Wearing old armored parts of other techs, this unit is able to take more damage at the expense of wieght."
CF_ActUnlockData[factionid][i] = 1200
CF_ActTypes[factionid][i] = CF_ActorTypes.HEAVY;
CF_ActPowers[factionid][i] = 3

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Ronin Sniper"
CF_ActPresets[factionid][i] = "Ronin Sniper"
CF_ActModules[factionid][i] = "Ronin.rte"
CF_ActPrices[factionid][i] = 125
CF_ActDescriptions[factionid][i] = "Veteran Ronin soldier trained to operate long-ranged weapons."
CF_ActUnlockData[factionid][i] = 1200
CF_ActTypes[factionid][i] = CF_ActorTypes.LIGHT;
CF_ActPowers[factionid][i] = 2


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
CF_ItmNames[factionid][i] = "Glock"
CF_ItmPresets[factionid][i] = "Glock"
CF_ItmModules[factionid][i] = "Ronin.rte"
CF_ItmPrices[factionid][i] = 15
CF_ItmDescriptions[factionid][i] = "Great standard issue sidearm for every troop.  Twelve rounds per clip, decent stopping power and fast reloads."
CF_ItmUnlockData[factionid][i] = 0
CF_ItmTypes[factionid][i] = CF_WeaponTypes.PISTOL;
CF_ItmPowers[factionid][i] = 1

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Peacemaker"
CF_ItmPresets[factionid][i] = "Peacemaker"
CF_ItmModules[factionid][i] = "Ronin.rte"
CF_ItmPrices[factionid][i] = 20
CF_ItmDescriptions[factionid][i] = "The best and coolest revolver on the market, its extreme firepower is unmatched to other sidearms available."
CF_ItmUnlockData[factionid][i] = 500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.PISTOL;
CF_ItmPowers[factionid][i] = 3

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Pineapple Grenade"
CF_ItmPresets[factionid][i] = "Pineapple Grenade"
CF_ItmModules[factionid][i] = "Ronin.rte"
CF_ItmPrices[factionid][i] = 5
CF_ItmDescriptions[factionid][i] = "Timed grenade, make sure to throw it away after you've pulled the pin.  Features great explosive power."
CF_ItmUnlockData[factionid][i] = 150
CF_ItmClasses[factionid][i] = "TDExplosive"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.GRENADE;
CF_ItmPowers[factionid][i] = 2

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Stick Grenade"
CF_ItmPresets[factionid][i] = "Stick Grenade"
CF_ItmModules[factionid][i] = "Ronin.rte"
CF_ItmPrices[factionid][i] = 5
CF_ItmDescriptions[factionid][i] = "German explosive invention which explodes immidiatly on impact. Handle with extreme caution when using this grenade, especially dropping is not recommended. It features longer throwing range than the frag grenade."
CF_ItmUnlockData[factionid][i] = 150
CF_ItmClasses[factionid][i] = "TDExplosive"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.GRENADE;
CF_ItmPowers[factionid][i] = 2

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Molotov Cocktail"
CF_ItmPresets[factionid][i] = "Molotov Cocktail"
CF_ItmModules[factionid][i] = "Ronin.rte"
CF_ItmPrices[factionid][i] = 10
CF_ItmDescriptions[factionid][i] = "The classic improvised explosive. Burns stuff up pretty well, and packs a punch when it explodes too! Explodes on impact."
CF_ItmUnlockData[factionid][i] = 150
CF_ItmClasses[factionid][i] = "TDExplosive"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.GRENADE;
CF_ItmPowers[factionid][i] = 3

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Uzi"
CF_ItmPresets[factionid][i] = "Uzi"
CF_ItmModules[factionid][i] = "Ronin.rte"
CF_ItmPrices[factionid][i] = 30
CF_ItmDescriptions[factionid][i] = "Automatic sidearm with a high rate of fire and quick reload time. The Uzi can be wielded with a shield."
CF_ItmUnlockData[factionid][i] = 800
CF_ItmTypes[factionid][i] = CF_WeaponTypes.PISTOL;
CF_ItmPowers[factionid][i] = 5


i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "TommyGun"
CF_ItmPresets[factionid][i] = "TommyGun"
CF_ItmModules[factionid][i] = "Ronin.rte"
CF_ItmPrices[factionid][i] = 35
CF_ItmDescriptions[factionid][i] = "Cheap, reliable and swift. Buy your Tommy today!"
CF_ItmUnlockData[factionid][i] = 1000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.PISTOL;
CF_ItmPowers[factionid][i] = 7


i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Sawed-off shotgun"
CF_ItmPresets[factionid][i] = "Sawed-off shotgun"
CF_ItmModules[factionid][i] = "Ronin.rte"
CF_ItmPrices[factionid][i] = 20
CF_ItmDescriptions[factionid][i] = "Sawed-off double-barreled shotgun.  Can be wielded with a shield.  Only effective at close-quaters."
CF_ItmUnlockData[factionid][i] = 500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SHOTGUN;
CF_ItmPowers[factionid][i] = 1

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Pumpgun"
CF_ItmPresets[factionid][i] = "Pumpgun"
CF_ItmModules[factionid][i] = "Ronin.rte"
CF_ItmPrices[factionid][i] = 40
CF_ItmDescriptions[factionid][i] = "Basic low spread pump action shotgun.  Has long range and moderate power."
CF_ItmUnlockData[factionid][i] = 800
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SHOTGUN;
CF_ItmPowers[factionid][i] = 3

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Spas 12"
CF_ItmPresets[factionid][i] = "Spas 12"
CF_ItmModules[factionid][i] = "Ronin.rte"
CF_ItmPrices[factionid][i] = 60
CF_ItmDescriptions[factionid][i] = "Spas 12, the shotgun of tommorow.  It has amazing firepower and high ammo capacity."
CF_ItmUnlockData[factionid][i] = 1200
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SHOTGUN;
CF_ItmPowers[factionid][i] = 5

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "AK-47"
CF_ItmPresets[factionid][i] = "AK-47"
CF_ItmModules[factionid][i] = "Ronin.rte"
CF_ItmPrices[factionid][i] = 40
CF_ItmDescriptions[factionid][i] = "An old classic, simple design and cheap parts makes this gun a widespread design."
CF_ItmUnlockData[factionid][i] = 0
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 3

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "M16"
CF_ItmPresets[factionid][i] = "M16"
CF_ItmModules[factionid][i] = "Ronin.rte"
CF_ItmPrices[factionid][i] = 50
CF_ItmDescriptions[factionid][i] = "Accurate and deadly.  Great standard weapon for your troops. "
CF_ItmUnlockData[factionid][i] = 2000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 5

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "M1 Garand"
CF_ItmPresets[factionid][i] = "M1 Garand"
CF_ItmModules[factionid][i] = "Ronin.rte"
CF_ItmPrices[factionid][i] = 40
CF_ItmDescriptions[factionid][i] = "Semi-automatic rifle, excellent for hunting on your opponents!"
CF_ItmUnlockData[factionid][i] = 1800
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SNIPER;
CF_ItmPowers[factionid][i] = 6

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Kar98"
CF_ItmPresets[factionid][i] = "Kar98"
CF_ItmModules[factionid][i] = "Ronin.rte"
CF_ItmPrices[factionid][i] = 130
CF_ItmDescriptions[factionid][i] = "Powerful sniper rifle.  Long range and precision combined make this a deadly weapon."
CF_ItmUnlockData[factionid][i] = 2500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SNIPER;
CF_ItmPowers[factionid][i] = 9

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "M60"
CF_ItmPresets[factionid][i] = "M60"
CF_ItmModules[factionid][i] = "Ronin.rte"
CF_ItmPrices[factionid][i] = 100
CF_ItmDescriptions[factionid][i] = "Light machine gun. It's portability combined with steady rate of fire and large ammo capacity makes it a deadly weapon."
CF_ItmUnlockData[factionid][i] = 4000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 9

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Thumper"
CF_ItmPresets[factionid][i] = "Thumper"
CF_ItmModules[factionid][i] = "Ronin.rte"
CF_ItmPrices[factionid][i] = 80
CF_ItmDescriptions[factionid][i] = "Single-shot grenade launcher. Can fire Bouncing or Impact grenades.  Select which grenade type to use with the buttons in the Pie Menu."
CF_ItmUnlockData[factionid][i] = 2000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 8

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "RPG-7"
CF_ItmPresets[factionid][i] = "RPG-7"
CF_ItmModules[factionid][i] = "Ronin.rte"
CF_ItmPrices[factionid][i] = 150
CF_ItmDescriptions[factionid][i] = "Powerful and feared weapon in the Ronin arsenal.  Fires accelerating rockets that cause massive damage with a direct hit."
CF_ItmUnlockData[factionid][i] = 2500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 7

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "RPC M17"
CF_ItmPresets[factionid][i] = "RPC M17"
CF_ItmModules[factionid][i] = "Ronin.rte"
CF_ItmPrices[factionid][i] = 130
CF_ItmDescriptions[factionid][i] = "Rocket Propelled Chainsaw launcher.  This sadistic weapon can mutilate multiple enemies with one shot.  The launcher holds only one round per clip, so aim wisely."
CF_ItmUnlockData[factionid][i] = 3000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 9