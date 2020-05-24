-----------------------------------------------------------------------------------------
--	Objective: 	Kill enemy brain unit
--	Set used: 	Enemy, Assassinate
--	Events: 	Depending on mission difficulty AI might send dropships with up to 2 actors and 
--	 			launch one counterattack when it will try to kill player actors with
--				half of it's actors. Initial spawn rate varies based on mission difficulty.
--				After commander's death units go nuts for a few moments
--
-----------------------------------------------------------------------------------------
function VoidWanderers:MissionCreate()
	print ("COUNTERATTACK CREATE")
	-- Mission difficulty settings
	local setts
	
	setts = {}
	setts[1] = {}
	setts[1]["SpawnRate"] = 0.60
	setts[1]["Reinforcements"] = 2
	setts[1]["Interval"] = 20
	setts[1]["CounterAttackDelay"] = 60
	
	setts[2] = {}
	setts[2]["SpawnRate"] = 0.60
	setts[2]["Reinforcements"] = 3
	setts[2]["Interval"] = 20
	setts[2]["CounterAttackDelay"] = 55

	setts[3] = {}
	setts[3]["SpawnRate"] = 0.70
	setts[3]["Reinforcements"] = 4
	setts[3]["Interval"] = 20
	setts[3]["CounterAttackDelay"] = 50

	setts[4] = {}
	setts[4]["SpawnRate"] = 0.80
	setts[4]["Reinforcements"] = 5
	setts[4]["Interval"] = 20
	setts[4]["CounterAttackDelay"] = 45

	setts[5] = {}
	setts[5]["SpawnRate"] = 0.90
	setts[5]["Reinforcements"] = 6
	setts[5]["Interval"] = 20
	setts[5]["CounterAttackDelay"] = 40

	setts[6] = {}
	setts[6]["SpawnRate"] = 1
	setts[6]["Reinforcements"] = 7
	setts[6]["Interval"] = 20
	setts[6]["CounterAttackDelay"] = 35
	
	print ("DIFF: "..self.MissionDifficulty )
	
	self.MissionSettings = setts[self.MissionDifficulty]
	self.MissionStart = self.Time
	
	self.MissionSourcePlayer = self.AssaultEnemyPlayer
	
	-- Use generic enemy set
	local set = CF_GetRandomMissionPointsSet(self.Pts, "Enemy")
	
	self:DeployGenericMissionEnemies(set, "Enemy", self.MissionSourcePlayer, CF_CPUTeam, self.MissionSettings["SpawnRate"])

	-- Spawn commander
	local cmndrpts = CF_GetPointsArray(self.Pts, "Assassinate", set, "Commander")
	local cpos = cmndrpts[math.random(#cmndrpts)]
	
	self.MissionBrain = CF_MakeBrain(self.GS, self.MissionSourcePlayer, CF_CPUTeam, cpos)
	if self.MissionBrain then
		MovableMan:AddActor(self.MissionBrain)
	else
		error("Can't create CPU brain")
	end
	
	-- Remove doors
	for actor in MovableMan.Actors do
		if actor.ClassName == "ADoor" then
			actor.Team = CF_CPUTeam;
		end
	end--]]--
	
	self.MissionStages = {ACTIVE = 0, COMPLETED = 1}
	self.MissionStage = self.MissionStages.ACTIVE
	
	self.MissionReinforcementsTriggered = true
	self.MissionLastReinforcements = self.Time
	self.CounterAttackTriggered = false
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:MissionUpdate()
	if self.MissionStage == self.MissionStages.ACTIVE then
		self.MissionFailed = true
		local count = 0
			
		-- Start checking for victory only when all units were spawned
		if self.SpawnTable == nil then
			if MovableMan:IsActor(self.MissionBrain) then
				if not SceneMan:IsUnseen(self.MissionBrain.Pos.X, self.MissionBrain.Pos.Y, CF_PlayerTeam) then
					self:AddObjectivePoint("KILL", self.MissionBrain.AboveHUDPos, CF_PlayerTeam, GameActivity.ARROWDOWN);
				end
			else
				-- Kill some of the actors
				for actor in MovableMan.Actors do
					if actor.Team == CF_CPUTeam and (actor.Health < 25 or math.random() < 0.4) then
						actor:GibThis()
					end
				end
			
				self.MissionReputationReward = CF_CalculateReward(600, self.MissionDifficulty)
				self.MissionGoldReward = 0
				self:GiveMissionRewards(true)
				self.MissionStage = self.MissionStages.COMPLETED
				
				-- Remember when we started showing misison status message
				self.MissionStatusShowStart = self.Time
				self.MissionEnd = self.Time
			end
		end

		-- Trigger reinforcements
		for actor in MovableMan.Actors do
			if actor.Team == CF_CPUTeam and (actor.ClassName == "AHuman" or actor.ClassName == "ACrab") then
				local inside = false
				
				if not self.MissionReinforcementsTriggered and actor.Health < 50 then
					self.MissionReinforcementsTriggered = true
					
					self.MissionLastReinforcements = self.Time
				end
			end
		end
		
		self.MissionStatus = "COMMANDER ALIVE"
		
		-- Send reinforcements if available
		if self.MissionReinforcementsTriggered and #self.MissionLZs > 0 and self.MissionSettings["Reinforcements"] > 0 and self.Time >= self.MissionLastReinforcements + self.MissionSettings["Interval"] then
			if MovableMan:GetMOIDCount() < CF_MOIDLimit then
				self.MissionLastReinforcements = self.Time
				self.MissionSettings["Reinforcements"] = self.MissionSettings["Reinforcements"] - 1
					
				local count = math.random(2)
				local f = CF_GetPlayerFaction(self.GS, self.MissionTargetPlayer)
				for i = 1, count do
					local actor = CF_SpawnAIUnit(self.GS, self.AssaultEnemyPlayer, CF_CPUTeam, self.MissionLZs[math.random(#self.MissionLZs)], Actor.AIMODE_BRAINHUNT)
					if actor then
						MovableMan:AddActor(actor)
					end
				end
			end
		end
		
		-- Trigger 'counterattack', send every second actor to attack player troops
		if not self.CounterAttackTriggered and self.MissionSettings["CounterAttackDelay"] > 0 and self.Time >= self.MissionStart + self.MissionSettings["CounterAttackDelay"] then
			self.CounterAttackTriggered = true
			print ("COUNTERATTACK!")

			local count = 0
			
			for actor in MovableMan.Actors do
				if actor.Team == CF_CPUTeam and not actor:IsInGroup("Brains") then
					count = count + 1
					
					if count % 2 == 0 then
						actor.AIMode = Actor.AIMODE_BRAINHUNT
					end
				end
			end
		end
	elseif self.MissionStage == self.MissionStages.COMPLETED then
		self.MissionStatus = "MISSION COMPLETED"
		if not self.MissionEndMusicPlayed then
			self:StartMusic(CF_MusicTypes.VICTORY)
			self.MissionEndMusicPlayed = true
		end
		
		if self.Time < self.MissionStatusShowStart + CF_MissionResultShowInterval then
			for p = 0, self.PlayerCount - 1 do
				FrameMan:ClearScreenText(p);
				FrameMan:SetScreenText(self.MissionStatus, p, 0, 1000, true);
			end
		end
		
		if self.Time < self.MissionEnd + 25 then
			for actor in MovableMan.Actors do
				if actor.Team == CF_CPUTeam then
					local cont = actor:GetController();
					if cont ~= nil then
						if cont:IsState(Controller.WEAPON_FIRE) then
							cont:SetState(Controller.WEAPON_FIRE, false)
						else
							cont:SetState(Controller.WEAPON_FIRE, true)
						end
					end
				end
			end
		end
	end--]]--
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------