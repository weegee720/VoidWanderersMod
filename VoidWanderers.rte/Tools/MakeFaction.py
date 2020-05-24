#	Unmapped Lands 2 faction maker script
#	Author:
#		Evgeniy Vigovskiy aka Weegee
#
#	Version:
#		1.0
#
#	Usage:
#		Copy mod .rte folder to the same location where this script resides, 
#		or copy script to CC installation folder if you want to work with 
#		installed mods. Install Python 3.2 and run in command line:  
#
#		MakeFaction.py <module.rte> <outfile.lua> <factionname>
#
#	Example:
#		MakeFaction.py GeneralIndustries.rte GeneralIndustries.lua "General Industries"
#
#	Warning:
#		This mod simply dumps all available actors and items from mod. It does
#		not make usable faction files, it just creates an almost blank faction file to start 
#		with. You still have to manually set unlock values, weapon and actor types
#		etc. This script never updates existing faction files, it overwrites them and
#		in this case all your manual edits are be lost. 
#

import sys

def ParseFile(path, objects):
	print(path)
	
	input = open(path, 'r')
	lines = input.readlines()
	
	curobject = dict()
	
	nextcommentmode = False
	commentmode = False
	
	for l in lines:
		#Discard comments
		cmnts = l.split("//")
		ln = cmnts[0]
		
		cmnts = ln.split("/*")
		ln = cmnts[0]
		if len(cmnts) > 1:
			nextcommentmode = True

		cmnts = ln.split("*/")
		if len(cmnts) > 1:
			ln = cmnts[1]
			nextcommentmode = False
			commentmode = False

		if not commentmode: 
			v = ln.split("=");
			t = list()

			indentlevel = 0
			
			for j in range(0,len(ln)):
				if ln[j] == '\t':
					indentlevel = indentlevel + 1
			
			for i in range(0, len(v)):
				v[i] = v[i].strip()
			
			if len(v) > 1:
				v[0] = v[0].lower()
				
				#Parse included files
				if v[0] == "includefile":
					ParseFile(v[1], objects)
					
				#Parse actors
				if v[0].startswith("add") and indentlevel == 0:
					if "PresetName" in curobject and "Class" in curobject:
						if curobject["Class"] in AllowedClasses:
							objects[curobject["PresetName"]] = curobject;
					
					curobject = dict()
					curobject["Class"] = v[1]
					
				#Parse values
				if indentlevel == 1:
					if v[0] == "presetname":
						curobject["PresetName"] = v[1];
						
						#Refresh object data if preset already defined
						if curobject["PresetName"] in objects:
							if (not "GoldValue" in curobject) and ("GoldValue" in objects[curobject["PresetName"]]):
								curobject["GoldValue"] = objects[curobject["PresetName"]]["GoldValue"]

							if (not "Buyable" in curobject) and ("Buyable" in objects[curobject["PresetName"]]):
								curobject["Buyable"] = objects[curobject["PresetName"]]["Buyable"]							
						
							if (not "GibWoundLimit" in curobject) and ("GibWoundLimit" in objects[curobject["PresetName"]]):
								curobject["GibWoundLimit"] = objects[curobject["PresetName"]]["GibWoundLimit"]

							if (not "Description" in curobject) and ("Description" in objects[curobject["PresetName"]]):
								curobject["Description"] = objects[curobject["PresetName"]]["Description"]							

					if v[0] == "copyof":
						curobject["CopyOf"] = v[1]
						
					if v[0] == "buyable":
						curobject["Buyable"] = v[1]
						
					if v[0] == "goldvalue":
						curobject["GoldValue"] = v[1]

					if v[0] == "gibwoundlimit":
						curobject["GibWoundLimit"] = v[1]
						
					if v[0] == "description":
						curobject["Description"] = v[1];

		commentmode = nextcommentmode


	#Dump the last object when finished parsing file
	if "PresetName" in curobject and "Class" in curobject:
		if curobject["Class"] in AllowedClasses:
			objects[curobject["PresetName"]] = curobject;
	
	curobject = dict()
		
	input.close()

def GetValues(obj, objects):
	#print (obj)
	values = dict()

	#print ("PRE=" + obj["PresetName"])
	if "CopyOf" in obj:
		#print ("CPY=" + obj["CopyOf"])
		if obj["PresetName"] != obj["CopyOf"]:
			if obj["CopyOf"] in objects:
				values = GetValues(objects[obj["CopyOf"]], objects)
		values["CopyOf"] = obj["CopyOf"]
	#else:
		#print ("---")
		
	if "Buyable" in obj:
		values["Buyable"] = obj["Buyable"]
	
	if "GoldValue" in obj:
		values["GoldValue"] = obj["GoldValue"]
		
	if "PresetName" in obj:
		values["PresetName"] = obj["PresetName"]

	if "Class" in obj:
		values["Class"] = obj["Class"]

	if "Description" in obj:
		values["Description"] = obj["Description"]

	if "GibWoundLimit" in obj:
		values["GibWoundLimit"] = obj["GibWoundLimit"]
		
	return values
		
Objects = dict()

ModFolder = sys.argv[1]
OutputFile = sys.argv[2]
FactionName = sys.argv[3]

AllowedClasses = ["AHuman", "ACrab", "HDFirearm", "TDExplosive", "HeldDevice"]

ActorClasses = ["AHuman", "ACrab"]
ItemClasses = ["HDFirearm", "TDExplosive", "HeldDevice"]

#Actors with gib wound lower than this are considered light and others are heavy
GibWoundLimitHeavyThreshold = 15

Index = ModFolder + "/index.ini"

ParseFile(Index, Objects)

Actors = dict()
Items = dict()

for k in Objects.keys():
	usable = False

	vals = GetValues(Objects[k], Objects)
	
	#print (vals)
	
	if "Buyable" in vals:
		if vals["Buyable"] == "1":
			usable = True
		else:
			usable = False;
	else:
		usable = True

	if usable:
		cls = vals["Class"]
		
		if cls in AllowedClasses:
			usable = True
		else:
			usable = False
		
	if usable:
		if not "GoldValue" in vals:
			vals["GoldValue"] = "0"
	
		if not "Description" in vals:
			vals["Description"] = ""

		if not "GibWoundLimit" in vals:
			vals["GibWoundLimit"] = "0"

		print ('PRE= ' + vals["PresetName"])
		print ('CLS= ' + vals["Class"])
		print ('VAL= ' + vals["GoldValue"])
		#print ('DSC= ' + vals["Description"])
		print ('WND= ' + vals["GibWoundLimit"])
		
		if vals["Class"] in ActorClasses:
			Actors[vals["PresetName"]] = vals

		if vals["Class"] in ItemClasses:
			Items[vals["PresetName"]] = vals

out = open(OutputFile, 'w')

out.write('-- <Mod name here> <Mod URL here> by <Mod author here>\n')
out.write('-- Faction file by <Faction file contributors here>\n')
out.write('-- \n')

out.write('-- Unique Faction ID\n')
out.write('local factionid = "' + FactionName + '";\n')
out.write('print ("Loading "..factionid)\n')
out.write('\n')
out.write('CF_Factions[#CF_Factions + 1] = factionid\n')
out.write('\n')
out.write('CF_FactionNames[factionid] = "' + FactionName + '";\n')
out.write('CF_FactionDescriptions[factionid] = "";\n')
out.write('CF_FactionPlayable[factionid] = true;\n')
out.write('\n')
out.write('CF_RequiredModules[factionid] = {"' + ModFolder + '"}')
out.write('\n')
out.write('-- Available values ORGANIC, SYNTHETIC\n')
out.write('CF_FactionNatures[factionid] = CF_FactionTypes.ORGANIC;\n')
out.write('\n')
out.write('\n')
out.write('-- Define faction bonuses, in percents\n')
out.write('-- Scan price reduction\n')
out.write('CF_ScanBonuses[factionid] = 0\n')
out.write('-- Relation points increase\n')
out.write('CF_RelationsBonuses[factionid] = 0\n')
out.write('-- Hew HQ build price reduction\n')
out.write('CF_ExpansionBonuses[factionid] = 0\n')
out.write('\n')
out.write('-- Gold per turn increase\n')
out.write('CF_MineBonuses[factionid] = 0\n')
out.write('-- Science per turn increase\n')
out.write('CF_LabBonuses[factionid] = 0\n')
out.write('-- Delivery time reduction\n')
out.write('CF_AirfieldBonuses[factionid] = 0\n')
out.write('-- Superweapon targeting reduction\n')
out.write('CF_SuperWeaponBonuses[factionid] = 0\n')
out.write('-- Unit price reduction\n')
out.write('CF_FactoryBonuses[factionid] = 0\n')
out.write('-- Body price reduction\n')
out.write('CF_CloneBonuses[factionid] = 0\n')
out.write('-- HP regeneration increase\n')
out.write('CF_HospitalBonuses[factionid] = 0\n')
out.write('\n')
out.write('\n')
out.write('-- Define brain unit\n')
out.write('CF_Brains[factionid] = "Brain Robot";\n')
out.write('CF_BrainModules[factionid] = "Base.rte";\n')
out.write('CF_BrainClasses[factionid] = "AHuman";\n')
out.write('CF_BrainPrices[factionid] = 500;\n')
out.write('\n')
out.write('-- Define dropship\n')
out.write('CF_Crafts[factionid] = "Drop Ship MK1";\n')
out.write('CF_CraftModules[factionid] = "Base.rte";\n')
out.write('CF_CraftClasses[factionid] = "ACDropShip";\n')
out.write('CF_CraftPrices[factionid] = 120;\n')
out.write('\n')
out.write('-- Define superweapon script\n')
out.write('CF_SuperWeaponScripts[factionid] = "UnmappedLands2.rte/SuperWeapons/Bombing.lua"\n')
out.write('\n')
out.write('-- Define buyable actors available for purchase or unlocks\n')
out.write('CF_ActNames[factionid] = {}\n')
out.write('CF_ActPresets[factionid] = {}\n')
out.write('CF_ActModules[factionid] = {}\n')
out.write('CF_ActPrices[factionid] = {}\n')
out.write('CF_ActDescriptions[factionid] = {}\n')
out.write('CF_ActUnlockData[factionid] = {}\n')
out.write('CF_ActClasses[factionid] = {}\n')
out.write('CF_ActTypes[factionid] = {}\n')
out.write('CF_ActPowers[factionid] = {}\n')
out.write('CF_ActOffsets[factionid] = {}\n')
out.write('\n')
out.write('local i = 0\n')

#Start dumping actors
for k in Actors.keys():
	out.write('i = #CF_ActNames[factionid] + 1\n')
	out.write('CF_ActNames[factionid][i] = "' + Actors[k]["PresetName"].replace('"', '\\"') + '"\n')
	out.write('CF_ActPresets[factionid][i] = "' + Actors[k]["PresetName"].replace('"', '\\"') + '"\n')
	out.write('CF_ActModules[factionid][i] = "' + ModFolder + '"\n')
	out.write('CF_ActPrices[factionid][i] = ' + Actors[k]["GoldValue"] + '\n')
	out.write('CF_ActDescriptions[factionid][i] = "' + Actors[k]["Description"].replace('"', '\\"') + '"\n')
	out.write('CF_ActUnlockData[factionid][i] = 0\n')

	#Write class only if it's not the default AHuman
	if Actors[k]["Class"] != "AHuman":
		out.write('CF_ActClasses[factionid][i] = "' + Actors[k]["Class"] + '"\n')
	
	#Try to guess actor type
	if Actors[k]["Class"] == "AHuman":
		if int(Actors[k]["GibWoundLimit"]) < GibWoundLimitHeavyThreshold:
			out.write('CF_ActTypes[factionid][i] = CF_ActorTypes.LIGHT;\n')
		else:
			out.write('CF_ActTypes[factionid][i] = CF_ActorTypes.HEAVY;\n')
	else:
		out.write('CF_ActTypes[factionid][i] = CF_ActorTypes.ARMOR;\n')
	out.write('CF_ActPowers[factionid][i] = 0\n')
	out.write('\n')

out.write('\n')
out.write('\n')
out.write('\n')
out.write('\n')
out.write('-- Define buyable items available for purchase or unlocks\n')
out.write('CF_ItmNames[factionid] = {}\n')
out.write('CF_ItmPresets[factionid] = {}\n')
out.write('CF_ItmModules[factionid] = {}\n')
out.write('CF_ItmPrices[factionid] = {}\n')
out.write('CF_ItmDescriptions[factionid] = {}\n')
out.write('CF_ItmUnlockData[factionid] = {}\n')
out.write('CF_ItmClasses[factionid] = {}\n')
out.write('CF_ItmTypes[factionid] = {}\n')
out.write('CF_ItmPowers[factionid] = {} -- AI will select weapons based on this value 1 - weakest, 10 toughest, 0 never use\n')
out.write('\n')
out.write('-- Available weapon types\n')
out.write('-- PISTOL, RIFLE, SHOTGUN, SNIPER, HEAVY, SHIELD, DIGGER, GRENADE\n')
out.write('\n')
out.write('local i = 0\n')

#Start dumping actors
for k in Items.keys():
	out.write('i = #CF_ItmNames[factionid] + 1\n')
	out.write('CF_ItmNames[factionid][i] = "' + Items[k]["PresetName"].replace('"', '\\"') + '"\n')
	out.write('CF_ItmPresets[factionid][i] = "' + Items[k]["PresetName"].replace('"', '\\"') + '"\n')
	out.write('CF_ItmModules[factionid][i] = "' + ModFolder + '"\n')
	out.write('CF_ItmPrices[factionid][i] = ' + Items[k]["GoldValue"] + '\n')
	out.write('CF_ItmDescriptions[factionid][i] = "' + Items[k]["Description"].replace('"', '\\"') + '"\n')
	out.write('CF_ItmUnlockData[factionid][i] = 0\n')

	#Write class only if it's not the default HDFIrearm
	if Items[k]["Class"] != "HDFirearm":
		out.write('CF_ItmClasses[factionid][i] = "' + Items[k]["Class"] + '"\n')
	
	#Try to guess Item type
	if Items[k]["Class"] == "HeldDevice":
		out.write('CF_ItmTypes[factionid][i] = CF_WeaponTypes.SHIELD;\n')
	else:
		if Items[k]["Class"] == "TDExplosive":
			out.write('CF_ItmTypes[factionid][i] = CF_WeaponTypes.GRENADE;\n')
		else: 
			if Items[k]["Class"] == "HDFirearm":
				out.write('CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;\n')

	out.write('CF_ItmPowers[factionid][i] = 0\n')
	out.write('\n')
	
out.close()