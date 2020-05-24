-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function CF_MakeBrain(c, p, team, pos)
	local f = CF_GetPlayerFaction(c, p);
	CF_MakeBrainWithPreset(c, p, team, pos, CF_Brains[f], CF_BrainClasses[f], CF_BrainModules[f])
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function CF_MakeBrainWithPreset(c, p, team, pos, preset, class, module)
	--print ("CF_SpawnBrain");

	-- We don't check for moids here because we must create brain anyway
	local actor = nil
	local weapon = nil;
	local f = CF_GetPlayerFaction(c, p);
	
	if module ~= nil then
		actor = CF_MakeActor(preset, class, module)
	else
		actor = CF_MakeActor2(preset, class)
	end
	
	-- Create list of prefered weapons for brains
	local list = {CF_WeaponTypes.RIFLE, CF_WeaponTypes.DIGGER}
	
	if CF_PreferedBrainInventory[f] ~= nil then
		list = CF_PreferedBrainInventory[f]
	end
	
	local weaponsgiven = 0
	
	if actor ~= nil then
		for i = 1, #list do
			local weaps;
			-- Try to give brain most powerful prefered weapon
			weaps = CF_MakeListOfMostPowerfulWeapons(c, p, list[i], 100000)
			
			if weaps ~= nil then
				local wf = weaps[1]["Faction"]
				weapon = CF_MakeItem(CF_ItmPresets[wf][ weaps[1]["Item"] ], CF_ItmClasses[wf][ weaps[1]["Item"] ], CF_ItmModules[wf][ weaps[1]["Item"] ]);
				if weapon ~= nil then
					actor:AddInventoryItem(weapon);
					
					if list[i] ~= CF_WeaponTypes.DIGGER and list[i] ~= CF_WeaponTypes.TOOL then
						weaponsgiven = weaponsgiven + 1
					end
				end
			end
		end
		
		if weaponsgiven == 0 then
			-- If we didn't get any weapins try to give other weapons, rifles
			if weaps == nil then
				weaps = CF_MakeListOfMostPowerfulWeapons(c, p, CF_WeaponTypes.RIFLE, 100000)
			end

			-- Sniper rifles
			if weaps == nil then
				weaps = CF_MakeListOfMostPowerfulWeapons(c, p, CF_WeaponTypes.SNIPER, 100000)
			end

			-- No luck - heavies then
			if weaps == nil then
				weaps = CF_MakeListOfMostPowerfulWeapons(c, p, CF_WeaponTypes.HEAVY, 100000)
			end
			
			-- No luck - pistols then
			if weaps == nil then
				weaps = CF_MakeListOfMostPowerfulWeapons(c, p, CF_WeaponTypes.PISTOL, 100000)
			end
			
			if weaps ~= nil then
				local wf = weaps[1]["Faction"]
				weapon = CF_MakeItem(CF_ItmPresets[wf][ weaps[1]["Item"] ], CF_ItmClasses[wf][ weaps[1]["Item"] ], CF_ItmModules[wf][ weaps[1]["Item"] ]);
				if weapon ~= nil then
					actor:AddInventoryItem(weapon);
				end
			end
		end

		-- Set default AI mode
		actor.AIMode = Actor.AIMODE_SENTRY;
		actor.Pos = pos
		actor.Team = team
	end
	
	return actor;
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function CF_SpawnAIUnitWithPreset(c, p, team, pos, aimode, pre)
	local act = CF_MakeUnitFromPreset(c, p, pre)
	
	if act ~= nil then
		act.Team = team
		if pos ~= nil then
			act.Pos = pos
		end
		
		if aimode ~= nil then
			act.AIMode = aimode
		end
	end
	
	return act
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function CF_SpawnAIUnit(c, p, team, pos, aimode)
	local pre = math.random(CF_PresetTypes.ENGINEER)
	local act = CF_MakeUnitFromPreset(c, p, pre)
	
	if act ~= nil then
		act.Team = team
		if pos ~= nil then
			act.Pos = pos
		end
		
		if aimode ~= nil then
			act.AIMode = aimode
		end
	end
	
	return act
end
-----------------------------------------------------------------------------------------
--	Spawns some random infantry of specified faction, tries to spawn AHuman
-----------------------------------------------------------------------------------------
function CF_SpawnRandomInfantry(team , pos , faction , aimode)
	--print ("CF_SpawnRandomInfantry");
	local actor = nil;
	local r1, r2;
	local item;
	
	if MovableMan:GetMOIDCount() < CF_MOIDLimit then
		-- Find AHuman
		local ok = false;
		-- Emergency counter in case we don't have AHumans in factions
		local counter = 0
		
		while (not ok) do
			ok = false;
			r1 = math.random(#CF_ActNames[faction])

			if (CF_ActClasses[faction][r1] == nil or CF_ActClasses[faction][r1] == "AHuman") and CF_ActTypes[faction][r1] ~= CF_ActorTypes.ARMOR then
				ok = true;
			end
			
			-- Break to avoid endless loop
			counter = counter + 1
			if counter > 20 then
				break
			end
		end
	
		actor = CF_MakeActor(CF_ActPresets[faction][r1] , CF_ActClasses[faction][r1], CF_ActModules[faction][r1]);
		
		if actor ~= nil then
			-- Check if this is pre-equipped faction
			local preequipped = false
			
			if CF_PreEquippedActors[faction] ~= nil and CF_PreEquippedActors[faction] then
				preequpped = true
			end			
		
			if not preequipped then
				-- Find rifle
				local ok = false;
				-- Emergency counter in case we don't have AHumans in factions
				local counter = 0
				
				while (not ok) do
					ok = false;
					r2 = math.random(#CF_ItmNames[faction])
			
					if CF_ItmTypes[faction][r2] == CF_WeaponTypes.RIFLE or CF_ItmTypes[faction][r2] == CF_WeaponTypes.SHOTGUN or CF_ItmTypes[faction][r2] == CF_WeaponTypes.SNIPER then
						ok = true;
					end
					
					-- Break to avoid endless loop
					counter = counter + 1
					if counter > 40 then
						break
					end
				end
			
				item = CF_MakeItem(CF_ItmPresets[faction][r2] , CF_ItmClasses[faction][r2], CF_ItmModules[faction][r2]);
				
				if item ~= nil then
					actor:AddInventoryItem(item);
				end
			end
			
			actor.AIMode = aimode;
			actor.Team = team;
			
			if pos ~= nil then
				actor.Pos = pos;
				MovableMan:AddActor(actor);
			else
				return actor
			end
		end
	end
	
	return nil
end
-----------------------------------------------------------------------------------------
-- Create list of weapons of wtype sorted by their power. c - config, p - player, wtype - weapon type, 
-- tech - maximum allowed tech level in science points
-----------------------------------------------------------------------------------------
function CF_MakeListOfMostPowerfulWeapons(c, p, wtype, tech)
	local weaps = {};
	local f = CF_GetPlayerFaction(c, p)
	
	-- Filter needed items
	for i = 1, #CF_ItmNames[f] do
		if CF_ItmTypes[f][i] == wtype and CF_ItmPowers[f][i] > 0 and CF_ItmUnlockData[f][i] <= tech  then
			local n = #weaps + 1
			weaps[n] = {}
			weaps[n]["Item"] = i
			weaps[n]["Faction"] = f
			weaps[n]["Power"] = CF_ItmPowers[f][i]
		end
	end
	
	-- Sort them
	for j = 1, #weaps - 1 do
		for i = 1, #weaps - j do
			if weaps[i]["Power"] < weaps[i + 1]["Power"] then
				local temp = weaps[i];
				weaps[i] = weaps[i + 1]
				weaps[i + 1] = temp
			end
		end
	end
	
	if #weaps == 0 then
		return nil
	end
	
	return weaps;
end
-----------------------------------------------------------------------------------------
-- Create list of actors of atype sorted by their power. c - config, p - player, wtype - weapon type
-- tech - maximum allowed tech level in science points
-----------------------------------------------------------------------------------------
function CF_MakeListOfMostPowerfulActors(c, p, atype, tech)
	local acts = {};
	local f = CF_GetPlayerFaction(c, p)
	
	-- Filter needed items
	for i = 1, #CF_ActNames[f] do
		if CF_ActTypes[f][i] == atype and CF_ActPowers[f][i] > 0 and CF_ActUnlockData[f][i] <= tech then
			local n = #acts + 1
			acts[n] = {}
			acts[n]["Actor"] = i
			acts[n]["Faction"] = f
			acts[n]["Power"] = CF_ActPowers[f][i]
		end
	end
	
	-- Sort them
	for j = 1, #acts - 1 do
		for i = 1, #acts - j do
			if acts[i]["Power"] < acts[i + 1]["Power"] then
				local temp = acts[i];
				acts[i] = acts[i + 1]
				acts[i + 1] = temp
			end
		end
	end
	
	if #acts == 0 then
		return nil
	end
	
	return acts;
end
-----------------------------------------------------------------------------------------
--	Creates units presets for specified AI where c - config, p - player, tech - max unlock data
-----------------------------------------------------------------------------------------
function CF_CreateAIUnitPresets(c, p, tech)
	--print ("CF_CreateAIUnitPresets "..p)
	-- Presets -            	"Infantry 1", 				"Infantry 2", 			"Sniper", 				"Shotgun", 				"Heavy 1", 				"Heavy 2", 				"Armor 1", 				"Armor 2", 				"Engineer", 			"Defender"
	local desiredactors = 		{CF_ActorTypes.LIGHT, 		CF_ActorTypes.HEAVY, 	CF_ActorTypes.LIGHT, 	CF_ActorTypes.HEAVY, 	CF_ActorTypes.HEAVY, 	CF_ActorTypes.HEAVY, 	CF_ActorTypes.ARMOR, 	CF_ActorTypes.HEAVY, 	CF_ActorTypes.LIGHT, 	CF_ActorTypes.TURRET}

	local desiredweapons = 		{CF_WeaponTypes.RIFLE, 		CF_WeaponTypes.RIFLE, 	CF_WeaponTypes.SNIPER, 	CF_WeaponTypes.SHOTGUN, CF_WeaponTypes.HEAVY, 	CF_WeaponTypes.HEAVY, 	CF_WeaponTypes.HEAVY, 	CF_WeaponTypes.SHIELD, 	CF_WeaponTypes.DIGGER, 	CF_WeaponTypes.SHOTGUN}
	local desiredsecweapons = 	{CF_WeaponTypes.PISTOL, 	CF_WeaponTypes.PISTOL, 	CF_WeaponTypes.PISTOL, 	CF_WeaponTypes.GRENADE,	CF_WeaponTypes.RIFLE, 	CF_WeaponTypes.GRENADE,	CF_WeaponTypes.PISTOL, 	CF_WeaponTypes.PISTOL, 	CF_WeaponTypes.RIFLE, 	CF_WeaponTypes.GRENADE}
	local desiredtretweapons = 	{CF_WeaponTypes.GRENADE, 	CF_WeaponTypes.GRENADE,	CF_WeaponTypes.GRENADE,	CF_WeaponTypes.GRENADE, CF_WeaponTypes.GRENADE, CF_WeaponTypes.GRENADE, CF_WeaponTypes.GRENADE, CF_WeaponTypes.GRENADE, CF_WeaponTypes.GREANDE, CF_WeaponTypes.GRENADE}
	
	local f = CF_GetPlayerFaction(c,p)
	local preequipped = false
	
	if CF_PreEquippedActors[f] ~= nil and CF_PreEquippedActors[f] then
		preequipped = true
	end
	
	if preequipped then
		--print ("Pre-equipped")
		--print ("")

		-- Fill presets for pre-equpped faction
		for i = 1, 10 do
			-- Select a suitable actor based on his equipment class
			local selected = 1
			local match = false;

			local actors
			local lastgoodactors
			local weakestactor
			
			-- Build a list of desired actors and weapons
			local da = {}
			local dw = {}
			
			da[1] = desiredactors[i]
			dw[1] = desiredweapons[i]
			da[2] = CF_ActorTypes.HEAVY
			dw[2] = desiredweapons[i]
			da[3] = CF_ActorTypes.LIGHT
			dw[3] = desiredweapons[i]
			da[4] = CF_ActorTypes.ARMOR
			dw[4] = desiredweapons[i]
			da[5] = CF_ActorTypes.HEAVY
			dw[5] = nil
			da[6] = CF_ActorTypes.LIGHT
			dw[6] = nil
			da[7] = CF_ActorTypes.ARMOR
			dw[7] = nil

			for k = 1, #da do
				actors = CF_MakeListOfMostPowerfulActors(c, p, da[k], tech)
				
				if actors ~= nil and dw[k] ~= nil then
					for j = 1, #actors do
						if CF_EquipmentTypes[f][ actors[j]["Actor"] ] ~= nil then
							if CF_EquipmentTypes[f][ actors[j]["Actor"] ] == dw[k] then
								selected = j
								match = true
								break
							end
						end
					end
				end
				
				if match then
					break
				end
				
				if actors ~= nil then
					lastgoodactors = actors
				end
			end
			
			if actors == nil then
				actors = lastgoodactors
			end
			
			if actors ~= nil then
				c["Player"..p.."Preset"..i.."Actor"] = actors[selected]["Actor"];
				c["Player"..p.."Preset"..i.."Faction"] = actors[selected]["Faction"];

				--Reset all weapons
				for j = 1, CF_MaxItemsPerPreset do
					c["Player"..p.."Preset"..i.."Item"..j] = nil
					c["Player"..p.."Preset"..i.."ItemFaction"..j] = nil
				end
				
				-- If we didn't find a suitable engineer unit then try give digger to engineer preset
				if desiredweapons[i] == CF_WeaponTypes.DIGGER and not match then
					local weapons1
					weapons1 = CF_MakeListOfMostPowerfulWeapons(c, p, desiredweapons[i], tech)
				
					local class = CF_ActClasses[actors[selected]["Faction"]][actors[selected]["Actor"]]
					-- Don't give weapons to ACrabs
					if class ~= "ACrab" then
						if weapons1 ~= nil then
							c["Player"..p.."Preset"..i.."Item"..1] = weapons1[1]["Item"];
							c["Player"..p.."Preset"..i.."ItemFaction"..1] = weapons1[1]["Faction"];
							--print (CF_PresetNames[i].." + Digger")
						end
					end
				end
				
				--print(CF_PresetNames[i].." "..CF_ActPresets[c["Player"..p.."Preset"..i.."Faction"]][c["Player"..p.."Preset"..i.."Actor"]] .." "..tostring(match))
				--print(c["Player"..p.."Preset"..i.."Item1"])
				--print(c["Player"..p.."Preset"..i.."Item2"])
				--print(c["Player"..p.."Preset"..i.."Item3"])
			end	
		end
	else
		--print ("Empty actors")

		-- Fill presets for generic faction
		for i = 1, 10 do
			local actors
			actors = CF_MakeListOfMostPowerfulActors(c, p, desiredactors[i], tech)
			
			if actors == nil then
				actors = CF_MakeListOfMostPowerfulActors(c, p, CF_ActorTypes.LIGHT, tech)
			end

			if actors == nil then
				actors = CF_MakeListOfMostPowerfulActors(c, p, CF_ActorTypes.HEAVY, tech)
			end

			if actors == nil then
				actors = CF_MakeListOfMostPowerfulActors(c, p, CF_ActorTypes.ARMOR, tech)
			end
			
			local weapons1
			weapons1 = CF_MakeListOfMostPowerfulWeapons(c, p, desiredweapons[i], tech)

			if weapons1 == nil then
				weapons1 = CF_MakeListOfMostPowerfulWeapons(c, p, CF_WeaponTypes.RIFLE, tech)
			end

			if weapons1 == nil then
				weapons1 = CF_MakeListOfMostPowerfulWeapons(c, p, CF_WeaponTypes.SHOTGUN, tech)
			end

			if weapons1 == nil then
				weapons1 = CF_MakeListOfMostPowerfulWeapons(c, p, CF_WeaponTypes.SNIPER, tech)
			end
			
			if weapons1 == nil then
				weapons1 = CF_MakeListOfMostPowerfulWeapons(c, p, CF_WeaponTypes.HEAVY, tech)
			end
			
			if weapons1 == nil then
				weapons1 = CF_MakeListOfMostPowerfulWeapons(c, p, CF_WeaponTypes.PISTOL, tech)
			end


			local weapons2
			weapons2 = CF_MakeListOfMostPowerfulWeapons(c, p, desiredsecweapons[i], tech)

			if weapons2 == nil then
				weapons2 = CF_MakeListOfMostPowerfulWeapons(c, p, CF_WeaponTypes.PISTOL, tech)
			end

			if weapons2 == nil then
				weapons2 = CF_MakeListOfMostPowerfulWeapons(c, p, CF_WeaponTypes.DIGGER, tech)
			end

			local weapons3
			weapons3 = CF_MakeListOfMostPowerfulWeapons(c, p, desiredtretweapons[i], tech)
			
			if actors ~= nil then
				c["Player"..p.."Preset"..i.."Actor"] = actors[1]["Actor"];
				c["Player"..p.."Preset"..i.."Faction"] = actors[1]["Faction"];
				
				local class = CF_ActClasses[actors[1]["Faction"]][actors[1]["Actor"]]
				
				-- Don't give weapons to ACrabs
				if class ~= "ACrab" then
					local weap = 1
					
					if weapons1 ~= nil then
						-- Add small random spread for primary weapons
						local spread = 2;
					
						if #weapons1 < spread then
							spread = 1;
						end
						
						local w = math.random(spread)
						--print ("Selected weapon: "..w)
					
						c["Player"..p.."Preset"..i.."Item"..weap] = weapons1[w]["Item"];
						c["Player"..p.."Preset"..i.."ItemFaction"..weap] = weapons1[w]["Faction"];
						weap = weap + 1
					end
					
					if weapons2 ~= nil then
						-- Add small random spread for secondary weapons
						local spread = 2;
					
						if #weapons2 < spread then
							spread = 1;
						end
						
						local w = math.random(spread)
						--print ("Selected sec weapon: "..w)

						c["Player"..p.."Preset"..i.."Item"..weap] = weapons2[w]["Item"];
						c["Player"..p.."Preset"..i.."ItemFaction"..weap] = weapons2[w]["Faction"];
						weap = weap + 1
					end

					if weapons3 ~= nil then
						-- Add small random spread for grenades
						local spread = 2;
					
						if #weapons3 < spread then
							spread = 1;
						end
						
						local w = math.random(spread)
						--print ("Selected tri weapon: "..w)

						c["Player"..p.."Preset"..i.."Item"..weap] = weapons3[w]["Item"];
						c["Player"..p.."Preset"..i.."ItemFaction"..weap] = weapons3[w]["Faction"];
						weap = weap + 1
					end
					
					if CF_AIDebugOutput then
						--print ("------")
						--print(CF_ActPresets[c["Player"..p.."Preset"..i.."Faction"]][c["Player"..p.."Preset"..i.."Actor"]])
						--print(CF_ItmPresets[c["Player"..p.."Preset"..i.."ItemFaction1"]][c["Player"..p.."Preset"..i.."Item1"]])
						--print(CF_ItmPresets[c["Player"..p.."Preset"..i.."ItemFaction2"]][c["Player"..p.."Preset"..i.."Item2"]])
						--print(CF_ItmPresets[c["Player"..p.."Preset"..i.."ItemFaction3"]][c["Player"..p.."Preset"..i.."Item3"]])
					end
				end
			end
		end
	end -- If preequipped
end
-----------------------------------------------------------------------------------------
--	Create actor from preset pre, where c - config, p - player, t - territory, pay gold is pay == true
-- 	returns actor or nil, also returns actor ofsset, value wich you must add to default actor position to 
-- 	avoid actor hang in the air, used mainly for turrets
-----------------------------------------------------------------------------------------
function CF_MakeUnitFromPreset(c, p, pre)
	local actor = nil
	local offset = Vector(0,0)
	local weapon = nil;
	
	if MovableMan:GetMOIDCount() < CF_MOIDLimit then
		local a = c["Player"..p.."Preset"..pre.."Actor"]
		if a ~= nil then
			a = tonumber(a)
			local f = c["Player"..p.."Preset"..pre.."Faction"]
			
			actor = CF_MakeActor(CF_ActPresets[f][a], CF_ActClasses[f][a], CF_ActModules[f][a])
			
			offset = CF_ActOffsets[f][a]
			if offset == nil then
				offset = Vector(0,0)
			end			
			
			-- Give weapons to non-crab actors
			if actor ~= nil and CF_ActClasses[f][a] ~= "ACrab" then
				for i = 1, CF_MaxItemsPerPreset do 
					if c["Player"..p.."Preset"..pre.."Item"..i] ~= nil then
						
						local w = tonumber(c["Player"..p.."Preset"..pre.."Item"..i])
						local wf = c["Player"..p.."Preset"..pre.."ItemFaction"..i]
						
						weapon = CF_MakeItem(CF_ItmPresets[wf][w], CF_ItmClasses[wf][w], CF_ItmModules[wf][w]);
						--print (weapon)
						
						if weapon ~= nil then
							actor:AddInventoryItem(weapon)
						end
					end
				end
			end
			
			if actor ~= nil then
				-- Set default AI mode
				actor.AIMode = Actor.AIMODE_SENTRY;
			end
		end
	end
	
	return actor, offset;
end
-----------------------------------------------------------------------------
--	
-----------------------------------------------------------------------------
function CF_ReadPtsData(scene, ls)
	local pts = {}

	-- Create list of data objcets
	-- Add generic mission types which must be present on any map
	for i = 1, CF_GenericMissionCount do
		pts[ CF_Mission[i] ] = {}
	end
	
	for i = 1, #CF_LocationMissions[scene] do
		pts[ CF_LocationMissions[scene][i] ] = {}
	end

	-- Load level data
	for k1, v1 in pairs(pts) do
		local msntype = k1
		
		--print (msntype)
		
		for k2 = 1, CF_MissionMaxSets[msntype] do -- Enum sets
			local setnum = k2
			
			--print ("  "..setnum)
		
			for k3 = 1, #CF_MissionRequiredData[msntype] do -- Enum Point types
				local pttype = CF_MissionRequiredData[msntype][k3]["Name"]

				--print ("    "..pttype)
				
				--print (k3)
				--print (msntype)
				--print (pttype)
				
				for k4 = 1, CF_MissionRequiredData[msntype][k3]["Max"] do -- Enum points
					local id = msntype..tostring(setnum)..pttype..tostring(k4)
					
					local x = ls[id.."X"]
					local y = ls[id.."Y"]

					if x ~= nil and y ~= nil then
						if pts[msntype] == nil then
							pts[msntype] = {}
						end
						if pts[msntype][setnum] == nil then
							pts[msntype][setnum] = {}
						end
						if pts[msntype][setnum][pttype] == nil then
							pts[msntype][setnum][pttype] = {}
						end
						if pts[msntype][setnum][pttype][k4] == nil then
							pts[msntype][setnum][pttype][k4] = {}
						end
					
						pts[msntype][setnum][pttype][k4] = Vector(tonumber(x), tonumber(y))
					end
				end
			end
		end
	end

	--print ("---")
	
	--[[for k,v in pairs(pts) do
		print (k)
		
		for k2,v2 in pairs(v) do
			print ("  " .. k2)
			
			for k3,v3 in pairs(v2) do
				print ("    " ..k3)
				
				for k4,v4 in pairs(v3) do
					print (k4)
					print (v4)
				end
			end
		end
	end	--]]--
	
	return pts
end
-----------------------------------------------------------------------------
--	Returns available points set for specified mission from pts array 
-----------------------------------------------------------------------------
function CF_GetRandomMissionPointsSet(pts, msntype)
	local sets = {};
	
	for k, v in pairs(pts[msntype]) do
		sets[#sets + 1] = k
	end
	
	local r = math.random(#sets)
	
	return sets[r]
end
-----------------------------------------------------------------------------
--	Returns int indexed array of vectors with available points of specified 
--	mission type, points set and points type
-----------------------------------------------------------------------------
function CF_GetPointsArray(pts, msntype, setnum, ptstype)
	local vectors = {};
	
	--print (msntype)
	--print (setnum)
	--print (ptstype)
	
	if pts[msntype][setnum][ptstype] ~= nil then
		for k, v in pairs(pts[msntype][setnum][ptstype]) do
			vectors[#vectors + 1] = v
		end
	end
	
	return vectors;
end
-----------------------------------------------------------------------------
--	Returns array of n random points from array pts
-----------------------------------------------------------------------------
function CF_SelectRandomPoints(pts, n)
	local res = {};
	local isused = {}
	local issued = 0
	local retries
	
	-- If length of array = n then we don't need to find random and can simply return this array
	if #pts == n then
		return pts
	elseif #pts == 0 then
		return res
	else
		-- Start selecting random values
		for i = 1, #pts do
			isused[i] = false;
		end

		local retries = 0
	
		while issued < n do
			retries = retries + 1
			local good = false
			local r = math.random(#pts)
			
			if not isused[r] or retries > 50 then
				isused[r] = true
				good = true
				issued = issued + 1
				res[issued] = pts[r]
			end
		end
	end
	
	return res;
end
-----------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
function CF_GetAngriestPlayer(c)
	local angriest
	local rep = 0

	for i = 1, CF_MaxCPUPlayers do
		if c["Player"..i.."Active"] == "True" then
			if tonumber(c["Player"..i.."Reputation"]) < rep then
				angriest = i
				rep = tonumber(c["Player"..i.."Reputation"])
			end
		end
	end
	
	return angriest, rep
end
-----------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
function CF_GetLocationDifficulty(c, loc)
	local diff = CF_MaxDifficulty
	local sec = CF_GetLocationSecurity(c, loc)
	
	diff = math.floor(sec / 10)
	if diff > CF_MaxDifficulty then
		diff = CF_MaxDifficulty
	end
	
	if diff < 1 then
		diff = 1
	end
	
	return diff
end
-----------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
function CF_GetFullMissionDifficulty(c, loc, m)
	local ld = CF_GetLocationDifficulty(c, loc)
	local md = tonumber(c["Mission"..m.."Difficulty"])
	local diff = ld + md - 1
	
	if diff > CF_MaxDifficulty then
		diff = CF_MaxDifficulty
	end
	
	if diff < 1 then
		diff = 1
	end	
	
	return diff
end
-----------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
function CF_GetLocationSecurity(c, loc)
	local sec
	
	if c["Security_"..loc] ~= nil then
		sec = tonumber(c["Security_"..loc])
	else
		sec = CF_LocationSecurity[ loc ]
	end
	
	return sec
end
-----------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
function CF_SetLocationSecurity(c, loc, newsec)
	c["Security_"..loc] = newsec
end
-----------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
function CF_GenerateRandomMission(c)
	local cpus = tonumber(c["ActiveCPUs"])
	local mission = {}
	
	-- Select CPUs to choose mission. We'll give a bit higher priorities to CPU's with better reputation
	local selp = {}
	local r
	
	for i = 1, cpus do
		local rep = tonumber(c["Player"..i.."Reputation"])
		
		if rep < -2000 then
			r = 0.15
		elseif rep < -1000 then
			r = 0.30
		elseif rep < 0 then
			r = 0.45
		else
			r = 1
		end
		
		if math.random() < r then
			selp[#selp + 1] = i
		end
	end
	
	local p 
	if #selp > 0 then
		p = selp[math.random(#selp)]
	else
		p = math.random(cpus)
	end
	
	-- Make list of available missions
	local rep = tonumber(c["Player"..p.."Reputation"])
	
	local missions = {}
	
	for m = 1, #CF_Mission do
		local msnid = CF_Mission[m]
		
		if CF_MissionMinReputation[msnid] <= rep then
			local newmsn = #missions + 1
			
			missions[newmsn] = {}
			missions[newmsn]["MissionID"] = msnid
			missions[newmsn]["Scenes"] = {}
			
			-- Search for locations for this mission and make a list of them
			for l = 1, #CF_Location do
				local locid = CF_Location[l]
				local playable = true
				
				-- Discard unplayable locations
				if CF_LocationPlayable[locid] ~= nil then
					if CF_LocationPlayable[locid] == false then
						playable = false
					end
				end
				
				-- Bever select current player's location
				if c["Location"] == locid then
					playable = false
				end
				
				if CF_IsLocationHasAttribute(locid, CF_LocationAttributeTypes.NOTMISSIONASSIGNABLE) then
					playable = false
				end
				
				if playable then
					for lm = 1, #CF_LocationMissions[locid] do
						if msnid == CF_LocationMissions[locid][lm] then
							local newloc = #missions[newmsn]["Scenes"] + 1
						
							missions[newmsn]["Scenes"][newloc] = locid
						end
					end
				end
			end
		end
	end
	
	-- Pick some random mission for which we have locations
	local ok = false
	local rmsn
	local count = 1
	
	while not ok do
		ok = true
		
		rmsn = math.random(#missions)
		
		if #missions[rmsn]["Scenes"] == 0 then
			ok = false
		end
		
		count = count + 1
		if count > 100 then
			error("Endless loop at CF_GenerateRandomMission - mission selection")
			break
		end
	end
	
	-- Pick some random location for this mission
	local rloc = math.random(#missions[rmsn]["Scenes"])
	
	-- Pick some random difficulty for this mission
	-- Generate missions with CF_MaxDifficulty / 2 because additional difficulty 
	-- will be applied by location security level
	local rdif = tonumber(c["MissionDifficultyBonus"]) + math.random(3)
	
	if rdif < 1 then
		rdif = 1
	end
	
	if rdif > CF_MaxDifficulty then
		rdif = CF_MaxDifficulty
	end
	
	-- Pick some random target for this mission
	local ok = false
	local renm
	local count = 1
	
	while not ok do
		ok = true
		
		renm = math.random(cpus)
		
		if p == renm then
			ok = false
		end

		count = count + 1
		if count > 100 then
			error("Endless loop at CF_GenerateRandomMission - enemy selection")
			break
		end
	end
	
	-- Return mission
	mission["SourcePlayer"] = p
	mission["TargetPlayer"] = renm
	mission["Type"]= missions[rmsn]["MissionID"]
	mission["Location"]= missions[rmsn]["Scenes"][rloc]
	mission["Difficulty"]= rdif
	
	return mission;
end
-----------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
function CF_GenerateRandomMissions(c)
	local missions = {}
	
	for i = 1, CF_MaxMissions do
		local ok = false
		local msn
		local count = 1
		
		while not ok do
			ok = true
			
			msn = CF_GenerateRandomMission(c)
			
			-- Make sure that we don't have multiple missions in single locations
			if i > 1 then
				for j = 1, i - 1 do
					if missions[j]["Location"] == msn["Location"] then
						ok = false
					end
				end
			end
			
			count = count + 1
			if count > 100 then
				error("Endless loop at CF_GenerateRandomMissions - mission generation")
				break
			end
		end
		
		missions[i] = msn
	end
	
	-- Put missions to config
	for i = 1, CF_MaxMissions do
		c["Mission"..i.."SourcePlayer"] = missions[i]["SourcePlayer"]
		c["Mission"..i.."TargetPlayer"] = missions[i]["TargetPlayer"]
		c["Mission"..i.."Type"] = missions[i]["Type"]
		c["Mission"..i.."Location"] = missions[i]["Location"]
		c["Mission"..i.."Difficulty"] = missions[i]["Difficulty"]
	end
	
	--return c
end
-----------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
