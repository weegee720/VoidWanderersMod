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
	
	self.GS = {};
	self.ModuleName = "VoidWanderers.rte";

	self.TickTimer = Timer();
	self.TickTimer:Reset();
	self.TickInterval = CF_TickInterval;
	
	self.TeleportEffectTimer = Timer()
	self.TeleportEffectTimer:Reset()
	
	self.FlightTimer = Timer()
	self.FlightTimer:Reset()
	self.LastTrigger = 0
	
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
		
		self.Ship = SceneMan.Scene:GetArea("Vessel")
		
		local spawnedactors = 1
		local dest = 1
		
		-- Spawn previously saved actors
		for i = 1, CF_MaxSavedActors do
			if self.GS["Actor"..i.."Preset"] ~= nil then
				local actor = CF_MakeActor2(self.GS["Actor"..i.."Preset"], self.GS["Actor"..i.."Class"])
				if actor then
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
							local itm = CF_MakeItem2(self.GS["Actor"..i.."Item"..j.."Preset"], self.GS["Actor"..i.."Item"..j.."Class"])
							if itm then
								actor:AddInventoryItem(itm)
							end
						else
							break
						end
					end
					MovableMan:AddActor(actor)
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
				local actor = CF_MakeActor2(self.DeployedActors[i]["Preset"], self.DeployedActors[i]["Class"])
				if actor then
					actor.Pos = self.AwayTeamPos[dest]
					actor.Team = CF_PlayerTeam
					
					self.GS["Actor"..spawnedactors.."Preset"] = actor.PresetName
					self.GS["Actor"..spawnedactors.."Class"] = actor.ClassName
					self.GS["Actor"..spawnedactors.."X"] = math.ceil(actor.Pos.X)
					self.GS["Actor"..spawnedactors.."Y"] = math.ceil(actor.Pos.Y)
					
					for j = 1, #self.DeployedActors[i]["InventoryPresets"] do
						local itm = CF_MakeItem2(self.DeployedActors[i]["InventoryPresets"][j], self.DeployedActors[i]["InventoryClasses"][j])
						if itm then
							actor:AddInventoryItem(itm)
							
							self.GS["Actor"..spawnedactors.."Item"..j.."Preset"] = self.DeployedActors[i]["InventoryPresets"][j]
							self.GS["Actor"..spawnedactors.."Item"..j.."Class"] = self.DeployedActors[i]["InventoryClasses"][j]
						end
					end
					MovableMan:AddActor(actor)
					spawnedactors = spawnedactors + 1
				end
			
				dest = dest + 1
				if dest > #self.AwayTeamPos then
					dest = 1
				end
			end
		end
		self.DeployedActors = nil
		self:SaveCurrentGameState()
	end
	
	-- Spawn away-team objects
	if self.GS["Mode"] == "Mission" then
		-- All mission related final message will be accumulated in mission report list
		self.MissionReport = {}
		self.MissionDeployedTroops = #self.DeployedActors
	
		local scene = SceneMan.Scene.PresetName

		self.Pts =  CF_ReadPtsData(scene, self.LS)
		self.MissionDeploySet = CF_GetRandomMissionPointsSet(self.Pts, "Deploy")
	
		-- Find suitable LZ's
		local lzs = CF_GetPointsArray(self.Pts, "Deploy", self.MissionDeploySet, "PlayerLZ")
		self.LZControlPanelPos  = CF_SelectRandomPoints(lzs, self.PlayerCount)
		
		-- Init LZ's
		self:InitLZControlPanelUI()
		
		local dest = 1;
		local dsts = CF_GetPointsArray(self.Pts, "Deploy", self.MissionDeploySet, "PlayerUnit")
		
		-- Spawn player troops
		for i = 1, #self.DeployedActors do
			local actor = CF_MakeActor2(self.DeployedActors[i]["Preset"], self.DeployedActors[i]["Class"])
			if actor then
				actor.Pos = dsts[dest]
				actor.Team = CF_PlayerTeam
				actor.AIMode = Actor.AIMODE_SENTRY
				for j = 1, #self.DeployedActors[i]["InventoryPresets"] do
					local itm = CF_MakeItem2(self.DeployedActors[i]["InventoryPresets"][j], self.DeployedActors[i]["InventoryClasses"][j])
					if itm then
						actor:AddInventoryItem(itm)
					end
				end
				MovableMan:AddActor(actor)
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
		
		-- Find available mission
		for m = 1, CF_MaxMissions do
			if self.GS["Location"] == self.GS["Mission"..m.."Location"] then
			--if self.GS["Location"] == "Ketanot Hills" then -- DEBUG
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
				
				self.MissionScript = CF_MissionScript[ self.MissionType ]
				self.MissionGoldReward = CF_MissionGoldRewardPerDifficulty[ self.MissionType ] * self.MissionDifficulty
				self.MissionReputationReward = CF_MissionReputationRewardPerDifficulty[ self.MissionType ] * self.MissionDifficulty
				
				self.MissionStatus = "" -- Will be updated by mission script

				-- Create unit presets
				CF_CreateAIUnitPresets(self.GS, self.MissionSourcePlayer , CF_GetTechLevelFromDifficulty(self.GS, self.MissionSourcePlayer, self.MissionDifficulty, CF_MaxDifficulty))
				CF_CreateAIUnitPresets(self.GS, self.MissionTargetPlayer , CF_GetTechLevelFromDifficulty(self.GS, self.MissionTargetPlayer, self.MissionDifficulty, CF_MaxDifficulty))
				
				break
			end
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

			missionscript = CF_LocationScript[ self.GS["Location"] ]
			ambientscript = CF_LocationAmbientScript[ self.GS["Location"] ]
		end
		
		if missionscript == nil then
			missionscript = "VoidWanderers.rte/Scripts/Mission_Generic.lua"
		end
		
		if ambientscript == nil then
			ambientscript = "VoidWanderers.rte/Scripts/Ambient_Generic.lua"
		end
		
		self.SpawnTable = {}
		
		dofile(missionscript)
		dofile(ambientscript)
		
		self:MissionCreate()
		self:AmbientCreate()
		
		-- Set unseen
		if CF_FogOfWarEnabled then
			SceneMan:MakeAllUnseen(Vector(CF_FogOfWarResolution, CF_FogOfWarResolution), CF_PlayerTeam);
			
			-- Reveal previously saved fog of war
			--print ("Reveal fog")
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
		
		-- Set unseen for AI (maybe some day it will matter ))))
		for p = 1, 3 do
			SceneMan:MakeAllUnseen(Vector(CF_FogOfWarResolution, CF_FogOfWarResolution), p);
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
	if self.GS["Mode"] == "Vessel" and self.GS["SceneType"] == "Vessel" then
		self:InitConsoles()
	end

	self.AssaultTime = -100
	
	self:DoBrainSelection()
	self.EnableBrainSelection = true

	-- Init icon display data
	self.IconPresets = {}
	self.IconGroups = {}
	
	self.IconGroups[1] = "Diggers"
	self.IconGroups[2] = "Sniper Weapons"
	self.IconGroups[3] = "Heavy Weapons"
	--self.IconGroups[4] = "Explosive Weapons"
	
	self.IconPresets[1] = "Icon_Digger"
	self.IconPresets[2] = "Icon_Sniper"
	self.IconPresets[3] = "Icon_Heavy"
	--self.IconPresets[4] = "Icon_Heavy"
	
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
function VoidWanderers:DestroyConsoles()
	self:DestroyShipControlPanelUI()
	self:DestroyStorageControlPanelUI()
	self:DestroyClonesControlPanelUI()
	self:DestroyBeamControlPanelUI()
	
	self:DestroyItemShopControlPanelUI()
	self:DestroyCloneShopControlPanelUI()
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
			
			config[self.GS["Location"].."-Fog"..tostring(y)] = str;
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
	
	if self.Time % CF_AssaultCheckInterval == 0 then
		local toassault = false
		
		-- First select random assault player
		self.AssaultEnemyPlayer = math.random(tonumber(self.GS["ActiveCPUs"]))
		
		local rep = tonumber(self.GS["Player"..self.AssaultEnemyPlayer.."Reputation"])
		
		--print (CF_GetPlayerFaction(self.GS,self.AssaultEnemyPlayer))
		--print (rep)
		
		if rep < CF_ReputationHuntTreshold then
			self.AssaultDifficulty = math.floor(math.abs(rep / CF_ReputationPerDifficulty))
			
			if self.AssaultDifficulty <= 0 then
				self.AssaultDifficulty = 1
			end
			
			if self.AssaultDifficulty > CF_MaxDifficulty then
				self.AssaultDifficulty = CF_MaxDifficulty
			end
			
			local r = math.random(CF_MaxDifficulty * 40)
			local tgt = ((CF_MaxDifficulty - self.AssaultDifficulty) * 4) + 4
			
			--print (self.AssaultDifficulty)
			--print (r)
			--print (tgt)
			
			if r < tgt then
				toassault = true
			end
		end
	
		if toassault then
			self.AssaultTime = self.Time + CF_ShipAssaultDelay
			
			self.AssaultEnemiesToSpawn = CF_AssaultDifficultyUnitCount[self.AssaultDifficulty]
			self.AssaultNextSpawnTime = self.AssaultTime + CF_AssaultDifficultySpawnInterval[self.AssaultDifficulty] + 1
			self.AssaultNextSpawnPos = self.EnemySpawn[math.random(#self.EnemySpawn)]	
			
			-- Create attacker's unit presets
			CF_CreateAIUnitPresets(self.GS, self.AssaultEnemyPlayer, CF_GetTechLevelFromDifficulty(self.GS, self.AssaultEnemyPlayer, self.AssaultDifficulty, CF_MaxDifficulty))	
			
			-- Remove some panel actors
			self.ShipControlPanelActor.ToDelete = true
			self.BeamControlPanelActor.ToDelete = true
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
				MovableMan:AddActor(act)
			end
			if nm["RenamePreset"] ~= nil then
				act.PresetName = nm["RenamePreset"]
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
		self.GS["Actor"..i.."X"] = nil
		self.GS["Actor"..i.."Y"] = nil
		
		for j = 1, CF_MaxSavedItemsPerActor do
			self.GS["Actor"..i.."Item"..j.."Preset"] = nil
			self.GS["Actor"..i.."Item"..j.."Class"] = nil
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
			local pre, cls = CF_GetInventory(actor)
		
			-- Save actors to config
			self.GS["Actor"..savedactor.."Preset"] = actor.PresetName
			self.GS["Actor"..savedactor.."Class"] = actor.ClassName
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

	if self.WasPaused then
		self:RestoreAI()
	end
	
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
			local s = CF_GetPlayerGold(self.GS, self.HumanPlayer) .. " oz [+"..math.ceil(self.LastPlayerIncome).."]"
			local l = CF_GetStringPixelWidth(s)
			
			CF_DrawString(s, curactor.Pos + Vector(-l/2, -76), 200, 200)
		end
	end

	-- Display icons
	if CF_EnableIcons then
		for actor in MovableMan.Actors do
			if actor.Team == CF_PlayerTeam then
				local icons = {}
				
				if actor.PresetName == "-" then
					icons[#icons + 1] = "Icon_Ally"
				end
			
				for i = 1, #self.IconPresets do
					if actor:HasObjectInGroup(self.IconGroups[i]) then
						icons[#icons + 1] = self.IconPresets[i]
					end
				end
				
				local l = #icons
				
				if l > 0 then
					for i = 1, l do
						self:PutGlow(icons[i], actor.Pos + Vector( -(13 * l / 2) + ((i - 1) * 13) + 7, -67))
					end
				end
			end
		end
	end
	
	-- Process UI's and other vessel mode features
	if self.GS["Mode"] == "Vessel" then
		self:ProcessClonesControlPanelUI()
		self:ProcessStorageControlPanelUI()

		-- Auto heall all actors when not in combat
		if not self.OverCrowded then
			for actor in MovableMan.Actors do
				if actor.Health > 0 and actor.Team == CF_PlayerTeam and self.Ship:IsInside(actor.Pos) then
					actor.Health = 100
				end
			end
		else
			FrameMan:ClearScreenText(0);
			FrameMan:SetScreenText("LIFE SUPPORT OVERLOADED\nSTORE OR DUMP SOME BODIES", 0, 0, 1000, true);
		end
		
		
		-- Switch players from brain to bridge
		local bridgeempty = true
		local plrtoswitch = -1
		
		for plr = 0 , self.PlayerCount - 1 do
			local act = self:GetControlledActor(plr);
			
			if act.PresetName == "Brain Case" and plrtoswitch == -1 then
				plrtoswitch = plr
			end
			
			if act.PresetName == "Ship Control Panel" then
				bridgeempty = false
			end
		end
			
		if plrtoswitch > -1 and bridgeempty and MovableMan:IsActor(self.ShipControlPanelActor) then
			self:SwitchToActor(self.ShipControlPanelActor, plrtoswitch, CF_PlayerTeam);
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

			-- Remove control actors
			self:DestroyStorageControlPanelUI()
			self:DestroyClonesControlPanelUI()
			self:DestroyBeamControlPanelUI()
			self:DestroyItemShopControlPanelUI()
			self:DestroyCloneShopControlPanelUI()
		end
	end
	
	if self.GS["Mode"] == "Vessel" and self.FlightTimer:IsPastSimMS(CF_FlightTickInterval) then
		self.FlightTimer:Reset()
		-- Fly to new location
		if self.GS["Destination"] ~= nil and self.Time > self.AssaultTime then
			-- Move ship
			local dx = tonumber(self.GS["DestX"])
			local dy = tonumber(self.GS["DestY"])
			
			local sx = tonumber(self.GS["ShipX"])
			local sy = tonumber(self.GS["ShipY"])
			
			local d = CF_Dist(Vector(sx,sy), Vector(dx,dy))
			
			if (d < 1) then
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
				
				self.LastTrigger = self.LastTrigger + 1
				
				if self.LastTrigger > 25 then
					self.LastTrigger = 0
					self:TriggerShipAssault()
				end
				
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
		if self.GS["Planet"] == "TradeStar" and self.GS["Location"] ~= nil then
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
	end
	
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
		
		if self.GS["Mode"] == "Vessel" then
			if CF_CountActors(CF_PlayerTeam) > tonumber(self.GS["Player0VesselLifeSupport"]) then
				self.OverCrowded = true
				
				if self.Time % 3 == 0 then
					for actor in MovableMan.Actors do
						if actor.ClassName == "AHuman" or actor.ClassName == "ACrab" then
							if actor:IsInGroup("Heavy Infantry") then
								actor.Health = actor.Health - math.random(2)
							else
								actor.Health = actor.Health - math.random(3)
							end
						end
					end
				end
			else
				self.OverCrowded = false
			end
		end
		
		-- Kill all actors outside the ship
		if self.GS["SceneType"] == "Vessel" then
			for actor in MovableMan.Actors do
				if (actor.ClassName == "AHuman" or actor.ClassName == "ACrab") and not self.Ship:IsInside(actor.Pos) then
					--actor:AddAbsForce(Vector(0 , -12*actor.Mass) , Vector(actor.Pos.X , actor.Pos.Y - 50))
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
			-- Spawn enemies
			if self.AssaultNextSpawnTime == self.Time then
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
		for actor in MovableMan.Actors do
			if actor.Team == CF_PlayerTeam and (actor.ClassName == "AHuman" or actor.ClassName == "ACrab") and actor.PresetName ~= "-" then
				count = count + 1

				if self.Time % 4 == 0 and count > tonumber(self.GS["Player0VesselCommunication"]) then
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
			end
		end
	end
	
	if self.EnableBrainSelection then
		self:DoBrainSelection()
	end
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
function VoidWanderers:DeployGenericMissionEnemies(setnumber, setname, plr, spawnrate)
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
		
		print (dq[d]["PointName"].." - "..#enmpos.." / ".. #fullenmpos .." - "..spawnrate)
		
		for i = 1, #enmpos do
			local nw = {}
			if dq[d]["Preset"] == nil then
				nw["Preset"] = math.random(CF_PresetTypes.ARMOR2)
			else
				nw["Preset"] = dq[d]["Preset"]
			end
			nw["Team"] = CF_CPUTeam
			nw["Player"] = plr
			nw["AIMode"] = Actor.AIMODE_SENTRY
			nw["Pos"] = enmpos[i]
			
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
function VoidWanderers:GiveMissionRewards()
	print ("MISSION COMPLETED")
	self.GS["Player"..self.MissionSourcePlayer.."Reputation"] = tonumber(self.GS["Player"..self.MissionSourcePlayer.."Reputation"]) + self.MissionReputationReward
	self.GS["Player"..self.MissionTargetPlayer.."Reputation"] = tonumber(self.GS["Player"..self.MissionTargetPlayer.."Reputation"]) - math.ceil(self.MissionReputationReward * CF_ReputationPenaltyRatio)
	CF_SetPlayerGold(self.GS, 0, CF_GetPlayerGold(self.GS, 0) + self.MissionGoldReward)
	
	self.MissionReport[#self.MissionReport + 1] = "MISSION COMPLETED"
	if self.MissionGoldReward > 0 then
		self.MissionReport[#self.MissionReport + 1] = tostring(self.MissionGoldReward).."oz of gold received"
	end
	
	if self.MissionReputationReward > 0 then
		self.MissionReport[#self.MissionReport + 1] = "+"..self.MissionReputationReward.." "..CF_FactionNames[ CF_GetPlayerFaction(self.GS, self.MissionSourcePlayer) ].." reputation"
		self.MissionReport[#self.MissionReport + 1] = "-"..math.ceil(self.MissionReputationReward * CF_ReputationPenaltyRatio).." "..CF_FactionNames[ CF_GetPlayerFaction(self.GS, self.MissionTargetPlayer) ].." reputation"
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
function VoidWanderers:CraftEnteredOrbit()
	-- Empty default handler, may be changed by mission scripts
end
-----------------------------------------------------------------------------------------
-- That's all folks!!!
-----------------------------------------------------------------------------------------