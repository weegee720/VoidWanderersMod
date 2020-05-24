-- List of HumanBehaviors functions
--[[
function HumanBehaviors.LookForTargets(AI, Owner)
function HumanBehaviors.CheckEnemyLOS(AI, Owner)
function HumanBehaviors.CalculateThreatLevel(MO, Owner)
function HumanBehaviors.ProcessAlarmEvent(AI, Owner)
function HumanBehaviors.GetGrenadeAngle(AimPoint, TargetVel, StartPos, muzVel)
function HumanBehaviors.EquipPrimaryWeapon(AI, Owner)
function HumanBehaviors.Sentry(AI, Owner)
function HumanBehaviors.Patrol(AI, Owner)
function HumanBehaviors.GoldDig(AI, Owner)	
function HumanBehaviors.BrainSearch(AI, Owner)
function HumanBehaviors.WeaponSearch(AI, Owner)
function HumanBehaviors.ToolSearch(AI, Owner)
function HumanBehaviors.GoToWpt(AI, Owner)
function HumanBehaviors.GoProne(AI, Owner, TargetPos, targetID)
function HumanBehaviors.GetProjectileData(Owner)
function HumanBehaviors.ShootTarget(AI, Owner)
function HumanBehaviors.ThrowTarget(AI, Owner)
function HumanBehaviors.AttackTarget(AI, Owner)
function HumanBehaviors.MoveAroundActor(AI, Owner)
function HumanBehaviors.GetAngleToHit(PrjDat, Dist)
function HumanBehaviors.ShootArea(AI, Owner)
function HumanBehaviors.FaceAlarm(AI, Owner) ]]--

--print ("Custom AI")

-- Change human behaviors anyway
-- Save original human behaviors once
if Original_HumanBehaviors == nil then
	Original_HumanBehaviors = HumanBehaviors
end

Custom_HumanBehaviors = {}

Custom_HumanBehaviors.LookForTargets = HumanBehaviors.LookForTargets
Custom_HumanBehaviors.CheckEnemyLOS = HumanBehaviors.CheckEnemyLOS
Custom_HumanBehaviors.CalculateThreatLevel = HumanBehaviors.CalculateThreatLevel
Custom_HumanBehaviors.ProcessAlarmEvent = HumanBehaviors.ProcessAlarmEvent
Custom_HumanBehaviors.GetGrenadeAngle = HumanBehaviors.GetGrenadeAngle
Custom_HumanBehaviors.EquipPrimaryWeapon = HumanBehaviors.EquipPrimaryWeapon
Custom_HumanBehaviors.Sentry = HumanBehaviors.Sentry
Custom_HumanBehaviors.Patrol = HumanBehaviors.Patrol
Custom_HumanBehaviors.GoldDig = HumanBehaviors.GoldDig
Custom_HumanBehaviors.BrainSearch = HumanBehaviors.BrainSearch
Custom_HumanBehaviors.WeaponSearch = HumanBehaviors.WeaponSearch
Custom_HumanBehaviors.ToolSearch = HumanBehaviors.ToolSearch
Custom_HumanBehaviors.GoToWpt = HumanBehaviors.GoToWpt
Custom_HumanBehaviors.GoProne = HumanBehaviors.GoProne
Custom_HumanBehaviors.GetProjectileData = HumanBehaviors.GetProjectileData
Custom_HumanBehaviors.ShootTarget = HumanBehaviors.ShootTarget
Custom_HumanBehaviors.ThrowTarget = HumanBehaviors.ThrowTarget
Custom_HumanBehaviors.AttackTarget = HumanBehaviors.AttackTarget
Custom_HumanBehaviors.MoveAroundActor = HumanBehaviors.MoveAroundActor
Custom_HumanBehaviors.GetAngleToHit = HumanBehaviors.GetAngleToHit
Custom_HumanBehaviors.ShootArea = HumanBehaviors.ShootArea
Custom_HumanBehaviors.FaceAlarm = HumanBehaviors.FaceAlarm

HumanBehaviors = Custom_HumanBehaviors

function RevealUnseenWhenShooting(Owner)
	if CF_FogOfWarEnabled then
		--print ("Fire")
		for x = -2, 2 do
			for y = -2, 2 do
				SceneMan:RevealUnseen(Owner.Pos.X - x * CF_FogOfWarResolution, Owner.Pos.Y - y * CF_FogOfWarResolution, CF_PlayerTeam)
			end
		end
	end
end

function HumanBehaviors.LookForTargets(AI, Owner)
	local Origin
	local viewAng
	
	if AI.Target then	-- widen the view angle to increase the chance of spotting new targets
		Origin = Owner.EyePos
		viewAng = 0.7
	elseif AI.deviceState == AHuman.AIMING then
		if Owner.EquippedItem then
			Origin = Owner.EquippedItem.Pos
		else
			Origin = Owner.EyePos
		end
		
		viewAng = 0.3
	elseif AI.deviceState == AHuman.POINTING then
		Origin = Owner.EyePos
		viewAng = 0.5
	elseif AI.deviceState == AHuman.THROWING then
		Origin = Owner.EyePos
		viewAng = 0.7
	else
		Origin = Owner.EyePos
		viewAng = RangeRand(0.5, 1.4)
	end
	
	local viewLen = SceneMan:ShortestDistance(Owner.EyePos, Owner.ViewPoint, false).Magnitude + FrameMan.PlayerScreenWidth * 0.45 --0.55 --WEEGEE
	local Trace = Vector(viewLen, 0):RadRotate(viewAng*NormalRand()+Owner:GetAimAngle(true))
	local ID = SceneMan:CastMORay(Origin, Trace, Owner.ID, Owner.IgnoresWhichTeam, rte.grassID, false, 5)
  
	if ID < rte.NoMOID then
		local HitPoint = SceneMan:GetLastRayHitPos()
		if not AI.isPlayerOwned or not SceneMan:IsUnseen(HitPoint.X, HitPoint.Y, Owner.Team) then	-- AI-teams ignore the fog
			local MO = MovableMan:GetMOFromID(ID)
			if MO and ID ~= MO.RootID then
				MO = MovableMan:GetMOFromID(MO.RootID)
			end
			
			return MO, HitPoint
		end
	end
end


-- in sentry behavior the agent only looks for new enemies, it sometimes sharp aims to increse spotting range
function HumanBehaviors.Sentry(AI, Owner)
	--print ("Sentry")

	local sweepUp = true
	local sweepDone = false
	local maxAng = 1.4
	local minAng = -1.4
	local aim
	
	if HumanBehaviors.EquipPrimaryWeapon(AI, Owner) then
		local EquipTimer = Timer()
		while true do
			if EquipTimer:IsPastSimMS(500) then
				if not HumanBehaviors.EquipPrimaryWeapon(AI, Owner) then
					break -- our current weapon is either a primary, we have no primary or we have no weapon
				end
			end
			
			coroutine.yield()
		end
	end
	
	if AI.OldTargetPos then	-- try to reaquire an old target
		local Dist = SceneMan:ShortestDistance(Owner.EyePos, AI.OldTargetPos, false)
		AI.OldTargetPos = nil
		if (Dist.X < 0 and Owner.HFlipped) or (Dist.X > 0 and not Owner.HFlipped) then	-- we are facing the target	
			AI.deviceState = AHuman.AIMING
			AI.Ctrl.AnalogAim = Dist.Normalized
			
			for _ = 1, math.random(20, 30) do
				coroutine.yield()	-- aim here for ~0.25s
			end
		end
	elseif not AI.isPlayerOwned then -- face the most likely enemy approach direction
		for _ = 1, math.random(5) do	-- wait for a while
			coroutine.yield()
		end
		
		Owner:AddAISceneWaypoint(Vector(Owner.Pos.X, 0))
		Owner:UpdateMovePath()
		coroutine.yield()	-- wait until next frame
		
		-- face the direction of the first waypoint
		for WptPos in Owner.MovePath do
			local Dist = SceneMan:ShortestDistance(Owner.Pos, WptPos, false)
			if Dist.X > 5 then
				AI.SentryFacing = false
				AI.Ctrl.AnalogAim = Dist.Normalized
			elseif Dist.X < -5 then
				AI.SentryFacing = true
				AI.Ctrl.AnalogAim = Dist.Normalized
			end
			
			break
		end
	end
	
	while true do	-- start by looking forward
		aim = Owner:GetAimAngle(false)
		
		if sweepUp then
			if aim < maxAng/3 then
				AI.Ctrl:SetState(Controller.AIM_UP, false)
				coroutine.yield()	-- wait until next frame
				AI.Ctrl:SetState(Controller.AIM_UP, true)
			else
				sweepUp = false
			end
		else
			if aim > minAng/3 then
				AI.Ctrl:SetState(Controller.AIM_DOWN, false)
				coroutine.yield()	-- wait until next frame
				AI.Ctrl:SetState(Controller.AIM_DOWN, true)
			else
				sweepUp = true
				if sweepDone then
					break
				else
					sweepDone = true
				end
			end
		end
		
		coroutine.yield()	-- wait until next frame
	end
	
	if Owner.HFlipped ~= AI.SentryFacing then
		Owner.HFlipped = AI.SentryFacing	-- turn to the direction we have been order to guard
		return true	-- restart this behavior
	end
	
	while true do	-- look down
		aim = Owner:GetAimAngle(false)
		if aim > minAng then
			AI.Ctrl:SetState(Controller.AIM_DOWN, true)
		else
			break
		end
		
		coroutine.yield()	-- wait until next frame
	end
	
	local Hit = Vector()
	local NoObstacle = {}
	local StartPos
	AI.deviceState = AHuman.AIMING
	
	while true do	-- scan the area for obstacles
		aim = Owner:GetAimAngle(false)
		if aim < maxAng then
			AI.Ctrl:SetState(Controller.AIM_UP, true)
		else
			break
		end
		
		if Owner:EquipFirearm(false) and Owner.EquippedItem then
			StartPos = ToHeldDevice(Owner.EquippedItem).MuzzlePos
		else
			StartPos = Owner.EyePos
		end
		
		-- save the angle to a table if there is no obstacle
		if not SceneMan:CastStrengthRay(StartPos, Vector(60, 0):RadRotate(Owner:GetAimAngle(true)), 5, Hit, 2, 0, true) then
			table.insert(NoObstacle, aim)	-- TODO: don't use a table for this
		end
		
		coroutine.yield()	-- wait until next frame
	end
	
	local SharpTimer = Timer()
	local aimTime = 2000
	local angDiff = 1
	AI.deviceState = AHuman.POINTING
	
	if #NoObstacle > 1 then	-- only aim where we know there are no obstacles, e.g. out of a gun port
		minAng = NoObstacle[1] * 0.95
		maxAng = NoObstacle[#NoObstacle] * 0.95
		angDiff = 1 / math.max(math.abs(maxAng - minAng), 0.1)	-- sharp aim longer from a small aiming window
	end
	
	while true do
		if not Owner:EquipFirearm(false) and not Owner:EquipThrowable(false) then
			break
		end
		
		aim = Owner:GetAimAngle(false)
		
		if sweepUp then
			if aim < maxAng then
				if aim < maxAng/5 and aim > minAng/5 and PosRand() > 0.3 then
					AI.Ctrl:SetState(Controller.AIM_UP, false)
				else
					AI.Ctrl:SetState(Controller.AIM_UP, true)
				end
			else
				sweepUp = false
			end
		else
			if aim > minAng then
				if aim < maxAng/5 and aim > minAng/5 and PosRand() > 0.3 then
					AI.Ctrl:SetState(Controller.AIM_DOWN, false)
				else
					AI.Ctrl:SetState(Controller.AIM_DOWN, true)
				end
			else
				sweepUp = true
			end
		end
		
		if SharpTimer:IsPastSimMS(aimTime) then
			SharpTimer:Reset()
			
			if HumanBehaviors.EquipPrimaryWeapon(AI, Owner) then
				aimTime = 850 --500 --WEEGEE
			elseif AI.deviceState == AHuman.AIMING then
				aimTime = RangeRand(1000, 3000)
				AI.deviceState = AHuman.POINTING
			else
				aimTime = RangeRand(6000, 12000) * angDiff
				AI.deviceState = AHuman.AIMING
			end
			
			if SceneMan:ShortestDistance(Owner.Pos, AI.SentryPos, false).Magnitude > Owner.Height*0.7 then
				AI.SentryPos = SceneMan:MovePointToGround(AI.SentryPos, Owner.Height*0.25, 2)
				Owner:ClearAIWaypoints()
				Owner:AddAISceneWaypoint(AI.SentryPos)
				AI:CreateGoToBehavior(Owner)	-- try to return to the sentry pos
				break
			elseif Owner.HFlipped ~= AI.SentryFacing then
				Owner.HFlipped = AI.SentryFacing	-- turn to the direction we have been order to guard
				break	-- restart this behavior
			end
		end
		
		coroutine.yield()	-- wait until next frame
	end
	
	return true
end


-- find the closest enemy brain
function HumanBehaviors.BrainSearch(AI, Owner)
	if HumanBehaviors.EquipPrimaryWeapon(AI, Owner) then
		local EquipTimer = Timer()
		while true do
			if EquipTimer:IsPastSimMS(500) then
				if not HumanBehaviors.EquipPrimaryWeapon(AI, Owner) then
					break -- our current weapon is either a primary, we have no primary or we have no weapon
				end
			end
			
			coroutine.yield()
		end
	end
	
	local Brains = {}
	for Act in MovableMan.Actors do
		if Act.Team ~= Owner.Team and Act:HasObjectInGroup("Brains") then
			table.insert(Brains, Act)
		end
	end
	
	if #Brains < 1 then	-- no bain actors found, check if some other actor is the brain
		local GmActiv = ActivityMan:GetActivity()
		for player = Activity.PLAYER_1, Activity.MAXPLAYERCOUNT - 1 do
			if GmActiv:PlayerActive(player) and GmActiv:GetTeamOfPlayer(player) ~= Owner.Team then
				local Act = GmActiv:GetPlayerBrain(player)
				if Act and MovableMan:IsActor(Act) then
					table.insert(Brains, Act)
				end
			end
		end
	end
	
	-- WEEGEE 
	-- If our brains are LZ actors from tactical mode
	-- use brain-hunt mode simply as search-and-destroy mode
	if #Brains > 0 and Owner.Team ~= CF_PlayerTeam then
		if Brains[1].PresetName == "LZ Control Panel" then
			Brains = {}
			
			for Act in MovableMan.Actors do
				if Act.Team ~= Owner.Team and Act.ClassName == "AHuman" then
					table.insert(Brains, Act)
				end
			end
		end
	end
	-- WEEGEE
	
	if #Brains > 0 then
		coroutine.yield()	-- wait until next frame
		
		if #Brains == 1 then
			if MovableMan:IsActor(Brains[1]) then
				Owner:ClearAIWaypoints()
				AI.FollowingActor = Brains[1]
				Owner:AddAIMOWaypoint(AI.FollowingActor)
				AI:CreateGoToBehavior(Owner)
			end
		else
			local ClosestBrain
			local minDist = math.huge
			for _, Act in pairs(Brains) do
				-- measure how easy the path to the destination is to traverse
				if MovableMan:IsActor(Act) then
					Owner:ClearAIWaypoints()
					Owner:AddAISceneWaypoint(Act.Pos)
					Owner:UpdateMovePath()
					
					local OldWpt, deltaY
					local index = 0
					local height = 0
					local pathLength = 0
					local pathObstMaxHeight = 0
					for Wpt in Owner.MovePath do
						pathLength = pathLength + 1
						Wpt = SceneMan:MovePointToGround(Wpt, 15, 6)
						
						if OldWpt then
							deltaY = OldWpt.Y - Wpt.Y
							if deltaY > 20 then	-- Wpt is more than n pixels above OldWpt in the scene
								if deltaY / math.abs(SceneMan:ShortestDistance(OldWpt, Wpt, false).X) > 1 then	-- the slope is more than 45 degrees
									height = height + (OldWpt.Y - Wpt.Y)
									pathObstMaxHeight = math.max(pathObstMaxHeight, height)
								else
									height = 0
								end
							else
								height = 0
							end
						end
						
						OldWpt = Wpt
						
						if index > 30 then
							index = 0
							coroutine.yield()	-- wait until the next frame
						else
							index = index + 1
						end
					end
					
					local score = pathLength * 0.55 + math.floor(pathObstMaxHeight/27) * 8
					if score < minDist then
						minDist = score
						ClosestBrain = Act
					end
					
					coroutine.yield()	-- wait until next frame
				end
			end
			
			Owner:ClearAIWaypoints()
			
			if MovableMan:IsActor(ClosestBrain) then
				AI.FollowingActor = ClosestBrain
				Owner:AddAIMOWaypoint(AI.FollowingActor)
				AI:CreateGoToBehavior(Owner)
			else
				return true	-- the brain we found died while we where searching, restart this behavior next frame
			end
		end
	else	-- no enemy brains left
		if AI.isPlayerOwned then
			Owner.AIMode = Actor.AIMODE_SENTRY
		else
			Owner.AIMode = Actor.AIMODE_PATROL
		end
	end
	
	return true
end

-- open fire on the selected target
function HumanBehaviors.ShootTarget(AI, Owner)
	--print ("ShootTarget")
	if not MovableMan:IsActor(AI.Target) then
		return true
	end
	
	AI.canHitTarget = false
	AI.TargetLostTimer:SetSimTimeLimitMS(700)
	
	local LOSTimer = Timer()
	LOSTimer:SetSimTimeLimitMS(170)
	
	local ShootTimer = Timer()
	local shootDelay = RangeRand(800, 1200)--RangeRand(400, 600) -- WEEGEE
	local AimPoint = AI.Target.Pos + AI.TargetOffset
	if not AI.flying and AI.Target.Vel.Largest < 4 and HumanBehaviors.GoProne(AI, Owner, AimPoint, AI.Target.ID) then
		shootDelay = shootDelay + 500 -- 250 -- WEEGEE
	end
	
	local PrjDat, OldWaypoint
	local openFire = 0
	local checkAim = true
	local canSwitchWeapon = Owner.InventorySize
	local TargetAvgVel = Vector(AI.Target.Vel.X, AI.Target.Vel.Y)
	local Dist = SceneMan:ShortestDistance(Owner.Pos, AimPoint, false)
	
	-- make sure we are facing the right direction
	if Owner.HFlipped then
		if Dist.X > 0 then
			Owner.HFlipped = false
		end
	elseif Dist.X < 0 then
		Owner.HFlipped = true
	end
	
	coroutine.yield()	-- wait until next frame
	
	local ErrorOffset = Vector(RangeRand(40, 80), 0):RadRotate(RangeRand(1, 6))
	if Dist.Largest < 150 then
		ErrorOffset = ErrorOffset * 0.5
	end
	
	local aimTarget = SceneMan:ShortestDistance(Owner.Pos, AimPoint+ErrorOffset, false).AbsRadAngle
	
	while true do
		if not AI.Target or AI.Target:IsDead() then
			AI.Target = nil
			
			-- the target is gone, try to find another right away
			local ClosestEnemy
			local best = math.huge
			for Act in MovableMan.Actors do
				if Act.Team ~= Owner.Team then
					local distance = SceneMan:ShortestDistance(Act.Pos, AimPoint, false).Largest
					if distance < best then
						best = distance
						ClosestEnemy = Act
					end
				end
			end
			
			if best < 200 then
				-- check if the target is inside our "screen"
				local ViewDist = SceneMan:ShortestDistance(Owner.ViewPoint, ClosestEnemy.Pos, false)
				if (math.abs(ViewDist.X) - ClosestEnemy.Radius < FrameMan.PlayerScreenWidth * 0.5) and
					(math.abs(ViewDist.Y) - ClosestEnemy.Radius < FrameMan.PlayerScreenHeight * 0.5)
				then
					if not AI.isPlayerOwned or not SceneMan:IsUnseen(ClosestEnemy.Pos.X, ClosestEnemy.Pos.Y, Owner.Team) then	-- AI-teams ignore the fog
						if SceneMan:CastStrengthSumRay(Owner.EyePos, ClosestEnemy.Pos, 6, rte.grassID) < 120 then
							AI.Target = ClosestEnemy
							AI.TargetOffset = Vector()
						end
					end
				end
			end
			
			-- no new target found
			if not AI.Target then
				if OldWaypoint then
					Owner:ClearAIWaypoints()
					Owner:AddAISceneWaypoint(OldWaypoint)
					AI:CreateGoToBehavior(Owner)
				end
				
				break
			end
		end
		
		if Owner.FirearmIsReady then
			-- it is now safe to get the ammo stats since FirearmIsReady
			local Weapon = ToHDFirearm(Owner.EquippedItem)
			if not PrjDat or PrjDat.MagazineName ~= Weapon.Magazine.PresetName then
				PrjDat = HumanBehaviors.GetProjectileData(Owner)
				
				-- uncomment these to get the range of the weapon
				--ConsoleMan:PrintString(Weapon.PresetName .. " range = " .. PrjDat.rng .. " px")
				--ConsoleMan:PrintString(AI.Target.PresetName .. " range = " .. SceneMan:ShortestDistance(Owner.Pos, AI.Target.Pos, false).Magnitude .. " px")
				
				-- Aim longer with lo-cap weapons
				if Weapon.Magazine.Capacity > -1 and Weapon.Magazine.Capacity < 7 and Dist.Largest > 150 then
					ErrorOffset = ErrorOffset * 0.6
					shootDelay = shootDelay + 750-- 500 -- WEEGEE
				end
			else
				TargetAvgVel = TargetAvgVel * 0.6 + AI.Target.Vel * 0.4	-- smooth the target's velocity
				AimPoint = AI.Target.Pos + AI.TargetOffset + ErrorOffset
				
				Dist = SceneMan:ShortestDistance(Weapon.Pos, AimPoint, false)
				local range = Dist.Magnitude
				
				-- move the aimpoint towards the center of the target at close ranges
				if range < 40 then
					AI.TargetOffset = AI.TargetOffset * 0.95
				end
				
				if checkAim then
					checkAim = false	-- only check every second frame
					
					if range < 100 then	-- within 5m
						-- it is not safe to fire an explosive projectile at this distance
						aimTarget = Dist.AbsRadAngle
						AI.canHitTarget = true
						if PrjDat.exp and Owner.InventorySize > 0 then	-- we have more things in the inventory
							if Owner:EquipDiggingTool(false) then
								AI:CreateHtHBehavior(Owner)
								break
							elseif canSwitchWeapon > 0 and Owner:HasObjectInGroup("Primary Weapons") or Owner:HasObjectInGroup("Secondary Weapons") then
								canSwitchWeapon = canSwitchWeapon - 1
								AI.Ctrl:SetState(Controller.WEAPON_CHANGE_NEXT, true)
								PrjDat = nil	-- get the ammo info from the new weapon the next update
								AI.canHitTarget = false
							end
						end
					elseif range < PrjDat.rng then
						-- lead the target if target speed and projectile TTT is above the threshold
						local timeToTarget = range / PrjDat.vel
						if timeToTarget * AI.Target.Vel.Magnitude > 2 then
							timeToTarget = timeToTarget * RangeRand(1.6, 2.2)	-- ~double this value since we only do this every second update
							Dist = SceneMan:ShortestDistance(Weapon.Pos, AimPoint+(Owner.Vel*0.5+AI.Target.Vel)*timeToTarget, false)
						end
						
						aimTarget = HumanBehaviors.GetAngleToHit(PrjDat, Dist)
						if aimTarget then
							AI.canHitTarget = true
						else
							AI.canHitTarget = false
							
							-- the target is too far away; switch weapon, move closer or run away
							if canSwitchWeapon > 0 and (Owner:HasObjectInGroup("Primary Weapons") or Owner:HasObjectInGroup("Secondary Weapons")) then
								canSwitchWeapon = canSwitchWeapon - 1
								AI.Ctrl:SetState(Controller.WEAPON_CHANGE_NEXT, true)
								PrjDat = nil	-- get the ammo info from the new weapon the next update
							elseif not AI.isPlayerOwned or Owner.AIMode ~= Actor.AIMODE_SENTRY then
								if not Owner.MOMoveTarget or 
									not MovableMan:ValidMO(Owner.MOMoveTarget) or
									Owner.MOMoveTarget.RootID ~= AI.Target.RootID
								then	-- move towards the target
									OldWaypoint = Owner:GetLastAIWaypoint()
									if (OldWaypoint-Owner.Pos).Largest < 1 then
										OldWaypoint = Vector(Owner.Pos.X, Owner.Pos.Y)	-- move back here later
									end
									
									Owner:ClearAIWaypoints()
									Owner:AddAIMOWaypoint(AI.Target)
									AI:CreateGoToBehavior(Owner)
									AI.proneState = AHuman.NOTPRONE
								end
							else
								-- TODO: run away or duck?
								break
							end
						end
					elseif not AI.isPlayerOwned or Owner.AIMode ~= Actor.AIMODE_SENTRY then	-- target out of reach; move towards it
						-- check if we are already moving towards an actor
						if not Owner.MOMoveTarget or 
							not MovableMan:ValidMO(Owner.MOMoveTarget) or
							Owner.MOMoveTarget.RootID ~= AI.Target.RootID
						then	-- move towards the target
							OldWaypoint = Owner:GetLastAIWaypoint()
							if (OldWaypoint-Owner.Pos).Largest < 1 then
								OldWaypoint = Vector(Owner.Pos.X, Owner.Pos.Y)	-- move back here later
							end
							
							Owner:ClearAIWaypoints()
							Owner:AddAIMOWaypoint(AI.Target)
							AI:CreateGoToBehavior(Owner)
							AI.proneState = AHuman.NOTPRONE
							AI.canHitTarget = false
						end
					end
				else
					checkAim = true
					
					-- periodically check that we have LOS to the target
					if LOSTimer:IsPastSimTimeLimit() then
						LOSTimer:Reset()
						local TargetPoint = AI.Target.Pos + AI.TargetOffset
						
						if (range < 30 + Weapon.SharpLength + FrameMan.PlayerScreenWidth*0.5) and
							(not AI.isPlayerOwned or not SceneMan:IsUnseen(TargetPoint.X, TargetPoint.Y, Owner.Team))
						then
							if PrjDat.pen then
								if SceneMan:CastStrengthSumRay(Weapon.Pos, TargetPoint, 6, rte.grassID) * 5 < PrjDat.pen then
									AI.TargetLostTimer:Reset()	-- we can shoot at the target
								end
							else
								if SceneMan:CastStrengthSumRay(Weapon.Pos, TargetPoint, 6, rte.grassID) < 120 then
									AI.TargetLostTimer:Reset()	-- we can shoot at the target
								end
							end
						end
					end
				end
				
				if AI.canHitTarget then
					AI.lateralMoveState = Actor.LAT_STILL
					if not AI.flying then
						AI.deviceState = AHuman.AIMING
					end
				end
				
				local aim = Owner:GetAimAngle(true)			
				if AI.flying then
					aimTarget = (aimTarget or aim) + RangeRand(-0.05, 0.05)
				else
					aimTarget = (aimTarget or aim) + math.min(math.max(RangeRand(-15, 15)/(range+50), -0.1), 0.1)
				end
				
				local angDiff = aim - aimTarget
				if angDiff > math.pi then
					angDiff = angDiff - math.pi*2
				elseif angDiff < -math.pi then
					angDiff = angDiff + math.pi*2
				end
				
				if PrjDat and ShootTimer:IsPastRealMS(shootDelay) then
					ErrorOffset = ErrorOffset * 0.97	-- reduce the aim point error
					AI.Ctrl.AnalogAim = Vector(1,0):RadRotate(aim-math.max(math.min(angDiff*0.1, 0.25), -0.25))
					
					if AI.canHitTarget and angDiff < 0.7 then 
						if Weapon.FullAuto then	-- open fire if our aim overlap the target
							if math.abs(angDiff) < math.tanh((2*AI.Target.Diameter)/(range+0.1)) then
								openFire = 5	-- don't stop shooting just because we lose the target for a few frames
							else
								openFire = openFire - 1
							end
						elseif not AI.fire then	-- open fire if our aim overlap the target
							if math.abs(angDiff) < math.tanh((1.5*AI.Target.Diameter)/(range+0.1)) then
								openFire = 1
							else
								openFire = 0
							end
						else
							openFire = openFire - 1	-- release the trigger if semi auto
						end
						
						-- check for obstacles if the ammo have a blast radius
						if openFire > 0 and PrjDat.exp then
							if SceneMan:CastObstacleRay(Weapon.MuzzlePos, Weapon:RotateOffset(Vector(40, 0)), Vector(), Vector(), Owner.ID, Owner.IgnoresWhichTeam, rte.grassID, 2) > -1 then
								openFire = 0
							end
						end
					else
						openFire = openFire - 1
					end
				else
					ErrorOffset = ErrorOffset * 0.985	-- reduce the aim point error
					AI.Ctrl.AnalogAim = Vector(1,0):RadRotate(aim-math.max(math.min(angDiff*0.065, 0.07), -0.07) + RangeRand(-0.04, 0.04))
					openFire = 0
				end
				
				if openFire > 0 then
					AI.fire = true
					-- WEEGEE
					RevealUnseenWhenShooting(Owner)
					-- WEEGEE
				else
					AI.fire = false
				end
			end
		else
			if Owner.EquippedItem and ToHeldDevice(Owner.EquippedItem):IsReloading() then
				ShootTimer:Reset()
				AI.Ctrl.AnalogAim = SceneMan:ShortestDistance(Owner.Pos, AI.Target.Pos, false)
			elseif Owner:EquipFirearm(true) then
				shootDelay = RangeRand(300, 400)
				AI.deviceState = AHuman.POINTING
				AI.fire = false
				
				if Owner.FirearmIsEmpty then
					Owner:ReloadFirearm()
					-- TODO: check if ducking is appropriate while reloading (when we can make the actor stand up reliably)
				end
			else
				AI:CreateGetWeaponBehavior(Owner)
				break -- no firearm avaliable
			end
		end
		
		-- make sure we are facing the right direction
		if Owner.HFlipped then
			if Dist.X > 0 then
				Owner.HFlipped = false
			end
		elseif Dist.X < 0 then
			Owner.HFlipped = true
		end
		
		coroutine.yield()	-- wait until next frame
	end
	
	return true
end

-- open fire on the area around the selected target
function HumanBehaviors.ShootArea(AI, Owner)
	if not MovableMan:IsActor(AI.UnseenTarget) or not Owner.FirearmIsReady then
		return true
	end
	
	--WEEGEE
	-- Don't area-shoot distant targets
	if MovableMan:IsActor(AI.UnseenTarget) then
		if SceneMan:ShortestDistance(Owner.Pos, AI.UnseenTarget.Pos, true).Magnitude > FrameMan.PlayerScreenWidth * 0.95 then
			return true
		end
	end
	--WEEGEE
	
	-- see if we can shoot from the prone position
	local ShootTimer = Timer()
	local aimTime = RangeRand(100, 300)
	if not AI.flying and AI.UnseenTarget.Vel.Largest < 12 and HumanBehaviors.GoProne(AI, Owner, AI.UnseenTarget.Pos, AI.UnseenTarget.ID) then
		aimTime = aimTime + 500
	end
	
	local StartPos = Vector(AI.UnseenTarget.Pos.X, AI.UnseenTarget.Pos.Y)
	
	-- aim at the target in case we can see it when sharp aiming
	Owner:SetAimAngle(SceneMan:ShortestDistance(Owner.EyePos, StartPos, false).AbsRadAngle)
	AI.deviceState = AHuman.AIMING
	
	-- aim for ~160ms
	for _ = 1, 10 do
		coroutine.yield()	-- wait until next frame
	end
	
	if not Owner.FirearmIsReady then
		return true
	end
	
	local AimPoint
	for _ = 1, 5 do	-- try up to five times to find a target area that is resonably close to the target
		AimPoint = StartPos + Vector(RangeRand(-100, 100), RangeRand(-100, 50))
		if AimPoint.X > SceneMan.SceneWidth then
			AimPoint.X = SceneMan.SceneWidth - AimPoint.X
		elseif AimPoint.X < 0 then
			AimPoint.X = AimPoint.X + SceneMan.SceneWidth
		end
		
		-- check if we can fire at the AimPoint
		local Trace = SceneMan:ShortestDistance(Owner.EyePos, AimPoint, false)
		local rayLenght = SceneMan:CastObstacleRay(Owner.EyePos, Trace, Vector(), Vector(), rte.NoMOID, Owner.IgnoresWhichTeam, rte.grassID, 11)
		if Trace.Magnitude * 0.67 < rayLenght then
			break	-- the AimPoint is close enough to the target, start shooting
		end
		
		coroutine.yield()	-- wait until next frame
	end
	
	if not Owner.FirearmIsReady then
		return true
	end
	
	local aim
	local PrjDat = HumanBehaviors.GetProjectileData(Owner)
	local Dist = SceneMan:ShortestDistance(Owner.EquippedItem.Pos, AimPoint, false)
	if Dist.Magnitude < PrjDat.rng then
		aim = HumanBehaviors.GetAngleToHit(PrjDat, Dist)
	else
		return true	-- target out of range
	end
	
	local CheckTargetTimer = Timer()
	local aimError = RangeRand(-0.25, 0.25)
	
	while aim do
		if Owner.FirearmIsReady then
			AI.deviceState = AHuman.AIMING
			AI.Ctrl.AnalogAim = Vector(1,0):RadRotate(aim+aimError+RangeRand(-0.02, 0.02))
			
			if ShootTimer:IsPastSimMS(aimTime) then
				AI.fire = true
				-- WEEGEE
				RevealUnseenWhenShooting(Owner)
				-- WEEGEE
				
				aimError = aimError * 0.985
			else
				AI.fire = false
			end
		else
			AI.deviceState = AHuman.POINTING
			AI.fire = false
			
			ShootTimer:Reset()
			if Owner.FirearmIsEmpty then
				Owner:ReloadFirearm()
			end
			
			break -- stop this behavior when the mag is empty
		end
		
		coroutine.yield()	-- wait until next frame
		
		if AI.UnseenTarget and CheckTargetTimer:IsPastSimMS(400) then
			if MovableMan:IsActor(AI.UnseenTarget) and (AI.UnseenTarget.ClassName == "AHuman" or AI.UnseenTarget.ClassName == "ACrab") then
				CheckTargetTimer:Reset()
				if AI.UnseenTarget:GetController():IsState(Controller.WEAPON_FIRE) then
					-- compare the enemy aim angle with the angle of the alarm vector
					local enemyAim = AI.UnseenTarget:GetAimAngle(true)
					if enemyAim > math.pi*2 then	-- make sure the angle is in the [0..2*pi] range
						enemyAim = enemyAim - math.pi*2
					elseif enemyAim < 0 then
						enemyAim = enemyAim + math.pi*2
					end
					
					local angDiff = SceneMan:ShortestDistance(AI.UnseenTarget.Pos, Owner.Pos, false).AbsRadAngle - enemyAim
					if angDiff > math.pi then	-- the difference between two angles can never be larger than pi
						angDiff = angDiff - math.pi*2
					elseif angDiff < -math.pi then
						angDiff = angDiff + math.pi*2
					end
					
					if math.abs(angDiff) < 0.5 then
						-- this actor is shooting in our direction
						AimPoint = AI.UnseenTarget.Pos + SceneMan:ShortestDistance(AI.UnseenTarget.Pos, AimPoint, false) / 2 + Vector(RangeRand(-30, 30), RangeRand(-30, 30))
						aimError = RangeRand(-0.15, 0.15)
						
						Dist = SceneMan:ShortestDistance(Owner.EquippedItem.Pos, AimPoint, false)
						if Dist.Magnitude < PrjDat.rng then
							aim = HumanBehaviors.GetAngleToHit(PrjDat, Dist)
						end
					end
				end
			else
				AI.UnseenTarget = nil
			end
		end
	end
	
	return true
end



