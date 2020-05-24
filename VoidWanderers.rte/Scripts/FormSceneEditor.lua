-----------------------------------------------------------------------------------------
--	Load event. Put all UI element initialiations here.
-----------------------------------------------------------------------------------------
function VoidWanderers:FormLoad()
	G_CursorActor = CreateActor("VW_Cursor")
	if G_CursorActor then
		G_CursorActor.Team = CF_PlayerTeam
		local curactor = self:GetControlledActor(CF_PlayerTeam);
		
		if MovableMan:IsActor(curactor) then
			G_CursorActor.Pos = curactor.Pos
		else
			local curactor = self:GetPlayerBrain(0);
			if MovableMan:IsActor(curactor) then
				G_CursorActor.Pos = curactor.Pos
			else
				G_CursorActor.Pos = Vector(0,0)
			end
		end
		
		MovableMan:AddActor(G_CursorActor)
		ActivityMan:GetActivity():SwitchToActor(G_CursorActor, 0, 0);
	end

	self:CreateActors()
	
	
	local el;
	self.UI = {}
	
	local sx = 90
	local sy = 20
	local x = 0
	local y = 1
	
	local pos = Vector(SceneMan.Scene.Width / 2, 0)
	
	
	self.Mouse = pos

	-- Data array will be indexed Data[mission][]
	self.Data = {}
	
	
	-- Create list of data objcets
	
	self.Data[1] = {}
	self.Data[1]["Name"] = "Deploy"
	
	for i = 1, #CF_LocationMissions[self.SelectedLocationID] do
		self.Data[i + 1] = {}
		self.Data[i + 1]["Name"] = CF_LocationMissions[self.SelectedLocationID][i]
	end
	
	-- Create scene buttons
	for i = 1, #self.Data do
		el = {}
		el["Type"] = self.ElementTypes.BUTTON;
		el["Presets"] = {};
		el["Presets"][self.ButtonStates.IDLE] = "ButtonSceneEditorIdle"
		el["Presets"][self.ButtonStates.MOUSE_OVER] = "ButtonSceneEditorMouseOver"
		el["Presets"][self.ButtonStates.PRESSED] = "ButtonSceneEditorPressed"
		el["RelPos"] = Vector(-self.ResX2 + 20 + sx / 2 + x * sx, -self.ResY2 + 20 + y *sy)
		el["Text"] = self.Data[i]["Name"]
		el["Width"] = sx;
		el["Height"] = sy;
		el["Visible"] = false
		
		y = y + 1;
		
		--el["OnClick"] = self.SceneButton_OnClick;
		
		self.UI[#self.UI + 1] = el;	
	end	
	
	self.LastTypeElement = #self.UI
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:FormClick()
	local el = self.MousePressedElement;
	
	if el then
	end
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:ShowElements()
	local pos = self.Mouse

	for i = 1, #self.UI do
		self.UI[i]["Visible"] = true
		self.UI[i]["Pos"] = pos + self.UI[i]["RelPos"]
	end
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:HideElements()
	for i = 1, #self.UI do
		self.UI[i]["Visible"] = false
	end
end-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:FormUpdate()
	if UInputMan:KeyPressed(75) then
		self.ButtonPressed = not self.ButtonPressed
	
		if self.ButtonPressed then
			self:ShowElements()
		
		else
			self:HideElements()
		end
		
	end
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:FormDraw()

	CF_DrawString(""..math.ceil(self.Mouse.X).."-"..math.ceil(self.Mouse.Y), self.Mouse + Vector(-14,40), 100, 100)

end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------

function VoidWanderers:FormClose()
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
