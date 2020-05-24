-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
function VoidWanderers:MissionCreate()
	print ("VESSEL EXPLORATION CREATE")

	-- Spawn random wandering enemies
	local set = CF_GetRandomMissionPointsSet(self.Pts, "Deploy")	

	-- Spawn crates
	local enm = CF_GetPointsArray(self.Pts, "Deploy", set, "AmbientEnemy")
	self.MissionLZs = CF_GetPointsArray(self.Pts, "Deploy", set, "EnemyLZ")
	
	-- Create teams
	local teams = {}
	teams[1] = 1
	if math.random() < 0.15 then
		teams[#teams + 1] = 2
	end
	if math.random() < 0.15 then
		teams[#teams + 1] = 3
	end
	if math.random() < 0.15 then
		teams[#teams + 1] = 0
	end
	
	self.MissionStart = self.Time
	self.MissionNextDropShip = self.Time + CF_AmbientReinforcementsInterval
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:MissionUpdate()
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------