function Create(self)
	--print ("Created!")
	
	local wtypes = {CF_WeaponTypes.RIFLE, CF_WeaponTypes.SHOTGUN, CF_WeaponTypes.SNIPER, CF_WeaponTypes.HEAVY}
	local f = CF_Factions[math.random(#CF_Factions)]
	
	-- We need this fake cfg because CF_MakeList operates only on configs to get data
	local cfg = {}
	cfg["Player0Faction"] = f
	
	--print (cfg)
	
	local weaps = CF_MakeListOfMostPowerfulWeapons(cfg, 0, wtypes[math.random(#wtypes)], 100000)
	--print (weaps)
	if weaps ~= nil then
		local r = 1
	
		if #weaps > 3 then
			r = math.random(3)
		end
		
		local itmindex = weaps[r]["Item"]
		
		--print (itmindex)
		--print (CF_ItmPresets[f][itmindex])
		--print (CF_ItmClasses[f][itmindex])
		--print (CF_ItmModules[f][itmindex])
		
		-- Create item
		local itm = CF_MakeItem(CF_ItmPresets[f][itmindex], CF_ItmClasses[f][itmindex], CF_ItmModules[f][itmindex])
		if itm then
			itm.Pos = self.Pos
			itm.Vel = Vector(0,-5)
			MovableMan:AddItem(itm)
		end
	end
	-- TODO add random explosion probability
	
	self.ToDelete = true
end