function VoidWanderers:AmbientCreate()
	self.AmbientSmokesBrokenChambers = SceneMan.Scene:GetArea("Vessel");
	self.AmbientSmokesNextEmission = self.Time + math.random(3)
	self.AmbientSmokesEmitters = {};
    self.AmbientSmokesEmitterCount = 4;
    for i = 1 , self.AmbientSmokesEmitterCount do
		self.AmbientSmokesEmitters[i] = CreateAEmitter("White Smoke Burst" , self.ModuleName);
		self.AmbientSmokesEmitters[i].Pos = self.AmbientSmokesBrokenChambers:GetRandomPoint();
		self.AmbientSmokesEmitters[i].RotAngle = math.rad(270);
		self.AmbientSmokesEmitters[i]:EnableEmission(true);
		MovableMan:AddParticle(self.AmbientSmokesEmitters[i]);
    end
	
	self.AmbientSmokesNextHealthDamage = self.Time
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:AmbientUpdate()
	if self.Time >= self.AmbientSmokesNextEmission then
		self.AmbientSmokesNextEmission = self.Time + math.random(2)

		for i = 1 , self.AmbientSmokesEmitterCount do
			if MovableMan:IsParticle(self.AmbientSmokesEmitters[i]) then
				self.AmbientSmokesEmitters[i].Pos = self.AmbientSmokesBrokenChambers:GetRandomPoint();
			end
		end
	end
	
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
	end
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:AmbientDestroy()
	-- Destroy smoke emitters
	for i = 1 , self.AmbientSmokesEmitterCount do
		if MovableMan:IsParticle(self.AmbientSmokesEmitters[i]) then
			self.AmbientSmokesEmitters[i].ToDelete = true
		end
	end
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
