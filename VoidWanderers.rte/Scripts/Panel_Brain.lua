-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:InitBrainControlPanelUI()
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:DestroyBrainControlPanelUI()
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:ProcessBrainControlPanelUI()
	if self.GS["Mode"] == "Assault" then
		return
	end
	
	local showidle = true
	for plr = 0, self.PlayerCount - 1 do
		local act = self:GetControlledActor(plr);
	
		-- Process brain detachment
		if MovableMan:IsActor(act) and act.PresetName == "Brain Case" then
			showidle = false
			
			self:AddObjectivePoint("Press DOWN to detach", act.Pos + Vector(0,46), CF_PlayerTeam, GameActivity.ARROWDOWN);
			
			local cont = act:GetController()
			local pos = act.Pos
			
			if cont:IsState(Controller.PRESS_DOWN) then
				-- Determine which player's brain it is
				local bplr
				
				for b = 0, self.PlayerCount - 1 do
					if MovableMan:IsActor(self.CreatedBrains[b]) and self.CreatedBrains[b].ID == act.ID then
						bplr = b
					end
				end
				
				local tough = tonumber(self.GS["Brain"..plr.."Tougness"])
				if tough < 0 then
					tough = 0
				elseif tough > 5 then
					tough = 5
				end
				
				local rb = CreateAHuman("RPG Brain Robot LVL"..tough.." PLR"..bplr)
				if rb then
					rb.Team = CF_PlayerTeam
					rb.Pos = act.Pos + Vector(0,46)
					rb.AIMode = Actor.AIMODE_SENTRY
					rb.Health = act.Health
					MovableMan:AddActor(rb)
					
					-- Give items
					for j = 1, CF_MaxSavedItemsPerActor do
						if self.GS["Brain"..bplr.."Item"..j.."Preset"] ~= nil then
							local itm = CF_MakeItem2(self.GS["Brain"..bplr.."Item"..j.."Preset"], self.GS["Brain"..bplr.."Item"..j.."Class"])
							if itm then
								rb:AddInventoryItem(itm)
							end
						else
							break
						end
					end

					self:SwitchToActor(rb, plr, CF_PlayerTeam);
					
					self.GS["Brain"..bplr.."Detached"] = "True"
					CF_ClearAllBrainsSupplies(self.GS, bplr)
					self.CreatedBrains[bplr] = nil
					act.ToDelete = true
				end
			end
		end
		
		-- Process brain attachment
		if MovableMan:IsActor(act) and act:IsInGroup("Brains") then
			local s = act.PresetName
			local pos = string.find(s ,"RPG Brain Robot");
			if pos == 1 then
				-- Determine which player's brain it is
				local bplr = tonumber(string.sub(s, string.len(s), string.len(s) ))
				local readytoattach = false
				
				if act.Pos.X > self.BrainPos[bplr + 1].X - 10 and act.Pos.X < self.BrainPos[bplr + 1].X + 10 and act.Pos.Y > self.BrainPos[bplr + 1].Y and CF_Dist(act.Pos, self.BrainPos[bplr + 1]) < 100 then
					readytoattach = true
					self:AddObjectivePoint("Press UP to attach", self.BrainPos[bplr + 1] + Vector(0,6), CF_PlayerTeam, GameActivity.ARROWUP);
				else
					self:AddObjectivePoint("Attach brain", self.BrainPos[bplr + 1] + Vector(0,6), CF_PlayerTeam, GameActivity.ARROWUP);
				end

				local cont = act:GetController()
				
				if cont:IsState(Controller.PRESS_UP) and readytoattach then
					local rb = CreateActor("Brain Case")
					if rb then
						rb.Team = CF_PlayerTeam
						rb.Pos = self.BrainPos[bplr + 1]
						rb.Health = act.Health
						MovableMan:AddActor(rb)
						self:SwitchToActor(rb, plr, CF_PlayerTeam);
						
						-- Clear inventory
						for j = 1, CF_MaxSavedItemsPerActor do
							self.GS["Brain"..bplr.."Item"..j.."Preset"] = nil
							self.GS["Brain"..bplr.."Item"..j.."Class"] = nil
						end						
						
						-- Save inventory
						local pre, cls = CF_GetInventory(act)
							
						for j = 1, #pre do
							self.GS["Brain"..bplr.."Item"..j.."Preset"] = pre[j]
							self.GS["Brain"..bplr.."Item"..j.."Class"] = cls[j]
						end
						
						self.GS["Brain"..bplr.."Detached"] = "False"
						self.CreatedBrains[bplr] = rb
						act.ToDelete = true
					end
				end
			end
		end
	end
end
