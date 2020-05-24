-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:InitClonesControlPanelUI()
	-- Create actor
	-- Ship
	if self.ClonesControlPanelPos ~= nil then
		if not MovableMan:IsActor(self.ClonesControlPanelActor) then
			self.ClonesControlPanelActor = CreateActor("Clones Control Panel")
			if self.ClonesControlPanelActor ~= nil then
				self.ClonesControlPanelActor.Pos = self.ClonesControlPanelPos
				self.ClonesControlPanelActor.Team = CF_PlayerTeam
				MovableMan:AddActor(self.ClonesControlPanelActor)
			end
		end
	end
	
	self.ClonesControlPanelItemsPerPage = 9
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:ProcessClonesControlPanelUI()
	local showidle = true

	for plr = 0 , self.PlayerCount - 1 do
		local act = self:GetControlledActor(plr);
	
		if MovableMan:IsActor(act) and act.PresetName == "Clones Control Panel" then
			showidle = false
			
			-- Draw generic UI
			local pos = act.Pos
			self:PutGlow("ControlPanel_Clones_List", pos + Vector(-71,0))
			self:PutGlow("ControlPanel_Clones_Description", pos + Vector(90,0))
			self:PutGlow("ControlPanel_Clones_HorizontalPanel", pos + Vector(20,-77))
			self:PutGlow("ControlPanel_Clones_HorizontalPanel", pos + Vector(20,78))			
		end
	end
	
	if showidle and self.ClonesControlPanelPos ~= nil then
		self:PutGlow("ControlPanel_Clones", self.ClonesControlPanelPos)
	end
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
