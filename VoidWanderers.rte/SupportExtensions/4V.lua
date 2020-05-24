local paths = {}
if CF_IsFilePathExists("4V.rte/Artifact_4Vanilla.lua") then
	paths[#paths + 1] = "4V.rte/Artifact_4Vanilla.lua"

	for i = 1, #paths do
		print ("Support load: "..paths[i])
	end
else
	print ("MSG: 4V.rte support file loaded, but referenced file 4V.rte/Artifact_4Vanilla.lua was not found.")
end

return paths
