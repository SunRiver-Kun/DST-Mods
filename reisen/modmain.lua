PrefabFiles = {

	"reisen",
	"reisen_none",
	
}

Assets = {

    Asset( "IMAGE", "images/saveslot_portraits/reisen.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/reisen.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/reisen.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/reisen.xml" ),
	
    Asset( "IMAGE", "images/selectscreen_portraits/reisen_silho.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/reisen_silho.xml" ),

    Asset( "IMAGE", "bigportraits/reisen.tex" ),
    Asset( "ATLAS", "bigportraits/reisen.xml" ),
	
	Asset( "IMAGE", "images/map_icons/reisen.tex" ),
	Asset( "ATLAS", "images/map_icons/reisen.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_reisen.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_reisen.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_ghost_reisen.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_reisen.xml" ),
	
	Asset( "IMAGE", "images/avatars/self_inspect_reisen.tex" ),
    Asset( "ATLAS", "images/avatars/self_inspect_reisen.xml" ),
	
	Asset( "IMAGE", "images/names_reisen.tex" ),
    Asset( "ATLAS", "images/names_reisen.xml" ),
	
    Asset( "IMAGE", "bigportraits/reisen_none.tex" ),
    Asset( "ATLAS", "bigportraits/reisen_none.xml" ),

}

GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})	

modimport("scripts/skills_reisen.lua")

STRINGS.CHARACTER_TITLES.reisen = "The Moon Rabbit"
STRINGS.CHARACTER_NAMES.reisen = "Reisen"
STRINGS.CHARACTER_DESCRIPTIONS.reisen = "*Lunatic\n*Insomniac\n*Carrot Addict"
STRINGS.CHARACTER_QUOTES.reisen = "\"I'm just a little bunny, only good for my appeal.\""

STRINGS.CHARACTERS.REISEN = require "speech_reisen"

STRINGS.NAMES.REISEN = "Reisen"

--选人界面人物三维显示
TUNING.REISEN_HEALTH = 300
TUNING.REISEN_HUNGER = 200
TUNING.REISEN_SANITY = 100

-- --生存几率
-- STRINGS.CHARACTER_SURVIVABILITY.reisen = "~等级达到300时，生存已经不是任何问题~"

TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.REISEN = {"manrabbit_tail", "carrot_seeds", "healingsalve", }

AddMinimapAtlas("images/map_icons/reisen.xml")

AddModCharacter("reisen", "FEMALE")

-- Character Mod Made By: Senshimi [http://steamcommunity.com/id/Senshimi/]
