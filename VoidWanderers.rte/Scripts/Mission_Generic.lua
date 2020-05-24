-----------------------------------------------------------------------------------------
--	Generic mission script which is executed when no mission assigned and when no other
--	default script is specified for location
-----------------------------------------------------------------------------------------
--	Generic events:
--
--	Periodically script will spawn a dropship with 1-3 units based on scene difficulty level. 
-- 	Units will try to protect their own miners or if there's no any will try to find and kill
--	enemy miners.
--
--	Difficulty 2+:
--
--	Rarely script will spawn a dropship with 3 units of the mest agressive CPU player which
--	will switch to brain hunt mode. If custom AI is enabled the will search and destroy any 
--	enemy actors, if not they will probably move to player LZ's since they are brain units
--
-----------------------------------------------------------------------------------------
function VoidWanderers:MissionCreate()
	-- Spawn random wandering enemies
	local set = CF_GetRandomMissionPointsSet(self.Pts, "Deploy")	

	-- Spawn crates
	local enm = CF_GetPointsArray(self.Pts, "Deploy", set, "AmbientEnemy")
	self.MissionLZs = CF_GetPointsArray(self.Pts, "Deploy", set, "EnemyLZ")
	local amount = math.ceil(CF_AmbientEnemyRate * #enm)
	--print ("Crates: "..amount)
	local enmpos = CF_SelectRandomPoints(enm, amount)
	
	-- We should not spawn player-selected faction unless we have bad relation with  it
	local selection = {}
	for i = 1, tonumber(self.GS["ActiveCPUs"]) do
		if i == 1 then
			if tonumber(self.GS["Player"..i.."Reputation"]) < CF_ReputationHuntTreshold then
				selection[#selection + 1] = i
			end
		else
			selection[#selection + 1] = i
		end
	end
		
	p1 = selection[math.random(#selection)]

	-- Next we should select not p1 and not player faction if relations are good enough
	local selection = {}
	for i = 1, tonumber(self.GS["ActiveCPUs"]) do
		if i == 1 then
			if tonumber(self.GS["Player"..i.."Reputation"]) < CF_ReputationHuntTreshold then
				selection[#selection + 1] = i
			end
		else
			if i ~= p1  then
				selection[#selection + 1] = i
			end
		end
	end

	p2 = selection[math.random(#selection)]
	
	local diff = CF_GetLocationDifficulty(self.GS, self.GS["Location"])

	self.MissionDifficulty = diff
	
	print ("DIFF: "..self.MissionDifficulty)
	
	CF_CreateAIUnitPresets(self.GS, p1, CF_GetTechLevelFromDifficulty(self.GS, p1, diff, CF_MaxDifficulty))
	CF_CreateAIUnitPresets(self.GS, p2, CF_GetTechLevelFromDifficulty(self.GS, p2, diff, CF_MaxDifficulty))
	
	self.MissionCPUPlayers = {}
	self.MissionCPUTeams = {}
	
	self.MissionCPUPlayers[1] = p1
	self.MissionCPUPlayers[2] = p2
	self.MissionCPUTeams[1] = 2
	self.MissionCPUTeams[2] = 3
	
	for i = 1, #enmpos do
		local plr
		local tm
	
		if i % 2 == 0 then
			plr = p1
			tm = 2
		else
			plr = p2
			tm = 3
		end
		
		local pre = math.random(CF_PresetTypes.ENGINEER)
		local nw = {}
		nw["Preset"] = pre
		nw["Team"] = tm
		nw["Player"] = plr
		if pre == CF_PresetTypes.ENGINEER then
			nw["AIMode"] = Actor.AIMODE_GOLDDIG
		else
			nw["AIMode"] = Actor.AIMODE_SENTRY
		end
		nw["Pos"] = enmpos[i]
		
		table.insert(self.SpawnTable, nw)
		
		-- Spawn another engineer
		if math.random() < CF_AmbientEnemyDoubleSpawn then
			local pre = CF_PresetTypes.ENGINEER
			local nw = {}
			nw["Preset"] = pre
			nw["Team"] = tm
			nw["Player"] = plr
			nw["AIMode"] = Actor.AIMODE_GOLDDIG
			nw["Pos"] = enmpos[i]
			
			table.insert(self.SpawnTable, nw)
		end
	end	

	self.DropShipCount = 0
	
	self.MissionStart = self.Time
	self.MissionNextDropShip = self.Time + CF_AmbientReinforcementsInterval

	-- Find player's enemy
	self.AngriestPlayer, rep = CF_GetAngriestPlayer(self.GS)
	if self.AngriestPlayer ~= nil then
		if self.AngriestPlayer ~= p1 and self.AngriestPlayer ~= p2 then
			self.AngriestDifficulty = math.floor(math.abs(rep) / 1000)
			
			if self.AngriestDifficulty < 1 then
				self.AngriestDifficulty = 1
			end

			if self.AngriestDifficulty > CF_MaxDifficulty then
				self.AngriestDifficulty = CF_MaxDifficulty
			end
			
			CF_CreateAIUnitPresets(self.GS, self.AngriestPlayer, CF_GetTechLevelFromDifficulty(self.GS, self.AngriestPlayer, self.AngriestDifficulty, CF_MaxDifficulty))
			print ("TEAM 2: "..CF_GetPlayerFaction(self.GS, self.AngriestPlayer).." - "..self.AngriestDifficulty)
		else
			self.AngriestPlayer = nil
		end
	end

	--print (self.AngriestPlayer)
	
	self.MissionNextDropShip2 = self.Time + CF_AmbientReinforcementsInterval * 2.5
	--self.MissionNextDropShip2 = self.Time + 10 -- Debug
	
	print ("TEAM 3: "..CF_GetPlayerFaction(self.GS, p1))
	print ("TEAM 4: "..CF_GetPlayerFaction(self.GS, p2))
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:MissionUpdate()
	local teamcount = {}
	teamcount[-1] = 0
	teamcount[0] = 0
	teamcount[1] = 0
	teamcount[2] = 0
	teamcount[3] = 0
		
	-- Count actors
	for actor in MovableMan.Actors do
		if actor.ClassName == "AHuman" or actor.ClassName == "ACrab" then
			teamcount[actor.Team] = teamcount[actor.Team] + 1
		end
	end

	--print (self.MissionNextDropShip - self.Time)
	if self.Time > self.MissionNextDropShip and #self.MissionLZs > 0 then
		self.MissionNextDropShip = self.Time + CF_AmbientReinforcementsInterval + math.random(13)

		self.DropShipCount = self.DropShipCount + 1
		
		if MovableMan:GetMOIDCount() < CF_MOIDLimit then
			local sel

			if math.random() < 0.5 then
				sel = 1
			else
				sel = 2
			end
			
			-- Do nothin if there are too many actors of this team
			if teamcount[self.MissionCPUTeams[sel]] < 5 then
				local count = math.ceil(self.MissionDifficulty / 2)
				if count <= 0 then 
					count = 1
				end
				if count > 3 then
					count = 3
				end
				
				count = math.random(count)
				
				local f = CF_GetPlayerFaction(self.GS, self.MissionCPUPlayers[sel])
				local ship = CF_MakeActor(CF_Crafts[f] , CF_CraftClasses[f] , CF_CraftModules[f]);
				if ship then
					for i = 1, count do
						local actor = CF_SpawnAIUnit(self.GS, self.MissionCPUPlayers[sel], self.MissionCPUTeams[sel], nil, Actor.AIMODE_SENTRY)
						if actor then
							ship:AddInventoryItem(actor)
						end
					end
					ship.Team = self.MissionCPUTeams[sel]
					ship.Pos = Vector(self.MissionLZs[math.random(#self.MissionLZs)].X, -10)
					ship.AIMode = Actor.AIMODE_DELIVER
					MovableMan:AddActor(ship)
				end
			end
		end
	end
	
	-- Spawn green team dropship
	if self.MissionDifficulty >= 2 and self.AngriestPlayer ~= nil and self.Time > self.MissionNextDropShip2 and #self.MissionLZs > 0 then
		self.MissionNextDropShip2 = self.Time + (CF_AmbientReinforcementsInterval + math.random(13)) * 2.75
		
		if MovableMan:GetMOIDCount() < CF_MOIDLimit then
			local count = 3
			
			local f = CF_GetPlayerFaction(self.GS, self.AngriestPlayer)
			local ship = CF_MakeActor(CF_Crafts[f] , CF_CraftClasses[f] , CF_CraftModules[f]);
			if ship then
				for i = 1, count do
					local actor = CF_SpawnAIUnit(self.GS, self.AngriestPlayer, 1, nil, Actor.AIMODE_BRAINHUNT)
					if actor then
						ship:AddInventoryItem(actor)
					end
				end
				ship.Team = 1
				ship.Pos = Vector(self.MissionLZs[math.random(#self.MissionLZs)].X, -10)
				ship.AIMode = Actor.AIMODE_DELIVER
				MovableMan:AddActor(ship)
			end
		end
	end
	
	-- Assemble guards near miners from time to time
	local acts = {}
	local miners = {}
	local enemyminers = {}
	
	local sel

	if self.Time % 2 == 0 then
		sel = 1
	else
		sel = 2
	end
	
	-- Enumerate actors and select potential actors and miners
	for actor in MovableMan.Actors do
		if actor.ClassName == "ACDropShip" then
			self:AddObjectivePoint("INCOMING\nDROPSHIP", actor.Pos + Vector(0,-50) , CF_PlayerTeam, GameActivity.ARROWDOWN);
		end
	
		if actor.Team == self.MissionCPUTeams[sel] then
			if actor:HasObjectInGroup("Diggers") then 
				if  actor.AIMode == Actor.AIMODE_SENTRY then
					actor.AIMode = Actor.AIMODE_GOLDDIG
					--print (actor)
					--print ("GOLDDIG 1")
				end
				miners[#miners + 1] = actor
			else
				if actor.AIMode == Actor.AIMODE_SENTRY then
					acts[#acts + 1] = actor
				end
			end
		end
	end
	
	--print (#acts)
	--print (#miners)
	
	-- If we have spare actors and some miners then send some random actor to nearest miner to protect
	-- unless this actor is already close enough
	-- If we don't have any friendly miners then go to kill enemy miners
	-- Give orders only after some time to let player fortify
	if self.DropShipCount > 0 and #acts > 0 then
		local dest
		
		if #miners > 0 then
			dest = miners
		else
			if #enemyminers > 0 then
				dest = enemyminers
			end
		end
		
		if dest ~= nil then
			local rndact = acts[math.random(#acts)]
			
			local assignable = true
			local f = CF_GetPlayerFaction(self.GS, self.MissionCPUPlayers[sel])
			
			-- Check if unit is playable
			if CF_UnassignableUnits[f] ~= nil then
				for i = 1, #CF_UnassignableUnits[f] do
					if rndact.PresetName == CF_UnassignableUnits[f][i] then
						assignable = false
					end
				end
			end

			if assignable then
				local mindist = 1750
				local nearest
				
				for i = 1, #dest do
					local d = CF_Dist(rndact.Pos, dest[i].Pos)
					if d < mindist then
						mindist = d
						nearest = dest[i].Pos
					end
				end
				
				if mindist > 150 and nearest ~= nil then
					--rndact:FlashWhite(1500)
					rndact.AIMode = Actor.AIMODE_GOTO
					rndact:ClearAIWaypoints()
					rndact:AddAISceneWaypoint(nearest)
					--print (rndact)
					--print("GOTO 4")
					--print (rndact)
					--print (nearest)
				end
			end
		end
	end--]]--
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------