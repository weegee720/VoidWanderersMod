-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:InitLZControlPanelUI()
	self.LZControlPanelActor = {}

	for plr = 0 , self.PlayerCount - 1 do
		-- Create actor
		if not MovableMan:IsActor(self.LZControlPanelActor[plr + 1]) then
			self.LZControlPanelActor[plr + 1] = CreateActor("LZ Control Panel")
			--self.LZControlPanelActor[plr + 1] = CreateActor("Brain Case")
			if self.LZControlPanelActor[plr + 1] ~= nil then
				self.LZControlPanelActor[plr + 1].Pos = self.LZControlPanelPos[plr + 1]
				self.LZControlPanelActor[plr + 1].Team = CF_PlayerTeam
				MovableMan:AddActor(self.LZControlPanelActor[plr + 1])
			end
		end
		
		print (self.LZControlPanelActor[plr + 1])
	end
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:ProcessLZControlPanelUI()
	for plr = 0 , self.PlayerCount - 1 do
		local act = self:GetControlledActor(plr);
	
		if MovableMan:IsActor(act) and act.PresetName == "LZ Control Panel" then
			showidle = false
			
			pos = self.LZControlPanelPos
			
			self:PutGlow("ControlPanel_LZ_Button", pos)
			
			-- TODO add UI processing here
		end
	end
	
	if showidle and self.LZControlPanelPos ~= nil then
		for i = 1, #self.LZControlPanelPos do
			self:PutGlow("ControlPanel_LZ", self.LZControlPanelPos[i])
		end
	end
end
