--print("W40K.lua")

local paths = {}
paths[#paths + 1] = "./TSA.rte/weegee Scene Mod files/Void Wanderers/TSA.lua"

for i = 1, #paths do
	print ("Support load: "..paths[i])
end

return paths
