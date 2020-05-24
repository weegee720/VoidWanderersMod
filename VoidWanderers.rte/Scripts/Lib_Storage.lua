-----------------------------------------------------------------------------------------
--	Returns sorted array of stored items from game state
-----------------------------------------------------------------------------------------
function CF_GetStorageArray(gs)
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
	
	--for i = 1, #arr do
	--	print (arr[i]["Preset"])
	--end
	
	return arr
end
-----------------------------------------------------------------------------------------
--	Saves array of stored items to game state
-----------------------------------------------------------------------------------------
function CF_SetStorageArray(gs, arr)
end
-----------------------------------------------------------------------------------------
--	Searcheds for given item in all faction files and returns it's factions and index if found
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
--
-----------------------------------------------------------------------------------------
