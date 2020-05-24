-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:ProcessCloneControlPanelUI()
	local showidle = true

	for plr = 0 , self.PlayerCount - 1 do
		local act = self:GetControlledActor(plr);
	
		if MovableMan:IsActor(act) and act.PresetName == "Clone Control Panel" then
			showidle = false
			
			-- TODO add UI processing here
		end
	end
	
	if showidle and self.CloneControlPanelPos ~= nil then
		self:PutGlow("ControlPanel_Clones", self.CloneControlPanelPos)
	end
end
