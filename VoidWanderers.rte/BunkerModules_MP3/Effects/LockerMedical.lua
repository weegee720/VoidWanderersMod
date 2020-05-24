function Create(self)
	self.rechargetimerMLMP3 = Timer()
	self.newgundelay = 30000 --30 sec recharge per gun
	self.WepList = { "First Aid Kit" };
end

function Destroy(self)

end


function Update(self)
	--Check if timer has passed and activates an effect to show the module is ready to use.
	if self.rechargetimerMLMP3:IsPastSimMS(self.newgundelay) and not MovableMan:IsParticle(self.readyfxMLMP3) then
		self.readyfxMLMP3 = CreateAEmitter("MP3 Module Ready Signal")
		self.readyfxMLMP3.Pos = self.Pos - Vector(0,15)
		MovableMan:AddParticle(self.readyfxMLMP3);
	end
	--Checks if actor within module and gives them a gun if 30 seconds have passed. Timer is then restarted.
	for actor in MovableMan.Actors do
		if (self.rechargetimerMLMP3:IsPastSimMS(self.newgundelay)) and (actor.Pos.X >= self.Pos.X - 24) and (actor.Pos.X <= self.Pos.X + 24) and (actor.Pos.Y >= self.Pos.Y - 25) and (actor.Pos.Y <= self.Pos.Y + 25) then
			actor:FlashWhite(100);
			local sound = CreateAEmitter("MP3 Locker Sound Emitter");
			sound.Pos = self.Pos;
			MovableMan:AddParticle(sound);
			actor:AddInventoryItem(CreateTDExplosive(self.WepList[math.random(#self.WepList)],"Base.rte"));
			self.rechargetimerMLMP3:Reset()
			self.readyfxMLMP3.Lifetime = 1
		end
	end
end
