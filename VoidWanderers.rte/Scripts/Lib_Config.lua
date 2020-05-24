-----------------------------------------------------------------------------
-- Returns trimmed string
-----------------------------------------------------------------------------
function CF_StringTrim(s)
	return s:gsub("^%s+", ""):gsub("%s+$", "")
end
-----------------------------------------------------------------------------
-- Returns true if string ends with 'End'
-----------------------------------------------------------------------------
function CF_StringEnds(String,End)
   return End=='' or string.sub(String,-string.len(End))==End
end
-----------------------------------------------------------------------------
-- Read data from file line by line and return the list
-----------------------------------------------------------------------------
function CF_ReadFactionsList(filename, defaultpath)
	print("VoidWanderers::CF_ReadFactionsList")
	io = require("io");
	local config = {};
	
	for line in io.lines("./"..filename) do
		s = string.gsub(line , "\n" , "");
		s = string.gsub(s , "\r" , "");
		
		local enabled = false
		
		if string.find(s , "*") == nil then
			enabled = true
		end
		
		if enabled then
			if CF_StringEnds(s, ".rte") then
				local file = string.sub(s, 1, #s - 4)
				local path = "./"..s.."/FactionFiles/UL2/"..file..".lua"
				
				if PresetMan:GetModuleID(s) then
					if CF_IsFilePathExists(path) then
						-- Add found .lua file if it exists
						config[#config + 1] = path
					else
						-- Check support folder for special cases popular mods
						-- if lua file don't exist
						local supportpath = "./VoidWanderers.rte/Support/"..file..".lua"
						if CF_IsFilePathExists(supportpath) then
							print ("SUPPORT "..supportpath.." FOUND, EXECUTING")
							local paths
							f = loadfile(supportpath)
							if f ~= nil then
								paths = f()

								if paths ~= nil then
									for i = 1, #paths do
										config[#config + 1] = paths[i]
									end
								end
							else
								print ("ERR: CAN'T LOAD "..supportpath.." SUPPORT, FACTIONS DISABLED")
							end
						else
							print ("ERR: FILE "..path.." NOT FOUND, FACTION NOT AUTOLOADED")
						end
					end
				else
					print ("ERR: MODULE "..s.." NOT LOADED, FACTION NOT AUTOLOADED")
				end
			else
				config[#config + 1] = defaultpath..s;
			end
		end
	end
	
	return config;
end
-----------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------
function CF_ReadExtensionsList(filename)
	print("VoidWanderers::CF_ReadFactionsList")
	io = require("io");
	local config = {};
	
	for line in io.lines("./"..filename) do
		s = string.gsub(line , "\n" , "");
		s = string.gsub(s , "\r" , "");
		if string.find(s , "*") == nil then
			config[#config + 1] = s;
		end
	end
	
	return config;
end
-----------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
function CF_ParseLine(s)
	local pos1 , pos2;
	
	pos = string.find(s ,"=");
	
	if pos ~= nil then
		local  param , value;

		s = string.gsub(s , "\n" , "");
		s = string.gsub(s , "\r" , "");
		param = string.sub(s , 1 , pos - 1);
		value = string.sub(s , pos + 1 , string.len(s));

		return param , value;
	else
		return nil;
	end
end
-----------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
function CF_ReadConfigFile(modulename , filename)
	io = require("io");
	local config = {};
	
	for line in io.lines("./"..modulename.."/CampaignData/"..filename) do
		local param , value;
		
		param, value = CF_ParseLine(line);
		if param ~= nil then
			config[param] = value;
		end
	end
	
	return config;
end
-----------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
function CF_ReadSceneConfigFile(modulename , filename)
	io = require("io");
	local config = {};
	
	if CF_IsFilePathExists("./"..modulename.."/Scenes/Data/"..filename) then
		for line in io.lines("./"..modulename.."/Scenes/Data/"..filename) do
			local param , value;

			param, value = CF_ParseLine(line);
			if param ~= nil then
				config[param] = value;
			end
		end
	end
	
	return config;
end
-----------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
function CF_WriteSceneConfigFile(config, modulename, filename)
	io = require("io");
	local file = io.open("./"..modulename.."/Scenes/Data/"..filename , "w");
	
	--for i,line in pairs(config) do
	--	file:write(tostring(i).."="..tostring(line).."\n");
	--end
	
	local sorted = CF_GetSortedListFromTable(config)
	
	for i = 1, #sorted do
		file:write(tostring(sorted[i]["Key"]).."="..tostring(sorted[i]["Value"]).."\n");
	end
	
	file:close();
end
-----------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
function CF_WriteConfigFile(config , modulename , filename)
	io = require("io");

	local file = io.open("./"..modulename.."/CampaignData/"..filename , "w");
	
	--for i,line in pairs(config) do
	--	file:write(tostring(i).."="..tostring(line).."\n");
	--end
	
	local sorted = CF_GetSortedListFromTable(config)
	
	for i = 1, #sorted do
		file:write(tostring(sorted[i]["Key"]).."="..tostring(sorted[i]["Value"]).."\n");
	end
	
	file:close();
end
-----------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
function CF_GetSortedListFromTable(arr)
	local newarr = {}

	for key, value in pairs(arr) do
		local i = #newarr + 1
		newarr[i] = {}
		newarr[i]["Key"] = key
		newarr[i]["Value"] = value
	end
	
	for i = 1, #newarr do
		for j = 1, #newarr - 1 do
			if newarr[j]["Key"] > newarr[j + 1]["Key"] then
				local tmp = newarr[j]
				newarr[j] = newarr[j + 1]
				newarr[j + 1] = tmp
			end
		end
	end
	
	return newarr;
end
-----------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
function CF_DeleteCurrentConfig(modulename)
	io = require("io");

	local file = io.open("./"..modulename.."/CampaignData/current.dat" , "w");
	
	for i,line in pairs(config) do
		file:write(tostring(i).."="..tostring(line).."\n");
	end
	
	file:close();
end
-----------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------
function CF_IsFileExists(modulename , filename)
	io = require("io");
	
	local file = io.open("./"..modulename.."/CampaignData/"..filename , "r");
	
	if file == nil then
		return false;
	end
	
	file:close();
	return true;
end
-----------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------
function CF_IsFilePathExists(path)
	io = require("io");
	
	local file = io.open(path , "r");
	
	if file == nil then
		return false;
	end
	
	file:close();
	return true;
end
-----------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
function CF_GetCharPixelWidth(char)
	local ChrLen = {};
	local n = nil;

	ChrLen["1"] = 4;
	ChrLen[" "] = 3;
	ChrLen["!"] = 3;
	ChrLen[","] = 3;
	ChrLen["."] = 3;

	ChrLen["f"] = 5;
	ChrLen["i"] = 3;
	ChrLen["j"] = 4;
	ChrLen["l"] = 3;
	ChrLen["m"] = 8;
	ChrLen["t"] = 5;
	ChrLen["w"] = 8;

	ChrLen["I"] = 3;
	ChrLen["M"] = 8;
	ChrLen["T"] = 5;
	ChrLen["W"] = 8;

	--print(char);
	
	n = ChrLen[char];
	
	--print (n);
	
	if n == nil then
		n = 6;
	end

	return n;
end
-----------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
function CF_GetStringPixelWidth(str)
	local len = 0;
	for i = 1, #str do
		len = len + CF_GetCharPixelWidth(string.sub(str , i , i));
	end
	return len;
end
-----------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------





