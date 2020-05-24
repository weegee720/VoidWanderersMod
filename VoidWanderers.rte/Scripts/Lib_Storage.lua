-----------------------------------------------------------------------------------------
--	Returns sorted array of stored items from game state. If makefilters is true, then 
--	it will also return additional array with filtered items
-----------------------------------------------------------------------------------------
function CF_GetStorageArray(gs, makefilters)
	local arr = {}
	
	-- Copy items
	for i = 1, CF_MaxStorageItems do
		if gs["ItemStorage"..i.."Preset"] ~= nil then
			arr[i] = {}
			arr[i]["Preset"] = gs["ItemStorage"..i.."Preset"]
			arr[i]["Class"] = gs["ItemStorage"..i.."Class"]
			arr[i]["Count"] = tonumber(gs["ItemStorage"..i.."Count"])
		else
			break
		end
	end
	
	-- Sort items
	for i = 1, #arr do
		for j = 1, #arr  - 1 do
			if arr[j]["Preset"] > arr[j + 1]["Preset"] then
				local p = arr[j]["Preset"]
				local c = arr[j]["Class"]
				local n = arr[j]["Count"]
			
				arr[j]["Preset"] = arr[j + 1]["Preset"]
				arr[j]["Class"] = arr[j + 1]["Class"]
				arr[j]["Count"] = arr[j + 1]["Count"]
			
				arr[j + 1]["Preset"] = p
				arr[j + 1]["Class"] = c
				arr[j + 1]["Count"] = n
			end
		end
	end
	
	local arr2
	if makefilters then
		arr2 = {}
		
		-- Array for all items
		arr2[-1] = {}
		-- Array for unknown items
		arr2[-2] = {}
		-- Arrays for items by types
		arr2[CF_WeaponTypes.PISTOL] = {}
		arr2[CF_WeaponTypes.RIFLE] = {}
		arr2[CF_WeaponTypes.SHOTGUN] = {}
		arr2[CF_WeaponTypes.SNIPER] = {}
		arr2[CF_WeaponTypes.HEAVY] = {}
		arr2[CF_WeaponTypes.SHIELD] = {}
		arr2[CF_WeaponTypes.DIGGER] = {}
		arr2[CF_WeaponTypes.GRENADE] = {}
		arr2[CF_WeaponTypes.TOOL] = {}
		
		for itm = 1, #arr do
			local f,i = CF_FindItemInFactions(arr[itm]["Preset"], arr[itm]["Class"])

			-- Add item to 'all' list
			local indx = #arr2[-1] + 1
			arr2[-1][indx] = itm
			
			if f ~= nil and i ~= nil then
				-- Add item to specific list
				local indx = #arr2[CF_ItmTypes[f][i]] + 1
				arr2[CF_ItmTypes[f][i]][indx] = itm
			else
				-- Add item to unknown list
				local indx = #arr2[-2] + 1
				arr2[-2][indx] = itm
			end
		end
	end
	
	--for i = 1, #arr do
	--	print (arr[i]["Preset"])
	--end
	
	return arr, arr2
end
-----------------------------------------------------------------------------------------
--	Saves array of stored items to game state
-----------------------------------------------------------------------------------------
function CF_SetStorageArray(gs, arr)
	-- Clear stored array data
	for i = 1, CF_MaxStorageItems do
		gs["ItemStorage"..i.."Preset"] = nil
		gs["ItemStorage"..i.."Class"] = nil
		gs["ItemStorage"..i.."Count"] = nil
	end
	
	-- Copy items
	local itm = 1
	
	
	for i = 1, #arr do
		if arr[i]["Count"] > 0 then
			gs["ItemStorage"..itm.."Preset"] = arr[i]["Preset"]
			gs["ItemStorage"..itm.."Class"] = arr[i]["Class"]
			gs["ItemStorage"..itm.."Count"] = arr[i]["Count"]
			itm = itm + 1
		end
	end
end
-----------------------------------------------------------------------------------------
--	Counts used storage units in storage array
-----------------------------------------------------------------------------------------
function CF_CountUsedStorageInArray(arr)
	local count = 0
	
	for i = 1, #arr do
		count = count + arr[i]["Count"]
	end
	
	return count
end
-----------------------------------------------------------------------------------------
--	Searches for given item in all faction files and returns it's factions and index if found
-----------------------------------------------------------------------------------------
function CF_FindItemInFactions(preset, class)
	for fact = 1, #CF_Factions do
		local f = CF_Factions[fact]
	
		for i = 1, #CF_ItmNames[f] do
			if preset == CF_ItmPresets[f][i] then
				if class == CF_ItmClasses[f][i] or (class == "HDFirearm" and CF_ItmClasses[f][i] == nil) then
					return f, i
				end
			end
		end
	end
	
	return nil, nil
end
-----------------------------------------------------------------------------------------
--	Put item to storage array. You still need to update filters array if this is a new item. 
--	Returns true if added item is new item and you need to sort and update filters
-----------------------------------------------------------------------------------------
function CF_PutItemToStorageArray(arr, preset, class)
	-- Put item to storage array
	-- Find item in storage array
	local found = 0
	local isnew = false
	
	for j = 1, #arr do
		if arr[j]["Preset"] == preset then
			found = j
		end
	end
	
	if found == 0 then
		found = #arr + 1
		arr[found] = {}
		arr[found]["Count"] = 1
		arr[found]["Preset"] = preset
		arr[found]["Class"] = class
		isnew = true
	else
		arr[found]["Count"] = arr[found]["Count"] + 1
	end

	return isnew
end
-----------------------------------------------------------------------------------------
--	Searches for given actor in all faction files and returns it's factions and index if found
-----------------------------------------------------------------------------------------
function CF_FindActorInFactions(preset, class)
	for fact = 1, #CF_Actors do
		local f = CF_Actors[fact]
	
		for i = 1, #CF_ActNames[f] do
			if preset == CF_ActPresets[f][i] then
				if class == CF_ActClasses[f][i] or (class == "AHuman" and CF_ActClasses[f][i] == nil) then
					return f, i
				end
			end
		end
	end
	
	return nil, nil
end
-----------------------------------------------------------------------------------------
--	Returns sorted array of stored items from game state. If makefilters is true, then 
--	it will also return additional array with filtered items
-----------------------------------------------------------------------------------------
function CF_GetClonesArray(gs)
	local arr = {}
	
	-- Copy clones
	for i = 1, CF_MaxClones do
		if gs["ClonesStorage"..i.."Preset"] ~= nil then
			arr[i] = {}
			arr[i]["Preset"] = gs["ClonesStorage"..i.."Preset"]
			arr[i]["Class"] = gs["ClonesStorage"..i.."Class"]
			
			arr[i]["Items"] = {}
			for itm = 1, CF_MaxItems do
				if gs["ClonesStorage"..i.."Item"..itm.."Preset"] ~= nil then
					arr[i]["Items"][itm] = {}
					arr[i]["Items"][itm]["Preset"] = gs["ClonesStorage"..i.."Item"..itm.."Preset"]
					arr[i]["Items"][itm]["Class"] = gs["ClonesStorage"..i.."Item"..itm.."Class"]
				else
					break
				end
			end
		else
			break
		end
	end
	
	-- Sort clones
	for i = 1, #arr do
		for j = 1, #arr  - 1 do
			if arr[j]["Preset"] > arr[j + 1]["Preset"] then
				local p = arr[j]["Preset"]
				local c = arr[j]["Class"]
				local itm = arr[j]["Items"]
			
				arr[j]["Preset"] = arr[j + 1]["Preset"]
				arr[j]["Class"] = arr[j + 1]["Class"]
				arr[j]["Items"] = arr[j + 1]["Items"]
			
				arr[j + 1]["Preset"] = p
				arr[j + 1]["Class"] = c
				arr[j + 1]["Class"] = itm
			end
		end
	end
	
	return arr
end

-----------------------------------------------------------------------------------------
--	Counts used clones in clone array
-----------------------------------------------------------------------------------------
function CF_CountUsedClonesInArray(arr)
	return #arr
end

-----------------------------------------------------------------------------------------
--	Saves array of stored items to game state
-----------------------------------------------------------------------------------------
function CF_SetClonesArray(gs, arr)
	-- Clean clones
	for i = 1, CF_MaxClones do
		gs["ClonesStorage"..i.."Preset"] = nil
		gs["ClonesStorage"..i.."Class"] = nil
		
		for itm = 1, CF_MaxItems do
			gs["ClonesStorage"..i.."Item"..itm.."Preset"] = nil
			gs["ClonesStorage"..i.."Item"..itm.."Class"] = nil
		end
	end
	
	-- Save clones
	-- Copy clones
	for i = 1, #arr do
		gs["ClonesStorage"..i.."Preset"] = arr[i]["Preset"]
		gs["ClonesStorage"..i.."Class"] = arr[i]["Class"]
		
		for itm = 1, #arr[i]["Items"] do
			gs["ClonesStorage"..i.."Item"..itm.."Preset"] = arr[i]["Items"][itm]["Preset"]
			gs["ClonesStorage"..i.."Item"..itm.."Class"] = arr[i]["Items"][itm]["Class"]
		end
	end	
	
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------


