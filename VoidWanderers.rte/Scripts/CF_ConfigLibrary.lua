-----------------------------------------------------------------------------
-- Read data from file line by line and return the list
-----------------------------------------------------------------------------
function CF_ReadFactionsList(filename)
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
function CF_WriteConfigFile(config , modulename , filename)
	io = require("io");

	local file = io.open("./"..modulename.."/CampaignData/"..filename , "w");
	
	for i,line in pairs(config) do
		file:write(tostring(i).."="..tostring(line).."\n");
	end
	
	file:close();
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





