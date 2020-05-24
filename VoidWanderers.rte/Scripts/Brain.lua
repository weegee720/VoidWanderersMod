dofile("VoidWanderers.rte/Scripts/Brain_Create.lua")
dofile("VoidWanderers.rte/Scripts/Brain_Update.lua")

function Create(self)
	do_rpgbrain_create(self)
end

function Update(self)
	do_rpgbrain_update(self)
end
