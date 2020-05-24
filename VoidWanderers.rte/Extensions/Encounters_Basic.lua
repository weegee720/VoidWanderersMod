local id = "TEST";

CF_RandomEncounters[#CF_RandomEncounters + 1] = id
	
CF_RandomEncountersInitialTexts[id] = "TEST ENCOUNTER"
CF_RandomEncountersInitialVariants[id] = {"Variant 1", "Variant 2", "Variant 3"}
CF_RandomEncountersOneTime[id] = false
CF_RandomEncountersFunctions[id] = 

function (activity, variant) 
	print ("Test")
end
