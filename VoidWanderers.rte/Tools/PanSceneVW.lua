-- A simple and dumb script that moves all objects and areas of the scene's DAT file.
-- Script arguments
-- Input scene file
--local input = "SceneName.dat.original"
local input = "..\\Scenes\\Data\\Abandoned Gryphon Vessel.dat.original"
-- Resulting scene file. Those CAN NOT be the same. If they're the same original file MAY BE LOST!
--local output = "SceneName.dat"
local output = "..\\Scenes\\Data\\Abandoned Gryphon Vessel.dat"
-- How many blocks to move horizontally. 1 block = 12px. Positive values move to the right, negative
-- to the left
local blocksx = 10000
-- How many blocks to move vaertically. Positive values move upwards, negative downwards
local blocksy = 0
-- END OF USER SERVICEABLE PART!!!

io = require("io");

local f = io.open(output , "w");

local px = blocksx * 12;
local py = blocksy * 12;

for line in io.lines(input) do
	local pos;
	local num;
	
	pos = string.find(line, "X=")
	if pos ~= nil then
		num = tonumber(string.sub(line, pos + 2, #line))
		num = num + px;
		line = string.sub(line, 1, pos + 1)..tostring(num)
	end

	pos = string.find(line, "Y=")
	if pos ~= nil then
		num = tonumber(string.sub(line, pos + 2, #line))
		num = num + py;
		line = string.sub(line, 1, pos + 1)..tostring(num)
	end
	
	f:write(line.."\n");
end

f:close()