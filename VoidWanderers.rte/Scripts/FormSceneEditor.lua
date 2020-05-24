-----------------------------------------------------------------------------------------
--	Load event. Put all UI element initialiations here.
-----------------------------------------------------------------------------------------
function VoidWanderers:FormLoad()
	--CF_StopUIProcessing = true

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
	
	self.Pts = {}
	
	local el;
	self.UI = {}
	
	local sx = 160
	local sy = 20
	local x = 0
	local y = 1
	
	local pos = Vector(SceneMan.Scene.Width / 2, 0)
	
	self.FixedPos = Vector(0,0)
	
	
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

	el = {}
	el["Type"] = self.ElementTypes.BUTTON;
	el["Presets"] = {};
	el["Presets"][self.ButtonStates.IDLE] = "ButtonSceneEditorWideIdle"
	el["Presets"][self.ButtonStates.MOUSE_OVER] = "ButtonSceneEditorWideMouseOver"
	el["Presets"][self.ButtonStates.PRESSED] = "ButtonSceneEditorWidePressed"
	el["RelPos"] = Vector(-self.ResX2 + 20 + sx / 2 , -self.ResY2 + 20 )
	el["Text"] = "SAVE"
	el["Width"] = sx;
	el["Height"] = sy;
	el["Visible"] = false
	
	el["OnClick"] = self.Save_OnClick;
	
	self.UI[#self.UI + 1] = el;	
	
	-- Create scene buttons
	for i = 1, #self.Data do
		el = {}
		el["Type"] = self.ElementTypes.BUTTON;
		el["Presets"] = {};
		el["Presets"][self.ButtonStates.IDLE] = "ButtonSceneEditorWideIdle"
		el["Presets"][self.ButtonStates.MOUSE_OVER] = "ButtonSceneEditorWideMouseOver"
		el["Presets"][self.ButtonStates.PRESSED] = "ButtonSceneEditorWidePressed"
		el["RelPos"] = Vector(-self.ResX2 + 20 + sx / 2 + x * sx, -self.ResY2 + 20 + y *sy)
		el["Text"] = self.Data[i]["Name"]
		el["Data"] = self.Data[i]["Name"]
		el["Width"] = sx;
		el["Height"] = sy;
		el["Visible"] = false
		
		y = y + 1;
		
		el["OnClick"] = self.MissionType_OnClick;
		
		self.UI[#self.UI + 1] = el;	
	end	
	
	self.LastTypeElement = #self.UI
	
	
	-- Load level data
	self.LS = CF_ReadSceneConfigFile(self.ModuleName , SceneMan.Scene.PresetName..".dat");
	
	for k1 = 1, #self.Data do
		local msntype = self.Data[k1]["Name"]
		
		for k2 = 1, CF_MissionMaxSets[msntype] do
		
			for k3 = 1, #CF_MissionRequiredData[msntype] do
				local pttype = CF_MissionRequiredData[msntype][k3]["Name"]
				
				for k4 = 1, CF_MissionRequiredData[msntype][k3]["Max"] do
					local id = msntype..tostring(k2)..pttype..tostring(k4)
					
					local x = self.LS[id.."X"]
					local y = self.LS[id.."Y"]

					if x ~= nil and y ~= nil then
						if self.Pts[msntype] == nil then
							self.Pts[msntype] = {}
						end
						if self.Pts[msntype][k2] == nil then
							self.Pts[msntype][k2] = {}
						end
						if self.Pts[msntype][k2][k3] == nil then
							self.Pts[msntype][k2][k3] = {}
						end
						if self.Pts[msntype][k2][k3][k4] == nil then
							self.Pts[msntype][k2][k3][k4] = {}
						end
					
						self.Pts[msntype][k2][k3][k4] = Vector(tonumber(x), tonumber(y))
					end
				end
			end
		end
	end--]]--
	
	--[[for k,v in pairs(self.Pts) do
		print (k)
		
		for k2,v2 in pairs(v) do
			print (k2)
			
			for k3,v3 in pairs(v2) do
				print (k3)
				
				for k4,v4 in pairs(v3) do
					print (k4)
					print (v4)
				end
			end
		end
	end	]]--
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:ShowElements()
	local pos = self.FixedPos

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
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:Save_OnClick()
	for k,v in pairs(self.Pts) do -- Mission type
		--print (k)
		local msntype = k
		
		for k2,v2 in pairs(v) do -- Set number
			--print (k2)
			
			local setnum = tostring (k2)
			
			for k3,v3 in pairs(v2) do -- Point type
				--print (k3)
				
				local pnttype = CF_MissionRequiredData[k][k3]["Name"]
				-- Clear data
				for i = 1, CF_MissionRequiredData[k][k3]["Max"] do
					self.LS[msntype..setnum..pnttype..tostring(i).."X"] = nil
					self.LS[msntype..setnum..pnttype..tostring(i).."Y"] = nil
				end
				
				-- Save data
				for k4,v4 in pairs(v3) do -- Point vector
					--print (k4)
					--print (v4)
					self.LS[msntype..setnum..pnttype..tostring(k4).."X"] = v4.X
					self.LS[msntype..setnum..pnttype..tostring(k4).."Y"] = v4.Y
				end
			end
		end
	end
	
	CF_WriteSceneConfigFile(self.LS, CF_ModuleName, SceneMan.Scene.PresetName..".dat")
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:MissionType_OnClick()
	local newui = {}

	-- Delete all unneded elements
	for i = 1, self.LastTypeElement do
		newui[i] = self.UI[i]
	end
	
	self.UI = newui;
	
	self.SelectedType = self.UI[self.MousePressedElement]["Data"]
	
	-- Create sub-elements
	local sx = 90
	local sy = 20
	local x = 0
	local y = 1
	
	local pos = Vector(SceneMan.Scene.Width / 2, 0)
	
	-- Fill sets
	for i = 1, CF_MissionMaxSets[self.SelectedType] do
		el = {}
		el["Type"] = self.ElementTypes.BUTTON;
		el["Presets"] = {};
		el["Presets"][self.ButtonStates.IDLE] = "ButtonSceneEditorIdle"
		el["Presets"][self.ButtonStates.MOUSE_OVER] = "ButtonSceneEditorMouseOver"
		el["Presets"][self.ButtonStates.PRESSED] = "ButtonSceneEditorPressed"
		el["RelPos"] = Vector(-self.ResX2 + 20 + sx / 2 + x * sx + 161, -self.ResY2 + 20 + y *sy)
		el["Text"] = "SET "..i
		el["Data"] = i
		el["Width"] = sx;
		el["Height"] = sy;
		el["Visible"] = true
		
		y = y + 1;
		
		el["OnClick"] = self.Set_OnClick;
		
		self.UI[#self.UI + 1] = el;	
	end

	local sx = 160
	local sy = 20
	local x = 0
	local y = 1
	
	-- Fill point types
	for i = 1, #CF_MissionRequiredData[self.SelectedType] do
		el = {}
		el["Type"] = self.ElementTypes.BUTTON;
		el["Presets"] = {};
		el["Presets"][self.ButtonStates.IDLE] = "ButtonSceneEditorWideIdle"
		el["Presets"][self.ButtonStates.MOUSE_OVER] = "ButtonSceneEditorWideMouseOver"
		el["Presets"][self.ButtonStates.PRESSED] = "ButtonSceneEditorWidePressed"
		el["RelPos"] = Vector(-self.ResX2 + 20 + sx / 2 + x * sx + 252, -self.ResY2 + 20 + y *sy)
		el["Text"] = CF_MissionRequiredData[self.SelectedType][i]["Name"]
		el["Data"] = i
		el["Width"] = sx;
		el["Height"] = sy;
		el["Visible"] = true
		
		y = y + 1;
		
		el["OnClick"] = self.PointType_OnClick;
		
		self.UI[#self.UI + 1] = el;	
	end
	
	self.LastPointTypeElement = #self.UI
	
	self.SelectedSet = 1
	
	self:ShowElements()
	
	--CF_DisableUIProcessing = true
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:Set_OnClick()
	self.SelectedSet = self.UI[self.MousePressedElement]["Data"]
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:PointType_OnClick()
	local newui = {}

	-- Delete all unneded elements
	for i = 1, self.LastPointTypeElement do
		newui[i] = self.UI[i]
	end
	
	self.UI = newui;
	
	self.SelectedPointType = self.UI[self.MousePressedElement]["Data"]
	
	-- Create sub-elements
	local sx = 90
	local sy = 20
	local x = 0
	local y = 1
	
	local pos = Vector(SceneMan.Scene.Width / 2, 0)
	
	-- Fill sets
	for i = 1, CF_MissionRequiredData[self.SelectedType][self.SelectedPointType]["Max"] do
		el = {}
		el["Type"] = self.ElementTypes.BUTTON;
		el["Presets"] = {};
		el["Presets"][self.ButtonStates.IDLE] = "ButtonSceneEditorIdle"
		el["Presets"][self.ButtonStates.MOUSE_OVER] = "ButtonSceneEditorMouseOver"
		el["Presets"][self.ButtonStates.PRESSED] = "ButtonSceneEditorPressed"
		el["RelPos"] = Vector(-self.ResX2 + 20 + sx / 2 + x * sx + 252 + 161, -self.ResY2 + 20 + y *sy)
		el["Text"] = tostring(i)
		el["Data"] = i
		el["Width"] = sx;
		el["Height"] = sy;
		el["Visible"] = true
		
		y = y + 1;
		
		el["OnClick"] = self.Point_OnClick;
		
		self.UI[#self.UI + 1] = el;	
	end
	
	self:ShowElements()
	self.SelectedPoint = 1
	
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:Point_OnClick()
	self.SelectedPoint = self.UI[self.MousePressedElement]["Data"]
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:FormUpdate()
	--print (UInputMan:MouseWheelMoved())
	
	if 	self.SelectedType ~= nil and
		self.SelectedSet ~= nil and
		self.SelectedPointType ~= nil and
		self.SelectedPoint ~= nil then
		
		local mx = CF_MissionRequiredData[self.SelectedType][self.SelectedPointType]["Max"]
		local mv = UInputMan:MouseWheelMoved()
		
		if mv > 0 then
			self.SelectedPoint = self.SelectedPoint - 1
			if self.SelectedPoint < 1 then
				self.SelectedPoint = mx
			end
		end

		if mv < 0 then
			self.SelectedPoint = self.SelectedPoint + 1
			if self.SelectedPoint > mx then
				self.SelectedPoint = 1
			end
		end
	end	

	if UInputMan:KeyPressed(75) then
		self.ButtonPressed = not self.ButtonPressed
	
		if self.ButtonPressed then
			self.FixedPos = self.Mouse
			
			if self.Mouse.Y < self.ResY2 then
				self.FixedPos.Y = self.ResY2
			end
			
			if self.Mouse.Y > SceneMan.Scene.Height - self.ResY2 then
				self.FixedPos.Y = SceneMan.Scene.Height - self.ResY2
			end
			
			self.Mouse = self.FixedPos
			if MovableMan:IsActor(G_CursorActor) then
				G_CursorActor.Pos = self.Mouse
			end
			
			self:ShowElements()
		else
			self:HideElements()
		end
	end
	
	if UInputMan:MouseButtonPressed(2) then
		if self.SelectedType ~= nil then
			if 	self.Pts[self.SelectedType] ~= nil and 
				self.Pts[self.SelectedType][self.SelectedSet] ~= nil then
		
				-- Enum 
				for k3,v3 in pairs(self.Pts[self.SelectedType][self.SelectedSet]) do
					for k4,v4 in pairs(v3) do
					
						--self:PutGlow("ControlPanel_Ship_LocationDot", v4)
						if CF_Dist(v4, self.Mouse) < 5 then
							self.Pts[self.SelectedType][self.SelectedSet][k3][k4] = nil
						end
					end
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:FormClick()
	if not self.ButtonPressed then
		local el = self.MousePressedElement;
		
		if el then
		end
		
		if self.SelectedType ~= nil and self.SelectedPointType ~= nil then
			if self.Pts[self.SelectedType] == nil then
				self.Pts[self.SelectedType] = {}
			end
			if self.Pts[self.SelectedType][self.SelectedSet] == nil then
				self.Pts[self.SelectedType][self.SelectedSet] = {}
			end
			if self.Pts[self.SelectedType][self.SelectedSet][self.SelectedPointType] == nil then
				self.Pts[self.SelectedType][self.SelectedSet][self.SelectedPointType] = {}
			end
			self.Pts[self.SelectedType][self.SelectedSet][self.SelectedPointType][self.SelectedPoint] = Vector(math.floor(self.Mouse.X), math.floor(self.Mouse.Y))
		end
	end
	
	-- Draw points
	--[[for k,v in pairs(self.Pts) do
		print (k)
		
		for k2,v2 in pairs(v) do
			print (k2)
			
			for k3,v3 in pairs(v2) do
				print (k3)
				
				for k4,v4 in pairs(v3) do
					print (k4)
					print (v4)
				end
			end
		end
	end--]]--
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:FormDraw()
	if not self.ButtonPressed then
		CF_DrawString(""..math.ceil(self.Mouse.X).."-"..math.ceil(self.Mouse.Y), self.Mouse + Vector(-14,40), 100, 100)
	end
	
	if self.SelectedType ~= nil then
		if 	self.Pts[self.SelectedType] ~= nil and 
			self.Pts[self.SelectedType][self.SelectedSet] ~= nil then
	
			-- Enum 
			for k3,v3 in pairs(self.Pts[self.SelectedType][self.SelectedSet]) do
				for k4,v4 in pairs(v3) do
					local nm = CF_MissionRequiredData[self.SelectedType][k3]["Name"]
					local s = nm.."-"..tostring(k4)
					local l = CF_GetStringPixelWidth(s)
				
					CF_DrawString(s, v4 + Vector(-l/2,-10), 150, 20)
					self:PutGlow("ControlPanel_Ship_LocationDot", v4)
				end
			end
		end
	end
	
	local s = ""
	
	if self.SelectedType ~= nil then
		s = s..self.SelectedType
	end
	
	if self.SelectedSet ~= nil then
		s = s.." - S "..self.SelectedSet
	end

	if self.SelectedPointType ~= nil then
		s = s.." - "..CF_MissionRequiredData[self.SelectedType][self.SelectedPointType]["Name"]
	end

	if self.SelectedPoint ~= nil then
		s = s.." - "..self.SelectedPoint
	end
	
	FrameMan:ClearScreenText(0);
	FrameMan:SetScreenText(s, 0, 0, 1000, false);
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:PutGlow(preset, pos)
	local glow = CreateMOPixel(preset, self.ModuleName);
	if glow then
		glow.Pos = pos
		MovableMan:AddParticle(glow);	
	end
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------

function VoidWanderers:FormClose()
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
