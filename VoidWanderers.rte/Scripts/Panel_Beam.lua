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

	local x1,y1, x2, y2;
			
	x1 = tonumber(self.LS["BeamBoxX1"])
	y1 = tonumber(self.LS["BeamBoxY1"])
	x2 = tonumber(self.LS["BeamBoxX2"])
	y2 = tonumber(self.LS["BeamBoxY2"])

	if x1~= nil and y1 ~= nil and x2 ~= nil and y2 ~= nil then
		self.BeamControlPanelBox = Box(x1,y1, x2, y2)
	else
		self.BeamControlPanelBox = nil
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
			
			local pos = self.BeamControlPanelPos
			
			local canbeam = false
			
			-- Create teleport effects
			if self.TeleportEffectTimer:IsPastSimMS(50) then
				-- Create particle
				local p = CreateMOSParticle("Tiny Blue Glow", self.ModuleName)
				p.Pos = self.BeamControlPanelBox:GetRandomPoint()
				p.Vel = Vector(0,-2)
				MovableMan:AddParticle(p)
				self.TeleportEffectTimer:Reset()
			end
			
			local count = 0
			for actor in MovableMan.Actors do
				if self.BeamControlPanelBox:WithinBox(actor.Pos) then
					actor:FlashWhite(50)
					count = count + 1
				end
			end
			
			local locname = CF_LocationName[ self.GS["Location"] ]
			if locname ~= nil then
				if CF_LocationPlayable[ self.GS["Location"] ] == nil or CF_LocationPlayable[ self.GS["Location"] ] == true then
					
					if count <= tonumber(self.GS["Player0VesselCommunication"]) then
						if count > 0 then
							CF_DrawString("Deploy away team on "..CF_LocationName[ self.GS["Location"] ], pos + Vector(-55, -6), 130, 36)
							canbeam = true
						else
							CF_DrawString("No units on landing deck", pos + Vector(-50, -6), 130, 36)
							canbeam = false
						end
					else
						CF_DrawString("Too many units!", pos + Vector(-35, -6), 130, 36)
						canbeam = false
					end
				else
					CF_DrawString("Can't deploy to "..CF_LocationName[ self.GS["Location"] ], pos + Vector(-50, -6), 130, 36)
					canbeam = false
				end
			else
				CF_DrawString("Can't deploy units into space", pos, 130, 36)
				canbeam = false
			end
			
			CF_DrawString("DEPLOY [ "..tostring(count).."/"..self.GS["Player0VesselCommunication"].." ]", pos + Vector(-30, -16), 130, 36)
			
			if canbeam then
				self:PutGlow("ControlPanel_Beam_Button", pos)
			else
				self:PutGlow("ControlPanel_Beam_ButtonRed", pos)
			end
		end
	end
	
	if showidle and self.BeamControlPanelPos ~= nil then
		self:PutGlow("ControlPanel_Beam", self.BeamControlPanelPos)
	end
end
