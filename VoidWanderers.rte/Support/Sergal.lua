--print("W40K.lua")

local paths = {}
paths[#paths + 1] = "./Sergal.rte/Sergal.lua"

for i = 1, #paths do
	print ("Support load: "..paths[i])
end

return paths
