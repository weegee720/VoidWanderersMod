-----------------------------------------------------------------------------------------
--	Objective: 	Kill all enemy miners and shoot down all incoming dropships
--	Set used: 	Enemy
--	Events: 	After a while AI will send some dropships to replace dead miners
--
-----------------------------------------------------------------------------------------
function VoidWanderers:MissionCreate()
	print ("DROPSHIPS CREATE")
	-- Mission difficulty settings
	local setts
	
	setts = {}
	setts[1] = {}
	setts[1]["SpawnRate"] = 0.20
	setts[1]["Reinforcements"] = 2
	setts[1]["Interval"] = 26
	setts[1]["TargetGold"] = 4500
	
	setts[2] = {}
	setts[2]["SpawnRate"] = 0.40
	setts[2]["Reinforcements"] = 3
	setts[2]["Interval"] =26
	setts[2]["TargetGold"] = 4500

	setts[3] = {}
	setts[3]["SpawnRate"] = 0.60
	setts[3]["Reinforcements"] = 4
	setts[3]["Interval"] = 26
	setts[3]["TargetGold"] = 4500

	setts[4] = {}
	setts[4]["SpawnRate"] = 0.80
	setts[4]["Reinforcements"] = 5
	setts[4]["Interval"] = 24
	setts[4]["TargetGold"] = 4500

	setts[5] = {}
	setts[5]["SpawnRate"] = 1
	setts[5]["Reinforcements"] = 6
	setts[5]["Interval"] = 24
	setts[5]["TargetGold"] = 4500

	setts[6] = {}
	setts[6]["SpawnRate"] = 1
	setts[6]["Reinforcements"] = 7
	setts[6]["Interval"] = 22
	setts[6]["TargetGold"] = 4500
	
	self.MissionSettings = setts[self.MissionDifficulty]
	self.MissionStart = self.Time
	self.MissionLastReinforcements = self.Time + self.MissionSettings["Interval"] * 3
	self.MissionNextWarningGold = self.MissionSettings["TargetGold"] * 0.20
	self.MissionLastFailWarning = 0
	
	-- Use generic enemy set
	local set = CF_GetRandomMissionPointsSet(self.Pts, "Mine")

	-- Get LZs
	self.MissionLZs = CF_GetPointsArray(self.Pts, "Mine", set, "MinerLZ")	
	
	--print (#self.MissionLZs)
	
	local count

	-- Get miner locations
	local miners = CF_GetPointsArray(self.Pts, "Mine", set, "Miners")
	count = math.ceil(#miners * self.MissionSettings["SpawnRate"])
	if count < 0 then
		count = 1
	end
	miners = CF_SelectRandomPoints(miners, count)

	-- Get security locations
	local security = CF_GetPointsArray(self.Pts, "Mine", set, "MinerSentries")
	count = math.ceil(#security * self.MissionSettings["SpawnRate"])
	if count < 0 then
		count = 1
	end
	security = CF_SelectRandomPoints(security, count)

	-- Spawn miners with double rate
	for i = 1, #miners do
		local nw = {}
		nw["Preset"] = CF_PresetTypes.ENGINEER
		nw["Team"] = CF_CPUTeam
		nw["Player"] = self.MissionTargetPlayer
		nw["AIMode"] = Actor.AIMODE_GOLDDIG
		nw["Pos"] = miners[i]
		
		table.insert(self.SpawnTable, nw)
	end
	
	-- Spawn security
	for i = 1, #security do
		local nw = {}
		nw["Preset"] = math.random(CF_PresetTypes.HEAVY2)
		nw["Team"] = CF_CPUTeam
		nw["Player"] = self.MissionTargetPlayer
		nw["AIMode"] = Actor.AIMODE_SENTRY
		nw["Pos"] = security[i]
		
		table.insert(self.SpawnTable, nw)
	end
	
	-- Spawn a few snipers finally
	local snipers = CF_GetPointsArray(self.Pts, "Enemy", set, "Sniper")
	for i = 1, #snipers do
		if math.random() < self.MissionSettings["SpawnRate"] / 3 then
			local nw = {}
			nw["Preset"] = CF_PresetTypes.SNIPER
			nw["Team"] = CF_CPUTeam
			nw["Player"] = self.MissionTargetPlayer
			nw["AIMode"] = Actor.AIMODE_SENTRY
			nw["Pos"] = snipers[i]
			
			table.insert(self.SpawnTable, nw)
		end
	end
	
	self.MissionStages = {ACTIVE = 0, COMPLETED = 1, FAILED = 2}
	self.MissionStage = self.MissionStages.ACTIVE
	
	self:SetTeamFunds(0, CF_CPUTeam);
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:MissionUpdate()
	if self.MissionStage == self.MissionStages.ACTIVE then
		self.MissionFailed = true
		local count = 0
			
		if self:GetTeamFunds(CF_CPUTeam) > 0 then
			--print (self:GetTeamFunds(CF_CPUTeam))
		
			-- Show gold warnings from time to time
			if self:GetTeamFunds(CF_CPUTeam) > self.MissionNextWarningGold then
				self.MissionNextWarningGold = self.MissionNextWarningGold + self.MissionSettings["TargetGold"] * 0.20
				self.MissionLastFailWarning = self.Time + 5
			end
			
			-- Always show last warning
			if  self:GetTeamFunds(CF_CPUTeam) > self.MissionSettings["TargetGold"] * 0.95 then
				self.MissionLastFailWarning = self.Time + 5
			end
			
			if self.Time < self.MissionLastFailWarning then
				for p = 0, self.PlayerCount - 1 do
					FrameMan:ClearScreenText(p);
					FrameMan:SetScreenText("STOP ENEMY MINING OPERATION\n"..self.MissionSettings["TargetGold"] - math.ceil(self:GetTeamFunds(CF_CPUTeam)).."oz OF GOLD LEFT TO MINE", p, 0, 1000, true);
				end
			end
			
			-- Mission failed
			if self:GetTeamFunds(CF_CPUTeam) >= self.MissionSettings["TargetGold"] then
				self.MissionStage = self.MissionStages.FAILED
				self.MissionStatusShowStart = self.Time		
			end
		end
			
		for actor in MovableMan.Actors do
			if actor.Team == CF_CPUTeam then
				if actor:HasObjectInGroup("Diggers") then
					count = count + 1
					
					if actor.AIMode ~= Actor.AIMODE_GOLDDIG then
						actor.AIMode = Actor.AIMODE_GOLDDIG
					end
					
					if not SceneMan:IsUnseen(actor.Pos.X, actor.Pos.Y, CF_PlayerTeam) then
						self:AddObjectivePoint("KILL", actor.AboveHUDPos, CF_PlayerTeam, GameActivity.ARROWDOWN);
					end
				end
				
				if actor.ClassName == "ACDropShip" or actor.ClassName == "ACRocket" then
					if not SceneMan:IsUnseen(actor.Pos.X, actor.Pos.Y, CF_PlayerTeam) then
						self:AddObjectivePoint("TAKE DOWN\nDROPSHIP", actor.AboveHUDPos, CF_PlayerTeam, GameActivity.ARROWDOWN);
					end
				end
			end
		end
		
		if self.MissionSettings["Reinforcements"] > 0 then
			self.MissionStatus = "DROP SHIPS: "..self.MissionSettings["Reinforcements"]
		else
			self.MissionStatus = "MINERS REMAINING: "..count
		end

		if self.MissionSettings["Reinforcements"] == 0 and count == 0 then
			self:GiveMissionRewards()
			self.MissionStage = self.MissionStages.COMPLETED
			
			-- Remember when we started showing misison status message
			self.MissionStatusShowStart = self.Time		
		end
		
		-- Send reinforcements if available
		if #self.MissionLZs > 0 and self.MissionSettings["Reinforcements"] > 0 and self.Time >= self.MissionLastReinforcements + self.MissionSettings["Interval"] then
			if MovableMan:GetMOIDCount() < CF_MOIDLimit then
				self.MissionLastReinforcements = self.Time
				self.MissionSettings["Reinforcements"] = self.MissionSettings["Reinforcements"] - 1
					
				local pres = {}
				pres[1] = CF_PresetTypes.ENGINEER
				pres[2] = math.random(CF_PresetTypes.SHOTGUN)
				pres[3] = math.random(CF_PresetTypes.HEAVY2)
				
				local modes = {}
				modes[1] = Actor.AIMODE_GOLDDIG
				modes[2] = Actor.AIMODE_SENTRY
				modes[3] = Actor.AIMODE_BRAINHUNT
				
				local f = CF_GetPlayerFaction(self.GS, self.MissionTargetPlayer)
				local ship = CF_MakeActor(CF_Crafts[f] , CF_CraftClasses[f] , CF_CraftModules[f]);
				if ship then
					local i = math.random(#pres)
					--for i = 1, math.random(#pres) do
						local actor = CF_SpawnAIUnitWithPreset(self.GS, self.MissionTargetPlayer, CF_CPUTeam, nil, modes[i], pres[i])
						if actor then
							ship:AddInventoryItem(actor)
						end
					--end
					ship.Team = CF_CPUTeam
					ship.Pos = Vector(self.MissionLZs[math.random(#self.MissionLZs)].X, -10)
					ship.AIMode = Actor.AIMODE_DELIVER
					MovableMan:AddActor(ship)
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
	end--]]--
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:CraftEnteredOrbit()
	if self.OrbitedCraft.Team == CF_CPUTeam then
		self.MissionSettings["Reinforcements"] = self.MissionSettings["Reinforcements"] + 1
	end
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
