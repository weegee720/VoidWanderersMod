-- Unique Faction ID
local factionid = "Browncoats";
--print ("Loading "..factionid)

CF_Factions[#CF_Factions + 1] = factionid

-- Faction name
CF_FactionNames[factionid] = "Browncoats";
-- Faction description
CF_FactionDescriptions[factionid] = "A strong mercenary group who are fearsome when confronted up-close. What they lack in range is made up for in durability, allowing them to close distances while soaking bullets.";
-- Set true if faction is selectable by player or AI
CF_FactionPlayable[factionid] = true;

-- Main module used to check if mod is installed and as backward compatibility layer with v1-faction files enabled missions
CF_RequiredModules[factionid] = {"Base.rte", "Browncoats.rte"}

-- Set faction nature
CF_FactionNatures[factionid] = CF_FactionTypes.ORGANIC;

-- Define faction bonuses, in percents
CF_ScanBonuses[factionid] = 0
CF_RelationsBonuses[factionid] = 50
CF_ExpansionBonuses[factionid] = 0

CF_MineBonuses[factionid] = 5
CF_LabBonuses[factionid] = 5
CF_AirfieldBonuses[factionid] = 25
CF_SuperWeaponBonuses[factionid] = 0
CF_FactoryBonuses[factionid] = 5
CF_CloneBonuses[factionid] = 5
CF_HospitalBonuses[factionid] = 0


-- Define brain unit
CF_Brains[factionid] = "Brain Robot";
CF_BrainModules[factionid] = "Base.rte";
CF_BrainClasses[factionid] = "AHuman";
CF_BrainPrices[factionid] = 500;

-- Define dropship	
CF_Crafts[factionid] = "Drop Ship MK1";
CF_CraftModules[factionid] = "Base.rte";
CF_CraftClasses[factionid] = "ACDropShip";
CF_CraftPrices[factionid] = 120;

-- Define superweapon script
CF_SuperWeaponScripts[factionid] = "UnmappedLands2.rte/SuperWeapons/NapalmBombing.lua"

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
CF_ActNames[factionid][i] = "Browncoat Light"
CF_ActPresets[factionid][i] = "Browncoat Light"
CF_ActModules[factionid][i] = "Browncoats.rte"
CF_ActPrices[factionid][i] = 125
CF_ActDescriptions[factionid][i] = "Tough mercenaries who are well armored and equipped with strong jetpacks."
CF_ActUnlockData[factionid][i] = 0
CF_ActTypes[factionid][i] = CF_ActorTypes.LIGHT;
CF_ActPowers[factionid][i] = 3

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Browncoat Heavy"
CF_ActPresets[factionid][i] = "Browncoat Heavy"
CF_ActModules[factionid][i] = "Browncoats.rte"
CF_ActPrices[factionid][i] = 160
CF_ActDescriptions[factionid][i] = "An even stronger fighter than the 'ligher' variant, this monster can take quite a beating before he dies on you."
CF_ActUnlockData[factionid][i] = 2000
CF_ActTypes[factionid][i] = CF_ActorTypes.HEAVY;
CF_ActPowers[factionid][i] = 6



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
CF_ItmNames[factionid][i] = "HG-10 Stinger"
CF_ItmPresets[factionid][i] = "HG-10 Stinger"
CF_ItmModules[factionid][i] = "Browncoats.rte"
CF_ItmPrices[factionid][i] = 35
CF_ItmDescriptions[factionid][i] = "Compact with a high rate of fire, this handgun can also function as a primary weapon."
CF_ItmUnlockData[factionid][i] = 0
CF_ItmTypes[factionid][i] = CF_WeaponTypes.PISTOL;
CF_ItmPowers[factionid][i] = 3

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Fire Bomb"
CF_ItmPresets[factionid][i] = "Fire Bomb"
CF_ItmModules[factionid][i] = "Browncoats.rte"
CF_ItmPrices[factionid][i] = 10
CF_ItmDescriptions[factionid][i] = "When thrown, this canister will burst into flames in 3 seconds and burn for 10 seconds."
CF_ItmUnlockData[factionid][i] = 350
CF_ItmClasses[factionid][i] = "TDExplosive"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.GRENADE;
CF_ItmPowers[factionid][i] = 2

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Fuel Bomb"
CF_ItmPresets[factionid][i] = "Fuel Bomb"
CF_ItmModules[factionid][i] = "Browncoats.rte"
CF_ItmPrices[factionid][i] = 5
CF_ItmDescriptions[factionid][i] = "This canister contains a mixture of flammable chemicals that ignite in a short period of time after being released."
CF_ItmUnlockData[factionid][i] = 250
CF_ItmClasses[factionid][i] = "TDExplosive"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.GRENADE;
CF_ItmPowers[factionid][i] = 1

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "AR-25 Hammerfist"
CF_ItmPresets[factionid][i] = "AR-25 Hammerfist"
CF_ItmModules[factionid][i] = "Browncoats.rte"
CF_ItmPrices[factionid][i] = 60
CF_ItmDescriptions[factionid][i] = "A sturdy, powerful assault rifle with a 25-round magazine."
CF_ItmUnlockData[factionid][i] = 0
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 5

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "SR-06 Longshot"
CF_ItmPresets[factionid][i] = "SR-06 Longshot"
CF_ItmModules[factionid][i] = "Browncoats.rte"
CF_ItmPrices[factionid][i] = 90
CF_ItmDescriptions[factionid][i] = "Reliable and powerful long-ranged weapon with a steady rate of fire."
CF_ItmUnlockData[factionid][i] = 1500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SNIPER;
CF_ItmPowers[factionid][i] = 6

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "IN-02 Backblast"
CF_ItmPresets[factionid][i] = "IN-02 Backblast"
CF_ItmModules[factionid][i] = "Browncoats.rte"
CF_ItmPrices[factionid][i] = 75
CF_ItmDescriptions[factionid][i] = "An incendiary shotgun that can fire 2 blasts of scorching flames."
CF_ItmUnlockData[factionid][i] = 1200
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SHOTGUN;
CF_ItmPowers[factionid][i] = 6

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "FL-200 Heatlance"
CF_ItmPresets[factionid][i] = "FL-200 Heatlance"
CF_ItmModules[factionid][i] = "Browncoats.rte"
CF_ItmPrices[factionid][i] = 90
CF_ItmDescriptions[factionid][i] = "Light flamethrower that is extremely powerful in close quarters."
CF_ItmUnlockData[factionid][i] = 1000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SHOTGUN;
CF_ItmPowers[factionid][i] = 5

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "PY-07 Trailblazer"
CF_ItmPresets[factionid][i] = "PY-07 Trailblazer"
CF_ItmModules[factionid][i] = "Browncoats.rte"
CF_ItmPrices[factionid][i] = 140
CF_ItmDescriptions[factionid][i] = "Firing blazing bullets, this pyro rifle can both burn and pierce enemies at a moderate distance."
CF_ItmUnlockData[factionid][i] = 2000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 8

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "GL-01 Magmaul"
CF_ItmPresets[factionid][i] = "GL-01 Magmaul"
CF_ItmModules[factionid][i] = "Browncoats.rte"
CF_ItmPrices[factionid][i] = 120
CF_ItmDescriptions[factionid][i] = "This handy launcher spits out fuel canisters that are either ignited initially and burn for 4 seconds before exploding, or launches a canister that bursts and spills fuel over and area before igniting the flammable chemicals."
CF_ItmUnlockData[factionid][i] = 2000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 8

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "CA-01 Firestorm"
CF_ItmPresets[factionid][i] = "CA-01 Firestorm"
CF_ItmModules[factionid][i] = "Browncoats.rte"
CF_ItmPrices[factionid][i] = 170
CF_ItmDescriptions[factionid][i] = "Powerful cannon that fires explosive incendiary shells."
CF_ItmUnlockData[factionid][i] = 2500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 8

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "ML-02 Flash"
CF_ItmPresets[factionid][i] = "ML-02 Flash"
CF_ItmModules[factionid][i] = "Browncoats.rte"
CF_ItmPrices[factionid][i] = 250
CF_ItmDescriptions[factionid][i] = "The Flash carries two fire-and-forget missiles in separate launch tubes. The seeker heads in the missiles can target both terrain and moving objects but need a moment to lock on to its pray."
CF_ItmUnlockData[factionid][i] = 2500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 7

