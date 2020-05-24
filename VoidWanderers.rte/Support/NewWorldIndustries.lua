--print("W40K.lua")

local paths = {}
paths[#paths + 1] = "NewWorldIndustries.rte/UnmappedLands2/NWI.lua"

for i = 1, #paths do
	print ("Support load: "..paths[i])
end

return paths
