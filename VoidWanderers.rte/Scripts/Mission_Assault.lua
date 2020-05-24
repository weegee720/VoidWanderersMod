-----------------------------------------------------------------------------------------
--
--
--
-----------------------------------------------------------------------------------------
--	Set used: Enemy
--
--	Generic events:
--
--
--	Difficulty 2+:
--
--
-----------------------------------------------------------------------------------------
function VoidWanderers:MissionCreate()
	-- Use generic enemy set
	local set = CF_GetRandomMissionPointsSet(self.Pts, "Enemy")
	
	self:DeployGenericMissionEnemies(set, "Enemy", self.MissionTargetPlayer)
	
	self.MissionStages = {ASSAULT = 0, COMPLETED = 1}
	self.MissionStage = self.MissionStages.ASSAULT
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:MissionUpdate()
	if self.MissionStage == self.MissionStages.ASSAULT then
		self.MissionFailed = true
		local count = 0
		
		for actor in MovableMan.Actors do
			if actor.Team == CF_CPUTeam then
				local inside = false
			
				for i = 1, #self.MissionBase do
					if self.MissionBase[i]:WithinBox(actor.Pos) then
						actor:FlashWhite(250)
						count = count + 1
						inside = true
						break
					end
				end
				
				if inside and self.Time % 7 == 0 then
					self:AddObjectivePoint("KILL", actor.AboveHUDPos, CF_PlayerTeam, GameActivity.ARROWDOWN);
				end
			end
		end
		
		self.MissionStatus = "Enemies left: "..tostring(count)
		
		-- Start checking for victory only when all units were spawned
		if self.SpawnTable == nil and count == 0 then
			self:GiveMissionRewards()
			self.MissionStage = self.MissionStages.COMPLETED
			
			
			-- Remember when we started showing misison status message
			self.MissionStatusShowStart = self.Time
		end
	elseif self.MissionStage == self.MissionStages.COMPLETED then
		self.MissionStatus = "MISSION COMPLETED"
		
		if self.Time < self.MissionStatusShowStart + 8 then
			for p = 0, self.PlayerCount - 1 do
				FrameMan:ClearScreenText(p);
				FrameMan:SetScreenText(self.MissionStatus, p, 0, 1000, true);
			end
		end
	end
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------