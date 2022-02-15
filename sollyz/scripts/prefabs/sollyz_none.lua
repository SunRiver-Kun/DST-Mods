local assets =
{

	Asset( "ANIM", "anim/sollyz.zip" ),
	Asset( "ANIM", "anim/ghost_sollyz_build.zip" ),
	
}

local skins =
{

	normal_skin = "sollyz",
	ghost_skin = "ghost_sollyz_build",
	
}

local base_prefab = "sollyz"

local tags = {"SOLLYZ", "BASE"}

return CreatePrefabSkin("sollyz_none",
{  --prefabskin.lua

	base_prefab = base_prefab, 
	skins = skins, 
	assets = assets,
	tags = tags,
	build_name_override = "sollyz",
	type = "base",
	rarity = "Character",
	bigportrait = { build = "bigportraits/sollyz_none.xml", symbol = "sollyz_none.tex"}, 
	
})
