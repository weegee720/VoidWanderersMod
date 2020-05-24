-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
function VoidWanderers:MissionCreate()
	print ("ABANDONED VESSEL FACTION CREATE")

	-- Spawn random wandering enemies
	local set = CF_GetRandomMissionPointsSet(self.Pts, "Deploy")	

	local enm = CF_GetPointsArray(self.Pts, "Deploy", set, "AmbientEnemy")
	local amount = math.ceil(CF_AmbientEnemyRate * #enm)
	local enmpos = CF_SelectRandomPoints(enm, amount)	

	self.MissionLZs = CF_GetPointsArray(self.Pts, "Deploy", set, "EnemyLZ")
	
	-- Select faction 
	local ok = false

	while not ok do
		self.MissionSelectedFaction = CF_Factions[math.random(#CF_Factions)]
		if CF_FactionPlayable[self.MissionSelectedFaction] then
			ok = true
		end
	end
	
	local diff = CF_GetLocationDifficulty(self.GS, self.GS["Location"])
	self.MissionDifficulty = diff

	-- Create fake player for this random faction
	self.MissionFakePlayer = CF_MaxCPUPlayers + 1
	self.GS["Player"..self.MissionFakePlayer.."Faction"] = self.MissionSelectedFaction
	CF_CreateAIUnitPresets(self.GS, self.MissionFakePlayer, CF_GetTechLevelFromDifficulty(self.GS, self.MissionFakePlayer, diff, CF_MaxDifficulty))	
	
	print ("DIFF: "..self.MissionDifficulty)

	for i = 1, #enmpos do
		local plr
		local tm
		
		local pre = math.random(CF_PresetTypes.ENGINEER)
		local nw = {}
		nw["Preset"] = pre
		
		if math.random() < 0.175 then
			tm = CF_PlayerTeam
		elseif math.random() < 0.275 then
			tm = 2
		else
			tm = CF_CPUTeam
		end
		
		nw["Team"] = tm
		nw["Player"] = self.MissionFakePlayer
		if tm == CF_CPUTeam and math.random() < 0.40 then
			nw["AIMode"] = Actor.AIMODE_BRAINHUNT
		else
			nw["AIMode"] = Actor.AIMODE_SENTRY
		end
		nw["Pos"] = enmpos[i]
		
		table.insert(self.SpawnTable, nw)
		
		-- Spawn another engineer
		if math.random() < CF_AmbientEnemyDoubleSpawn then
			local pre = CF_PresetTypes.HEAVY2
			local nw = {}
			nw["Preset"] = pre
			nw["Team"] = tm
			nw["Player"] = self.MissionFakePlayer
			nw["AIMode"] = Actor.AIMODE_SENTRY
			nw["Pos"] = enmpos[i]
			
			table.insert(self.SpawnTable, nw)
		end
	end	
	
	self.MissionStart = self.Time
	self.MissionNextDropShip = self.Time + CF_AmbientReinforcementsInterval
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:MissionUpdate()
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------