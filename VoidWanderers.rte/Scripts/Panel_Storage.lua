-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:InitStorageControlPanelUI()
	-- Create actor
	-- Ship
	if self.StorageControlPanelPos ~= nil then
		if not MovableMan:IsActor(self.StorageControlPanelActor) then
			self.StorageControlPanelActor = CreateActor("Storage Control Panel")
			if self.StorageControlPanelActor ~= nil then
				self.StorageControlPanelActor.Pos = self.StorageControlPanelPos
				self.StorageControlPanelActor.Team = CF_PlayerTeam
				MovableMan:AddActor(self.StorageControlPanelActor)
			end
		end
	end
	
	-- Init variables
	--self.ShipControlPanelModes = {LOCATION = 0, PLANET = 1}
	
	--self.ShipControlMode = self.ShipControlPanelModes.LOCATION
end
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
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
