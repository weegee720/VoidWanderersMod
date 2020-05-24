-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:InitBombsControlPanelUI()
	self.BombsControlPanelActor = CreateActor("Bomb Control Panel")
	if self.BombsControlPanelActor ~= nil then
		self.BombsControlPanelActor.Pos = Vector(0,0)
		self.BombsControlPanelActor.Team = CF_PlayerTeam
		MovableMan:AddActor(self.BombsControlPanelActor)
	end
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:DestroyBombsControlPanelUI()
	if self.BombsControlPanelActor ~= nil and MovableMan:IsActor(self.BombsControlPanelActor) then
		self.BombsControlPanelActor.ToDelete = true
		self.BombsControlPanelActor = nil
	end
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:ProcessBombsControlPanelUI()
	if MovableMan:IsActor(self.BombsControlPanelActor) then
		local isactive = false
	
		for plr = 0 , self.PlayerCount - 1 do
			local act = self:GetControlledActor(plr);
		
			if MovableMan:IsActor(act) and act.PresetName == "Bomb Control Panel" then
				self.BombsControlPanelInBombMode = true
				isactive = true
				local pos = self.BombsControlPanelActor.Pos
				local cont = act:GetController()
				
				local left = false
				local right = false
					
				if self.BombingTarget == nil then
					if cont:IsState(Controller.PRESS_LEFT) then
						left = true
					end

					if cont:IsState(Controller.PRESS_RIGHT) then
						right = true
					end
						
					if self.HoldTimer:IsPastSimMS(25) then
						self.HoldTimer:Reset()

						if cont:IsState(Controller.HOLD_LEFT) then
							left = true
						end
					
						if cont:IsState(Controller.HOLD_RIGHT) then
							right = true
						end
					end
					
					if left then
						pos.X = pos.X - 15
						if pos.X < 0 then
							pos.X = SceneMan.Scene.Width - math.abs(pos.X)
						end
					end
					
					if right then
						pos.X = pos.X + 15
						if pos.X > SceneMan.Scene.Width then
							pos.X = pos.X - SceneMan.Scene.Width
						end
					end
				end
					
				local bombpos = SceneMan:MovePointToGround(Vector(pos.X, 0) , 20 , 3);
				
				if bombpos.Y < 0 then
					bombpos.Y = 0
				end
				
				if bombpos.Y > SceneMan.Scene.Height then
					bombpos.Y = SceneMan.Scene.Height
				end

				self.BombsControlPanelActor.Pos = bombpos

				local range
				
				if SceneMan:IsUnseen(bombpos.X, bombpos.Y, CF_PlayerTeam) then
					range = CF_BombUnseenRange
				else
					range = CF_BombSeenRange
				end
				
				local s = "SELECT TARGET"
				
				if self.BombingTarget ~= nil then
					s = ""
					if self.Time <= self.BombingStart + self.BombingLoadTime then
						s = "LOADING BOMBS\nT-"..tostring(self.BombingStart + self.BombingLoadTime + CF_BombFlightInterval - self.Time)
					elseif self.Time <= self.BombingStart + self.BombingLoadTime  + CF_BombFlightInterval then
						s = "BOMBS RELEASED\nT-"..tostring(self.BombingStart + self.BombingLoadTime + CF_BombFlightInterval - self.Time)
					end
				else
					self.LastKnownBombingPosition = bombpos
				end
				self:AddObjectivePoint(s, bombpos, CF_PlayerTeam, GameActivity.ARROWDOWN);

				local x = pos.X - range / 4
				if x < 0 then
					x = SceneMan.Scene.Width - math.abs(x)
				end
				local targetpos = SceneMan:MovePointToGround(Vector(x, 0) , 20 , 3);
				self:AddObjectivePoint("", targetpos, CF_PlayerTeam, GameActivity.ARROWDOWN);

				local x = pos.X - range / 2
				if x < 0 then
					x = SceneMan.Scene.Width - math.abs(x)
				end
				local targetpos = SceneMan:MovePointToGround(Vector(x, 0) , 20 , 3);
				self:AddObjectivePoint("", targetpos, CF_PlayerTeam, GameActivity.ARROWDOWN);

				local x = pos.X + range / 4
				if x > SceneMan.Scene.Width then
					x = x - SceneMan.Scene.Width
				end
				local targetpos = SceneMan:MovePointToGround(Vector(x, 0) , 20 , 3);
				self:AddObjectivePoint("", targetpos, CF_PlayerTeam, GameActivity.ARROWDOWN);

				local x = pos.X + range / 2
				if x > SceneMan.Scene.Width then
					x = x - SceneMan.Scene.Width
				end
				local targetpos = SceneMan:MovePointToGround(Vector(x, 0) , 20 , 3);
				self:AddObjectivePoint("", targetpos, CF_PlayerTeam, GameActivity.ARROWDOWN);
				
				if cont:IsState(Controller.WEAPON_FIRE) then
					if not self.FirePressed then
						self.FirePressed = true;
						
						if self.BombingTarget == nil then
							self.BombingTarget = bombpos.X
							self.BombingStart = self.Time
							self.BombingLoadTime = math.ceil(#self.BombPayload / tonumber(self.GS["Player0VesselBombBays"])) * CF_BombLoadInterval
							self.BobmingRange = range
							self.BombingLastBombShot = self.Time
							self.BombingCount = 1
							
							-- Commit bombs to storage
							CF_SetBombsArray(self.GS, self.Bombs)
						end
					end
				else
					self.FirePressed = false
				end
			end
		end
		
		-- Destroy bomb actor if it's not selected anymore
		if not isactive then
			if self.BombsControlPanelActor ~= nil then
				-- If we started to drop the bombs then LZ update routine will delete bombing actor once everything is finished
				-- we need to allow player to watch the results of bombing
				if self.BombingTarget == nil then
					self:DestroyBombsControlPanelUI()
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
