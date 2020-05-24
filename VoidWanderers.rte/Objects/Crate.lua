function Create(self)
	--print ("Created!")
	
	--self.Timer = Timer()
	--self.Timer:Reset()
	--self.Vel = Vector(0,-5)
	
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
			MovableMan:AddActor(act)
		end
	end
	-- TODO add random explosion probability
	
	self.ToDelete = true
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function Update(self)
	--[[if self.Timer:IsPastSimMS(650) then
		local atypes = {CF_WeaponTypes.RIFLE, CF_WeaponTypes.SHOTGUN, CF_WeaponTypes.SNIPER, CF_WeaponTypes.HEAVY}
		local f = CF_Factions[math.random(#CF_Factions)]
		
		-- We need this fake cfg because CF_MakeList operates only on configs to get data
		local cfg = {}
		cfg["Player0Faction"] = f
		
		--print (cfg)
		
		local acts = CF_MakeListOfMostPowerfulWeapons(cfg, 0, atypes[math.random(#atypes)], 100000)
		--print (acts)
		if acts ~= nil then
			local r = 1
		
			if #acts > 3 then
				r = math.random(3)
			end
			
			local actindex = acts[r]["Item"]
			
			--print (actindex)
			--print (CF_ActPresets[f][actindex])
			--print (CF_ActClasses[f][actindex])
			--print (CF_ActModules[f][actindex])
			
			-- Create item
			local act = CF_MakeItem(CF_ActPresets[f][actindex], CF_ActClasses[f][actindex], CF_ActModules[f][actindex])
			if act then
				act.Pos = self.Pos
				act.Vel = Vector(0,-5)
				MovableMan:AddItem(act)
			end
		end
		-- TODO add random explosion probability
		
		self.ToDelete = true
	end--]]--
end