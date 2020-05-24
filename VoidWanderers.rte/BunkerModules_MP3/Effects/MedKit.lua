function Create(self)
	--Find out who shot the weapon by finding the closest actor within 150 pixels.
	local curdist = 150;
	for actor in MovableMan.Actors do
		local avgx = actor.Pos.X - self.Pos.X;
		local avgy = actor.Pos.Y - self.Pos.Y;
		local dist = math.sqrt(avgx ^ 2 + avgy ^ 2);
		if dist < curdist then
			curdist = dist;
			self.parent = actor;
		end
	end
	if not (self.parent.Health >= 100) then
	self.parent.Health = self.parent.Health + 1;
	end
end