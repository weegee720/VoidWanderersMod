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
		
		self.CockpitPos = {}
		for i = 1, 4 do
			local x,y;
			
			x = tonumber(self.LS["CockpitSpawn"..i.."X"])
			y = tonumber(self.LS["CockpitSpawn"..i.."Y"])
			self.CockpitPos[i] = Vector(x,y)
		end
		

		-- Create brains
		print ("Create brains")
		for player = 0, self.PlayerCount - 1 do
			local a = CreateActor("Brain Case", "Base.rte")
			if a ~= nil then
				a.Team = CF_PlayerTeam;
				a.Pos = self.BrainPos[player+1];
				MovableMan:AddActor(a)
			end
		end
		
		-- Create initial actors
		print ("Create actors")
		if self.GS["SpawnLocation"] == "Cockpit" then
			for i = 1, 4 do
				local p;
				local c;
				
				p = self.GS["PlayerActor"..i.."Preset"]
				c = self.GS["PlayerActor"..i.."Class"]
			
				local a = CF_MakeActor2(p, c)
				if a ~= nil then
					a.Team = CF_PlayerTeam;
					a.Pos = self.CockpitPos[i];
					a.AIMode = Actor.AIMODE_SENTRY;
					
					-- Give weapons
					for j = 1, CF_MaxItems do
						local p;
						local c;
						
						p = self.GS["PlayerActor"..i.."Item"..j.."Preset"]
						c = self.GS["PlayerActor"..i.."Item"..j.."Class"]
						if p ~= nil then
							local w = CF_MakeItem2(p, c)
							if w ~= nil then
								a:AddInventoryItem(w)
							end
						end
					end
					
					MovableMan:AddActor(a)
				end
			end
		end
	end
	
	-- Read control panels location data
	-- Ship Control Panel
	local x,y;
			
	x = tonumber(self.LS["ShipControlPanelX"])
	y = tonumber(self.LS["ShipControlPanelY"])
	if x~= nil and y ~= nil then
		self.ShipControlPanelPos = Vector(x,y)
	else
		self.ShipControlPanelPos = nil
	end

	-- Clone Control Panel
	local x,y;
			
	x = tonumber(self.LS["CloneControlPanelX"])
	y = tonumber(self.LS["CloneControlPanelY"])
	if x~= nil and y ~= nil then
		self.CloneControlPanelPos = Vector(x,y)
	else
		self.CloneControlPanelPos = nil
	end

	-- Storage Control Panel
	local x,y;
			
	x = tonumber(self.LS["StorageControlPanelX"])
	y = tonumber(self.LS["StorageControlPanelY"])
	if x~= nil and y ~= nil then
		self.StorageControlPanelPos = Vector(x,y)
	else
		self.StorageControlPanelPos = nil
	end

	-- Beam Control Panel
	local x,y;
			
	x = tonumber(self.LS["BeamControlPanelX"])
	y = tonumber(self.LS["BeamControlPanelY"])
	if x~= nil and y ~= nil then
		self.BeamControlPanelPos = Vector(x,y)
	else
		self.BeamControlPanelPos = nil
	end
	
	self.GenericTimer = Timer();
	self.GenericTimer:Reset();

	self.TickTimer = Timer();
	self.TickTimer:Reset();
	self.TickInterval = CF_TacticalTickInterval;
	self.Time = 1;

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
	
	self:CreateControlPanelActors()
	
	self:InitShipControlPanelUI()
end
-----------------------------------------------------------------------------------------
-- Removes specified item from actor's inventory, returns number of removed items
-----------------------------------------------------------------------------------------
function VoidWanderers:CreateControlPanelActors()
	-- Clone
	if self.CloneControlPanelPos ~= nil then
		if not MovableMan:IsActor(self.CloneControlPanelActor) then
			self.CloneControlPanelActor = CreateActor("Clone Control Panel")
			if self.CloneControlPanelActor ~= nil then
				self.CloneControlPanelActor.Pos = self.CloneControlPanelPos
				self.CloneControlPanelActor.Team = CF_PlayerTeam
				MovableMan:AddActor(self.CloneControlPanelActor)
			end
		end
	end
	
	-- Storage
	if self.StorageControlPanelPos ~= nil then
		if not MovableMan:IsActor(self.StorageControlPanelActor) then
			self.StorageControlPanelActor = CreateActor("Storage Control Panel")
			if self.StorageControlPanelActor ~= nil then
				self.StorageControlPanelActor.Pos = self.StorageControlPanelPos
				self.StorageControlPanelActor.Team = CF_PlayerTeam
				MovableMan:AddActor(self.StorageControlPanelActor)
			end
		end
	end
		

	-- Beam
	if self.BeamControlPanelPos ~= nil then
		if not MovableMan:IsActor(self.BeamControlPanelActor) then
			self.BeamControlPanelActor = CreateActor("Beam Control Panel")
			if self.BeamControlPanelActor ~= nil then
				self.BeamControlPanelActor.Pos = self.BeamControlPanelPos
				self.BeamControlPanelActor.Team = CF_PlayerTeam
				MovableMan:AddActor(self.BeamControlPanelActor)
			end
		end
	end
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
	end
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:SaveCurrentGameState()
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
	
	-- Process UI's
	self:ProcessShipControlPanelUI()
	self:ProcessCloneControlPanelUI()
	self:ProcessStorageControlPanelUI()
	self:ProcessBeamControlPanelUI()
	
	-- Tick timer
	if self.TickTimer:IsPastSimMS(self.TickInterval) then
		self.Time = self.Time + 1
		self.TickTimer:Reset();
	end
	
	-- Show retreat reason
	if self.MissionEndText ~= nil then
		FrameMan:ClearScreenText(0);
		FrameMan:SetScreenText(self.MissionEndText, 0, 0, 8000, true);	
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