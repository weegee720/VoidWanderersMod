-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:InitBeamControlPanelUI()

	-- Beam Control Panel
	local x,y;
			
	x = tonumber(self.LS["BeamControlPanelX"])
	y = tonumber(self.LS["BeamControlPanelY"])
	if x~= nil and y ~= nil then
		self.BeamControlPanelPos = Vector(x,y)
	else
		self.BeamControlPanelPos = nil
	end

	-- Create actor
	-- Ship
	if self.BeamControlPanelPos ~= nil then
		if not MovableMan:IsActor(self.BeamControlPanelActor) then
			self.BeamControlPanelActor = CreateActor("Beam Control Panel")
			if self.BeamControlPanelActor ~= nil then
				self.BeamControlPanelActor.Pos = self.BeamControlPanelPos
				self.BeamControlPanelActor.Team = CF_PlayerTeam
				MovableMan:AddActor(self.BeamControlPanelActor)
			end
		end
	end	
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:ProcessBeamControlPanelUI()
	local showidle = true

	for plr = 0 , self.PlayerCount - 1 do
		local act = self:GetControlledActor(plr);
	
		if MovableMan:IsActor(act) and act.PresetName == "Beam Control Panel" then
			showidle = false
			
			pos = self.BeamControlPanelPos
			
			self:PutGlow("ControlPanel_Beam_Button", pos)
			
			-- TODO add UI processing here
		end
	end
	
	if showidle and self.BeamControlPanelPos ~= nil then
		self:PutGlow("ControlPanel_Beam", self.BeamControlPanelPos)
	end
end
