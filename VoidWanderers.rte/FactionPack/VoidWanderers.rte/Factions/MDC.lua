-- MaximDude Corp. http://forums.datarealms.com/viewtopic.php?f=61&t=17243 by MaximDude
-- Faction file by weegee
-- 
-- Unique Faction ID
local factionid = "MaximDude Corp.";
print ("Loading "..factionid)

CF_Factions[#CF_Factions + 1] = factionid

CF_FactionNames[factionid] = "MaximDude Corp.";
CF_FactionDescriptions[factionid] = "";
CF_FactionPlayable[factionid] = true;

CF_RequiredModules[factionid] = {"MDC.rte"}
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
CF_SuperWeaponBonuses[factionid] = 65
-- Unit price reduction
CF_FactoryBonuses[factionid] = 0
-- Body price reduction
CF_CloneBonuses[factionid] = 0
-- HP regeneration increase
CF_HospitalBonuses[factionid] = 0

-- Define brain unit
CF_Brains[factionid] = "Brain Robot";
CF_BrainModules[factionid] = "Base.rte";
CF_BrainClasses[factionid] = "AHuman";
CF_BrainPrices[factionid] = 500;

-- Define dropship
CF_Crafts[factionid] = "MDC Drop Ship";
CF_CraftModules[factionid] = "MDC.rte";
CF_CraftClasses[factionid] = "ACDropShip";
CF_CraftPrices[factionid] = 100;

-- Define superweapon script
CF_SuperWeaponScripts[factionid] = "UnmappedLands2.rte/SuperWeapons/MDC_Gunship.lua"

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
CF_ActNames[factionid][i] = "MDC Miner Clone"
CF_ActPresets[factionid][i] = "MDC Miner Clone"
CF_ActModules[factionid][i] = "MDC.rte"
CF_ActPrices[factionid][i] = 50
CF_ActDescriptions[factionid][i] = "A special clone designed for mining.  Said clone was not meant for combat and thus alot more vulnerable to weapons then regular soldiers, but has increased falling resistance and will not take damage from falling so easily.  Comes pre-equipped with an MDC Digger."
CF_ActUnlockData[factionid][i] = 0
CF_ActTypes[factionid][i] = CF_ActorTypes.LIGHT;
CF_ActPowers[factionid][i] = 1

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "MDC General Purpose Trooper"
CF_ActPresets[factionid][i] = "MDC General Purpose Trooper"
CF_ActModules[factionid][i] = "MDC.rte"
CF_ActPrices[factionid][i] = 70
CF_ActDescriptions[factionid][i] = "Strength of a heavy, speed of a light, price of a medium.  Dreams do come to life  -  for a short period of time..."
CF_ActUnlockData[factionid][i] = 1000
CF_ActTypes[factionid][i] = CF_ActorTypes.HEAVY;
CF_ActPowers[factionid][i] = 3

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "MDC Man-Bear"
CF_ActPresets[factionid][i] = "MDC Man-Bear"
CF_ActModules[factionid][i] = "MDC.rte"
CF_ActPrices[factionid][i] = 90
CF_ActDescriptions[factionid][i] = "Half-Man, Half-Bear - Typical bullet soaker."
CF_ActUnlockData[factionid][i] = 2000
CF_ActTypes[factionid][i] = CF_ActorTypes.HEAVY;
CF_ActPowers[factionid][i] = 5

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "MDC Kamikaze Jumper"
CF_ActPresets[factionid][i] = "MDC Kamikaze Jumper"
CF_ActModules[factionid][i] = "MDC.rte"
CF_ActPrices[factionid][i] = 0
CF_ActDescriptions[factionid][i] = "MDC enginners decided it would be a good idea to make jumpers suicide bombers aswell.  Jumpers offer better mobility, but deliver a weaker explosion and not as reliable as crabs.  Maulfuntion may occur causing main explosive device detonation failure."
CF_ActUnlockData[factionid][i] = 500
CF_ActTypes[factionid][i] = CF_ActorTypes.LIGHT;
CF_ActPowers[factionid][i] = 0

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "MDC Mini Mobile Machinegun Turret"
CF_ActPresets[factionid][i] = "MDC Mini Mobile Machinegun Turret"
CF_ActModules[factionid][i] = "MDC.rte"
CF_ActPrices[factionid][i] = 80
CF_ActDescriptions[factionid][i] = "A miniature version of the Machinegun Turret.  Designed for easier indoor use.  Features small jump-jet."
CF_ActUnlockData[factionid][i] = 900
CF_ActClasses[factionid][i] = "ACrab"
CF_ActTypes[factionid][i] = CF_ActorTypes.ARMOR;
CF_ActPowers[factionid][i] = 3

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "MDC Mobile Machinegun Turret"
CF_ActPresets[factionid][i] = "MDC Mobile Machinegun Turret"
CF_ActModules[factionid][i] = "MDC.rte"
CF_ActPrices[factionid][i] = 120
CF_ActDescriptions[factionid][i] = "An armored mobile turret armed with a fast firing machinegun.  Used mainly in outnumbered situations."
CF_ActUnlockData[factionid][i] = 3000
CF_ActClasses[factionid][i] = "ACrab"
CF_ActTypes[factionid][i] = CF_ActorTypes.ARMOR;
CF_ActPowers[factionid][i] = 5

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "MDC Kamikaze Crab"
CF_ActPresets[factionid][i] = "MDC Kamikaze Crab"
CF_ActModules[factionid][i] = "MDC.rte"
CF_ActPrices[factionid][i] = 20
CF_ActDescriptions[factionid][i] = "MDC enginners were always bothered by the insane amount of crabs on the planet and the fact they were useless, so they decided it would be cool to turn them to suicide bombers.  Thats right, these crabs have explosive charges implanted directly to their bodies and will explode on command."
CF_ActUnlockData[factionid][i] = 250
CF_ActClasses[factionid][i] = "ACrab"
CF_ActTypes[factionid][i] = CF_ActorTypes.ARMOR;
CF_ActPowers[factionid][i] = 0

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Machinegun Turret"
CF_ActPresets[factionid][i] = "Machinegun Turret"
CF_ActModules[factionid][i] = "MDC.rte"
CF_ActPrices[factionid][i] = 110
CF_ActDescriptions[factionid][i] = "MDC enginners were always bothered by the insane amount of crabs on the planet and the fact they were useless, so they decided it would be cool to turn them to suicide bombers.  Thats right, these crabs have explosive charges implanted directly to their bodies and will explode on command."
CF_ActUnlockData[factionid][i] = 1250
CF_ActClasses[factionid][i] = "ACrab"
CF_ActTypes[factionid][i] = CF_ActorTypes.TURRET;
CF_ActPowers[factionid][i] = 4
CF_ActOffsets[factionid][i] = Vector(0,14)

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Cannon Turret"
CF_ActPresets[factionid][i] = "Cannon Turret"
CF_ActModules[factionid][i] = "MDC.rte"
CF_ActPrices[factionid][i] = 150
CF_ActDescriptions[factionid][i] = "MDC enginners were always bothered by the insane amount of crabs on the planet and the fact they were useless, so they decided it would be cool to turn them to suicide bombers.  Thats right, these crabs have explosive charges implanted directly to their bodies and will explode on command."
CF_ActUnlockData[factionid][i] = 2500
CF_ActClasses[factionid][i] = "ACrab"
CF_ActTypes[factionid][i] = CF_ActorTypes.TURRET;
CF_ActPowers[factionid][i] = 6
CF_ActOffsets[factionid][i] = Vector(0,14)



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
CF_ItmNames[factionid][i] = "MDC Digger"
CF_ItmPresets[factionid][i] = "MDC Digger"
CF_ItmModules[factionid][i] = "MDC.rte"
CF_ItmPrices[factionid][i] = 40
CF_ItmDescriptions[factionid][i] = "MDC's Standard issue digger.  Using a positive/negative charge method, the digger generates considerably less recoil then other diggers, making digging easier."
CF_ItmUnlockData[factionid][i] = 0
CF_ItmTypes[factionid][i] = CF_WeaponTypes.DIGGER;
CF_ItmPowers[factionid][i] = 1

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "MDC Brick Deployer"
CF_ItmPresets[factionid][i] = "MDC Brick Deployer"
CF_ItmModules[factionid][i] = "MDC.rte"
CF_ItmPrices[factionid][i] = 40
CF_ItmDescriptions[factionid][i] = "MDC engineers managed to increase the concrete sprayer's effectiveness by making some minor modifications, and the result was the brick deployer.  Using 200 wet concrete particles, the Deployer is capable of generating 1 concrete brick."
CF_ItmUnlockData[factionid][i] = 450
CF_ItmTypes[factionid][i] = CF_WeaponTypes.TOOL;
CF_ItmPowers[factionid][i] = 0

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "MDC Plasma Cutter"
CF_ItmPresets[factionid][i] = "MDC Plasma Cutter"
CF_ItmModules[factionid][i] = "MDC.rte"
CF_ItmPrices[factionid][i] = 10
CF_ItmDescriptions[factionid][i] = "A powerfull tool used to breach doors.  Handle with caution."
CF_ItmUnlockData[factionid][i] = 450
CF_ItmTypes[factionid][i] = CF_WeaponTypes.TOOL;
CF_ItmPowers[factionid][i] = 0

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "MDC Skinner"
CF_ItmPresets[factionid][i] = "MDC Skinner"
CF_ItmModules[factionid][i] = "MDC.rte"
CF_ItmPrices[factionid][i] = 100
CF_ItmDescriptions[factionid][i] = "No, it doesn't skin your enemies alive, but it does leave then butt naked by removing any armor they may have.  Does not affect craft."
CF_ItmUnlockData[factionid][i] = 450
CF_ItmTypes[factionid][i] = CF_WeaponTypes.TOOL;
CF_ItmPowers[factionid][i] = 0

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "MDC Reflector"
CF_ItmPresets[factionid][i] = "MDC Reflector"
CF_ItmModules[factionid][i] = "MDC.rte"
CF_ItmPrices[factionid][i] = 30
CF_ItmDescriptions[factionid][i] = "Using a new, strong metal, MDC engineers managed to come up with a new type of shield, the reflector.  This shield is capable of reflecting most conventional ammunition and can take a large number of hits before breaking.  Sadly, the new metal weights almost twice as the metal that was used in the past."
CF_ItmUnlockData[factionid][i] = 500
CF_ItmClasses[factionid][i] = "HeldDevice"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SHIELD;
CF_ItmPowers[factionid][i] = 2

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "MDC Acid Sprayer"
CF_ItmPresets[factionid][i] = "MDC Acid Sprayer"
CF_ItmModules[factionid][i] = "MDC.rte"
CF_ItmPrices[factionid][i] = 150
CF_ItmDescriptions[factionid][i] = "A weapon that sprays acid that can eat through pretty much anything.  Highly lethal against anything the enemy has to throw at you.  Since this weapon is very dangerous and is very expensive to mass-produce, MDC had to put a fairly high price tag on it."
CF_ItmUnlockData[factionid][i] = 1500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 5

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "MDC Pistol FG"
CF_ItmPresets[factionid][i] = "MDC Pistol FG"
CF_ItmModules[factionid][i] = "MDC.rte"
CF_ItmPrices[factionid][i] = 5
CF_ItmDescriptions[factionid][i] = "Nothing special really, just a standard pistol.  Slightly more accurate and faster shooting."
CF_ItmUnlockData[factionid][i] = 0
CF_ItmTypes[factionid][i] = CF_WeaponTypes.PISTOL;
CF_ItmPowers[factionid][i] = 1

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "MDC Pistol BG"
CF_ItmPresets[factionid][i] = "MDC Pistol BG"
CF_ItmModules[factionid][i] = "MDC.rte"
CF_ItmPrices[factionid][i] = 9
CF_ItmDescriptions[factionid][i] = "Nothing special really, just a standard pistol.  Slightly more accurate and faster shooting."
CF_ItmUnlockData[factionid][i] = 500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.PISTOL;
CF_ItmPowers[factionid][i] = 0

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "MDC Double Barrel Shotgun"
CF_ItmPresets[factionid][i] = "MDC Double Barrel Shotgun"
CF_ItmModules[factionid][i] = "MDC.rte"
CF_ItmPrices[factionid][i] = 7
CF_ItmDescriptions[factionid][i] = "Recently MDC has found a whole container full of these antique shotguns.  As these are not very effective and very fragile, they come at a discount price of 7 oz gold, a real bargain."
CF_ItmUnlockData[factionid][i] = 500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SHOTGUN;
CF_ItmPowers[factionid][i] = 1

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "MDC Shotgun"
CF_ItmPresets[factionid][i] = "MDC Shotgun"
CF_ItmModules[factionid][i] = "MDC.rte"
CF_ItmPrices[factionid][i] = 60
CF_ItmDescriptions[factionid][i] = "A standard issue 8 shot pump action MDC shotgun.  A powerfull mid-short range weapon, ideal in close quarters."
CF_ItmUnlockData[factionid][i] = 800
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SHOTGUN;
CF_ItmPowers[factionid][i] = 4

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "MDC Auto Shotgun"
CF_ItmPresets[factionid][i] = "MDC Auto Shotgun"
CF_ItmModules[factionid][i] = "MDC.rte"
CF_ItmPrices[factionid][i] = 80
CF_ItmDescriptions[factionid][i] = "A fully automatic version of the MDC shotgun.  Gas operated, 12 shot magazine.  Ideal in close quarters."
CF_ItmUnlockData[factionid][i] = 1600
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SHOTGUN;
CF_ItmPowers[factionid][i] = 6

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "MDC Revolver"
CF_ItmPresets[factionid][i] = "MDC Revolver"
CF_ItmModules[factionid][i] = "MDC.rte"
CF_ItmPrices[factionid][i] = 20
CF_ItmDescriptions[factionid][i] = "Possibly one of the largest revolvers the universe has seen.  Shoots 3.2kg bullets, has a very slow fireing rate.  Uses a recoil reduction system."
CF_ItmUnlockData[factionid][i] = 250
CF_ItmTypes[factionid][i] = CF_WeaponTypes.PISTOL;
CF_ItmPowers[factionid][i] = 4

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "MDC Micro SMG FG"
CF_ItmPresets[factionid][i] = "MDC Micro SMG FG"
CF_ItmModules[factionid][i] = "MDC.rte"
CF_ItmPrices[factionid][i] = 15
CF_ItmDescriptions[factionid][i] = "A small, lightweight, one handed version of the SMG.  Features a larger capacity magazine, although less accurate."
CF_ItmUnlockData[factionid][i] = 700
CF_ItmTypes[factionid][i] = CF_WeaponTypes.PISTOL;
CF_ItmPowers[factionid][i] = 5

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "MDC Micro SMG BG"
CF_ItmPresets[factionid][i] = "MDC Micro SMG BG"
CF_ItmModules[factionid][i] = "MDC.rte"
CF_ItmPrices[factionid][i] = 15
CF_ItmDescriptions[factionid][i] = "A small, lightweight, one handed version of the SMG.  Features a larger capacity magazine, although less accurate."
CF_ItmUnlockData[factionid][i] = 700
CF_ItmTypes[factionid][i] = CF_WeaponTypes.PISTOL;
CF_ItmPowers[factionid][i] = 0

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "MDC Assault Rifle"
CF_ItmPresets[factionid][i] = "MDC Assault Rifle"
CF_ItmModules[factionid][i] = "MDC.rte"
CF_ItmPrices[factionid][i] = 50
CF_ItmDescriptions[factionid][i] = "MDC's standatd issue assault rifle.  Optimal for mid-long range combat.  Features a large capacity magazine and a higher rate of fire."
CF_ItmUnlockData[factionid][i] = 0
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 4

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "MDC Assault Rifle Mark II"
CF_ItmPresets[factionid][i] = "MDC Assault Rifle Mark II"
CF_ItmModules[factionid][i] = "MDC.rte"
CF_ItmPrices[factionid][i] = 70
CF_ItmDescriptions[factionid][i] = "A brand new version of MDC's  assault rifle.  It is now lighter, more accurate, has a larger capacity magazine and is more effective then ever.  Sadly, with great efficiency comes a great price."
CF_ItmUnlockData[factionid][i] = 1000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 6

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "MDC Machinegun"
CF_ItmPresets[factionid][i] = "MDC Machinegun"
CF_ItmModules[factionid][i] = "MDC.rte"
CF_ItmPrices[factionid][i] = 90
CF_ItmDescriptions[factionid][i] = "MDC's squad assault weapon, ideal for supressing enemies and holding barricades.  Uses higher caliber ammo, and has a large capacity magazine along with a high fire rate."
CF_ItmUnlockData[factionid][i] = 1500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 7

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "MDC Gatling Gun"
CF_ItmPresets[factionid][i] = "MDC Gatling Gun"
CF_ItmModules[factionid][i] = "MDC.rte"
CF_ItmPrices[factionid][i] = 120
CF_ItmDescriptions[factionid][i] = "MDC's portable gatling gun.  Originally designed to be mounted on turrets, but because of technical difficulties causing turrets to malfunction when using said guns, it was converted for infantry usage."
CF_ItmUnlockData[factionid][i] = 2500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 9

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "MDC Ion Beam Rifle"
CF_ItmPresets[factionid][i] = "MDC Ion Beam Rifle"
CF_ItmModules[factionid][i] = "MDC.rte"
CF_ItmPrices[factionid][i] = 160
CF_ItmDescriptions[factionid][i] = "A smaller, more compact version of the Beam Cannon, gone through serious reworking in order to make it a worthwile assaul weapon, rather than heavy support.  The Ion Beam Rifle shoots weaker beams than the cannon, but is faster fireing and has a larger magazine capacity."
CF_ItmUnlockData[factionid][i] = 1500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 5

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "MDC Ion Beam Cannon"
CF_ItmPresets[factionid][i] = "MDC Ion Beam Cannon"
CF_ItmModules[factionid][i] = "MDC.rte"
CF_ItmPrices[factionid][i] = 200
CF_ItmDescriptions[factionid][i] = "A powerful weapon that shoots a massive ion beam capable of vaporizing enemies.  The weapon's main core is quite unstable, and will most likely cause vaporization of wielder upon destruction.  Currently considered MDC's most powerful weapon."
CF_ItmUnlockData[factionid][i] = 2500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 7

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "MDC Rocket Launcher"
CF_ItmPresets[factionid][i] = "MDC Rocket Launcher"
CF_ItmModules[factionid][i] = "MDC.rte"
CF_ItmPrices[factionid][i] = 120
CF_ItmDescriptions[factionid][i] = "MDC's own rocket launcher.  MDC engineers looked over many other rocket launchers and were able to create a more efficient one that does more damage and not as complicated to reload."
CF_ItmUnlockData[factionid][i] = 3000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 6

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "MDC Acid Grenade Launcher"
CF_ItmPresets[factionid][i] = "MDC Acid Grenade Launcher"
CF_ItmModules[factionid][i] = "MDC.rte"
CF_ItmPrices[factionid][i] = 135
CF_ItmDescriptions[factionid][i] = "An different variant of MDC's grenade launcher.  Instead of shooting explsive shells, it shoots acid shells, filled with the same acid as the acid grenades.  Uses about one third less acid then a standard acid grenade."
CF_ItmUnlockData[factionid][i] = 750
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 5

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "MDC Plasma Cannon"
CF_ItmPresets[factionid][i] = "MDC Plasma Cannon"
CF_ItmModules[factionid][i] = "MDC.rte"
CF_ItmPrices[factionid][i] = 190
CF_ItmDescriptions[factionid][i] = "A weapon that fires a highly ionized plasma ball, causing enemies to explode after a certain time.  Make sure to keep distance from the ball after it has been released, it won't blow you up, but it sure will hurt you.  Badly."
CF_ItmUnlockData[factionid][i] = 4500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 9

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "MDC Sniper Rifle"
CF_ItmPresets[factionid][i] = "MDC Sniper Rifle"
CF_ItmModules[factionid][i] = "MDC.rte"
CF_ItmPrices[factionid][i] = 60
CF_ItmDescriptions[factionid][i] = "MDC's sniper rifle.  A slightly old design and not as effective as other snipers out there in the galaxy, but a good marksman will be able to kick some ass with this baby."
CF_ItmUnlockData[factionid][i] = 500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SNIPER;
CF_ItmPowers[factionid][i] = 3

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "MDC Sniper Rifle Mark II"
CF_ItmPresets[factionid][i] = "MDC Sniper Rifle Mark II"
CF_ItmModules[factionid][i] = "MDC.rte"
CF_ItmPrices[factionid][i] = 115
CF_ItmDescriptions[factionid][i] = "The mark II is MDC's 20mm HE fed heavy sniper rifle.  Fires explosive rounds capable of dealing immense damage.  Uses a recoil reduction method."
CF_ItmUnlockData[factionid][i] = 1500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SNIPER;
CF_ItmPowers[factionid][i] = 5

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "MDC Rocket Rifle"
CF_ItmPresets[factionid][i] = "MDC Rocket Rifle"
CF_ItmModules[factionid][i] = "MDC.rte"
CF_ItmPrices[factionid][i] = 135
CF_ItmDescriptions[factionid][i] = "A rocket launcher in a revolutionary rifle form.  MDC engineers managed not only to make a rocket fireing rifle, but to bring ammo compression to a new level aswell by compressing 12 of these high explsive, and rather unstable, rockets into one medium size magazine."
CF_ItmUnlockData[factionid][i] = 1500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 6

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "MDC Auto Cannon"
CF_ItmPresets[factionid][i] = "MDC Auto Cannon"
CF_ItmModules[factionid][i] = "MDC.rte"
CF_ItmPrices[factionid][i] = 150
CF_ItmDescriptions[factionid][i] = "MDC's fully automatic high caliber cannon.  This weapon uses the same ammo compression method as the MDC rocket rifle.  The bullets used in this weapon are larger then the ones used in MDC turrets, and yet, the weapon is still usable by infantry thanks to a brand new recoil reduction system."
CF_ItmUnlockData[factionid][i] = 2500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 5

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "MDC EMP Rocket Launcher"
CF_ItmPresets[factionid][i] = "MDC EMP Rocket Launcher"
CF_ItmModules[factionid][i] = "MDC.rte"
CF_ItmPrices[factionid][i] = 125
CF_ItmDescriptions[factionid][i] = "A brand new model of the MDC Rocket Launcher.  The new launcher's main usage is disabling crafts, so instead of HE rockets, the new launcher uses special EMP rockets that are capable of disabling craft engines, rendering crafts useess without damaging the cargo inside...  Well, for a small period of time at least, untill the craft explodes."
CF_ItmUnlockData[factionid][i] = 750
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 0

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "MDC Flame Thrower"
CF_ItmPresets[factionid][i] = "MDC Flame Thrower"
CF_ItmModules[factionid][i] = "MDC.rte"
CF_ItmPrices[factionid][i] = 85
CF_ItmDescriptions[factionid][i] = "The MDC flame thrower, turns your enemy into toast, in seconds only."
CF_ItmUnlockData[factionid][i] = 800
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 0

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "MDC EMP Grenade"
CF_ItmPresets[factionid][i] = "MDC EMP Grenade"
CF_ItmModules[factionid][i] = "MDC.rte"
CF_ItmPrices[factionid][i] = 5
CF_ItmDescriptions[factionid][i] = "A grenade that sends an electro magnetic pulse once detonated, causing all robotics within a certain radius to cease operation and deactivate."
CF_ItmUnlockData[factionid][i] = 150
CF_ItmClasses[factionid][i] = "TDExplosive"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.GRENADE;
CF_ItmPowers[factionid][i] = 0

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "MDC Acid Grenade"
CF_ItmPresets[factionid][i] = "MDC Acid Grenade"
CF_ItmModules[factionid][i] = "MDC.rte"
CF_ItmPrices[factionid][i] = 15
CF_ItmDescriptions[factionid][i] = "A new type of grenade that uses acid to liquidate it's enemies.  Very lethal, tends to create a small acid rain after detonation."
CF_ItmUnlockData[factionid][i] = 550
CF_ItmClasses[factionid][i] = "TDExplosive"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.GRENADE;
CF_ItmPowers[factionid][i] = 4

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "MDC Compressed Air Grenade"
CF_ItmPresets[factionid][i] = "MDC Compressed Air Grenade"
CF_ItmModules[factionid][i] = "MDC.rte"
CF_ItmPrices[factionid][i] = 1
CF_ItmDescriptions[factionid][i] = "Compressed air in a can, how lethal can that possibly be?  Well, MDC discovered that it can be VERY lethal, and because air is very common, manufacturing these grenades is very cheap.  Capable of tearing everybody within blast radius to tiny pieces."
CF_ItmUnlockData[factionid][i] = 250
CF_ItmClasses[factionid][i] = "TDExplosive"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.GRENADE;
CF_ItmPowers[factionid][i] = 1

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "MDC Grenade Launcher"
CF_ItmPresets[factionid][i] = "MDC Grenade Launcher"
CF_ItmModules[factionid][i] = "MDC.rte"
CF_ItmPrices[factionid][i] = 110
CF_ItmDescriptions[factionid][i] = "MDC's own grenade launcher.  Has enhanced explosive power and uses a simple and fast reload method."
CF_ItmUnlockData[factionid][i] = 1000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 3

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "MDC First Aid Kit"
CF_ItmPresets[factionid][i] = "MDC First Aid Kit"
CF_ItmModules[factionid][i] = "MDC.rte"
CF_ItmPrices[factionid][i] = 15
CF_ItmDescriptions[factionid][i] = "MDC's first aid kit, capable of restoring up to 50 health points.  Field deployable and no training is required, optimal in combat conditions.  Will not heal over units original health value.  Will not stop bleeding."
CF_ItmUnlockData[factionid][i] = 550
CF_ItmClasses[factionid][i] = "TDExplosive"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.TOOL;
CF_ItmPowers[factionid][i] = 0

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "MDC Landmine"
CF_ItmPresets[factionid][i] = "MDC Landmine"
CF_ItmModules[factionid][i] = "MDC.rte"
CF_ItmPrices[factionid][i] = 15
CF_ItmDescriptions[factionid][i] = "A standard landmine.  Drop it off and watch your enemies mindlesly step on it and explode.  Be warned, these mines are old and don't have any target identification systems, so keep your distance once you activate one."
CF_ItmUnlockData[factionid][i] = 750
CF_ItmClasses[factionid][i] = "TDExplosive"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.GRENADE;
CF_ItmPowers[factionid][i] = 0

