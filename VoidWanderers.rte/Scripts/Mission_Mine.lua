-----------------------------------------------------------------------------------------
--	Objective: 	Kill all enemies to protect friendly miners, deploy mining operation
--				and protect incoming friendly miners from incoming enemy troops
--	Set used: 	Enemy
--	Events: 	After a while AI will send some dropships to replace dead miners
--
-----------------------------------------------------------------------------------------
function VoidWanderers:MissionCreate()
	print ("MINE CREATE")
	-- Mission difficulty settings
	local setts
	
	setts = {}
	setts[1] = {}
	setts[1]["AllyReinforcementsCount"] = 6
	setts[1]["EnemyDropshipUnitCount"] = 1
	setts[1]["Interval"] = 35
	setts[1]["InitialMiners"] = 2
	setts[1]["MinersNeeded"] = 3
	setts[1]["TimeToHold"] = 120
	
	setts[2] = {}
	setts[2]["AllyReinforcementsCount"] = 6
	setts[2]["EnemyDropshipUnitCount"] = 1
	setts[2]["Interval"] = 35
	setts[2]["InitialMiners"] = 2
	setts[2]["MinersNeeded"] = 3
	setts[2]["TimeToHold"] = 140

	setts[3] = {}
	setts[3]["AllyReinforcementsCount"] = 6
	setts[3]["EnemyDropshipUnitCount"] = 2
	setts[3]["Interval"] = 35
	setts[3]["InitialMiners"] = 2
	setts[3]["MinersNeeded"] = 4
	setts[3]["TimeToHold"] = 160

	setts[4] = {}
	setts[4]["AllyReinforcementsCount"] = 6
	setts[4]["EnemyDropshipUnitCount"] = 2
	setts[4]["Interval"] = 35
	setts[4]["InitialMiners"] = 2
	setts[4]["MinersNeeded"] = 4
	setts[4]["TimeToHold"] = 180

	setts[5] = {}
	setts[5]["AllyReinforcementsCount"] = 6
	setts[5]["EnemyDropshipUnitCount"] = 3
	setts[5]["Interval"] = 35
	setts[5]["InitialMiners"] = 3
	setts[5]["MinersNeeded"] = 5
	setts[5]["TimeToHold"] = 200

	setts[6] = {}
	setts[6]["AllyReinforcementsCount"] = 6
	setts[6]["EnemyDropshipUnitCount"] = 3
	setts[6]["Interval"] = 35
	setts[6]["InitialMiners"] = 3
	setts[6]["MinersNeeded"] = 5
	setts[6]["TimeToHold"] = 220
	
	self.MissionSettings = setts[self.MissionDifficulty]
	self.MissionStart = self.Time
	self.MissionLastReinforcements = self.Time + self.MissionSettings["Interval"] * 1.5
	self.MissionAllySpawnInterval = 50
	self.MissionLastAllyReinforcements = self.Time - 1
	
	-- Use generic enemy set
	local set = CF_GetRandomMissionPointsSet(self.Pts, "Mine")

	-- Get LZs
	self.MissionLZs = CF_GetPointsArray(self.Pts, "Mine", set, "MinerLZ")
	
	-- Git miners
	local miners = CF_GetPointsArray(self.Pts, "Mine", set, "Miners")
	miners = CF_SelectRandomPoints(miners, self.MissionSettings["InitialMiners"])

	-- Spawn miners
	for i = 1, #miners do
		local nw = {}
		nw["Preset"] = CF_PresetTypes.ENGINEER
		nw["Team"] = CF_PlayerTeam
		nw["Player"] = self.MissionSourcePlayer
		nw["AIMode"] = Actor.AIMODE_GOLDDIG
		nw["Pos"] = miners[i]
		nw["RenamePreset"] = "-" -- Spawn as allies. Allies don't need comm-points to operate and don't get transfered to ship
		
		table.insert(self.SpawnTable, nw)
	end
	
	self.MissionStages = {ACTIVE = 0, COMPLETED = 1, FAILED = 2}
	self.MissionStage = self.MissionStages.ACTIVE
	self.MissionEnoughMiners = false
	self.MissionCompleteCountdownStart = 0
	self.MissionShowDropshipWarningStart = 0
	
	self:SetTeamFunds(0, CF_CPUTeam);
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:MissionUpdate()
	if self.MissionStage == self.MissionStages.ACTIVE then
		self.MissionFailed = true
		local count = 0
			
		for actor in MovableMan.Actors do
			if actor.Team == CF_PlayerTeam then
				if actor:HasObjectInGroup("Diggers") and self:IsAlly(actor) then
					count = count + 1
					
					self:AddObjectivePoint("PROTECT", actor.AboveHUDPos, CF_PlayerTeam, GameActivity.ARROWDOWN);
				end
				
				-- Don't let the player take over allied crafts
				if (actor.ClassName == "ACDropShip" or actor.ClassName == "ACRocket") and actor:IsInventoryEmpty() then
					actor.Vel = Vector(0,-24)
				end
			end
		end
		
		self.MissionStatus = "MINERS: "..count.."/"..self.MissionSettings["MinersNeeded"]

		if count >= self.MissionSettings["MinersNeeded"] then
			if self.MissionEnoughMiners == false then
				self.MissionEnoughMiners = true
				self.MissionCompleteCountdownStart = self.Time
			end
			
			self.MissionStatus = "HOLD FOR "..self.MissionCompleteCountdownStart + self.MissionSettings["TimeToHold"] - self.Time.." TICKS"
		else
			self.MissionEnoughMiners = false
		end
		
		if self.MissionEnoughMiners and self.Time >= self.MissionCompleteCountdownStart + self.MissionSettings["TimeToHold"] then
			self:GiveMissionRewards()
			self.MissionStage = self.MissionStages.COMPLETED
			
			-- Remember when we started showing misison status message
			self.MissionStatusShowStart = self.Time		
		end

		if self.MissionSettings["AllyReinforcementsCount"] == 0 and count < self.MissionSettings["MinersNeeded"] then
			self.MissionStage = self.MissionStages.FAILED
			self.MissionStatusShowStart = self.Time
			
			for actor in MovableMan.Actors do
				if self:IsAlly(actor) then
					actor.Health = 0
				end
			end
		end
		
		if self.Time < self.MissionShowDropshipWarningStart + 10 then
			local s = ""
			if self.MissionSettings["AllyReinforcementsCount"] > 1 then
				s = "S"
			end
		
			if self.MissionSettings["AllyReinforcementsCount"] > 0 then
				for p = 0, self.PlayerCount - 1 do
					FrameMan:ClearScreenText(p);
					FrameMan:SetScreenText("ONLY "..self.MissionSettings["AllyReinforcementsCount"].." ALLY DROPSHIP"..s.." LEFT!!!", p, 0, 1000, true);
				end
			end
		end
		
		-- Send player reinforcements
		if not self.MissionEnoughMiners and #self.MissionLZs > 0 and self.Time >= self.MissionLastAllyReinforcements + 20 and self.MissionSettings["AllyReinforcementsCount"] > 0 then
			if MovableMan:GetMOIDCount() < CF_MOIDLimit then
				--print ("Spawn ally")
				self.MissionLastAllyReinforcements = self.Time
				
				if self.MissionSettings["AllyReinforcementsCount"] < 3 then
					self.MissionShowDropshipWarningStart = self.Time
				end
				
				local f = CF_GetPlayerFaction(self.GS, self.MissionSourcePlayer)
				local ship = CF_MakeActor(CF_Crafts[f] , CF_CraftClasses[f] , CF_CraftModules[f]);
				if ship then
					for i = 1, 2 do
						local actor = CF_SpawnAIUnitWithPreset(self.GS, self.MissionSourcePlayer, CF_PlayerTeam, nil, Actor.AIMODE_GOLDDIG, CF_PresetTypes.ENGINEER)
						if actor then
							ship:AddInventoryItem(actor)
							actor.PresetName = "-"..actor.PresetName
						end
					end
					ship.Team = CF_PlayerTeam
					ship.Pos = Vector(self.MissionLZs[math.random(#self.MissionLZs)].X, -10)
					ship.AIMode = Actor.AIMODE_DELIVER
					MovableMan:AddActor(ship)
					self.MissionSettings["AllyReinforcementsCount"] = self.MissionSettings["AllyReinforcementsCount"] - 1
				end
			end
		end
		
	elseif self.MissionStage == self.MissionStages.COMPLETED then
		self.MissionStatus = "MISSION COMPLETED"
		
		if self.Time < self.MissionStatusShowStart + CF_MissionResultShowInterval then
			for p = 0, self.PlayerCount - 1 do
				FrameMan:ClearScreenText(p);
				FrameMan:SetScreenText(self.MissionStatus, p, 0, 1000, true);
			end
		end
	elseif self.MissionStage == self.MissionStages.FAILED then
		self.MissionStatus = "MISSION FAILED"
		
		if self.Time < self.MissionStatusShowStart + CF_MissionResultShowInterval then
			for p = 0, self.PlayerCount - 1 do
				FrameMan:ClearScreenText(p);
				FrameMan:SetScreenText(self.MissionStatus, p, 0, 1000, true);
			end
		end
	end
	
	-- Always send enemy reinforcements to prevent player from digging out the whole map with free miners
	if #self.MissionLZs > 0 and self.Time >= self.MissionLastReinforcements + self.MissionSettings["Interval"] then
		if MovableMan:GetMOIDCount() < CF_MOIDLimit then
			self.MissionLastReinforcements = self.Time
			
			local f = CF_GetPlayerFaction(self.GS, self.MissionTargetPlayer)
			local ship = CF_MakeActor(CF_Crafts[f] , CF_CraftClasses[f] , CF_CraftModules[f]);
			if ship then
				local count 
				if self.MissionStage == self.MissionStages.ACTIVE then
					count = math.random(self.MissionSettings["EnemyDropshipUnitCount"])
				else
					count =3
				end
			
				for i = 1, count do
					local actor = CF_SpawnAIUnitWithPreset(self.GS, self.MissionTargetPlayer, CF_CPUTeam, nil, Actor.AIMODE_BRAINHUNT, math.random(CF_PresetTypes.HEAVY2))
					if actor then
						ship:AddInventoryItem(actor)
					end
				end
				ship.Team = CF_CPUTeam
				ship.Pos = Vector(self.MissionLZs[math.random(#self.MissionLZs)].X, -10)
				ship.AIMode = Actor.AIMODE_DELIVER
				MovableMan:AddActor(ship)
			end
		end
	end
	--]]--
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
