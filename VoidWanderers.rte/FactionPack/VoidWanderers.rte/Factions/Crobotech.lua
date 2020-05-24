-- Crobotech http://forums.datarealms.com/viewtopic.php?f=61&t=21530 by capnbubs
-- Faction file by Weegee
-- 
-- Unique Faction ID
local factionid = "Crobotech";
print ("Loading "..factionid)

CF_Factions[#CF_Factions + 1] = factionid

CF_FactionNames[factionid] = "Crobotech";
CF_FactionDescriptions[factionid] = "An army of powerful robots with advanced weaponry.";
CF_FactionPlayable[factionid] = true;

CF_RequiredModules[factionid] = {"Crobotech.rte"}
-- Available values ORGANIC, SYNTHETIC
CF_FactionNatures[factionid] = CF_FactionTypes.SYNTHETIC;


-- Define faction bonuses, in percents
-- Scan price reduction
CF_ScanBonuses[factionid] = 0
-- Relation points increase
CF_RelationsBonuses[factionid] = 0
-- Hew HQ build price reduction
CF_ExpansionBonuses[factionid] = 50

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
CF_HospitalBonuses[factionid] = 0


-- Define brain unit
CF_Brains[factionid] = "Brain Robot";
CF_BrainModules[factionid] = "Base.rte";
CF_BrainClasses[factionid] = "AHuman";
CF_BrainPrices[factionid] = 500;

-- Define dropship
CF_Crafts[factionid] = "Orbital Teleportation";
CF_CraftModules[factionid] = "Crobotech.rte";
CF_CraftClasses[factionid] = "ACRocket";
CF_CraftPrices[factionid] = 100;

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
CF_ActNames[factionid][i] = "Light"
CF_ActPresets[factionid][i] = "Light"
CF_ActModules[factionid][i] = "Crobotech.rte"
CF_ActPrices[factionid][i] = 220
CF_ActDescriptions[factionid][i] = "Standard Crobotech infantry. A sophisticated and highly durable robotic body with an organic brain. Although virtually impervious to small arms fire the helmet is less structurally secure than the rest of the unit."
CF_ActUnlockData[factionid][i] = 0 
CF_ActTypes[factionid][i] = CF_ActorTypes.LIGHT;
CF_ActPowers[factionid][i] = 7

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Heavy"
CF_ActPresets[factionid][i] = "Heavy"
CF_ActModules[factionid][i] = "Crobotech.rte"
CF_ActPrices[factionid][i] = 200
CF_ActDescriptions[factionid][i] = "A heavily armoured version of the Crobotech infantry unit. Can take much more punishment due to a kinetic shielding system built into the surface of the armour, however the shield will give in eventually or can be bypassed completely with a large enough kinetic force."
CF_ActUnlockData[factionid][i] = 2500 
CF_ActTypes[factionid][i] = CF_ActorTypes.HEAVY;
CF_ActPowers[factionid][i] = 9

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Crobotech Tank"
CF_ActPresets[factionid][i] = "Crobotech Tank"
CF_ActModules[factionid][i] = "Crobotech.rte"
CF_ActPrices[factionid][i] = 700
CF_ActDescriptions[factionid][i] = "A long range mobile artillery piece with advanced ballistic prediction. Vulnerable in close combat."
CF_ActUnlockData[factionid][i] = 3000 
CF_ActClasses[factionid][i] = "ACrab"
CF_ActTypes[factionid][i] = CF_ActorTypes.ARMOR;
CF_ActPowers[factionid][i] = 0

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
CF_ItmNames[factionid][i] = "Heavy Digger"
CF_ItmPresets[factionid][i] = "Heavy Digger"
CF_ItmModules[factionid][i] = "Base.rte"
CF_ItmPrices[factionid][i] = 100
CF_ItmDescriptions[factionid][i] = "Heaviest and the most powerful of them all. Eats concrete with great hunger and allows you to make complex mining caves incredibly fast. Shreds anyone unfortunate who stand in its way."
CF_ItmUnlockData[factionid][i] = 0
CF_ItmTypes[factionid][i] = CF_WeaponTypes.DIGGER;
CF_ItmPowers[factionid][i] = 8

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "SUPRT: Ballistic Pistol"
CF_ItmPresets[factionid][i] = "SUPRT: Ballistic Pistol"
CF_ItmModules[factionid][i] = "Crobotech.rte"
CF_ItmPrices[factionid][i] = 35
CF_ItmDescriptions[factionid][i] = "A semi-automatic pistol that can be dual wielded. Has a larger than average 20 round clip."
CF_ItmUnlockData[factionid][i] = 0
CF_ItmTypes[factionid][i] = CF_WeaponTypes.PISTOL;
CF_ItmPowers[factionid][i] = 4

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "ASSLT: Ballistic Rifle"
CF_ItmPresets[factionid][i] = "ASSLT: Ballistic Rifle"
CF_ItmModules[factionid][i] = "Crobotech.rte"
CF_ItmPrices[factionid][i] = 85
CF_ItmDescriptions[factionid][i] = "The standard assault weapon of the Crobotech forces. A very high fire rate and armour piercing capability make this weapon very powerfull but, due to an average clip size, care must be taken to avoid reloading under fire."
CF_ItmUnlockData[factionid][i] = 0
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 6

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "CLOSE: High Velocity Shotgun"
CF_ItmPresets[factionid][i] = "CLOSE: High Velocity Shotgun"
CF_ItmModules[factionid][i] = "Crobotech.rte"
CF_ItmPrices[factionid][i] = 120
CF_ItmDescriptions[factionid][i] = "Fires a cluster of highly penetrative projectiles that will cause massive damage to anything at close to medium range."
CF_ItmUnlockData[factionid][i] = 550
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SHOTGUN;
CF_ItmPowers[factionid][i] = 7

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "SUPRT: Energy Pistol"
CF_ItmPresets[factionid][i] = "SUPRT: Energy Pistol"
CF_ItmModules[factionid][i] = "Crobotech.rte"
CF_ItmPrices[factionid][i] = 50
CF_ItmDescriptions[factionid][i] = "Based on the Energy Rifle's technology compacted into a one handed form. This smaller weapon only holds 8 rounds per clip but can be effectively dual wielded."
CF_ItmUnlockData[factionid][i] = 500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.PISTOL;
CF_ItmPowers[factionid][i] = 0

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "ENRGY: Energy Rifle"
CF_ItmPresets[factionid][i] = "ENRGY: Energy Rifle"
CF_ItmModules[factionid][i] = "Crobotech.rte"
CF_ItmPrices[factionid][i] = 75
CF_ItmDescriptions[factionid][i] = "A very powerful energy based assault rifle. Slower rate of fire but effective against all targets."
CF_ItmUnlockData[factionid][i] = 500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 6

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "EXPLO: Grenade Launcher"
CF_ItmPresets[factionid][i] = "EXPLO: Grenade Launcher"
CF_ItmModules[factionid][i] = "Crobotech.rte"
CF_ItmPrices[factionid][i] = 120
CF_ItmDescriptions[factionid][i] = "A single round grenade launcher that fires timed explosives. Although relatively low yield, can be very effective when used tactically."
CF_ItmUnlockData[factionid][i] = 800
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 7

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "ASSLT: Machine Gun"
CF_ItmPresets[factionid][i] = "ASSLT: Machine Gun"
CF_ItmModules[factionid][i] = "Crobotech.rte"
CF_ItmPrices[factionid][i] = 120
CF_ItmDescriptions[factionid][i] = "Also known as the 'Thumper'. This powerful automatic weapon has a medium rate of fire and a large clip, making it effective for supression."
CF_ItmUnlockData[factionid][i] = 1500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 7

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "EXPLO: Rocket Propelled Grenade"
CF_ItmPresets[factionid][i] = "EXPLO: Rocket Propelled Grenade"
CF_ItmModules[factionid][i] = "Crobotech.rte"
CF_ItmPrices[factionid][i] = 90
CF_ItmDescriptions[factionid][i] = "This unguided rocket is inaccurate but very powerful. Highly unsafe in confined spaces."
CF_ItmUnlockData[factionid][i] = 1200
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 8

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "SUPRT: Particle Disruption Rifle"
CF_ItmPresets[factionid][i] = "SUPRT: Particle Disruption Rifle"
CF_ItmModules[factionid][i] = "Crobotech.rte"
CF_ItmPrices[factionid][i] = 200
CF_ItmDescriptions[factionid][i] = "Creates a beam along which particles are greatly agitated causing damage to anything it passes through. Due to the nature of this weapon it is unreliable in anti-personnel use but immensely efficient against large targets."
CF_ItmUnlockData[factionid][i] = 250
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 0 -- Looks like it does not work in 1.0

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "GTLNG: Gatling Cannon"
CF_ItmPresets[factionid][i] = "GTLNG: Gatling Cannon"
CF_ItmModules[factionid][i] = "Crobotech.rte"
CF_ItmPrices[factionid][i] = 210
CF_ItmDescriptions[factionid][i] = "A formidible gatling cannon. The kinetic force of the lead blanket this weapon produces is so great that, even if it does not pierce your enemies armour, it will force your enemies back into cover."
CF_ItmUnlockData[factionid][i] = 2500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 9

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "SUPRT: Laser Cannon"
CF_ItmPresets[factionid][i] = "SUPRT: Laser Cannon"
CF_ItmModules[factionid][i] = "Crobotech.rte"
CF_ItmPrices[factionid][i] = 170
CF_ItmDescriptions[factionid][i] = "A sustained beam weapon that causes a destabilisation of particles in the air at the point of impact. After a moment these particles will explode violently, causing massive damage to anything caught in the reaction."
CF_ItmUnlockData[factionid][i] = 2500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 9

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "SUPRT: Lazer Rifle"
CF_ItmPresets[factionid][i] = "SUPRT: Lazer Rifle"
CF_ItmModules[factionid][i] = "Crobotech.rte"
CF_ItmPrices[factionid][i] = 120
CF_ItmDescriptions[factionid][i] = "A sustained beam weapon that causes a destabilisation of particles in the air at the point of impact. After a moment these particles will explode violently, causing massive damage to anything caught in the reaction."
CF_ItmUnlockData[factionid][i] = 1500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 5

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "EXPLO: Rocket Launcher"
CF_ItmPresets[factionid][i] = "EXPLO: Rocket Launcher"
CF_ItmModules[factionid][i] = "Crobotech.rte"
CF_ItmPrices[factionid][i] = 75
CF_ItmDescriptions[factionid][i] = "A four round, semi-automatic rocket launcher. Highly effective in long range combat against any enemy. Use each shot seperately to improve effectiveness against groups of light armoured targets or fire in quick succession to eliminate larger threats quickly and efficiently. Unsafe for close combat."
CF_ItmUnlockData[factionid][i] = 750
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 9

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "ENRGY: Plasma Gun"
CF_ItmPresets[factionid][i] = "ENRGY: Plasma Gun"
CF_ItmModules[factionid][i] = "Crobotech.rte"
CF_ItmPrices[factionid][i] = 130
CF_ItmDescriptions[factionid][i] = "A high power plasma cannon that fires explosive projectiles at high speeds. Be careful not to use at very close range."
CF_ItmUnlockData[factionid][i] = 850
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 7

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Crobo Grenade"
CF_ItmPresets[factionid][i] = "Crobo Grenade"
CF_ItmModules[factionid][i] = "Crobotech.rte"
CF_ItmPrices[factionid][i] = 10
CF_ItmDescriptions[factionid][i] = "A single round grenade launcher that fires timed explosives. Although relatively low yield, can be very effective when used tactically."
CF_ItmUnlockData[factionid][i] = 400
CF_ItmClasses[factionid][i] = "TDExplosive";
CF_ItmTypes[factionid][i] = CF_WeaponTypes.GRENADE;
CF_ItmPowers[factionid][i] = 7