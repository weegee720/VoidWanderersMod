--print("W40K.lua")

io = require("io");

local paths = {}
local factns = {}

local n = #factns + 1
factns[n] = {}
factns[n]["Line"] = "Imperial Guard.ini"
factns[n]["Path"] = "./W40K.rte/Other Mod Support/UnmappedLands2/Factions/40K - Imperial Guard.lua"

local n = #factns + 1
factns[n] = {}
factns[n]["Line"] = "Black Templars.ini"
factns[n]["Path"] = "./W40K.rte/Other Mod Support/UnmappedLands2/Factions/40K - Black Templars.lua"

local n = #factns + 1
factns[n] = {}
factns[n]["Line"] = "Blood Angels.ini"
factns[n]["Path"] = "./W40K.rte/Other Mod Support/UnmappedLands2/Factions/40K - Blood Angels.lua"

local n = #factns + 1
factns[n] = {}
factns[n]["Line"] = "Dark Angels.ini"
factns[n]["Path"] = "./W40K.rte/Other Mod Support/UnmappedLands2/Factions/40K - Dark Angels.lua"

local n = #factns + 1
factns[n] = {}
factns[n]["Line"] = "Space Wolves.ini"
factns[n]["Path"] = "./W40K.rte/Other Mod Support/UnmappedLands2/Factions/40K - Space Wolves.lua"

local n = #factns + 1
factns[n] = {}
factns[n]["Line"] = "Ultra Marines.ini"
factns[n]["Path"] = "./W40K.rte/Other Mod Support/UnmappedLands2/Factions/40K - Ultramarines.lua"

for line in io.lines("./W40K.rte/Factions.ini") do
	local s

	s = string.gsub(line , "\n" , "");
	s = string.gsub(s , "\r" , "");
	s = CF_StringTrim(s)
	
	for i = 1, #factns do
		if string.find(s, factns[i]["Line"]) ~= nil then
			local enabled = true
			
			-- Check if line is uncommented
			if string.find(s, "//") ~= nil then
				if string.find(s, "//") < string.find(s, factns[i]["Line"]) then
					enabled = false
				end
			end
			
			if enabled then
				paths[#paths + 1] = factns[i]["Path"]
			end
		end
	end
end

for i = 1, #paths do
	print ("Support load: "..paths[i])
end

return paths
