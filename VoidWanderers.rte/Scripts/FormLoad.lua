-----------------------------------------------------------------------------------------
--	Load event. Put all UI element initialiations here.
-----------------------------------------------------------------------------------------
function VoidWanderers:FormLoad()
	local el;
	
	-- Clear old elements
	self.UI = {}

	-- Create save slots-buttons
	self.Slots = {}
	for i = 1, CF_MaxSaveGames do
		el = {}
		el["Type"] = self.ElementTypes.BUTTON;
		el["Presets"] = {};
		el["Presets"][self.ButtonStates.IDLE] = "SlotWideIdle"
		el["Presets"][self.ButtonStates.MOUSE_OVER] = "SlotWideMouseOver"
		el["Presets"][self.ButtonStates.PRESSED] = "SlotWidePressed"
		el["Pos"] = Vector(0,0) -- Will be calculated later
		el["Text"] = nil
		el["Width"] = 180;
		el["Height"] = 70;
		
		el["OnHover"] = self.SaveSlots_OnHover;
		el["OnClick"] = self.SaveSlots_OnClick;
		
		self.UI[#self.UI + 1] = el;

		self.Slots[i] = {}
		self.Slots[i]["Empty"] = true;
		
		if CF_IsFileExists(self.ModuleName , "savegame"..i..".dat") then
			local config = {};
			
			config = CF_ReadConfigFile(self.ModuleName , "savegame"..i..".dat");
			
			local isbroken = false;
			local reason = ""
			
			-- Check that all used factions are installed
			for j = 0 , CF_MaxCPUPlayers do
				if config["Player"..j.."Active"] == "True" then
					local f = config["Player"..j.."Faction"];
					
					if f == nil then
						isbroken = true;
						break;
					else
						if CF_FactionNames[f] == nil or CF_FactionPlayable[f] == false then
							isbroken = true;
							reason = "NO "..f
						end
					end
				end
			end

			if not isbroken then
				self.Slots[i]["Faction"] = CF_FactionNames[config["Player0Faction"]];
				self.Slots[i]["Gold"] = config["Player0Gold"];
				self.Slots[i]["Time"] = config["Time"];
				self.Slots[i]["Reason"] = reason
				self.Slots[i]["TimeStamp"] = config["TimeStamp"];
				self.Slots[i]["Empty"] = false;
			else
				self.Slots[i]["Faction"] = "Broken slot #"..i.."";
			end
		else
			self.Slots[i]["Faction"] = "EMPTY";
		end
	end

	-- Place elements
	self.SaveSlotsPerRow = 2; -- Plates per row
	
	if CF_MaxSaveGames < self.SaveSlotsPerRow then
		self.SaveSlotsPerRow = CF_MaxSaveGames
	end
	
	self.Rows = math.floor(CF_MaxSaveGames / self.SaveSlotsPerRow + 1)

	local xtile = 1
	local ytile = 1
	local tilesperrow = 0
	
	-- Init factions UI
	for i = 1 , CF_MaxSaveGames do
		if i <= CF_MaxSaveGames - CF_MaxSaveGames % self.SaveSlotsPerRow then
			tilesperrow = self.SaveSlotsPerRow
		else
			tilesperrow = CF_MaxSaveGames % self.SaveSlotsPerRow
		end
		
		self.UI[i]["Pos"] = Vector((self.MidX) - ((tilesperrow * (180 - 2)) / 2) + (xtile * (180 - 2)) - ((180 - 2) / 2), 
									(self.MidY) - ((self.Rows * 68) / 2) + (ytile * 68) - (68 / 2))
		
		xtile = xtile + 1
		if xtile > self.SaveSlotsPerRow then
			xtile = 1
			ytile = ytile + 1
		end
	end

	-- Create description labels
	for i = 1, CF_MaxSaveGames do
		el = {}
		el["Type"] = self.ElementTypes.LABEL;
		el["Preset"] = nil
		el["Pos"] = self.UI[i]["Pos"] + Vector(0, -25)
		el["Text"] = self.Slots[i]["Faction"]
		el["Width"] = 180;
		el["Height"] = 70;
		
		self.UI[#self.UI + 1] = el;

		el = {}
		el["Type"] = self.ElementTypes.LABEL;
		el["Preset"] = nil
		el["Pos"] = self.UI[i]["Pos"] + Vector(0, -15)
		el["Text"] = self.Slots[i]["Reason"]
		el["Width"] = 180;
		el["Height"] = 70;
		
		self.UI[#self.UI + 1] = el;
		
		if not self.Slots[i]["Empty"] then
			el = {}
			el["Type"] = self.ElementTypes.LABEL;
			el["Preset"] = nil
			el["Pos"] = self.UI[i]["Pos"] + Vector(0, 10)
			el["Text"] = self.Slots[i]["TimeStamp"] .." / ".. self.Slots[i]["Time"]
			el["Width"] = 180;
			el["Height"] = 70;
			
			self.UI[#self.UI + 1] = el;

			el = {}
			el["Type"] = self.ElementTypes.LABEL;
			el["Preset"] = nil
			el["Pos"] = self.UI[i]["Pos"] + Vector(0, 24)
			el["Text"] = self.Slots[i]["Gold"].." oz"
			el["Width"] = 60;
			el["Height"] = 70;
			
			self.UI[#self.UI + 1] = el;
		end
	end
	
	el = {}
	el["Type"] = self.ElementTypes.LABEL;
	el["Preset"] = nil
	el["Pos"] = self.Mid + Vector(0,-self.ResY2 + 8)
	el["Text"] = "LOAD GAME"
	el["Width"] = 800;
	el["Height"] = 100;

	self.UI[#self.UI + 1] = el;

	el = {}
	el["Type"] = self.ElementTypes.BUTTON;
	el["Presets"] = {};
	el["Presets"][self.ButtonStates.IDLE] = "SideMenuButtonSmallIdle"
	el["Presets"][self.ButtonStates.MOUSE_OVER] = "SideMenuButtonSmallMouseOver"
	el["Presets"][self.ButtonStates.PRESSED] = "SideMenuButtonSmallPressed"
	el["Pos"] = self.Mid + Vector(self.ResX2 - 70,-self.ResY2 + 12)
	el["Text"] = "Back"
	el["Width"] = 140;
	el["Height"] = 40;
	
	el["OnClick"] = self.BtnBack_OnClick;

	self.UI[#self.UI + 1] = el;
	
	el = {}
	el["Type"] = self.ElementTypes.LABEL;
	el["Preset"] = nil
	el["Pos"] = self.Mid + Vector(0,-self.ResY2 + 28)
	el["Text"] = ""
	el["Width"] = 800;
	el["Height"] = 100;

	self.UI[#self.UI + 1] = el;
	self.LblSlotDescription = el
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:SaveSlots_OnHover()
	if self.Slots[self.MouseOverElement]["Empty"] ~= true then
		self.LblSlotDescription["Text"] = "!!! WARNING, YOUR CURRENT GAME WILL BE OVERWRITTEN !!!";
	else
		self.LblSlotDescription["Text"] = ""
	end
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:SaveSlots_OnClick()
	-- Update timestamp
	if not self.Slots[self.MouseOverElement]["Empty"] then
		local config = CF_ReadConfigFile(self.ModuleName , "savegame"..self.MouseOverElement..".dat");
		CF_WriteConfigFile(config , self.ModuleName , STATE_CONFIG_FILE);
		self:FormClose();
		dofile(BASE_PATH.."FormDefault.lua")
		self:LoadCurrentGameState();
		self:FormLoad();
	end
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:BtnBack_OnClick()
	self:FormClose();
	if self.ReturnToStart then
		dofile(BASE_PATH.."FormStart.lua")
	else
		dofile(BASE_PATH.."FormDefault.lua")
	end
	self.ReturnToStart = false
	self:FormLoad();
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
