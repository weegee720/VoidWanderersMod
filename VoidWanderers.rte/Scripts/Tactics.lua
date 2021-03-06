-----------------------------------------------------------------------------------------
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
	self.ShopsCreated = false
	
	self.LastMusicType = -1
	self.LastMusicTrack = -1
	
	self.GS = {};
	self.ModuleName = "VoidWanderers.rte";
	
	self.TickTimer = Timer();
	self.TickTimer:Reset();
	self.TickInterval = CF_TickInterval;
	
	self.TeleportEffectTimer = Timer()
	self.TeleportEffectTimer:Reset()

	self.HoldTimer = Timer()
	self.HoldTimer:Reset()	
	
	self.RandomEncounterDelayTimer = Timer()
	self.RandomEncounterDelayTimer:Reset()
	
	self.FlightTimer = Timer()
	self.FlightTimer:Reset()
	self.LastTrigger = 0

	-- All items in this queue will be removed
	self.ItemRemoveQueue = {}
	
	-- Factions are already initialized by strategic part
	self:LoadCurrentGameState();
	
	CF_GS = self.GS

	self.RandomEncounterID = nil
	
	self.PlayerFaction = self.GS["Player0Faction"]
	
	-- If activity was reset during mission switch back to mission mode
	if self.GS["WasReset"] == "True" then
		self.GS["Mode"] = "Vessel"
		self.GS["SceneType"] = "Vessel"
		self.GS["WasReset"] = nil
	end

	self.AlliedUnits = nil
	
	-- Read brain location data
	if self.GS["SceneType"] == "Vessel" then
		-- Load vessel level data
		self.LS = CF_ReadSceneConfigFile(self.ModuleName , SceneMan.Scene.PresetName.."_deploy.dat");

		self.BrainPos = {}
		for i = 1, 4 do
			local x,y;
			
			x = tonumber(self.LS["BrainSpawn"..i.."X"])
			y = tonumber(self.LS["BrainSpawn"..i.."Y"])
			self.BrainPos[i] = Vector(x,y)
		end

		self.EnginePos = {}
		for i = 1, 10 do
			local x,y;
			
			x = tonumber(self.LS["Engine"..i.."X"])
			y = tonumber(self.LS["Engine"..i.."Y"])
			if x ~= nil and y ~= nil then
				self.EnginePos[i] = Vector(x,y)
			else
				break
			end
		end

		self.AwayTeamPos = {}
		
		for i = 1, 16 do
			local x,y;
			
			x = tonumber(self.LS["AwayTeamSpawn"..i.."X"])
			y = tonumber(self.LS["AwayTeamSpawn"..i.."Y"])
			
			if x ~= nil and y ~= nil then
				self.AwayTeamPos[i] = Vector(x,y)
			else
				break
			end
		end
		
		self.CreatedBrains = {}
		
		-- Create brains
		--print ("Create brains")
		for player = 0, self.PlayerCount - 1 do
			if self.GS["Brain"..player.."Detached"] ~= "True" then
				local a = CreateActor("Brain Case", "Base.rte")
				if a ~= nil then
					a.Team = CF_PlayerTeam;
					a.Pos = self.BrainPos[player + 1];
					MovableMan:AddActor(a)
					self.CreatedBrains[player] = a
				end
			end
		end
		
		self.Ship = SceneMan.Scene:GetArea("Vessel")
		
		local spawnedactors = 1
		local dest = 1

		-- Spawn previously saved actors
		for i = 1, CF_MaxSavedActors do
			if self.GS["Actor"..i.."Preset"] ~= nil then
				local actor = CF_MakeActor(self.GS["Actor"..i.."Preset"], self.GS["Actor"..i.."Class"], self.GS["Actor"..i.."Module"])
				if actor then
					actor.AIMode = Actor.AIMODE_SENTRY;
					actor:ClearAIWaypoints();
					
					local x = self.GS["Actor"..i.."X"]
					local y = self.GS["Actor"..i.."Y"]
					
					if x ~= nil and y ~= nil then
						actor.Pos = Vector(tonumber(x), tonumber(y))
					else
						actor.Pos = self.AwayTeamPos[dest]
						dest = dest + 1
						
						if dest > #self.AwayTeamPos then
							dest = 1
						end
					end
					actor.Team = CF_PlayerTeam
					for j = 1, CF_MaxSavedItemsPerActor do
						--print(self.GS["Actor"..i.."Item"..j.."Preset"])
						if self.GS["Actor"..i.."Item"..j.."Preset"] ~= nil then
							local itm = CF_MakeItem(self.GS["Actor"..i.."Item"..j.."Preset"], self.GS["Actor"..i.."Item"..j.."Class"], self.GS["Actor"..i.."Item"..j.."Module"])
							if itm then
								actor:AddInventoryItem(itm)
							end
						else
							break
						end
					end
					MovableMan:AddActor(actor)
					self:AddPreEquippedItemsToRemovalQueue(actor)

					spawnedactors = spawnedactors + 1
				end
			else
				break
			end
		end
		
		-- Spawn previously deployed actors
		if self.DeployedActors ~= nil then
			local dest = 1;
			
			-- Not only we need to spawn deployed actors but we also need to save them to config
			-- if we don't do that once player will restart the game after mission away-team actors will disappear
			for i = 1, #self.DeployedActors do
				local actor = CF_MakeActor(self.DeployedActors[i]["Preset"], self.DeployedActors[i]["Class"], self.DeployedActors[i]["Module"])
				if actor then
					actor.AIMode = Actor.AIMODE_SENTRY;
					actor:ClearAIWaypoints();
				
					actor.Pos = self.AwayTeamPos[dest]
					actor.Team = CF_PlayerTeam
					
					self.GS["Actor"..spawnedactors.."Preset"] = actor.PresetName
					self.GS["Actor"..spawnedactors.."Class"] = actor.ClassName
					self.GS["Actor"..spawnedactors.."Module"] = CF_GetModuleName(actor:GetModuleAndPresetName())
					self.GS["Actor"..spawnedactors.."X"] = math.ceil(actor.Pos.X)
					self.GS["Actor"..spawnedactors.."Y"] = math.ceil(actor.Pos.Y)
					
					--print (#self.DeployedActors[i]["InventoryPresets"])
					
					for j = 1, #self.DeployedActors[i]["InventoryPresets"] do
						local itm = CF_MakeItem(self.DeployedActors[i]["InventoryPresets"][j], self.DeployedActors[i]["InventoryClasses"][j], self.DeployedActors[i]["InventoryModules"][j])
						if itm then
							actor:AddInventoryItem(itm)
							
							self.GS["Actor"..spawnedactors.."Item"..j.."Preset"] = self.DeployedActors[i]["InventoryPresets"][j]
							self.GS["Actor"..spawnedactors.."Item"..j.."Class"] = self.DeployedActors[i]["InventoryClasses"][j]
							self.GS["Actor"..spawnedactors.."Item"..j.."Module"] = self.DeployedActors[i]["InventoryModules"][j]
						end
					end
					MovableMan:AddActor(actor)
					self:AddPreEquippedItemsToRemovalQueue(actor)
					
					spawnedactors = spawnedactors + 1
				end
			
				dest = dest + 1
				if dest > #self.AwayTeamPos then
					dest = 1
				end
			end
		end
		
		-- If we'er on temp-location then cancel this location
		if CF_IsLocationHasAttribute(self.GS["Location"], CF_LocationAttributeTypes.TEMPLOCATION) then
			self.GS["Location"] = nil
		end
		
		self.DeployedActors = nil
		self:SaveCurrentGameState()
	else
		-- Load generic level data
		self.LS = CF_ReadSceneConfigFile(self.ModuleName , SceneMan.Scene.PresetName..".dat");
	end

	-- Spawn away-team objects
	if self.GS["Mode"] == "Mission" then
		self:StartMusic(CF_MusicTypes.MISSION_CALM)
	
		self.GS["WasReset"] = "True"
	
		-- All mission related final message will be accumulated in mission report list
		self.MissionDeployedTroops = #self.DeployedActors
		
		self.AlliedUnits = {}
	
		local scene = SceneMan.Scene.PresetName

		self.Pts =  CF_ReadPtsData(scene, self.LS)
		self.MissionDeploySet = CF_GetRandomMissionPointsSet(self.Pts, "Deploy")
		
		-- Remove non-CPU doors
		if CF_LocationRemoveDoors[self.GS["Location"]] ~= nil and CF_LocationRemoveDoors[self.GS["Location"]] == true then
			for actor in MovableMan.Actors do
				if actor.ClassName == "ADoor" then
					actor.Team = CF_CPUTeam
				end
			end
		end
	
		-- Find suitable LZ's
		local lzs = CF_GetPointsArray(self.Pts, "Deploy", self.MissionDeploySet, "PlayerLZ")
		self.LZControlPanelPos  = CF_SelectRandomPoints(lzs, self.PlayerCount)
		
		-- Init LZ's
		self:InitLZControlPanelUI()
		
		local dest = 1;
		local dsts = CF_GetPointsArray(self.Pts, "Deploy", self.MissionDeploySet, "PlayerUnit")
		
		-- Spawn player troops
		for i = 1, #self.DeployedActors do
			local actor = CF_MakeActor(self.DeployedActors[i]["Preset"], self.DeployedActors[i]["Class"], self.DeployedActors[i]["Module"])
			if actor then
				actor.Pos = dsts[dest]
				actor.Team = CF_PlayerTeam
				actor.AIMode = Actor.AIMODE_SENTRY
				actor:ClearAIWaypoints();
				for j = 1, #self.DeployedActors[i]["InventoryPresets"] do
					local itm = CF_MakeItem(self.DeployedActors[i]["InventoryPresets"][j], self.DeployedActors[i]["InventoryClasses"][j], self.DeployedActors[i]["InventoryModules"][j])
					if itm then
						actor:AddInventoryItem(itm)
					end
				end
				MovableMan:AddActor(actor)
				self:AddPreEquippedItemsToRemovalQueue(actor)
			end
		
			dest = dest + 1
			if dest > #dsts then
				dest = 1
			end
		end
		self.DeployedActors = nil
		
		-- Spawn crates
		local crts = CF_GetPointsArray(self.Pts, "Deploy", self.MissionDeploySet, "Crates")
		local amount = math.ceil(CF_CratesRate * #crts)
		--print ("Crates: "..amount)
		local crtspos = CF_SelectRandomPoints(crts, amount)
		
		for i = 1, #crtspos do
			local crt 
			if math.random() < CF_ActorCratesRate then
				crt = CreateMOSRotating("Crate", self.ModuleName)
			else
				crt = CreateMOSRotating("Case", self.ModuleName)
			end
			if crt then
				crt.Pos = crtspos[i]
				MovableMan:AddParticle(crt)
			end
		end
		
		--	Prepare for mission, load scripts
		self.MissionAvailable = false
		local missionscript
		local ambientscript
		
		self.MissionStatus = nil
		
		-- Set generic mission difficulty based on location security
		local diff = CF_GetLocationDifficulty(self.GS, self.GS["Location"])
		self.MissionDifficulty = diff		
		
		-- Find available mission
		for m = 1, CF_MaxMissions do
			if self.GS["Location"] == self.GS["Mission"..m.."Location"] then -- GAMEPLAY
				self.MissionAvailable = true
				
				self.MissionNumber = m
				self.MissionType = self.GS["Mission"..m.."Type"]
				self.MissionDifficulty = CF_GetFullMissionDifficulty(self.GS, self.GS["Location"], m)--tonumber(self.GS["Mission"..m.."Difficulty"])
				self.MissionSourcePlayer = tonumber(self.GS["Mission"..m.."SourcePlayer"])
				self.MissionTargetPlayer = tonumber(self.GS["Mission"..m.."TargetPlayer"])

				-- DEBUG
				--self.MissionDifficulty = CF_MaxDifficulty -- DEBUG
				--self.MissionType = "Assault" -- DEBUG
				--self.MissionType = "Assassinate" -- DEBUG
				--self.MissionType = "Dropships" -- DEBUG
				--self.MissionType = "Mine" -- DEBUG
				--self.MissionType = "Zombies" -- DEBUG
				--self.MissionType = "Defend" -- DEBUG
				--self.MissionType = "Destroy" -- DEBUG
				--self.MissionType = "Squad" -- DEBUG
				
				self.MissionScript = CF_MissionScript[ self.MissionType ]
				self.MissionGoldReward = CF_CalculateReward(CF_MissionGoldRewardPerDifficulty[ self.MissionType ] , self.MissionDifficulty)
				self.MissionReputationReward = CF_CalculateReward(CF_MissionReputationRewardPerDifficulty[ self.MissionType ] , self.MissionDifficulty)
				
				self.MissionStatus = "" -- Will be updated by mission script

				-- Create unit presets
				CF_CreateAIUnitPresets(self.GS, self.MissionSourcePlayer , CF_GetTechLevelFromDifficulty(self.GS, self.MissionSourcePlayer, self.MissionDifficulty, CF_MaxDifficulty))
				CF_CreateAIUnitPresets(self.GS, self.MissionTargetPlayer , CF_GetTechLevelFromDifficulty(self.GS, self.MissionTargetPlayer, self.MissionDifficulty, CF_MaxDifficulty))
				
				break
			end -- GAMEPLAY
		end
		
		if self.MissionAvailable then
			-- Increase location security every time mission started
			local sec = CF_GetLocationSecurity(self.GS, self.GS["Location"])
			sec = sec + CF_SecurityIncrementPerMission
			CF_SetLocationSecurity(self.GS, self.GS["Location"], sec)
		
			missionscript = self.MissionScript
			ambientscript = CF_LocationAmbientScript[ self.GS["Location"] ]
		else
			-- Slightly increase location security every time deplyment happens
			local sec = CF_GetLocationSecurity(self.GS, self.GS["Location"])
			sec = sec + CF_SecurityIncrementPerDeployment
			CF_SetLocationSecurity(self.GS, self.GS["Location"], sec)

			if CF_LocationScript[ self.GS["Location"] ] ~= nil then
				local r = math.random(#CF_LocationScript[ self.GS["Location"] ])
				missionscript = CF_LocationScript[ self.GS["Location"] ][r]
			end
			
			ambientscript = CF_LocationAmbientScript[ self.GS["Location"] ]
		end
		
		self.MissionReport = {}
		
		if missionscript == nil then
			missionscript = "VoidWanderers.rte/Scripts/Mission_Generic.lua"
		end
		
		if ambientscript == nil then
			ambientscript = "VoidWanderers.rte/Scripts/Ambient_Generic.lua"
		end
		
		self.MissionStartTime = tonumber(self.GS["Time"])
		self.MissionEndMusicPlayed = false
		
		self.SpawnTable = {}
		
		-- Clear previous script functions
		self.MissionCreate = nil
		self.MissionUpdate = nil
		self.MissionDestroy = nil

		self.AmbientCreate = nil
		self.AmbientUpdate = nil
		self.AmbientDestroy = nil
		
		dofile(missionscript)
		dofile(ambientscript)
		
		self:MissionCreate()
		self:AmbientCreate()
		
		-- Set unseen
		if self.GS["FogOfWar"] and self.GS["FogOfWar"] == "true" then
			SceneMan:MakeAllUnseen(Vector(CF_FogOfWarResolution, CF_FogOfWarResolution), CF_PlayerTeam);
			
			-- Reveal previously saved fog of war
			-- But do not reveal on vessel maps
			if not CF_IsLocationHasAttribute(self.GS["Location"], CF_LocationAttributeTypes.ALWAYSUNSEEN) then
				local wx = math.ceil(SceneMan.Scene.Width / CF_FogOfWarResolution);
				local wy = math.ceil(SceneMan.Scene.Height / CF_FogOfWarResolution);
				local str = "";
				
				for y = 0, wy do
					str = self.GS[self.GS["Location"].."-Fog"..tostring(y)];
					-- print (str);
					if str ~= nil then
						for x = 0, wx do
							-- print(string.sub(str, x + 1 , x + 1))
							if string.sub(str, x + 1, x + 1) == "1" then
								SceneMan:RevealUnseen(x * CF_FogOfWarResolution , y * CF_FogOfWarResolution , CF_PlayerTeam);
							end
						end
					end
				end
			end
		end
		
		-- Set unseen for AI (maybe some day it will matter ))))
		for p = 1, 3 do
			SceneMan:MakeAllUnseen(Vector(CF_FogOfWarResolution, CF_FogOfWarResolution), p);
		end
	else
		self:StartMusic(CF_MusicTypes.SHIP_CALM)
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
	if self.GS["Mode"] == "Vessel" and self.GS["SceneType"] == "Vessel" then
		self:InitConsoles()
	end

	self.AssaultTime = -100
	
	self.BrainSwitchTimer = Timer()
	self.BrainSwitchTimer:Reset()
	
	self:DoBrainSelection()
	self.EnableBrainSelection = true

	-- Init icon display data
	self.IconPresets = {}
	self.IconGroups = {}
	
	self.IconGroups[1] = {"Diggers"}
	self.IconGroups[2] = {"Sniper Weapons"}
	self.IconGroups[3] = {"Heavy Weapons", "Explosive Weapons"}
	
	self.IconPresets[1] = "Icon_Digger"
	self.IconPresets[2] = "Icon_Sniper"
	self.IconPresets[3] = "Icon_Heavy"
	
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
	self:InitTurretsControlPanelUI()
end
-----------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------
function VoidWanderers:DestroyConsoles()
	self:DestroyShipControlPanelUI()
	self:DestroyStorageControlPanelUI()
	self:DestroyClonesControlPanelUI()
	self:DestroyBeamControlPanelUI()
	
	self:DestroyItemShopControlPanelUI()
	self:DestroyCloneShopControlPanelUI()
	
	self:DestroyTurretsControlPanelUI()
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
function VoidWanderers:RemoveInventoryItem(actor , itempreset, maxcount)
	local count = 0;
	local toabort = 0
	
	--print ("Remove "..itempreset)
	
	if MovableMan:IsActor(actor) and actor.ClassName == "AHuman" then
		if actor:HasObject(itempreset) then
			local human = ToAHuman(actor);
		
			if human.EquippedItem ~= nil then
				if human.EquippedItem.PresetName == itempreset then
					human.EquippedItem.ToDelete = true;
					count = 1;
				end
			end
			
			human:UnequipBGArm()

			if not actor:IsInventoryEmpty() then
				actor:AddInventoryItem(CreateTDExplosive("VoidWanderersInventoryMarker" , self.ModuleName));
				
				local enough = false;
				while not enough do
					local weap = actor:Inventory();
					
					--print (weap.PresetName)
					
					if weap.PresetName == itempreset then
						if count < maxcount then
							weap = actor:SwapNextInventory(nil, true);
							count = count + 1;
						else
							weap = actor:SwapNextInventory(weap, true);
						end
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
	local tiles = 0
	local revealed = 0
	
	if config["FogOfWar"] and config["FogOfWar"] == "true" then
		local wx = SceneMan.Scene.Width / CF_FogOfWarResolution;
		local wy = SceneMan.Scene.Height / CF_FogOfWarResolution;
		local str = "";
		
		for y = 0, wy do
			str = "";
			for x = 0, wx do
				tiles = tiles + 1
				if SceneMan:IsUnseen(x * CF_FogOfWarResolution, y * CF_FogOfWarResolution, CF_PlayerTeam) then
					str = str.."0";
				else
					str = str.."1";
					revealed = revealed + 1
				end
			end
			
			config[self.GS["Location"].."-Fog"..tostring(y)] = str;
			config[self.GS["Location"].."-FogRevealPercentage"] = math.floor(revealed / tiles * 100);
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
	
	local toassault = false
	
	-- First select random assault player
	-- Select angry CPU's
	local angry = {}
	
	for i = 1, tonumber(self.GS["ActiveCPUs"]) do
		local rep = tonumber(self.GS["Player"..i.."Reputation"])
		if rep <= CF_ReputationHuntTreshold then
			angry[#angry + 1] = i
		end
	end
	
	
	if #angry > 0 then
		local rangedangry = {}
		-- Range angry CPU based on their 
		for i = 1, #angry do
			--print ("- "..CF_GetPlayerFaction(self.GS, angry[i]))
			local anger = math.floor(math.abs(tonumber(self.GS["Player"..angry[i].."Reputation"]) / CF_ReputationPerDifficulty))
			
			if anger <= 0 then
				anger = 1
			end
			
			if anger > CF_MaxDifficulty then
				anger = CF_MaxDifficulty
			end			
			
			for j = 1, anger do
				rangedangry[#rangedangry + 1] = angry[i]
				--print (CF_GetPlayerFaction(self.GS, angry[i]))
			end
		end
		
		angry = rangedangry

		self.AssaultEnemyPlayer = angry[math.random(#angry)]
		
		local rep = tonumber(self.GS["Player"..self.AssaultEnemyPlayer.."Reputation"])
		
		self.AssaultDifficulty = math.floor(math.abs(rep / CF_ReputationPerDifficulty))
		
		if self.AssaultDifficulty <= 0 then
			self.AssaultDifficulty = 1
		end
		
		if self.AssaultDifficulty > CF_MaxDifficulty then
			self.AssaultDifficulty = CF_MaxDifficulty
		end
		
		local r = math.random(CF_MaxDifficulty * 45)
		local tgt = (self.AssaultDifficulty * 5) + 10
		
		print (CF_GetPlayerFaction(self.GS, self.AssaultEnemyPlayer).." D - "..self.AssaultDifficulty.." R - "..r.." TGT - "..tgt)
		
		if r < tgt then
			toassault = true
		end
	end
	
	--toassault = false -- DEBUG
	--toassault = true -- DEBUG

	if toassault then
		self.AssaultTime = self.Time + CF_ShipAssaultDelay
		self.AssaultEnemiesToSpawn = CF_AssaultDifficultyUnitCount[self.AssaultDifficulty]
		self.AssaultNextSpawnTime = self.AssaultTime + CF_AssaultDifficultySpawnInterval[self.AssaultDifficulty] + 1
		self.AssaultNextSpawnPos = self.EnemySpawn[math.random(#self.EnemySpawn)]	

		--self.AssaultEnemiesToSpawn = 1 -- DEBUG
		--self.AssaultTime = self.Time + 3 -- DEBUG

		-- Create attacker's unit presets
		CF_CreateAIUnitPresets(self.GS, self.AssaultEnemyPlayer, CF_GetTechLevelFromDifficulty(self.GS, self.AssaultEnemyPlayer, self.AssaultDifficulty, CF_MaxDifficulty))	
		
		-- Remove some panel actors
		self.ShipControlPanelActor.ToDelete = true
		self.BeamControlPanelActor.ToDelete = true
	else
		-- Trigger random encounter
		if math.random() < CF_RandomEncounterProbability and #CF_RandomEncounters > 0 then
			-- Find suitable random event
			local r 
			local id
			local found = false
			local brk = 1
			
			while not found do
				r = math.random(#CF_RandomEncounters)
				id = CF_RandomEncounters[r]
				
				if CF_RandomEncountersOneTime[id] == true then
					if self.GS["Encounter"..id.."Happened"] == nil then
						found = true
					end
				else
					found = true
				end
				
				brk = brk + 1
				if brk > 30 then
					--error("Endless loop in random encounter selector")
					break
				end
			end
			
			--id = "PIRATE_GENERIC" -- DEBUG
			--id = "ABANDONED_VESSEL_GENERIC"  -- DEBUG
			--id = "HOSTILE_DRONE" -- DEBUG
			--id = "REAVERS" -- DEBUG
			
			-- Launch encounter
			if found and id ~= nil then
				-- Increase probability of reavers a bit
				if CF_RandomEncounters["REAVERS"] ~= nil then
					if id ~= "REAVERS" then
						if math.random() < 0.2 then
							id = "REAVERS"
						end
					end
				end
			
				self.RandomEncounterID = id
				self.RandomEncounterVariant = 0
				
				self.RandomEncounterDelayTimer:Reset()
				
				self.RandomEncounterText = CF_RandomEncountersInitialTexts[id]
				self.RandomEncounterVariants = CF_RandomEncountersInitialVariants[id]
				self.RandomEncounterVariantsInterval = CF_RandomEncountersVariantsInterval[id]
				self.RandomEncounterChosenVariant = 0
				self.RandomEncounterIsInitialized = false
				self.ShipControlSelectedEncounterVariant = 1
				
				-- Switch to ship panel
				local bridgeempty = true
				local plrtoswitch = -1
				
				for plr = 0 , self.PlayerCount - 1 do
					local act = self:GetControlledActor(plr);
					
					if act ~= nil and MovableMan:IsActor(act) then
						if act.PresetName ~= "Ship Control Panel" and plrtoswitch == -1 then
							plrtoswitch = plr
						end
						
						if act.PresetName == "Ship Control Panel" then
							bridgeempty = false
						end
					end
				end
					
				if plrtoswitch > -1 and bridgeempty and MovableMan:IsActor(self.ShipControlPanelActor) then
					self:SwitchToActor(self.ShipControlPanelActor, plrtoswitch, CF_PlayerTeam);
				end
				self.ShipControlMode = self.ShipControlPanelModes.REPORT
				
				self:StartMusic(CF_MusicTypes.SHIP_INTENSE)
				--]]--
			end
		end
	end
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:SpawnFromTable()
	if #self.SpawnTable > 0 then
		if MovableMan:GetMOIDCount() < CF_MOIDLimit then
			local nm = self.SpawnTable[1]
		
			local act = CF_SpawnAIUnitWithPreset(self.GS, nm["Player"], nm["Team"], nm["Pos"], nm["AIMode"], nm["Preset"])
			if act then
				-- Give diggers of required
				if nm["Digger"] ~= nil and nm["Digger"] == true then
					local diggers = CF_MakeListOfMostPowerfulWeapons(self.GS, nm["Player"], CF_WeaponTypes.DIGGER, 10000)
					if diggers ~= nil then
						local r = math.random(#diggers)
						local itm = diggers[r]["Item"]
						local fct = diggers[r]["Faction"]
						
						local pre = CF_ItmPresets[fct][itm]
						local cls = CF_ItmClasses[fct][itm]
						local mdl = CF_ItmModules[fct][itm]
						
						local newitem = CF_MakeItem(pre, cls, mdl)
						if newitem then
							act:AddInventoryItem(newitem)
						end
					end
				end
			
				MovableMan:AddActor(act)
			end
			if nm["RenamePreset"] ~= nil then
				act.PresetName = nm["RenamePreset"]..act.PresetName
			end
			table.remove(self.SpawnTable, 1)
		else
			print ("MOID LIMIT REACHED!!!")
			self.SpawnTable = nil
		end
	else
		self.SpawnTable = nil
	end
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:ClearActors()
	for i = 1, CF_MaxSavedActors do
		self.GS["Actor"..i.."Preset"] = nil
		self.GS["Actor"..i.."Class"] = nil
		self.GS["Actor"..i.."Module"] = nil
		self.GS["Actor"..i.."X"] = nil
		self.GS["Actor"..i.."Y"] = nil
		
		for j = 1, CF_MaxSavedItemsPerActor do
			self.GS["Actor"..i.."Item"..j.."Preset"] = nil
			self.GS["Actor"..i.."Item"..j.."Class"] = nil
			self.GS["Actor"..i.."Item"..j.."Module"] = nil
		end
	end
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:SaveActors(clearpos)
	self:ClearActors()

	local savedactor = 1

	for actor in MovableMan.Actors do
		if actor.PresetName ~= "Brain Case" and (actor.ClassName == "AHuman" or actor.ClassName == "ACrab") then
			local pre, cls, mdl = CF_GetInventory(actor)
		
			-- Save actors to config
			self.GS["Actor"..savedactor.."Preset"] = actor.PresetName
			self.GS["Actor"..savedactor.."Class"] = actor.ClassName
			self.GS["Actor"..savedactor.."Module"] = CF_GetModuleName(actor:GetModuleAndPresetName())
			if clearpos then
				self.GS["Actor"..savedactor.."X"] = nil
				self.GS["Actor"..savedactor.."Y"] = nil
			else
				self.GS["Actor"..savedactor.."X"] = math.floor(actor.Pos.X)
				self.GS["Actor"..savedactor.."Y"] = math.floor(actor.Pos.Y)
			end
			
			for j = 1, #pre do
				self.GS["Actor"..savedactor.."Item"..j.."Preset"] = pre[j]
				self.GS["Actor"..savedactor.."Item"..j.."Class"] = cls[j]
				self.GS["Actor"..savedactor.."Item"..j.."Module"] = mdl[j]
			end

			savedactor = savedactor + 1
		end
	end
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
	
	--if true then
	--	return
	--end
	
	-- Clear player's money to avoid buying via Trade Star
	local gold2add = self:GetTeamFunds(CF_PlayerTeam);
	self:SetTeamFunds(0, CF_PlayerTeam);
	if gold2add ~= 0 then
		CF_SetPlayerGold(self.GS, CF_PlayerTeam, CF_GetPlayerGold(self.GS, CF_PlayerTeam) + gold2add);
		
		self.LastIncomeShowTime = self.Time
		self.LastPlayerIncome = gold2add;
	end
	
	-- Display player income for a short time
	if self.LastIncomeShowTime + self.LastIncomeShowInterval > self.Time then
		local curactor = self:GetControlledActor(CF_PlayerTeam);
		if MovableMan:IsActor(curactor) then
			local s = CF_GetPlayerGold(self.GS, self.HumanPlayer) .. " oz"-- [+"..math.ceil(self.LastPlayerIncome).."]"
			local l = CF_GetStringPixelWidth(s)
			
			CF_DrawString(s, curactor.Pos + Vector(-l/2, -80), 200, 200)
		end
	end

	-- Display icons
	if CF_EnableIcons then
		for actor in MovableMan.Actors do
			if actor.Team == CF_PlayerTeam then
				local icons = {}
				
				if self:IsAlly(actor) then
					icons[#icons + 1] = "Icon_Ally"
				end
				
				if actor:HasObject("Light Scanner") or actor:HasObject("Medium Scanner") or actor:HasObject("Heavy Scanner") then
					icons[#icons + 1] = "Icon_Scanner"
				end
			
				for i = 1, #self.IconPresets do
					for j = 1, #self.IconGroups[i] do
						if actor:HasObjectInGroup(self.IconGroups[i][j]) then
							icons[#icons + 1] = self.IconPresets[i]
							break
						end
					end
				end
				
				local l = #icons
				
				if l > 0 then
					for i = 1, l do
						local pos = actor.Pos + Vector( -(13 * l / 2) + ((i - 1) * 13) + 7, -67)
						
						self:PutGlow(icons[i], pos)
					end
				end
			end
		end
	end--]]--
	
	
	-- Process UI's and other vessel mode features
	if self.GS["Mode"] == "Vessel" then
		self:ProcessClonesControlPanelUI()
		self:ProcessStorageControlPanelUI()
		self:ProcessBrainControlPanelUI()
		self:ProcessTurretsControlPanelUI()
		
		-- Auto heal all actors when not in combat or random encounter
		if not self.OverCrowded then
			if self.RandomEncounterID == nil then
				for actor in MovableMan.Actors do
					if actor.Health > 0 and actor.Health < 100 and actor.Team == CF_PlayerTeam and self.Ship:IsInside(actor.Pos) then
						actor.Health = 100
					end
				end
			end
		else
			local count = CF_CountActors(CF_PlayerTeam) - tonumber(self.GS["Player0VesselLifeSupport"])
			local s = "BODIES"
			
			if count == 1 then
				s = "BODY"
			end
		
			FrameMan:ClearScreenText(0);
			FrameMan:SetScreenText("LIFE SUPPORT OVERLOADED\nSTORE OR DUMP "..CF_CountActors(CF_PlayerTeam) - tonumber(self.GS["Player0VesselLifeSupport"]) .." "..s, 0, 0, 1000, true);
		end
		
		-- Show assault warning
		if self.AssaultTime > self.Time then
			FrameMan:ClearScreenText(0);
			FrameMan:SetScreenText(CF_GetPlayerFaction(self.GS, tonumber(self.AssaultEnemyPlayer)).." "..CF_AssaultDifficultyTexts[self.AssaultDifficulty].." approaching in T-"..self.AssaultTime - self.Time.."\nBATTLE STATIONS!", 0, 0, 1000, true);
		else
			-- Process some control panels only when ship is not boarded
			self:ProcessShipControlPanelUI()
			self:ProcessBeamControlPanelUI()
			self:ProcessItemShopControlPanelUI()
			self:ProcessCloneShopControlPanelUI()
		end
		
		-- Launch defense activity
		if self.AssaultTime == self.Time then
			self.GS["Mode"] = "Assault"
			
			self:DeployTurrets()
			
			-- Remove control actors
			self:DestroyStorageControlPanelUI()
			self:DestroyClonesControlPanelUI()
			self:DestroyBeamControlPanelUI()
			self:DestroyItemShopControlPanelUI()
			self:DestroyCloneShopControlPanelUI()
			self:DestroyTurretsControlPanelUI()
			
			self:StartMusic(CF_MusicTypes.SHIP_INTENSE)
		end
		
		-- Process random encounter function
		if self.RandomEncounterID ~= nil then
			CF_RandomEncountersFunctions[self.RandomEncounterID](self, self.RandomEncounterChosenVariant)
			-- If incounter was finished then remove turrets
			if self.RandomEncounterID == nil then
				self:RemoveDeployedTurrets()
			end
		end
	end--]]--
	
	
	if self.GS["Mode"] == "Vessel" and self.FlightTimer:IsPastSimMS(CF_FlightTickInterval) then
		self.FlightTimer:Reset()
		-- Fly to new location
		if self.GS["Destination"] ~= nil and self.GS["Location"] == nil and self.Time > self.AssaultTime and self.RandomEncounterID == nil then
			-- Move ship
			local dx = tonumber(self.GS["DestX"])
			local dy = tonumber(self.GS["DestY"])
			
			local sx = tonumber(self.GS["ShipX"])
			local sy = tonumber(self.GS["ShipY"])
			
			local d = CF_Dist(Vector(sx,sy), Vector(dx,dy))
			
			if (d < 0.5) then
				self.GS["Location"] = self.GS["Destination"]
				self.GS["Destination"] = nil

				local locpos = CF_LocationPos[ self.GS["Location"] ]
				if locpos == nil then
					locpos = Vector(0,0)
				end
				
				self.GS["ShipX"] = locpos.X
				self.GS["ShipY"] = locpos.Y
				
				-- Delete emitters
				if self.EngineEmitters ~= nil then
					for i = 1, #self.EngineEmitters do
						self.EngineEmitters[i].ToDelete = true
					end
					self.EngineEmitters = nil
				end
			else
				self.GS["Distance"] = d
				
				local ax = (dx - sx) / d * (tonumber(self.GS["Player0VesselSpeed"]) / CF_KmPerPixel)
				local ay = (dy - sy) / d * (tonumber(self.GS["Player0VesselSpeed"]) / CF_KmPerPixel)
				
				sx = sx + ax
				sy = sy + ay
				
				self.GS["ShipX"] = sx
				self.GS["ShipY"] = sy
				
				
				self.LastTrigger = self.GS["DistanceTraveled"]
				
				if self.LastTrigger == nil then
					self.LastTrigger = 0
				else
					self.LastTrigger = tonumber(self.LastTrigger)
				end
				
				self.LastTrigger = self.LastTrigger + 1
				
				if self.LastTrigger > CF_DistanceToAttemptEvent then
					self.LastTrigger = 0
					self:TriggerShipAssault()
				end

				self.GS["DistanceTraveled"] = self.LastTrigger
				
				-- Create emitters if nessesary
				if self.EngineEmitters == nil then
					self.EngineEmitters = {}
					
					for i = 1, #self.EnginePos do
						local em = CreateAEmitter("Vessel Main Thruster")
						if em then
							em.Pos = self.EnginePos[i] + Vector(2,0)
							self.EngineEmitters[i] = em
 							MovableMan:AddParticle(em)
							em:EnableEmission(true)
						end
					end
				end
			end
		end
		
		-- Create or delete shops if we arrived/departed to/from Star base
		if CF_IsLocationHasAttribute(self.GS["Location"], CF_LocationAttributeTypes.TRADESTAR) or CF_IsLocationHasAttribute(self.GS["Location"], CF_LocationAttributeTypes.BLACKMARKET) then
			if not self.ShopsCreated then
				-- Destroy any previously created item shops and create a new one
				self:DestroyItemShopControlPanelUI()
				self:InitItemShopControlPanelUI()
				self:DestroyCloneShopControlPanelUI()
				self:InitCloneShopControlPanelUI()
				self.ShopsCreated = true
			end
		else
			if self.ShopsCreated then
				self:DestroyItemShopControlPanelUI()
				self:DestroyCloneShopControlPanelUI()
				self.ShopsCreated = false
			end
		end
	end--]]--

		
	-- Remove pre-eqipped items from inventories
	if #self.ItemRemoveQueue > 0 then
		for i = 1, #self.ItemRemoveQueue do
			if MovableMan:IsActor(self.ItemRemoveQueue[i]["Actor"]) then
				self:RemoveInventoryItem(self.ItemRemoveQueue[i]["Actor"], self.ItemRemoveQueue[i]["Preset"], 1)
				table.remove(self.ItemRemoveQueue, i)
				--print ("Removed")
				break;
			else
				table.remove(self.ItemRemoveQueue, i)
				break;
			end
		end		
	end--]]--
	
	-- Tick timer
	--if self.TickTimer:IsPastSimMS(self.TickInterval) then
	if self.TickTimer:IsPastRealMS(self.TickInterval) then
		self.Time = self.Time + 1
		self.TickTimer:Reset();

		-- Reputation erosion
		if self.Time % CF_ReputationErosionInterval	== 0 then
			for i = 1, tonumber(self.GS["ActiveCPUs"]) do
				local rep =  tonumber(self.GS["Player"..i.."Reputation"]) 
				
				if rep > 0 then 
					rep = rep - 1
				elseif rep < 0 then
					rep = rep + 1
				end
				
				self.GS["Player"..i.."Reputation"] = rep
			end
		end
		
		if self.AssaultTime > self.Time then
			if self.Time % 2 == 0 then
				self:MakeAlertSound()
			end
		end
		
		if self.GS["Mode"] == "Vessel" then
			local count = 0 
		
			-- Count actors except turrets
			for actor in MovableMan.Actors do
				if actor.Team == CF_PlayerTeam and (actor.ClassName == "AHuman" or actor.ClassName == "ACrab") and not actor:IsInGroup("Brains") then
					local isturret = false
				
					if self.TurretsDeployedActors ~= nil then
						local count = tonumber(self.GS["Player0VesselTurrets"])

						for turr = 1, count do
							if MovableMan:IsActor(self.TurretsDeployedActors[turr]) then
								if actor.ID == self.TurretsDeployedActors[turr].ID then
									isturret = true
								end
							end
						end
					end
					
					if not isturret then
						count = count + 1
					end
				end
			end
		
			if count > tonumber(self.GS["Player0VesselLifeSupport"]) then
				self.OverCrowded = true
				
				if self.Time % 3 == 0 then
					for actor in MovableMan.Actors do
						if (actor.ClassName == "AHuman" or actor.ClassName == "ACrab") and not actor:IsInGroup("Brains") then
							if actor:IsInGroup("Heavy Infantry") then
								actor.Health = actor.Health - math.random(2)
							else
								actor.Health = actor.Health - math.random(3)
							end
						end
					end
				end
				
				if self.Time % 2 == 0 then
					self:MakeAlertSound()
				end
			else
				self.OverCrowded = false
			end
			
			if self.RandomEncounterID ~= nil then
				if self.Time % 2 == 0 then
					self:MakeAlertSound()
				end
			end
			
			-- When on vessel always 
		end
		
		-- Kill all actors outside the ship
		if self.GS["SceneType"] == "Vessel" then
			for actor in MovableMan.Actors do
				if (actor.ClassName == "AHuman" or actor.ClassName == "ACrab") and not self.Ship:IsInside(actor.Pos) and not actor:IsInGroup("Brains") then
					if actor:IsInGroup("Heavy Infantry") then
						actor.Health = actor.Health - math.random(4)
					else
						actor.Health = actor.Health - math.random(8)
						if actor.Health < 20 then
							actor:GibThis()
						end
					end
				end
			end
		end
		
		-- Process enemy spawn during assaults
		if self.GS["Mode"] == "Assault" then
			if self.Time % 2 == 0 then
				self:MakeAlertSound()
			end
		
			-- Spawn enemies
			if self.AssaultNextSpawnTime == self.Time then
				-- Check end of assault conditions
				if CF_CountActors(CF_CPUTeam) == 0 and self.AssaultEnemiesToSpawn == 0 then
					-- End of assault
					self.GS["Mode"] = "Vessel"
					
					-- Give some exp
					if 	self.MissionReport == nil then
						self.MissionReport = {}
					end
					self.MissionReport[#self.MissionReport + 1] = "We survived this assault."
					self:GiveRandomExperienceReward(self.AssaultDifficulty)
					
					-- Remove turrets
					self:RemoveDeployedTurrets()

					-- Re-init consoles back
					self:InitConsoles()
					
					-- Launch ship assault encounter
					local id = "COUNTERATTACK"
					self.RandomEncounterID = id
					self.RandomEncounterVariant = 0
					
					self.RandomEncounterText = ""
					self.RandomEncounterVariants = {"Blood for Ba'al!!!", "Let them leave."}
					self.RandomEncounterVariantsInterval = 12
					self.RandomEncounterChosenVariant = 0
					self.RandomEncounterIsInitialized = false
					self.ShipControlSelectedEncounterVariant = 1
					
					-- Switch to ship panel
					local bridgeempty = true
					local plrtoswitch = -1
					
					for plr = 0 , self.PlayerCount - 1 do
						local act = self:GetControlledActor(plr);
						
						if act ~= nil and MovableMan:IsActor(act) then
							if act.PresetName ~= "Ship Control Panel" and plrtoswitch == -1 then
								plrtoswitch = plr
							end
							
							if act.PresetName == "Ship Control Panel" then
								bridgeempty = false
							end
						end
					end
						
					if plrtoswitch > -1 and bridgeempty and MovableMan:IsActor(self.ShipControlPanelActor) then
						self:SwitchToActor(self.ShipControlPanelActor, plrtoswitch, CF_PlayerTeam);
					end
					self.ShipControlMode = self.ShipControlPanelModes.REPORT					
				end

				--print ("Spawn")
				self.AssaultNextSpawnTime = self.Time + CF_AssaultDifficultySpawnInterval[self.AssaultDifficulty]
				
				local cnt = math.random(CF_AssaultDifficultySpawnBurst[self.AssaultDifficulty])
				for j = 1, cnt do
					if self.AssaultEnemiesToSpawn > 0 then
						pos = self.AssaultNextSpawnPos
					
						local act = CF_SpawnAIUnit(self.GS, self.AssaultEnemyPlayer, CF_CPUTeam, pos, Actor.AIMODE_BRAINHUNT)
						
						if act then
							self.AssaultEnemiesToSpawn = self.AssaultEnemiesToSpawn - 1
							MovableMan:AddActor(act)
							
							local fxb = CreateAEmitter("Teleporter Effect A");
							fxb.Pos = act.Pos;
							MovableMan:AddParticle(fxb);
							
							act:FlashWhite(1500);
						end
					end
				end
				
				self.AssaultNextSpawnPos = self.EnemySpawn[math.random(#self.EnemySpawn)]
			end
		end
	end
	
	if self.GS["Mode"] == "Assault" then
		-- Show enemies count
		if self.Time % 10 == 0 and self.AssaultEnemiesToSpawn > 0 then
			FrameMan:SetScreenText("Remaining assault bots: "..self.AssaultEnemiesToSpawn, 0, 0, 1500, true);
		end
		
		-- Create teleportation effect
		--print ("-")
		--print (AssaultEnemiesToSpawn)
		--print (self.AssaultNextSpawnTime)
		
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
	
	-- DEBUG
	-- Debug-print unit orders
	--local arr = {}
	--arr[Actor.AIMODE_BRAINHUNT] = "Brainhunt"
	--arr[Actor.AIMODE_SENTRY] = "Sentry"
	--arr[Actor.AIMODE_GOLDDIG] = "Gold dig"
	--arr[Actor.AIMODE_GOTO] = "Goto"
	--
	--for actor in MovableMan.Actors do
	--	if actor.ClassName == "AHuman" or actor.ClassName == "ACrab" then
	--		local s = arr[actor.AIMode]
	--		
	--		if s ~= nil then
	--			CF_DrawString(s, actor.Pos + Vector(-20,30), 100, 100)
	--		end
	--	end
	--end

	-- Deploy turrets when key pressed
	--if UInputMan:KeyPressed(75) then
	--	if self.TurretsDeployedActors == nil then
	--		self:DeployTurrets()
	--	else
	--		self:RemoveDeployedTurrets()
	--	end
	--end
	
	if self.GS["Mode"] == "Mission" then
		self:ProcessLZControlPanelUI()
		
		-- Spawn units from table while it have some left
		if self.SpawnTable ~= nil then
			self:SpawnFromTable()
		end
		
		if self.AmbientUpdate ~= nil then
			self:AmbientUpdate()
		end
		
		if self.MissionUpdate ~= nil then
			self:MissionUpdate()
		end
		
		-- Make actors glitch if there are too many of them
		local count = 0;
		local braincount = 0;
		for actor in MovableMan.Actors do
			if actor.Team == CF_PlayerTeam and (actor.ClassName == "AHuman" or actor.ClassName == "ACrab") then
				count = count + 1

				if self.Time % 4 == 0 and count > tonumber(self.GS["Player0VesselCommunication"]) and self.GS["BrainsOnMission"] ~= "True" then
					local cont = actor:GetController();
					if cont ~= nil then
						if cont:IsState(Controller.WEAPON_FIRE) then
							cont:SetState(Controller.WEAPON_FIRE, false)
						else
							cont:SetState(Controller.WEAPON_FIRE, true)
						end
					end
					
					self:AddObjectivePoint("CONNECTION LOST", actor.AboveHUDPos , CF_PlayerTeam, GameActivity.ARROWUP);
				end
				
				if actor:IsInGroup("Brains") then
					braincount  = braincount + 1
				end
			end
			
			-- Add allied units to array when they are actually spawned
			if actor.Team == CF_PlayerTeam and (actor.ClassName == "AHuman" or actor.ClassName == "ACrab") then
				if string.find(actor.PresetName , "-") == 1 then
					local nw = #self.AlliedUnits + 1
					self.AlliedUnits[nw] = actor
					actor.PresetName = string.sub(actor.PresetName , 2 , string.len(actor.PresetName))
				end
			end
		end
		
		-- Check loosing conditions
		if self.GS["BrainsOnMission"] ~= "False" and self.ActivityState ~= Activity.OVER then
			if braincount < self.PlayerCount and self.EnableBrainSelection and self.Time > self.MissionStartTime + 1 then
				self.WinnerTeam = CF_CPUTeam;
				ActivityMan:EndActivity();
				self:StartMusic(CF_MusicTypes.DEFEAT)
			end
		end
	end
	
	if self.EnableBrainSelection then
		self:DoBrainSelection()
	end
	self:CheckWinningConditions();
	self:YSortObjectivePoints();
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
					
					-- Looks like a brain actor can't become a brain actor if it can't hit MO's
					-- so we'll define LZ actors as hittable but then change this once our brains are assigned to cheat
					if newBrain.PresetName == "LZ Control Panel" then
						newBrain.HitsMOs = false
						newBrain.GetsHitByMOs = false
					end
					
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
--
-----------------------------------------------------------------------------------------
function VoidWanderers:DrawDottedLine(x1,y1,x2,y2,dot,interval)
	local d = CF_Dist(Vector(x1,y1), Vector(x2,y2))
		
	local ax = (x2 - x1) / d * interval
	local ay = (y2 - y1) / d * interval
	
	local x = x1
	local y = y1
	
	d = math.floor(d)
	
	for i = 1, d, interval do
		self:PutGlowWithModule(dot, Vector(x,y), self.ModuleName)
		
		x = x + ax
		y = y + ay
	end
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:DeployGenericMissionEnemies(setnumber, setname, plr, team, spawnrate)
	-- Define spawn queue
	local dq = {}
	-- Defenders aka turrets if any
	dq[1] = {}
	dq[1]["Preset"] = CF_PresetTypes.DEFENDER
	dq[1]["PointName"] = "Defender"
	
	-- Snipers
	dq[2] = {}
	dq[2]["Preset"] = CF_PresetTypes.SNIPER
	dq[2]["PointName"] = "Sniper"
	
	--Heavies
	dq[3] = {}
	if math.random(10) < 5 then
		dq[3]["Preset"] = CF_PresetTypes.HEAVY1
	else
		dq[3]["Preset"] = CF_PresetTypes.HEAVY2
	end
	dq[3]["PointName"] = "Heavy"
	
	--Shotguns
	dq[4] = {}
	dq[4]["Preset"] = CF_PresetTypes.SHOTGUN
	dq[4]["PointName"] = "Shotgun"
	
	-- Armored
	dq[5] = {}
	if math.random(10) < 5 then
		dq[5]["Preset"] = CF_PresetTypes.ARMOR1
	else
		dq[5]["Preset"] = CF_PresetTypes.ARMOR2
	end
	dq[5]["PointName"] = "Armor"

	-- Riflemen
	dq[6] = {}
	if math.random(10) < 5 then
		dq[6]["Preset"] = CF_PresetTypes.INFANTRY1
	else
		dq[6]["Preset"] = CF_PresetTypes.INFANTRY2
	end
	dq[6]["PointName"] = "Rifle"

	-- Random
	dq[7] = {}
	dq[7]["Preset"] = nil
	dq[7]["PointName"] = "Any"--]]--
	
	-- Spawn everything
	for d = 1, #dq do
		local fullenmpos = CF_GetPointsArray(self.Pts, setname, setnumber, dq[d]["PointName"])
		local count = math.floor(spawnrate * #fullenmpos)
		-- Guarantee that at least one unit is awlays spawned
		if count < 1 then
			count = 1
		end
		
		local enmpos = CF_SelectRandomPoints(fullenmpos, count)
		
		--print (dq[d]["PointName"].." - "..#enmpos.." / ".. #fullenmpos .." - "..spawnrate)
		
		for i = 1, #enmpos do
			local nw = {}
			if dq[d]["Preset"] == nil then
				nw["Preset"] = math.random(CF_PresetTypes.ARMOR2)
			else
				nw["Preset"] = dq[d]["Preset"]
			end
			nw["Team"] = team
			nw["Player"] = plr
			nw["AIMode"] = Actor.AIMODE_SENTRY
			nw["Pos"] = enmpos[i]
			
			-- If spawning as player's team then they are allies
			if team == CF_PlayerTeam then
				nw["RenamePreset"] = "-"
			end
			
			table.insert(self.SpawnTable, nw)
		end
	end
	
	-- Get LZs
	self.MissionLZs = CF_GetPointsArray(self.Pts, setname, setnumber, "LZ")
	
	-- Get base box
	local bp = CF_GetPointsArray(self.Pts, setname, setnumber, "Base")
	self.MissionBase = {}
	
	for i = 1, #bp, 2 do
		if bp[i + 1] == nil then
			print ("OUT OF BOUNDS WHEN BUILDING BASE BOX")
			break
		end
		
		-- Split the box if we're crossing the seam
		if bp[i].X > bp[i + 1].X then
			local nxt = #self.MissionBase + 1
			-- Box(x1,y1, x2, y2)
			self.MissionBase[nxt] = Box(bp[i].X, bp[i].Y, SceneMan.Scene.Width, bp[i + 1].Y)

			local nxt = #self.MissionBase + 1
			self.MissionBase[nxt] = Box(0, bp[i].Y, bp[i + 1].X, bp[i + 1].Y)
		else
			local nxt = #self.MissionBase + 1
			self.MissionBase[nxt] = Box(bp[i].X, bp[i].Y, bp[i + 1].X, bp[i + 1].Y)
		end
	end
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:GiveMissionRewards(disablepenalties)
	print ("MISSION COMPLETED")
	self.GS["Player"..self.MissionSourcePlayer.."Reputation"] = tonumber(self.GS["Player"..self.MissionSourcePlayer.."Reputation"]) + self.MissionReputationReward
	if not disablepenalties then
		self.GS["Player"..self.MissionTargetPlayer.."Reputation"] = tonumber(self.GS["Player"..self.MissionTargetPlayer.."Reputation"]) - math.ceil(self.MissionReputationReward * CF_ReputationPenaltyRatio)
	end
	CF_SetPlayerGold(self.GS, 0, CF_GetPlayerGold(self.GS, 0) + self.MissionGoldReward)
	
	self.MissionReport[#self.MissionReport + 1] = "MISSION COMPLETED"
	if self.MissionGoldReward > 0 then
		self.MissionReport[#self.MissionReport + 1] = tostring(self.MissionGoldReward).."oz of gold received"
	end
	
	local exppts = math.floor((self.MissionReputationReward + self.MissionGoldReward) / 8)
	
	local levelup = false;

	if self.GS["BrainsOnMission"] == "True" then
		levelup = CF_GiveExp(self.GS, exppts)
		
		self.MissionReport[#self.MissionReport + 1] = tostring(exppts).." exp received"
		if levelup then
			local s = ""
			if self.PlayerCount > 1 then
				s = "s"
			end
		
			self.MissionReport[#self.MissionReport + 1] = "Brain"..s.." leveled up!"
		end
	end
	
	if self.MissionReputationReward > 0 then
		self.MissionReport[#self.MissionReport + 1] = "+"..self.MissionReputationReward.." "..CF_FactionNames[ CF_GetPlayerFaction(self.GS, self.MissionSourcePlayer) ].." reputation"
		if not disablepenalties then
			self.MissionReport[#self.MissionReport + 1] = "-"..math.ceil(self.MissionReputationReward * CF_ReputationPenaltyRatio).." "..CF_FactionNames[ CF_GetPlayerFaction(self.GS, self.MissionTargetPlayer) ].." reputation"
		end
	end

	self.MissionFailed = false
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:GiveMissionPenalties()
	print ("MISSION FAILED")
	self.GS["Player"..self.MissionSourcePlayer.."Reputation"] = tonumber(self.GS["Player"..self.MissionSourcePlayer.."Reputation"]) - math.ceil(self.MissionReputationReward * CF_MissionFailedReputationPenaltyRatio)
	self.GS["Player"..self.MissionTargetPlayer.."Reputation"] = tonumber(self.GS["Player"..self.MissionTargetPlayer.."Reputation"]) - math.ceil(self.MissionReputationReward * CF_MissionFailedReputationPenaltyRatio)
	
	self.MissionReport[#self.MissionReport + 1] = "MISSION FAILED"
	
	if self.MissionReputationReward > 0 then
		self.MissionReport[#self.MissionReport + 1] = "-"..math.ceil(self.MissionReputationReward * CF_MissionFailedReputationPenaltyRatio).." "..CF_FactionNames[ CF_GetPlayerFaction(self.GS, self.MissionSourcePlayer) ].." reputation"
		self.MissionReport[#self.MissionReport + 1] = "-"..math.ceil(self.MissionReputationReward * CF_MissionFailedReputationPenaltyRatio).." "..CF_FactionNames[ CF_GetPlayerFaction(self.GS, self.MissionTargetPlayer) ].." reputation"
	end
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:IsAlly(actor)
	if self.AlliedUnits ~= nil then
		local l = #self.AlliedUnits
		for i = 1, l do
			if self.AlliedUnits[i] ~= nil and MovableMan:IsActor(self.AlliedUnits[i]) then
				if self.AlliedUnits[i].ID == actor.ID then
					return true
				end
			else
				self.AlliedUnits[i] = nil
			end
		end
	end
	return false
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:AddPreEquippedItemsToRemovalQueue(a)
	-- Mark actor's pre-equipped items for deletion
	if CF_ItemsToRemove[a.PresetName] then
		for i = 1, #CF_ItemsToRemove[a.PresetName] do
			local nw = #self.ItemRemoveQueue + 1
			self.ItemRemoveQueue[nw] = {}
			self.ItemRemoveQueue[nw]["Preset"] = CF_ItemsToRemove[a.PresetName][i]
			self.ItemRemoveQueue[nw]["Actor"] = a
		end
	end
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:InitExplorationPoints()
	local set = CF_GetRandomMissionPointsSet(self.Pts, "Exploration")

	local pts = CF_GetPointsArray(self.Pts, "Exploration", set, "Explore")
	self.MissionExplorationPoint = pts[math.random(#pts)]
	self.MissionExplorationRecovered = false
	
	self.MissionExplorationHologram = "Holo" .. math.random(CF_MaxHolograms)
	
	self.MissionExplorationText = {}
	self.MissionExplorationTextStart = -100
	
	--print (self.MissionExplorationPoint)
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:ProcessExplorationPoints()
	if self.MissionExplorationPoint ~= nil then
		if not self.MissionExplorationRecovered then
			if math.random(10) < 7 then
				self:PutGlow(self.MissionExplorationHologram, self.MissionExplorationPoint)
			end
			
			-- Send all units to brainhunt
			for actor in MovableMan.Actors do
				if actor.Team == CF_PlayerTeam and CF_Dist(actor.Pos, self.MissionExplorationPoint) < 25 then
					if actor:IsInGroup("Brains") then
						self.MissionExplorationText = self:GiveRandomExplorationReward()
						self.MissionExplorationRecovered = true
						--self.MissionExplorationPoint = nil
						
						self.MissionExplorationTextStart = self.Time
						
						for a in MovableMan.Actors do
							if a.Team ~= CF_PlayerTeam then
								a.AIMode = Actor.AIMODE_BRAINHUNT
							end
						end
						
						break
					else
						self:AddObjectivePoint("Only brain can decrypt this holorecord", self.MissionExplorationPoint + Vector(0,-30) , CF_PlayerTeam, GameActivity.ARROWDOWN);
					end
				end
			end
		end
	end
	
	if self.Time > self.MissionExplorationTextStart and self.Time < self.MissionExplorationTextStart + 10 then
		local txt = ""
		for i = 1, #self.MissionExplorationText do
			txt = self.MissionExplorationText[i] .."\n"
		end
		
		self:AddObjectivePoint(txt, self.MissionExplorationPoint + Vector(0,-30) , CF_PlayerTeam, GameActivity.ARROWDOWN);
	end
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:GiveRandomExplorationReward()
	local rewards = {gold = 1, experience = 2, reputation = 3, blueprints = 4, nothing = 5}
	local text = {"Nothing of value was found."}
	
	local r = math.random(rewards.nothing)
	
	if r == rewards.gold then
		local amount = math.floor(self.MissionDifficulty * 200 + math.random(self.MissionDifficulty * 500))
		
		CF_SetPlayerGold(self.GS, 0, CF_GetPlayerGold(self.GS, 0) + amount)
		text = {}
		text[1] = "Bank account access codes found."
		text[2] = tostring(amount).."oz of gold received."
	elseif r == rewards.experience then
		local exppts = math.floor(self.MissionDifficulty * 50 + math.random(self.MissionDifficulty * 100))
		levelup = CF_GiveExp(self.GS, exppts)
		
		text = {}
		text[1] = "Captain's log found. "..exppts.." exp gained."
		
		if levelup then
			local s = ""
			if self.PlayerCount > 1 then
				s = "s"
			end
		
			text[2] = "Brain"..s.." leveled up!"
		end
	elseif r == rewards.reputation then
		local amount = math.floor(self.MissionDifficulty * 25 + math.random(self.MissionDifficulty * 25))
		local plr = math.random(tonumber(self.GS["ActiveCPUs"]))
		
		local rep = tonumber(self.GS["Player"..plr.."Reputation"])
		self.GS["Player"..plr.."Reputation"] = rep + amount
		
		text = {}
		text[1] = "Intelligence data found."
		text[2] = "+"..amount.." "..CF_GetPlayerFaction(self.GS, plr).." reputation."
	elseif r == rewards.blueprints then
		local id = CF_UnlockRandomQuantumItem(self.GS)
		
		text = {CF_QuantumItmPresets[id].." quantum scheme found."}
	end
	
	if self.MissionReport == nil then
		self.MissionReport = {}
	end
	for i = 1, #text do
		self.MissionReport[#self.MissionReport + 1]	= text[i]
	end
	CF_SaveMissionReport(self.GS, self.MissionReport)
	
	return text;
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:GiveRandomExperienceReward(diff)
	local exppts = 150 + math.random(350)
	
	if diff ~= nil then
		exppts = CF_CalculateReward(diff , 250)
	end
	
	levelup = CF_GiveExp(self.GS, exppts)
	
	text = {}
	text[1] = tostring(exppts).." exp gained."
	
	if levelup then
		local s = ""
		if self.PlayerCount > 1 then
			s = "s"
		end
	
		text[2] = "Brain"..s.." leveled up!"
	end

	if 	self.MissionReport == nil then
		self.MissionReport = {}
	end
	for i = 1, #text do
		self.MissionReport[#self.MissionReport + 1]	= text[i]
	end
	CF_SaveMissionReport(self.GS, self.MissionReport)
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:CraftEnteredOrbit()
	-- Empty default handler, may be changed by mission scripts
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:MakeAlertSound()
	local pos = self.BrainPos[1]
	local actr = self:GetControlledActor(0)
	if actr ~= nil then
		pos = actr.Pos
	end

	local fxb = CreateAEmitter("Alarm Effect");
	fxb.Pos = pos;
	MovableMan:AddParticle(fxb);				
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:StartMusic(musictype)
	print ("VoidWanderers:StartMusic")
	local ok = false
	local counter = 0
	local track = -1
	local queue = false
	
	-- Queue defeat or victory loops
	if musictype == CF_MusicTypes.VICTORY then
		AudioMan:PlayMusic("Base.rte/Music/dBSoundworks/uwinfinal.ogg", 1, -1);
		queue = true
		print ("MUSIC: Play victory")
	end
	
	if musictype == CF_MusicTypes.DEFEAT then
		AudioMan:PlayMusic("Base.rte/Music/dBSoundworks/udiedfinal.ogg", 1, -1);
		queue = true
		print ("MUSIC: Play defeat")
	end
	
	-- Select calm music to queue after victory or defeat
	if self.LastMusicType ~= -1 and queue then
		if self.LastMusicType == CF_MusicTypes.SHIP_CALM or self.LastMusicType == CF_MusicTypes.SHIP_INTENSE then
			musictype = CF_MusicTypes.SHIP_CALM
		end
	
		if self.LastMusicType == CF_MusicTypes.MISSION_CALM or self.LastMusicType == CF_MusicTypes.MISSION_INTENSE then
			musictype = CF_MusicTypes.MISSION_CALM
		end
	end
	
	while (not ok) do
		ok = true
		track = math.random(#CF_Music[musictype])
		
		--print (track)
		--print (CF_Music[musictype][track])
		
		if musictype ~= self.LastMusicType and #CF_Music[musictype] > 1 then
			if track == self.LastMusicTrack then
				ok = false
			end
		end

		counter = counter + 1
		if counter > 5 then
			print ("BREAK")
			break
		end
	end
	
	-- If we're playing intense music, then just queue it once and play ambient all the other times
	if ok then
		if musictype == CF_MusicTypes.SHIP_INTENSE or musictype == CF_MusicTypes.MISSION_INTENSE then
			self:PlayMusicFile(CF_Music[musictype][track], false, 1)
			print ("MUSIC: Queue intense")
		else
			self:PlayMusicFile(CF_Music[musictype][track], queue, -1)
			if queue then
				print("MUSIC: Queue calm")
			else
				print("MUSIC: Play calm")
			end
		end
	end

	-- Then add a calm music after an intense
	if musictype == CF_MusicTypes.SHIP_INTENSE or musictype == CF_MusicTypes.MISSION_INTENSE then
		if musictype == CF_MusicTypes.SHIP_INTENSE then
			musictype = CF_MusicTypes.SHIP_CALM
		end
	
		if musictype == CF_MusicTypes.MISSION_INTENSE then
			musictype = CF_MusicTypes.MISSION_CALM
		end

		local ok = false
		local counter = 0

		while (not ok) do
			ok = true

			track = math.random(#CF_Music[musictype])
			
			if musictype ~= self.LastMusicType and #CF_Music[musictype] > 1 then
				if track == self.LastMusicTrack then
					ok = false
				end
			end
			
			counter = counter + 1
			if counter > 5 then
				print ("BREAK")
				break
			end
		end
		if ok then
			self:PlayMusicFile(CF_Music[musictype][track], true, -1)
			print("MUSIC: Queue calm")
		end
	end
	
	self.LastMusicType = musictype
	self.LastMusicTrack = track
--]]--
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:PlayMusicFile(path , queue, count)
	if CF_IsFilePathExists(path) then
		if queue then
			AudioMan:QueueMusicStream(path)
		else
			AudioMan:ClearMusicQueue();
			AudioMan:PlayMusic(path, count, -1);
		end
		return true
	else
		print ("ERR: Can't find music: "..path);
		return false
	end	
end
-----------------------------------------------------------------------------------------
-- That's all folks!!!
-----------------------------------------------------------------------------------------
