-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:ProcessStorageControlPanelUI()
	local showidle = true

	for plr = 0 , self.PlayerCount - 1 do
		local act = self:GetControlledActor(plr);
	
		if MovableMan:IsActor(act) and act.PresetName == "Storage Control Panel" then
			showidle = false
			
			-- TODO add UI processing here
		end
	end
	
	if showidle and self.StorageControlPanelPos ~= nil then
		self:PutGlow("ControlPanel_Storage", self.StorageControlPanelPos)
	end
end
