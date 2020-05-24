function Create(self)
	self.hurtTimer = Timer();
	self.hurtInterval = 100;
end

function Update(self)
    if self.hurtTimer:IsPastSimMS(self.hurtInterval) then
	--Cycle through every actor on the level.
	for actor in MovableMan.Actors do
	    --Check if the actor is within the conveyor's zone.
	    if (actor.Pos.X >= self.Pos.X - 24) and (actor.Pos.X <= self.Pos.X + 24) and (actor.Pos.Y >= self.Pos.Y - 25) and (actor.Pos.Y <= self.Pos.Y + 25) and (actor.PinStrength <= 0) then
		--Kill the actor
		actor.Health = actor.Health - 5;
		actor:FlashWhite(250);
	    end
	end
	self.hurtTimer:Reset();
    end
end