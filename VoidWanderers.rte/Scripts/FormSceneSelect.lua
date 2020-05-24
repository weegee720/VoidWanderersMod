-----------------------------------------------------------------------------------------
--	Load event. Put all UI element initialiations here.
-----------------------------------------------------------------------------------------
function VoidWanderers:FormLoad()
	-- Create UI elements
	-- Clear old elements
	local el;
	self.UI = {}
	
	local sx = 140
	local sy = 40
	local wx = 4
	local x = 1
	local y = 1
	
	local pos = Vector(SceneMan.Scene.Width / 2, SceneMan.Scene.Height / 2)
	
	-- Create scene buttons
	for i = 1, #CF_Location	do
		el = {}
		el["Type"] = self.ElementTypes.BUTTON;
		el["Presets"] = {};
		el["Presets"][self.ButtonStates.IDLE] = "ButtonIdle"
		el["Presets"][self.ButtonStates.MOUSE_OVER] = "ButtonMouseOver"
		el["Presets"][self.ButtonStates.PRESSED] = "ButtonPressed"
		el["Pos"] = pos + Vector( -(wx * sx / 2) + x*sx, y*sy)
		el["Text"] = CF_LocationScene[CF_Location[i]]
		el["LocationID"] = CF_Location[i]
		el["Width"] = sx;
		el["Height"] = sy;
		
		x = x + 1;
		if x > wx then
			x = 1
			y = y + 1
		end
		
		--el["OnHover"] = self.SaveSlots_OnHover;
		el["OnClick"] = self.SceneButton_OnClick;
		
		self.UI[#self.UI + 1] = el;	
	end
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
function VoidWanderers:SceneButton_OnClick()
	local el = self.MousePressedElement;
	
	self:FormClose();
	SceneMan:LoadScene(self.UI[el]["Text"], false)
	self.SelectedLocationID = self.UI[el]["LocationID"]
	dofile(BASE_PATH.."FormSceneEditor.lua")
	self:FormLoad();
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:FormUpdate()
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:FormDraw()
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------

function VoidWanderers:FormClose()
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------