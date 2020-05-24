-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:ProcessBeamControlPanelUI()
	local showidle = true

	for plr = 0 , self.PlayerCount - 1 do
		local act = self:GetControlledActor(plr);
	
		if MovableMan:IsActor(act) and act.PresetName == "Beam Control Panel" then
			showidle = false
			
			-- TODO add UI processing here
		end
	end
	
	if showidle and self.BeamControlPanelPos ~= nil then
		self:PutGlow("ControlPanel_Beam", self.BeamControlPanelPos)
	end
end
