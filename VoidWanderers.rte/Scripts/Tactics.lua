-----------------------------------------------------------------------------------------
-- Start Activity
-----------------------------------------------------------------------------------------
function VoidWanderers:StartActivity()
	print ("VoidWanderers:Tactics:StartActivity");
	
	-- Disable string rendering optimizations because letters start to fall down )))
	CF_FrameCounter = 0

	if self.IsInitialized == nil then
		self.IsInitialized = false
	end

	if self.IsInitialized then 
		return
	end

	self.IsInitialized = true
	
	self.GS = {};
	self.ModuleName = "VoidWanderers.rte";

	self.TickTimer = Timer();
	self.TickTimer:Reset();
	self.TickInterval = CF_TickInterval;
	
	
	self.TeleportEffectTimer = Timer()
	self.TeleportEffectTimer:Reset()
	
	-- Factions are already initialized by strategic part
	self:LoadCurrentGameState();

	self.GS["ActivityWasReset"] = "True"
	
	self.PlayerFaction = self.GS["Player0Faction"]

	-- Load level data
	self.LS = CF_ReadSceneConfigFile(self.ModuleName , SceneMan.Scene.PresetName..".dat");
	
	-- Read brain location data
	if self.GS["SceneType"] == "Vessel" then
		self.BrainPos = {}
		for i = 1, 4 do
			local x,y;
			
			x = tonumber(self.LS["BrainSpawn"..i.."X"])
			y = tonumber(self.LS["BrainSpawn"..i.."Y"])
			self.BrainPos[i] = Vector(x,y)
		end

		-- Create brains
		--print ("Create brains")
		for player = 0, self.PlayerCount - 1 do
			local a = CreateActor("Brain Case", "Base.rte")
			if a ~= nil then
				a.Team = CF_PlayerTeam;
				a.Pos = self.BrainPos[player+1];
				MovableMan:AddActor(a)
			end
		end
	end
	
	-- Load pre-spawned enemy locations. These locations also used during assaults to place teleported units
	self.EnemySpawn = {}
	for i = 1, 32 do
		local x,y;
		
		x = tonumber(self.LS["EnemySpawn"..i.."X"])
		y = tonumber(self.LS["EnemySpawn"..i.."Y"])
		if x ~= nil and y ~= nil then
			self.EnemySpawn[i] = Vector(x,y)
		else
			break
		end
	end
	
	self.GenericTimer = Timer();
	self.GenericTimer:Reset();


	self.AISpawnTimer = Timer();
	self.AISpawnTimer:Reset();
	
	self.IsInitialized = true
	
	self:SetTeamFunds(0 , 0);

	self.HumanPlayer = 0

	for player = 0, self.PlayerCount - 1 do
		self:SetPlayerBrain(nil, player);
	end	
	
	-- Income show counter
	self.LastIncome = 0
	
	self.LastIncomeShowTime = -1000
	self.LastIncomeShowInterval = 2	

	self:SaveCurrentGameState();
	
	-- Init consoles if in Vessel mode
	if self.GS["Mode"] == "Vessel" then
		self:InitConsoles()
	end

	self.AssaultTime = 0
	
	print ("VoidWanderers:Tactics:StartActivity - End");
end
-----------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------
function VoidWanderers:InitConsoles()
	self:InitShipControlPanelUI()
	self:InitStorageControlPanelUI()
	self:InitClonesControlPanelUI()
	self:InitBeamControlPanelUI()
end
-----------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------
function VoidWanderers:PutGlow(preset, pos)
	local glow = CreateMOPixel(preset, self.ModuleName);
	if glow then
		glow.Pos = pos
		MovableMan:AddParticle(glow);	
	end
end
-----------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------
function VoidWanderers:PutGlowWithModule(preset, pos, module)
	local glow = CreateMOPixel(preset, module);
	if glow then
		glow.Pos = pos
		MovableMan:AddParticle(glow);	
	end
end
-----------------------------------------------------------------------------------------
-- Removes specified item from actor's inventory, returns number of removed items
-----------------------------------------------------------------------------------------
function VoidWanderers:RemoveInventoryItem(actor , itempreset)
	local count = 0;
	local toabort = 0
	
	if MovableMan:IsActor(actor) and actor.ClassName == "AHuman" then
		if actor:HasObject(itempreset) then
			local human = ToAHuman(actor);
		
			if human.EquippedItem ~= nil then
				if human.EquippedItem.PresetName == itempreset then
					human.EquippedItem.ToDelete = true;
					count = 1;
				end
			end

			if not actor:IsInventoryEmpty() then
				actor:AddInventoryItem(CreateTDExplosive("VoidWanderersInventoryMarker" , self.ModuleName));
				
				local enough = false;
				while not enough do
					local weap = actor:Inventory();
					
					if weap.PresetName == itempreset then
						weap = actor:SwapNextInventory(nil, true);
						count = count + 1;
					else
						if weap.PresetName == "VoidWanderersInventoryMarker" then
							enough = true;
							actor:SwapNextInventory(nil, true);
						else
							weap = actor:SwapNextInventory(weap, true);
						end
					end
					
					toabort = toabort + 1
					if toabort == 20 then
						enough = true;
					end
				end
			end
		end
	end
	
	-- print (tostring(count).." items removed")
	return count;
end
-----------------------------------------------------------------------------------------
-- Save fog of war
-----------------------------------------------------------------------------------------
function VoidWanderers:SaveFogOfWarState(config)
	-- Save fog of war status
	-- Since if we disable fog of war all map will be revealed we don't
	-- need to save fog of war state at all
	if CF_FogOfWarEnabled then
		local wx = SceneMan.Scene.Width / CF_FogOfWarResolution;
		local wy = SceneMan.Scene.Height / CF_FogOfWarResolution;
		local str = "";
		
		for y = 0, wy do
			str = "";
			for x = 0, wx do
				if SceneMan:IsUnseen(x * CF_FogOfWarResolution, y * CF_FogOfWarResolution, CF_PlayerTeam) then
					str = str.."0";
				else
					str = str.."1";
				end
			end
			
			config["Terr"..self.Target..self.FacilityString.."Fog"..tostring(y)] = str;
		end
	end
end
-----------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------
function VoidWanderers:TriggerShipAssault()
	if not CF_EnableAssaults then
		return
	end

	--TODO Check reputation and trigger assaults accordingly
	
	self.AssaultTime = self.Time + CF_ShipAssaultDelay
	self.AssaultEnemyPlayer = 1
	self.AssaultDifficulty = 1--math.random(CF_MaxDifficulty)
	self.AssaultEnemiesToSpawn = CF_AssaultDifficultyUnitCount[self.AssaultDifficulty]
	self.AssaultNextSpawnTime = self.AssaultTime + CF_AssaultDifficultySpawnInterval[self.AssaultDifficulty] + 1
	self.AssaultNextSpawnPos = self.EnemySpawn[math.random(#self.EnemySpawn)]	
	
	-- Create attacker's unit presets
	-- TODO Add actual tech levels depending on difficulty
	CF_CreateAIUnitPresets(self.GS, self.AssaultEnemyPlayer, CF_GetTechLevelFromDifficulty(self.GS, self.AssaultEnemyPlayer, self.AssaultDifficulty, CF_MaxDifficulty))	
	
	-- Remove some panel actors
	self.ShipControlPanelActor.ToDelete = true
	self.BeamControlPanelActor.ToDelete = true
end
-----------------------------------------------------------------------------------------
-- Pause Activity
-----------------------------------------------------------------------------------------
function VoidWanderers:PauseActivity(pause)
end
-----------------------------------------------------------------------------------------
-- End Activity
-----------------------------------------------------------------------------------------
function VoidWanderers:EndActivity()
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:LoadCurrentGameState()
	if CF_IsFileExists(self.ModuleName , STATE_CONFIG_FILE) then
		self.GS = CF_ReadConfigFile(self.ModuleName , STATE_CONFIG_FILE);
		
		self.Time = tonumber(self.GS["Time"])
	end
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:SaveCurrentGameState()
	self.GS["Time"] = tostring(self.Time)
	CF_WriteConfigFile(self.GS , self.ModuleName , STATE_CONFIG_FILE);
end
-----------------------------------------------------------------------------------------
-- Update Activity
-----------------------------------------------------------------------------------------
function VoidWanderers:UpdateActivity()
	-- Just check for intialization flags in update loop to avoid unnecessary function calls during all the mission
	if self.IsInitialized == nil then
		self.IsInitialized = false
	end
	
	if not self.IsInitialized then
		--Init mission if we're still not
		self:StartActivity()
	end

	self:ClearObjectivePoints();
	
	-- Clear player's money to avoid buying via Trade Star
	local gold2add = self:GetTeamFunds(CF_PlayerTeam);
	self:SetTeamFunds(0, CF_PlayerTeam);
	if gold2add ~= 0 then
		CF_SetPlayerGold(self.GS, self.HumanPlayer, CF_GetPlayerGold(self.GS, self.HumanPlayer) + gold2add);
		
		self.LastIncomeShowTime = self.Time
		self.LastPlayerIncome = gold2add;
	end
	
	-- Display player income for a short time
	if self.LastIncomeShowTime + self.LastIncomeShowInterval > self.Time then
		local curactor = self:GetControlledActor(CF_PlayerTeam);
		if MovableMan:IsActor(curactor) then
			local s = CF_GetPlayerGold(self.GS, self.HumanPlayer) .. " oz [+"..math.ceil(self.LastPlayerIncome).."]"
			local l = CF_GetStringPixelWidth(s)
			
			CF_DrawString(s, curactor.Pos + Vector(-l/2, -76), 200, 200)
		end
	end
	
	-- Process UI's and other vessel mode features
	if self.GS["Mode"] == "Vessel" then
		self:ProcessClonesControlPanelUI()
		self:ProcessStorageControlPanelUI()
		
		-- Show assault warning
		if self.AssaultTime > self.Time then
			FrameMan:ClearScreenText(0);
			FrameMan:SetScreenText(CF_GetPlayerFaction(self.GS, tonumber(self.AssaultEnemyPlayer)).." "..CF_AssaultDifficultyTexts[self.AssaultDifficulty].." approaching in T-"..self.AssaultTime - self.Time.."\nBATTLE STATIONS!", 0, 0, 1000, true);
		else
			-- Process some control panels only when ship is not boarded
			self:ProcessShipControlPanelUI()
			self:ProcessBeamControlPanelUI()
		end
		
		-- Launch defense activity
		if self.AssaultTime == self.Time then
			self.GS["Mode"] = "Assault"

			-- Remove control actors
			self.StorageControlPanelActor.ToDelete = true		
			self.ClonesControlPanelActor.ToDelete = true		
		end
	end
	
	-- Tick timer
	if self.TickTimer:IsPastSimMS(self.TickInterval) then
		self.Time = self.Time + 1
		self.TickTimer:Reset();
		
		-- Process enemy spawn during assaults
		if self.GS["Mode"] == "Assault" then
			-- Spawn enemies
			if self.AssaultNextSpawnTime == self.Time then
				print ("Spawn")
				self.AssaultNextSpawnTime = self.Time + CF_AssaultDifficultySpawnInterval[self.AssaultDifficulty]
				
				local cnt = math.random(CF_AssaultDifficultySpawnBurst[self.AssaultDifficulty])
				for j = 1, cnt do
					if self.AssaultEnemiesToSpawn > 0 then
						pos = self.AssaultNextSpawnPos
					
						local act = CF_SpawnAIUnit(self.GS, self.AssaultEnemyPlayer, CF_CPUTeam, pos, Actor.AIMODE_BRAINHUNT)
						
						if act then
							self.AssaultEnemiesToSpawn = self.AssaultEnemiesToSpawn - 1
							MovableMan:AddActor(act)
						end
					end
				end
				
				self.AssaultNextSpawnPos = self.EnemySpawn[math.random(#self.EnemySpawn)]
			end
		
			-- Check end of assault conditions
			if CF_CountActors(CF_CPUTeam) == 0 and self.AssaultEnemiesToSpawn == 0 then
				-- End of assault
				self.GS["Mode"] = "Vessel"
				
				-- Re-init consoles back
				self:InitConsoles()
			end
		end
	end
	
	if self.GS["Mode"] == "Assault" then
		-- Show enemies count
		if self.Time % 10 == 0 and self.AssaultEnemiesToSpawn > 0 then
			FrameMan:SetScreenText("Remaining assault bots: "..self.AssaultEnemiesToSpawn, 0, 0, 1500, true);
		end
		
		-- Create teleportation effect
		if self.AssaultEnemiesToSpawn > 0 and self.AssaultNextSpawnTime - self.Time < 6 then
			self:AddObjectivePoint("INTRUDER\nALERT", self.AssaultNextSpawnPos , CF_PlayerTeam, GameActivity.ARROWDOWN);
		
			if self.TeleportEffectTimer:IsPastSimMS(50) then
				-- Create particle
				local p = CreateMOSParticle("Tiny Blue Glow", self.ModuleName)
				p.Pos = self.AssaultNextSpawnPos + Vector(-20 + math.random(40), 30 - math.random(20))
				p.Vel = Vector(0,-2)
				MovableMan:AddParticle(p)
				self.TeleportEffectTimer:Reset()
			end
		end
	end
	
	self:DoBrainSelection()
	self:CheckWinningConditions();
	self:YSortObjectivePoints();
	--CF_ReturnOnMissionEnd();
	--]]--
	
end
-----------------------------------------------------------------------------------------
-- Brain selection and gameover conditions check
-----------------------------------------------------------------------------------------
function VoidWanderers:CheckWinningConditions()
	if self.ActivityState ~= Activity.OVER then
	end
end
-----------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------
function VoidWanderers:GetItemPrice(itmpreset, itmclass)
	local price = 0;

	for f = 1, #CF_Factions do
		local ff = CF_Factions[f]
		for i = 1, #CF_ItmNames[ff] do
			local class = CF_ItmClasses[ff][i]
			if class == nil then
				class = "HDFirearm"
			end

			if itmclass == class and itmpreset == CF_ItmPresets[ff][i] then
				return CF_ItmPrices[ff][i]
			end
		end
	end
	
	return price;
end
-----------------------------------------------------------------------------------------
-- Brain selection and gameover conditions check
-----------------------------------------------------------------------------------------
function VoidWanderers:DoBrainSelection()
	if self.ActivityState ~= Activity.OVER then
		for player = 0, self.PlayerCount - 1 do
			local team = self:GetTeamOfPlayer(player);
			local brain = self:GetPlayerBrain(player);

			if not brain or not MovableMan:IsActor(brain) or not brain:HasObjectInGroup("Brains") then
				if team == CF_PlayerTeam then
					self.PlayerBrainDead = true
				end

				self:SetPlayerBrain(nil, player);
				local newBrain = MovableMan:GetUnassignedBrain(team);
				if newBrain then
					self:SetPlayerBrain(newBrain, player);
					self:SwitchToActor(newBrain, player, team);
					
					if team == CF_PlayerTeam then
						self.PlayerBrainDead = false
					end
				end
			else
				self:SetObservationTarget(brain.Pos, player)
			end
		end
	end
end
-----------------------------------------------------------------------------------------
-- Thats all folks!!!
-----------------------------------------------------------------------------------------