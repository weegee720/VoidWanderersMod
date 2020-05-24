--print("W40K.lua")

local paths = {}
paths[#paths + 1] = "RCM.rte/UL2 Faction File/RCM.lua"

for i = 1, #paths do
	print ("Support load: "..paths[i])
end

return paths
