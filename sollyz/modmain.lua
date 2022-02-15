
PrefabFiles = {
	"sollyz",
	"sollyz_none",
	"nohat",
	"sollyz_greencane",
	"greencane_plant_fx"
}

Assets = {
    Asset( "IMAGE", "images/saveslot_portraits/sollyz.tex" ),	--存档图片
    Asset( "ATLAS", "images/saveslot_portraits/sollyz.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/sollyz.tex" ),	--单机选人界面
	Asset( "ATLAS", "images/selectscreen_portraits/sollyz.xml" ),
	
	Asset( "IMAGE", "images/selectscreen_portraits/sollyz_silho.tex" ),	--单机选人界面
    Asset( "ATLAS", "images/selectscreen_portraits/sollyz_silho.xml" ),

    Asset( "IMAGE", "bigportraits/sollyz.tex" ),	--人物大图（方形的那个）
    Asset( "ATLAS", "bigportraits/sollyz.xml" ),
	
	Asset( "IMAGE", "images/map_icons/sollyz.tex" ),	--小地图
	Asset( "ATLAS", "images/map_icons/sollyz.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_sollyz.tex" ),	--人物列表显示的头像
    Asset( "ATLAS", "images/avatars/avatar_sollyz.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_ghost_sollyz.tex" ),	--人物列表显示的头像（死亡）
	Asset( "ATLAS", "images/avatars/avatar_ghost_sollyz.xml" ),
	
	Asset( "IMAGE", "images/avatars/self_inspect_sollyz.tex" ),	--自检
    Asset( "ATLAS", "images/avatars/self_inspect_sollyz.xml" ),
	
	Asset( "IMAGE", "images/names_sollyz.tex" ),	--名字
	Asset( "ATLAS", "images/names_sollyz.xml" ),
	
	Asset( "IMAGE", "bigportraits/sollyz_none.tex" ),  --人物大图（椭圆的那个）
    Asset( "ATLAS", "bigportraits/sollyz_none.xml" ),
	
	--自定义初始装备
	Asset("IMAGE", "images/inventoryimages/nohat.tex"),
	Asset("ATLAS", "images/inventoryimages/nohat.xml"),


}
for i=1,16 do --一定记得插入图片和信息
	table.insert(Assets,Asset("IMAGE", "images/buttonimages/button"..i..".tex"))
	table.insert(Assets,Asset("ATLAS", "images/buttonimages/button"..i..".xml"))
end


---[[	R轮设计
TUNING.sollyz_key_r	= GetModConfigData("KEY_R")		 
TUNING.sollyz_key_h	= GetModConfigData("KEY_H")		
TUNING.sollyz_isbeta = GetModConfigData("isbeta")		

GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})		--一键GLOBAL

if  TUNING.sollyz_isbeta  then	--保证旧版不会出现R轮等

modimport("scripts/prefabs/API_prefabs")
--modimport("scripts/components/API_components.lua")	--改变官方组件
modimport("scripts/wheel")  --写在skills_sollyz后面
end
---]]


-- The character select screen lines,
STRINGS.CHARACTER_TITLES.sollyz = "猫妹子"
STRINGS.CHARACTER_NAMES.sollyz = "Sollyz"
STRINGS.CHARACTER_DESCRIPTIONS.sollyz = "*爱吃鱼的猫妹子\n*自带钓鱼竿和发夹\n*身手灵敏，好运相伴\n*可夜视和改变鱼杆钓鱼速度"
STRINGS.CHARACTER_QUOTES.sollyz = "\"我爱胆小狗就像爱鱼一样!\""

-- Custom speech strings
if GetModConfigData("isspeech_sollyz") then	--是否加载本喵
	STRINGS.CHARACTERS.SOLLYZ = require "speech_sollyz"		--speech	
end

-- The character's name as appears in-game 
STRINGS.NAMES.SOLLYZ = "Sollyz"	--如果是代码直接打出来就叫这名字

--皮肤
GLOBAL.PREFAB_SKINS["sollyz"] = {  
	"sollyz_none",
}

STRINGS.SKIN_NAMES.sollyz_none = "SOLLYZ"  
STRINGS.SKIN_DESCRIPTIONS.sollyz_none = "基本皮肤"
STRINGS.SKIN_QUOTES.sollyz_none = "\"我爱胆小狗就像爱鱼一样!\""

--选人界面人物三维显示
TUNING.SOLLYZ_HEALTH = 100
TUNING.SOLLYZ_HUNGER = 150
TUNING.SOLLYZ_SANITY = 90

--生存几率
STRINGS.CHARACTER_SURVIVABILITY.sollyz = "~等级达到300时，生存已经不是任何问题~"

--选人界面初始物品显示
TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.SOLLYZ = {"fishingrod","nohat"}

TUNING.STARTING_ITEM_IMAGE_OVERRIDE["nohat"] = {	--应该是自定义物品，所以要定位一下图片位置
	atlas = "images/inventoryimages/nohat.xml",
	image = "nohat.tex",
}

AddModCharacter("sollyz", "FEMALE")
AddMinimapAtlas("images/map_icons/sollyz.xml")

----------------------------------------------配方
--GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})
--猫妹子的发夹
local nohatrecipe=AddRecipe("nohat", 	
{Ingredient("butterflywings", 4),Ingredient("petals", 2)},  
RECIPETABS.DRESS,  TECH.NONE,  
nil, nil, nil, 1, "sollyz",  --是否有placer  是否有放置的间隔  科技锁  制作的数量（改成2就可以一次做两个） 需要的标签（比如女武神的配方需要女武神的自有标签才可以看得到）
"images/inventoryimages/nohat.xml",  --配方的贴图（跟物品栏使用同一个贴图）
"nohat.tex")
nohatrecipe.sortkey = AllRecipes.flowerhat.sortkey - 0.1
STRINGS.NAMES.NOHAT = "猫妹子的发夹"
STRINGS.CHARACTERS.SOLLYZ.DESCRIBE.NOHAT = "那是来着姐姐的礼物"		--特定人物检查时说的话
STRINGS.CHARACTERS.GENERIC.DESCRIBE.NOHAT = "多么可爱，多么迷人"
STRINGS.RECIPE_DESC.NOHAT = "伴有淡淡花香的发夹" 	--物品栏上的介绍文字
--自然手杖
STRINGS.NAMES.SOLLYZ_GREENCANE = "自然手杖"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SOLLYZ_GREENCANE = "运用大自然的力量！"
-----------------------------------------------其他改变


