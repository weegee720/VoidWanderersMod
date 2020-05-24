function Create(self)
    x = self;
    --Set the speed in pixels per frame at which to move the actors/items.
    self.speed = 2;
end


function Update(self)
    if (math.floor(math.deg(self.RotAngle)) == 0) then
   for actor in MovableMan.Actors do
       if (actor.Pos.X >= self.Pos.X - 25) and (actor.Pos.X <= self.Pos.X + 25) and (actor.Pos.Y >= self.Pos.Y - 120) and (actor.Pos.Y <= self.Pos.Y + 120) and (actor.PinStrength <= 0) then
      actor.Pos.Y = actor.Pos.Y - self.speed;
      actor.Vel.X = actor.Vel.X - ((actor.Pos.X - self.Pos.X)) / 35;
      actor.Vel.Y = actor.Vel.Y / 2;
      actor.Pos.X = ((actor.Pos.X * 24) + self.Pos.X) / 25;
       end
   end
    elseif (math.floor(math.deg(self.RotAngle)) == 180) then
   for actor in MovableMan.Actors do
       if (actor.Pos.X >= self.Pos.X - 25) and (actor.Pos.X <= self.Pos.X + 25) and (actor.Pos.Y >= self.Pos.Y - 120) and (actor.Pos.Y <= self.Pos.Y + 120) and (actor.PinStrength <= 0) then
      actor.Pos.Y = actor.Pos.Y + self.speed;
      actor.Vel.X = actor.Vel.X - ((actor.Pos.X - self.Pos.X)) / 35;
      actor.Vel.Y = actor.Vel.Y / 2;
      actor.Pos.X = ((actor.Pos.X * 24) + self.Pos.X) / 25;
       end
   end
    end
end