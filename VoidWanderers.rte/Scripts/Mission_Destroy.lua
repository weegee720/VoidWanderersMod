-----------------------------------------------------------------------------------------
--	Objective: 	Destroy all clone vats
--	Set used: 	Deploy, Zombies
--	Events: 	AI might call in reinforcemtnes. If AI device is damaged then all nearby units are switched in 
--				brainhunt mode
--
-----------------------------------------------------------------------------------------
function VoidWanderers:MissionCreate()
	print ("DESTROY CREATE")
	-- Mission difficulty settings
	local setts
	
	setts = {}
	setts[1] = {}
	setts[1]["DeviceCount"] = 3
	setts[1]["SpawnRate"] = 0.50
	setts[1]["Reinforcements"] = 0
	setts[1]["Interval"] = 0
	
	setts[2] = {}
	setts[2]["DeviceCount"] = 4
	setts[2]["SpawnRate"] = 0.60
	setts[2]["Reinforcements"] = 0
	setts[2]["Interval"] = 0

	setts[3] = {}
	setts[3]["DeviceCount"] = 5
	setts[3]["SpawnRate"] = 0.70
	setts[3]["Reinforcements"] = 0
	setts[3]["Interval"] = 0

	setts[4] = {}
	setts[4]["DeviceCount"] = 6
	setts[4]["SpawnRate"] = 0.80
	setts[4]["Reinforcements"] = 1
	setts[4]["Interval"] = 30

	setts[5] = {}
	setts[5]["DeviceCount"] = 7
	setts[5]["SpawnRate"] = 0.90
	setts[5]["Reinforcements"] = 2
	setts[5]["Interval"] = 30

	setts[6] = {}
	setts[6]["DeviceCount"] = 8
	setts[6]["SpawnRate"] = 1
	setts[6]["Reinforcements"] = 3
	setts[6]["Interval"] = 30
	
	self.MissionSettings = setts[self.MissionDifficulty]
	self.MissionStart = self.Time
	
	-- Spawn enemies
	local enmset = CF_GetRandomMissionPointsSet(self.Pts, "Deploy")
	local enm = CF_GetPointsArray(self.Pts, "Deploy", enmset, "AmbientEnemy")
	local enmpos = CF_SelectRandomPoints(enm, math.floor(self.MissionSettings["SpawnRate"] * #enm))
	self.MissionLZs = CF_GetPointsArray(self.Pts, "Deploy", enmset, "EnemyLZ")

	for i = 1, #enmpos do
		local pre = math.random(CF_PresetTypes.ENGINEER)
		local nw = {}
		nw["Preset"] = pre
		nw["Team"] = CF_CPUTeam
		nw["Player"] = self.MissionTargetPlayer
		nw["AIMode"] = Actor.AIMODE_SENTRY
		nw["Pos"] = enmpos[i]
		
		table.insert(self.SpawnTable, nw)
	end	
	
	local amount = math.ceil(CF_AmbientEnemyRate * #enm)
	--print ("Crates: "..amount)
	local enmpos = CF_SelectRandomPoints(enm, amount)
	
	-- Select set
	local set = CF_GetRandomMissionPointsSet(self.Pts, "Zombies")

	-- Get LZs
	self.MissionDevicesPos = CF_GetPointsArray(self.Pts, "Zombies", set, "Vat")
	if self.MissionSettings["DeviceCount"] < 8 then
		self.MissionDevicesPos = CF_SelectRandomPoints(self.MissionDevicesPos, self.MissionSettings["DeviceCount"])
	end

	self.MissionDevices = {}
	self.MissionAlertTriggered = {}
	
	-- Spawn vats
	for i = 1, self.MissionSettings["DeviceCount"] do
		--self.MissionDevices[i] = CreateActor("Factory Actor", self.ModuleName);
		--self.MissionDevices[i].Pos = self.MissionDevicesPos[i] + Vector(0,42)
		self.MissionDevices[i] = CreateActor("Computer Actor", self.ModuleName);
		self.MissionDevices[i].Pos = self.MissionDevicesPos[i] + Vector(0,30)
		self.MissionDevices[i].Team = CF_CPUTeam;
		MovableMan:AddActor(self.MissionDevices[i]);
		self.MissionAlertTriggered[i] = false
	end
	
	self.MissionStages = {ACTIVE = 0, COMPLETED = 1}
	self.MissionStage = self.MissionStages.ACTIVE
	self.MissionCompleteCountdownStart = 0
	self.MissionLastReinforcements = 0
	
	self.MissionAlertRange = 450
	
	self.MissionReinforcementsTriggered = false
	self.LastAlertTriggered = false
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:MissionUpdate()
	if self.MissionStage == self.MissionStages.ACTIVE then
		local vats = 0

		-- Count vats
		for i = 1, self.MissionSettings["DeviceCount"] do
			if MovableMan:IsActor(self.MissionDevices[i]) then
				vats = vats + 1
				
				if not SceneMan:IsUnseen(self.MissionDevicesPos[i].X, self.MissionDevicesPos[i].Y, CF_PlayerTeam) then
					self:AddObjectivePoint("DESTROY", self.MissionDevicesPos[i] + Vector(0,-10), CF_PlayerTeam, GameActivity.ARROWDOWN);
				end
				
				if self.MissionDevices[i].Health < 100 and self.MissionAlertTriggered[i] == false then
					self.MissionAlertTriggered[i] = true
					if not self.MissionReinforcementsTriggered then
						self.MissionReinforcementsTriggered = true
						self.MissionLastReinforcements = self.Time
					end
				
					for actor in MovableMan.Actors do
						if actor.Team == CF_CPUTeam  and actor.AIMode ~= Actor.AIMODE_BRAINHUNT and (actor.ClassName == "AHuman" or actor.ClassName == "ACrab") and CF_Dist(self.MissionDevicesPos[i], actor.Pos) < self.MissionAlertRange then
							actor.AIMode = Actor.AIMODE_BRAINHUNT
						end
					end
				end
			else
				self.MissionDevices[i] = nil
			end
		end
		
		if self.LastAlertTriggered == false and vats == 1 then
			self.LastAlertTriggered = true
			
			for actor in MovableMan.Actors do
				if actor.Team == CF_CPUTeam  and actor.AIMode ~= Actor.AIMODE_BRAINHUNT and (actor.ClassName == "AHuman" or actor.ClassName == "ACrab") then
					actor.AIMode = Actor.AIMODE_BRAINHUNT
				end
			end
		end

		self.MissionStatus = "DEVICES: "..vats

		if self.MissionReinforcementsTriggered and #self.MissionLZs > 0 and self.MissionSettings["Reinforcements"] > 0 and self.Time >= self.MissionLastReinforcements + self.MissionSettings["Interval"] then
			if MovableMan:GetMOIDCount() < CF_MOIDLimit then
				self.MissionLastReinforcements = self.Time
				self.MissionSettings["Reinforcements"] = self.MissionSettings["Reinforcements"] - 1
					
				local count = 3
				local f = CF_GetPlayerFaction(self.GS, self.MissionTargetPlayer)
				local ship = CF_MakeActor(CF_Crafts[f] , CF_CraftClasses[f] , CF_CraftModules[f]);
				if ship then
					for i = 1, count do
						local actor = CF_SpawnAIUnit(self.GS, self.MissionTargetPlayer, CF_CPUTeam, nil, Actor.AIMODE_BRAINHUNT)
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
		
		-- Check wining conditions
		if vats == 0 then
			self:GiveMissionRewards()
			self.MissionStage = self.MissionStages.COMPLETED
			
			-- Remember when we started showing misison status messageaaa
			self.MissionStatusShowStart = self.Time		
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
	end
	--]]--
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
