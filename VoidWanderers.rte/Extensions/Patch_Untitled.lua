if PresetMan:GetModuleID("Untitled.rte") ~= -1 then
	function CF_MakeItem2(item, class)
		--print ("CF_MakeItem2 - PATCHED")
		-- print ("CF_MakeItem")
		if class == nil then
			class = "HDFirearm"
		end
		
		if class == "HeldDevice" then
			return CreateHeldDevice(item)
		elseif class == "HDFirearm" then
			if item == "Laser Rifle" then
				return CreateHDFirearm(item, "Untitled.rte")
			else
				if item == "Pistol" then
					return CreateHDFirearm(item, "Coalition.rte")
				else
					return CreateHDFirearm(item)
				end
			end
		elseif class == "TDExplosive" then
			return CreateTDExplosive(item)
		elseif class == "ThrownDevice" then
			return CreateThrownDevice(item)
		end
		
		return nil;
	end
end