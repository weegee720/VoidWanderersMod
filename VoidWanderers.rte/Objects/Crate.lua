function Create(self)
	--print ("Created!")
	
	--self.Timer = Timer()
	--self.Timer:Reset()
	--self.Vel = Vector(0,-5)
	
	if #CF_ArtActPresets == 0 then
		CF_ArtifactActorRate = 0
	end
	
	if math.random() < CF_ArtifactActorRate then
		local r = math.random(#CF_ArtActPresets)
		
		local act = CF_MakeActor(CF_ArtActPresets[r], CF_ArtActClasses[r], CF_ArtActModules[r])
		if act then
			act.Pos = self.Pos-- + Vector(0,-8)
			act.Vel = Vector(0,-5)
			act.Team = CF_PlayerTeam
			act.AIMode = Actor.AIMODE_SENTRY			
			MovableMan:AddActor(act)
		end
	else
		local atypes = {CF_ActorTypes.LIGHT, CF_ActorTypes.HEAVY, CF_ActorTypes.HEAVY, CF_ActorTypes.ARMOR}
		local f = CF_Factions[math.random(#CF_Factions)]
		
		-- We need this fake cfg because CF_MakeList operates only on configs to get data
		local cfg = {}
		cfg["Player0Faction"] = f
		
		--print (cfg)
		
		local acts = CF_MakeListOfMostPowerfulActors(cfg, 0, atypes[math.random(#atypes)], 100000)
		--print (acts)
		if acts ~= nil then
			local r = 1
		
			if #acts > 3 then
				r = math.random(3)
			end
			
			local actindex = acts[r]["Actor"]
			
			--print (actindex)
			--print (CF_ActPresets[f][actindex])
			--print (CF_ActClasses[f][actindex])
			--print (CF_ActModules[f][actindex])
			
			-- Create item
			local act = CF_MakeActor(CF_ActPresets[f][actindex], CF_ActClasses[f][actindex], CF_ActModules[f][actindex])
			if act then
				act.Pos = self.Pos-- + Vector(0,-8)
				act.Vel = Vector(0,-5)
				act.Team = CF_PlayerTeam
				act.AIMode = Actor.AIMODE_SENTRY
				MovableMan:AddActor(act)
			end
		end
	end
	
	self.ToDelete = true
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function Update(self)
end