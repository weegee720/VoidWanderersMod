--print("W40K.lua")

local paths = {}
paths[#paths + 1] = "./HELL.rte/Faction file/muilaak.lua"

for i = 1, #paths do
	print ("Support load: "..paths[i])
end

return paths
