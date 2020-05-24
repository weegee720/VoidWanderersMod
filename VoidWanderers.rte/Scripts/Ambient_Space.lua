function VoidWanderers:AmbientCreate()
	self.AmbientSmokesNextHealthDamage = self.Time
	self.Ship = SceneMan.Scene:GetArea("Vessel")
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:AmbientUpdate()
	if self.Time >= self.AmbientSmokesNextHealthDamage then
		self.AmbientSmokesNextHealthDamage = self.Time + 1

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
	end--]]--
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
