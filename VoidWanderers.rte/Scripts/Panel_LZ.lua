-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:InitLZControlPanelUI()

	-- LZ Control Panel
	local x,y;
			
	x = tonumber(self.LS["LZControlPanelX"])
	y = tonumber(self.LS["LZControlPanelY"])
	if x~= nil and y ~= nil then
		self.LZControlPanelPos = Vector(x,y)
	else
		self.LZControlPanelPos = nil
	end

	-- Create actor
	-- Ship
	if self.LZControlPanelPos ~= nil then
		if not MovableMan:IsActor(self.LZControlPanelActor) then
			self.LZControlPanelActor = CreateActor("LZ Control Panel")
			if self.LZControlPanelActor ~= nil then
				self.LZControlPanelActor.Pos = self.LZControlPanelPos
				self.LZControlPanelActor.Team = CF_PlayerTeam
				MovableMan:AddActor(self.LZControlPanelActor)
			end
		end
	end	
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:ProcessLZControlPanelUI()
	local showidle = true

	for plr = 0 , self.PlayerCount - 1 do
		local act = self:GetControlledActor(plr);
	
		if MovableMan:IsActor(act) and act.PresetName == "LZ" then
			showidle = false
			
			pos = self.LZControlPanelPos
			
			self:PutGlow("ControlPanel_LZ_Button", pos)
			
			-- TODO add UI processing here
		end
	end
	
	--if showidle and self.LZControlPanelPos ~= nil then
	--	self:PutGlow("ControlPanel_LZ", self.LZControlPanelPos)
	--end
end
