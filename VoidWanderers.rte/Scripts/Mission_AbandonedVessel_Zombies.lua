-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
function VoidWanderers:MissionCreate()
	print ("ABANDONED VESSEL ZOMBIES CREATE")

	-- Spawn random wandering enemies
	local set = CF_GetRandomMissionPointsSet(self.Pts, "Deploy")	

	local enm = CF_GetPointsArray(self.Pts, "Deploy", set, "AmbientEnemy")
	local amount = math.ceil(CF_AmbientEnemyRate / 2 * #enm)
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

	self.MissionFakePlayer = CF_MaxCPUPlayers + 1
	self.GS["Player"..self.MissionFakePlayer.."Faction"] = self.MissionSelectedFaction
	
	local diff = CF_GetLocationDifficulty(self.GS, self.GS["Location"])
	self.MissionDifficulty = diff
	
	self.MissionZombieRespawnInterval = 20 - self.MissionDifficulty
	self.MissionZombieRespawnTime = self.Time
	
	self.Zombies = {"Culled Clone", "Thin Culled Clone", "Fat Culled Clone"}

	-- Build random weapon lists
	local rifles = CF_MakeListOfMostPowerfulWeapons(self.GS, self.MissionFakePlayer, CF_WeaponTypes.RIFLE , CF_GetTechLevelFromDifficulty(self.GS, self.MissionFakePlayer, self.MissionDifficulty, CF_MaxDifficulty))
	local snipers = CF_MakeListOfMostPowerfulWeapons(self.GS, self.MissionFakePlayer, CF_WeaponTypes.SNIPER , CF_GetTechLevelFromDifficulty(self.GS, self.MissionFakePlayer, self.MissionDifficulty, CF_MaxDifficulty))
	local pistols = CF_MakeListOfMostPowerfulWeapons(self.GS, self.MissionFakePlayer, CF_WeaponTypes.PISTOL , CF_GetTechLevelFromDifficulty(self.GS, self.MissionFakePlayer, self.MissionDifficulty, CF_MaxDifficulty))
	local grenades = CF_MakeListOfMostPowerfulWeapons(self.GS, self.MissionFakePlayer, CF_WeaponTypes.GRENADE , CF_GetTechLevelFromDifficulty(self.GS, self.MissionFakePlayer, self.MissionDifficulty, CF_MaxDifficulty))
	
	self.MissionWeapons = {}
	
	if rifles ~= nil and #rifles > 0 then
		self.MissionWeapons[#self.MissionWeapons + 1] = rifles
	end
	
	if snipers ~= nil and #snipers > 0 then
		self.MissionWeapons[#self.MissionWeapons + 1] = sniper
	end

	if pistols ~= nil and #pistols > 0 then
		self.MissionWeapons[#self.MissionWeapons + 1] = pistols
	end

	if grenades ~= nil and #grenades > 0 then
		self.MissionWeapons[#self.MissionWeapons + 1] = grenades
	end
	
	-- Spawn some random zombies
	for i = 1, #enmpos do
		if MovableMan:GetMOIDCount() < CF_MOIDLimit and #self.MissionLZs > 0 then
			local a = CreateAHuman(self.Zombies[math.random(#self.Zombies)])
			if a then
				a.Pos = enmpos[i]
				if math.random() < 0.1 then
					a.Team = 2
				else
					a.Team = CF_CPUTeam
				end
				a.AIMode = Actor.AIMODE_BRAINHUNT
				
				local r1 = math.random(#self.MissionWeapons)
				local r2 = math.random(#self.MissionWeapons[r1])
				
				local i = self.MissionWeapons[r1][r2]["Item"]
				local f = self.MissionWeapons[r1][r2]["Faction"]
				
				local w = CF_MakeItem(CF_ItmPresets[f][i],CF_ItmClasses[f][i], CF_ItmModules[f][i])
				if w ~= nil then
					a:AddInventoryItem(w)
				end				
				
				MovableMan:AddActor(a)
			end
		end
	end
	
	self.MissionStart = self.Time
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:MissionUpdate()
	if self.Time >= self.MissionZombieRespawnTime then
		self.MissionZombieRespawnTime = self.Time + self.MissionZombieRespawnInterval
		
		for i = 1, math.random(3) do
			if MovableMan:GetMOIDCount() < CF_MOIDLimit and #self.MissionLZs > 0 then
				local a = CreateAHuman(self.Zombies[math.random(#self.Zombies)])
				if a then
					a.Pos = self.MissionLZs[math.random(#self.MissionLZs)]
					if math.random() < 0.1 then
						a.Team = 2
					else
						a.Team = CF_CPUTeam
					end
					a.AIMode = Actor.AIMODE_BRAINHUNT
					
					local r1 = math.random(#self.MissionWeapons)
					local r2 = math.random(#self.MissionWeapons[r1])
					
					local i = self.MissionWeapons[r1][r2]["Item"]
					local f = self.MissionWeapons[r1][r2]["Faction"]
					
					local w = CF_MakeItem(CF_ItmPresets[f][i],CF_ItmClasses[f][i], CF_ItmModules[f][i])
					if w ~= nil then
						a:AddInventoryItem(w)
					end				
					
					MovableMan:AddActor(a)
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------