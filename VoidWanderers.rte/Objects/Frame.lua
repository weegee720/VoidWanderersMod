function Create(self)
	self.simFrame = 1;
end

function Update(self)
	if self.simFrame < 32 then
		self.simFrame = self.simFrame + 1;
	else
		self.simFrame = 1;
	end
	self.Frame = math.abs(self.simFrame);
end