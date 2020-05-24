-- S.A.W. http://forums.datarealms.com/viewtopic.php?f=61&t=18120 by Coops
-- Faction file by StanT101

-- Unique Faction ID
local factionid = "S.A.W.";
print ("Loading "..factionid)

CF_Factions[#CF_Factions + 1] = factionid

-- Faction name
CF_FactionNames[factionid] = "S.A.W.";
-- Faction description
CF_FactionDescriptions[factionid] = "Elite military merc group";
-- Set true if faction is selectable by player or AI
CF_FactionPlayable[factionid] = true;

-- Main module used to check if mod is installed and as backward compatibility layer with v1-faction files enabled missions
CF_RequiredModules[factionid] = {"Base.rte", "SAW.rte"}

-- Set faction nature
CF_FactionNatures[factionid] = CF_FactionTypes.ORGANIC;


-- Define faction bonuses, in percents
CF_ScanBonuses[factionid] = 10
CF_RelationsBonuses[factionid] = 0
CF_ExpansionBonuses[factionid] = 50

CF_MineBonuses[factionid] = 25
CF_LabBonuses[factionid] = 10
CF_AirfieldBonuses[factionid] = 25
CF_SuperWeaponBonuses[factionid] = 0
CF_FactoryBonuses[factionid] = 0
CF_CloneBonuses[factionid] = 0
CF_HospitalBonuses[factionid] = 10


-- Define brain unit
CF_Brains[factionid] = "Commander";
CF_BrainModules[factionid] = "SAW.rte";
CF_BrainClasses[factionid] = "AHuman";
CF_BrainPrices[factionid] = 500;

-- Define dropship	
CF_Crafts[factionid] = "SOMAG-1131 Mk2";
CF_CraftModules[factionid] = "SAW.rte";
CF_CraftClasses[factionid] = "ACDropShip";
CF_CraftPrices[factionid] = 120;

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
CF_ActNames[factionid][i] = "Unit Medium"
CF_ActPresets[factionid][i] = "Unit Medium"
CF_ActModules[factionid][i] = "SAW.rte"
CF_ActPrices[factionid][i] = 95
CF_ActDescriptions[factionid][i] = ""
CF_ActUnlockData[factionid][i] = 0
CF_ActTypes[factionid][i] = CF_ActorTypes.LIGHT;
CF_ActPowers[factionid][i] = 1

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Unit Heavy"
CF_ActPresets[factionid][i] = "Unit Heavy"
CF_ActModules[factionid][i] = "SAW.rte"
CF_ActPrices[factionid][i] = 175
CF_ActDescriptions[factionid][i] = ""
CF_ActUnlockData[factionid][i] = 3000
CF_ActTypes[factionid][i] = CF_ActorTypes.HEAVY;
CF_ActPowers[factionid][i] = 1

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Unit Elite SOP-19"
CF_ActPresets[factionid][i] = "Unit Elite SOP-19"
CF_ActModules[factionid][i] = "SAW.rte"
CF_ActPrices[factionid][i] = 165
CF_ActDescriptions[factionid][i] = ""
CF_ActUnlockData[factionid][i] = 2500
CF_ActTypes[factionid][i] = CF_ActorTypes.HEAVY;
CF_ActPowers[factionid][i] = 1

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "RAAX-70R (Ancient Guardian)"
CF_ActPresets[factionid][i] = "RAAX-70R (Ancient Guardian)"
CF_ActModules[factionid][i] = "SAW.rte"
CF_ActPrices[factionid][i] = 5250
CF_ActDescriptions[factionid][i] = "The amount of Resources, Effort, Engineering, and Thought put into these makes it a sight you do not want to ever encounter."
CF_ActUnlockData[factionid][i] = 10000
CF_ActClasses[factionid][i] = "AHuman"
CF_ActTypes[factionid][i] = CF_ActorTypes.ARMOR;
CF_ActPowers[factionid][i] = 10


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
CF_ItmNames[factionid][i] = "MPT-KME2"
CF_ItmPresets[factionid][i] = "MPT-KME2"
CF_ItmModules[factionid][i] = "SAW.rte"
CF_ItmPrices[factionid][i] = 45
CF_ItmDescriptions[factionid][i] = "Multi-Purpose Tool. Fix's and heals units, Harms enemies, and Digs Terrain."
CF_ItmUnlockData[factionid][i] = 2000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.DIGGER;
CF_ItmPowers[factionid][i] = 10

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Laser Pointer Attachment S.A.W."
CF_ItmPresets[factionid][i] = "Laser Pointer Attachment S.A.W."
CF_ItmModules[factionid][i] = "SAW.rte"
CF_ItmPrices[factionid][i] = 100
CF_ItmDescriptions[factionid][i] = "Press Fire to activate or deactivate your laser pointer, you do not need this in your inventory for the laser to be on."
CF_ItmUnlockData[factionid][i] = 500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.DIGGER;
CF_ItmPowers[factionid][i] = 2

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
CF_ItmNames[factionid][i] = "DUL91"
CF_ItmPresets[factionid][i] = "DUL91"
CF_ItmModules[factionid][i] = "SAW.rte"
CF_ItmPrices[factionid][i] = 20
CF_ItmDescriptions[factionid][i] = "Segmented Sheild with great Protection."
CF_ItmUnlockData[factionid][i] = 700
CF_ItmClasses[factionid][i] = "HeldDevice"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SHIELD;
CF_ItmPowers[factionid][i] = 2

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "KEDD Mk1"
CF_ItmPresets[factionid][i] = "KEDD Mk1"
CF_ItmModules[factionid][i] = "SAW.rte"
CF_ItmPrices[factionid][i] = 20
CF_ItmDescriptions[factionid][i] = "Kinetic Energy Defensive Device. When shot releases a punch of Kinetic Energy"
CF_ItmUnlockData[factionid][i] = 700
CF_ItmClasses[factionid][i] = "HeldDevice"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SHIELD;
CF_ItmPowers[factionid][i] = 2

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "S-88"
CF_ItmPresets[factionid][i] = "S-88"
CF_ItmModules[factionid][i] = "SAW.rte"
CF_ItmPrices[factionid][i] = 15
CF_ItmDescriptions[factionid][i] = "Powerful Sidearm to wip out."
CF_ItmUnlockData[factionid][i] = 0
CF_ItmTypes[factionid][i] = CF_WeaponTypes.PISTOL;
CF_ItmPowers[factionid][i] = 4

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "IWG-5"
CF_ItmPresets[factionid][i] = "IWG-5"
CF_ItmModules[factionid][i] = "SAW.rte"
CF_ItmPrices[factionid][i] = 135
CF_ItmDescriptions[factionid][i] = "Impluse Wave Grenade."
CF_ItmUnlockData[factionid][i] = 500
CF_ItmClasses[factionid][i] = "TDExplosive"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.GRENADE;
CF_ItmPowers[factionid][i] = 4

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "IL-12"
CF_ItmPresets[factionid][i] = "IL-12"
CF_ItmModules[factionid][i] = "SAW.rte"
CF_ItmPrices[factionid][i] = 135
CF_ItmDescriptions[factionid][i] = "Flammable Gas Cannister."
CF_ItmUnlockData[factionid][i] = 700
CF_ItmClasses[factionid][i] = "TDExplosive"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.GRENADE;
CF_ItmPowers[factionid][i] = 4

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Transporter"
CF_ItmPresets[factionid][i] = "Transporter"
CF_ItmModules[factionid][i] = "SAW.rte"
CF_ItmPrices[factionid][i] = 135
CF_ItmDescriptions[factionid][i] = "Transports a Rogue Soldier to the BattleField."
CF_ItmUnlockData[factionid][i] = 1000
CF_ItmClasses[factionid][i] = "TDExplosive"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.GRENADE;
CF_ItmPowers[factionid][i] = 2

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "NI-8"
CF_ItmPresets[factionid][i] = "NI-8"
CF_ItmModules[factionid][i] = "SAW.rte"
CF_ItmPrices[factionid][i] = 10
CF_ItmDescriptions[factionid][i] = "HE... bassically self explanatory."
CF_ItmUnlockData[factionid][i] = 500
CF_ItmClasses[factionid][i] = "TDExplosive"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.GRENADE;
CF_ItmPowers[factionid][i] = 8

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "STEK-11"
CF_ItmPresets[factionid][i] = "STEK-11"
CF_ItmModules[factionid][i] = "SAW.rte"
CF_ItmPrices[factionid][i] = 45
CF_ItmDescriptions[factionid][i] = "Light but powerful."
CF_ItmUnlockData[factionid][i] = 0
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 4

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "DN-88"
CF_ItmPresets[factionid][i] = "DN-88"
CF_ItmModules[factionid][i] = "SAW.rte"
CF_ItmPrices[factionid][i] = 65
CF_ItmDescriptions[factionid][i] = "A superior match to any traditional Shotgun."
CF_ItmUnlockData[factionid][i] = 1500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SHOTGUN;
CF_ItmPowers[factionid][i] = 4

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "WUND-55"
CF_ItmPresets[factionid][i] = "WUND-55"
CF_ItmModules[factionid][i] = "SAW.rte"
CF_ItmPrices[factionid][i] = 65
CF_ItmDescriptions[factionid][i] = "A seperate choice of AR with it's own benefits."
CF_ItmUnlockData[factionid][i] = 1500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 6

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "GH-56"
CF_ItmPresets[factionid][i] = "GH-56"
CF_ItmModules[factionid][i] = "SAW.rte"
CF_ItmPrices[factionid][i] = 45
CF_ItmDescriptions[factionid][i] = "Of Course, The standard but deadly GH-56."
CF_ItmUnlockData[factionid][i] = 1000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 6

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "SEAR-7"
CF_ItmPresets[factionid][i] = "SEAR-7"
CF_ItmModules[factionid][i] = "SAW.rte"
CF_ItmPrices[factionid][i] = 90
CF_ItmDescriptions[factionid][i] = "Medium distance scope requires an excellent eye."
CF_ItmUnlockData[factionid][i] = 1500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SNIPER;
CF_ItmPowers[factionid][i] = 6

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "GAUS-121"
CF_ItmPresets[factionid][i] = "GAUS-121"
CF_ItmModules[factionid][i] = "SAW.rte"
CF_ItmPrices[factionid][i] = 115
CF_ItmDescriptions[factionid][i] = "Fires a powerful High Mass KME Projectile."
CF_ItmUnlockData[factionid][i] = 2000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 8

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "LMP-45"
CF_ItmPresets[factionid][i] = "LMP-45"
CF_ItmModules[factionid][i] = "SAW.rte"
CF_ItmPrices[factionid][i] = 85
CF_ItmDescriptions[factionid][i] = "Comes with an attachable shield for minor protection."
CF_ItmUnlockData[factionid][i] = 2000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 8

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "THOR-98"
CF_ItmPresets[factionid][i] = "THOR-98"
CF_ItmModules[factionid][i] = "SAW.rte"
CF_ItmPrices[factionid][i] = 95
CF_ItmDescriptions[factionid][i] = "A massive and deadly high caliber rifle.Heavy Only!"
CF_ItmUnlockData[factionid][i] = 2500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 7

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "BAP-9"
CF_ItmPresets[factionid][i] = "BAP-9"
CF_ItmModules[factionid][i] = "SAW.rte"
CF_ItmPrices[factionid][i] = 95
CF_ItmDescriptions[factionid][i] = "Powerful KME Slug propelled Shotgun.Heavy Only!"
CF_ItmUnlockData[factionid][i] = 2500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 7

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "RSC-58LN"
CF_ItmPresets[factionid][i] = "RSC-58LN"
CF_ItmModules[factionid][i] = "SAW.rte"
CF_ItmPrices[factionid][i] = 120
CF_ItmDescriptions[factionid][i] = "A fully Automatic Rocket Launcher.If the Laser Attachment is active then Missiles home into where the laser is pointed."
CF_ItmUnlockData[factionid][i] = 2000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 8

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "BULE-83"
CF_ItmPresets[factionid][i] = "BULE-83"
CF_ItmModules[factionid][i] = "SAW.rte"
CF_ItmPrices[factionid][i] = 75
CF_ItmDescriptions[factionid][i] = "Hybrid Launcher that fires both Kinetic and Ballistic Bombs.Heavy Only!"
CF_ItmUnlockData[factionid][i] = 2500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 7

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "GLUD-5"
CF_ItmPresets[factionid][i] = "GLUD-5"
CF_ItmModules[factionid][i] = "SAW.rte"
CF_ItmPrices[factionid][i] = 75
CF_ItmDescriptions[factionid][i] = "Semi Automatic Grenade Launcher, fires explosive rounds only."
CF_ItmUnlockData[factionid][i] = 2000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 8

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "MLR-4"
CF_ItmPresets[factionid][i] = "MLR-4"
CF_ItmModules[factionid][i] = "SAW.rte"
CF_ItmPrices[factionid][i] = 45
CF_ItmDescriptions[factionid][i] = "Launches 6 Homing Missiles after the enemy."
CF_ItmUnlockData[factionid][i] = 2000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 6

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "FMC-135"
CF_ItmPresets[factionid][i] = "FMC-135"
CF_ItmModules[factionid][i] = "SAW.rte"
CF_ItmPrices[factionid][i] = 130
CF_ItmDescriptions[factionid][i] = "Launches Globs of fire that explode, or just burn. Then Explode.."
CF_ItmUnlockData[factionid][i] = 2500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 6

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "FMC-LN5"
CF_ItmPresets[factionid][i] = "FMC-LN5"
CF_ItmModules[factionid][i] = "SAW.rte"
CF_ItmPrices[factionid][i] = 130
CF_ItmDescriptions[factionid][i] = "Fires a stream of a deadly mix of nano thermite and napalm."
CF_ItmUnlockData[factionid][i] = 2500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 6

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "FR-27"
CF_ItmPresets[factionid][i] = "FR-27"
CF_ItmModules[factionid][i] = "SAW.rte"
CF_ItmPrices[factionid][i] = 65
CF_ItmDescriptions[factionid][i] = "MR-15 got a little makeover, fully automatic KME Subgun."
CF_ItmUnlockData[factionid][i] = 1500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 8

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "VARE-10"
CF_ItmPresets[factionid][i] = "VARE-10"
CF_ItmModules[factionid][i] = "SAW.rte"
CF_ItmPrices[factionid][i] = 95
CF_ItmDescriptions[factionid][i] = "A powerful KME rifle but like all KME based weaponry, results may vary."
CF_ItmUnlockData[factionid][i] = 2000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 8

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "MUGA-K2"
CF_ItmPresets[factionid][i] = "MUGA-K2"
CF_ItmModules[factionid][i] = "SAW.rte"
CF_ItmPrices[factionid][i] = 175
CF_ItmDescriptions[factionid][i] = "High Velocity LMG that fires KME Rounds at extreme speed.Heavy Only!"
CF_ItmUnlockData[factionid][i] = 3000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 7

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "SIG-II"
CF_ItmPresets[factionid][i] = "SIG-II"
CF_ItmModules[factionid][i] = "SAW.rte"
CF_ItmPrices[factionid][i] = 160
CF_ItmDescriptions[factionid][i] = "A cannon that fires an explosive round that explodes mid-air."
CF_ItmUnlockData[factionid][i] = 2500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 9

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "SIG-LOS"
CF_ItmPresets[factionid][i] = "SIG-LOS"
CF_ItmModules[factionid][i] = "SAW.rte"
CF_ItmPrices[factionid][i] = 160
CF_ItmDescriptions[factionid][i] = "A second variant of the SIG series, Automatic and powerful.Heavy Only!"
CF_ItmUnlockData[factionid][i] = 3000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 8

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "RULAS-185"
CF_ItmPresets[factionid][i] = "RULAS-185"
CF_ItmModules[factionid][i] = "SAW.rte"
CF_ItmPrices[factionid][i] = 135
CF_ItmDescriptions[factionid][i] = "Rail Driver, KME propelled mass driver.Heavy Only!"
CF_ItmUnlockData[factionid][i] = 3500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 10
