function VoidWanderers:StartActivity()
	self.ModuleName = "VoidWanderers.rte";
	self.IsInitialized = false;

	LAUNCH_MISSION_PACK = nil;
	STATE_CONFIG_FILE = "current.dat"
	
	self.Zone = SceneMan.Scene:GetArea("VoidWanderersAntiBugZone");
	
	LIB_PATH = self.ModuleName.."/Scripts/"
	BASE_PATH = self.ModuleName.."/Scripts/"

	dofile(LIB_PATH.."Lib_Config.lua");
	dofile(LIB_PATH.."Lib_Generic.lua");
	dofile(LIB_PATH.."Lib_ExtensionsData.lua");
	dofile(LIB_PATH.."Lib_Spawn.lua");
	dofile(LIB_PATH.."Lib_Storage.lua");

	dofile(LIB_PATH.."Panel_Clones.lua");
	dofile(LIB_PATH.."Panel_Ship.lua");
	dofile(LIB_PATH.."Panel_Beam.lua");
	dofile(LIB_PATH.."Panel_Storage.lua");
	dofile(LIB_PATH.."Panel_LZ.lua");
	
	if TRANSFER_IN_PROGRESS == nil then
		TRANSFER_IN_PROGRESS = false
	end
	
	if not TRANSFER_IN_PROGRESS then
		print ("\n\n\n");
		-- Reset all previouly set scenes and scripts before launch since we're starting clean
		SCENE_TO_LAUNCH = nil
		SCRIPT_TO_LAUNCH = nil
	else
		TRANSFER_IN_PROGRESS = false
	end

	print("VoidWanderers:MissionLauncher!");
	
	if SCENE_TO_LAUNCH == nil then
		SCENE_TO_LAUNCH = "VoidWanderers Strategy Screen"
	end

	if SCRIPT_TO_LAUNCH == nil then
		SCRIPT_TO_LAUNCH = BASE_PATH.."StrategyScreenMain.lua"
	end
	
	TRANSFER_IN_PROGRESS = false
	
	FORM_TO_LOAD = BASE_PATH.."FormStart.lua"
	
	print ("SCRIPT: "..SCRIPT_TO_LAUNCH);
	print ("SCENE : "..SCENE_TO_LAUNCH);

	dofile(SCRIPT_TO_LAUNCH)
	SceneMan:LoadScene(SCENE_TO_LAUNCH , true)
end
-----------------------------------------------------------------------------------------
-- Launches new mission script without leaving current activity. Scene is case sensitive!
-----------------------------------------------------------------------------------------
function VoidWanderers:LaunchScript(scene , script)
	print ("VoidWanderers-LaunchScript: "..scene.." / "..script)
	--print(scene)
	--print(script)

	self.IsInitialized = false;
	
	MovableMan:PurgeAllMOs()
	
	dofile(BASE_PATH..script)
	SceneMan:LoadScene(scene , true)
end
-----------------------------------------------------------------------------------------
-- Pause Activity
-----------------------------------------------------------------------------------------
function VoidWanderers:PauseActivity(pause)
    print("PAUSE! -- VoidWanderers:PauseActivity()!");
end
-----------------------------------------------------------------------------------------
-- End Activity
-----------------------------------------------------------------------------------------
function VoidWanderers:EndActivity()
    print("END! -- VoidWanderers:EndActivity()!");
	CF_Self = nil;
end
-----------------------------------------------------------------------------------------
-- Update Activity
-----------------------------------------------------------------------------------------
function VoidWanderers:UpdateActivity()
	--print("VoidWanderers::Mission launcher - Update Once!")
	if TRANSFER_IN_PROGRESS then
		self:StartActivity()
	end
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:LoadCurrentGameState()
	if CF_IsFileExists(self.ModuleName , STATE_CONFIG_FILE) then
		self.GS = CF_ReadConfigFile(self.ModuleName , STATE_CONFIG_FILE);
		
		self.Time = tonumber(self.GS["Time"])
	end
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function VoidWanderers:SaveCurrentGameState()
	self.GS["Time"] = tostring(self.Time)
	CF_WriteConfigFile(self.GS , self.ModuleName , STATE_CONFIG_FILE);
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
