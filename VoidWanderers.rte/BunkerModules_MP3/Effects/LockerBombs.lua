function Create(self)
	self.rechargetimerGLMP3 = Timer()
	self.newgundelay = 15000 --15 sec recharge per bomb
	self.BomList = { "Grenade", "Cluster Grenade", "Incendiary Grenade" };
end

function Destroy(self)

end


function Update(self)
	--Check if timer has passed and activates an effect to show the module is ready to use.
	if self.rechargetimerGLMP3:IsPastSimMS(self.newgundelay) and not MovableMan:IsParticle(self.readyfxGLMP3) then
		self.readyfxGLMP3 = CreateAEmitter("MP3 Module Ready Signal")
		self.readyfxGLMP3.Pos = self.Pos - Vector(0,15);
		MovableMan:AddParticle(self.readyfxGLMP3);
	end
	--Checks if actor within module and gives them a random bomb if 15 seconds have passed. Timer is then restarted.
	for actor in MovableMan.Actors do
		if (self.rechargetimerGLMP3:IsPastSimMS(self.newgundelay)) and (actor.Pos.X >= self.Pos.X - 24) and (actor.Pos.X <= self.Pos.X + 24) and (actor.Pos.Y >= self.Pos.Y - 25) and (actor.Pos.Y <= self.Pos.Y + 25) then
			actor:FlashWhite(100);
			local sound = CreateAEmitter("MP3 Locker Sound Emitter");
			sound.Pos = self.Pos;
			MovableMan:AddParticle(sound);
			actor:AddInventoryItem(CreateTDExplosive(self.BomList[math.random(#self.BomList)],"Coalition.rte"));
			self.rechargetimerGLMP3:Reset()
			self.readyfxGLMP3.Lifetime = 1
		end
	end
end
