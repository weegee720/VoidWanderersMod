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
	local config = {};
	
	local fileid = LuaMan:FileOpen(filename, "rt");
	
	while not LuaMan:FileEOF(fileid) do
		line = LuaMan:FileReadLine(fileid)
		s = string.gsub(line , "\n" , "");
		s = string.gsub(s , "\r" , "");
		
		local enabled = false
		
		if string.find(s , "*") == nil then
			enabled = true
		end
		
		if enabled then
			if CF_StringEnds(s, ".rte") then
				local file = string.sub(s, 1, #s - 4)
				local path = s.."/FactionFiles/UL2/"..file..".lua"

				if PresetMan:GetModuleID(s) > -1 then
					if CF_IsFilePathExists(path) then
						-- Add found .lua file if it exists
						config[#config + 1] = path
					else
						-- Check support folder for special cases popular mods
						-- if lua file don't exist
						local supportpath = "VoidWanderers.rte/Support/"..file..".lua"
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
					print ("MSG: MODULE "..s.." NOT LOADED, FACTION NOT AUTOLOADED")
				end
			else
				config[#config + 1] = defaultpath..s;
			end
		end
	end
	
	LuaMan:FileClose(fileid)
	
	return config;
end
-----------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------
function CF_ReadExtensionsList(filename, defaultpath)
	print("VoidWanderers::CF_ReadFactionsList")
	local config = {};
	
	local fileid = LuaMan:FileOpen(filename, "rt");
	
	while not LuaMan:FileEOF(fileid) do
		line = LuaMan:FileReadLine(fileid)
		s = string.gsub(line , "\n" , "");
		s = string.gsub(s , "\r" , "");
		
		local enabled = false
		
		if string.find(s , "*") == nil then
			enabled = true
		end
		
		if enabled then
			local file = string.sub(s, 1, #s - 4)
		
			if CF_StringEnds(s, ".rte") then
				local supportpath = "VoidWanderers.rte/SupportExtensions/"..file..".lua"
				if CF_IsFilePathExists(supportpath) then
					print ("EXTENSION SUPPORT "..supportpath.." FOUND, EXECUTING")
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
						print ("ERR: CAN'T LOAD "..supportpath.." SUPPORT, EXTENSIONS DISABLED")
					end
				else
					print ("ERR: FILE "..supportpath.." NOT FOUND, EXTENSION NOT AUTOLOADED")
				end
			else
				config[#config + 1] = defaultpath..s;
			end
		end
	end
	
	LuaMan:FileClose(fileid)
	
	--for i = 1, #config do
	--	print (config[i])
	--end
	
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
	local config = {};
	
	local f = LuaMan:FileOpen(modulename.."/CampaignData/"..filename, "rt");
	
	while not LuaMan:FileEOF(f) do
		line = LuaMan:FileReadLine(f)
		local param , value;
		
		param, value = CF_ParseLine(line);
		if param ~= nil then
			config[param] = value;
		end
	end
	
	LuaMan:FileClose(f)
	
	return config;
end
-----------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
function CF_ReadSceneConfigFile(modulename , filename)
	local config = {};
	
	if CF_IsFilePathExists(modulename.."/Scenes/Data/"..filename) then
		local f = LuaMan:FileOpen(modulename.."/Scenes/Data/"..filename, "rt");
		
		while not LuaMan:FileEOF(f) do
			line = LuaMan:FileReadLine(f)
			local param , value;

			param, value = CF_ParseLine(line);
			if param ~= nil then
				config[param] = value;
			end
		end
		LuaMan:FileClose(f)
	end

	return config;
end
-----------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
function CF_WriteSceneConfigFile(config, modulename, filename)
	local file = LuaMan:FileOpen(modulename.."/Scenes/Data/"..filename, "wt");
	
	local sorted = CF_GetSortedListFromTable(config)
	
	for i = 1, #sorted do
		LuaMan:FileWriteLine(file, tostring(sorted[i]["Key"]).."="..tostring(sorted[i]["Value"]).."\n");
	end
	
	LuaMan:FileClose(file)
end
-----------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
function CF_WriteConfigFile(config , modulename , filename)
	local file = LuaMan:FileOpen(modulename.."/CampaignData/"..filename , "wt");
	local sorted = CF_GetSortedListFromTable(config)
	
	for i = 1, #sorted do
		LuaMan:FileWriteLine(file, tostring(sorted[i]["Key"]).."="..tostring(sorted[i]["Value"]).."\n");
	end
	
	LuaMan:FileClose(file)
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
	local file = LuaMan:FileOpen(modulename.."/CampaignData/current.dat" , "wt");
	
	for i,line in pairs(config) do
		LuaMan:WriteLine(file, tostring(i).."="..tostring(line).."\n");
	end
	
	LuaMan:FileClose(file);
end
-----------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------
function CF_IsFileExists(modulename , filename)
	local file = LuaMan:FileOpen(modulename.."/CampaignData/"..filename , "rt");
	
	if file == -1 then
		return false;
	end
	
	LuaMan:FileClose(file)
	return true;
end
-----------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------
function CF_IsFilePathExists(path)
	local file = LuaMan:FileOpen(path , "rt");
	
	--print (path .. " ".. file)
	
	if file == -1 then
		return false;
	end
	
	LuaMan:FileClose(file)
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





