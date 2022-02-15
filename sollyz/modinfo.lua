-- This information tells other players more about the mod
name = " 猫妹子300"
description = [[
更新日志：
修复划船时可能崩溃的bug
测试版本(完成度7/16)，可在设置里面开启，技能介绍见于mods/...(尾号5155)/information/skills_information.txt

*爱吃鱼的猫妹子
*自带钓鱼竿和发夹
*身手灵敏，好运相伴
*可夜视和改变鱼杆钓鱼速度]]

author = "Sollyz and Haruz	 , Sunriver"
version = "2.6"

-- This is the URL name of the mod's thread on the forum; the part after the ? and before the first & in the url
--forumthread = "/files/file/950-extended-sample-character/"


-- This lets other players know if your mod is out of date, update it to match the current version in the game
api_version = 10

dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
all_clients_require_mod = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"

local KEY = {	--8个
"R","H","Z","X","C","V","T","B"
}
local key ={
	{"TAB",9},
	{"SHIFT",402},
	{"CTRL",401},
	{"ALT",400},
	{"CAPSLOCK",301}
}
local string = ""
for i = 1, #KEY do
    KEY[i] = {description = KEY[i], data = string.lower(KEY[i]):byte()}	--见constans.lua里的数值
end
for i=1,#key do	--8+5=13
	KEY[8+i] = {description = key[i][1], data = key[i][2],hover = "应该避免热键冲突！"}
end
for i=1,8 do
	KEY[13+i] = {description ="F"..i , data = 281 +i}
end

local function Addoptions(name,label,hover,options,default)
	return {name = name , label = label , hover = hover , options = options, default = default}
end

configuration_options = {
	{
		name = "isspeech_sollyz",
		label = "选择speech",
		hover = "检查时说的话",
		options =		
			{
				{description = "本喵", data = true, hover = "这个可不是轻松的活,欢迎去speech_sollyz里进行补充"},
				{description = "原版", data = false, hover = "其实原版是没有加载speech_sollyz..."},		
			},
		default = true,
	},
	
	Addoptions("KEY_R","圆轮选择","圆轮按下会出现技能圆表，不启用测试版本则只是改变原本R键的位置",KEY,114),
	Addoptions("KEY_H","部分主动技能按键选择","包括：夜视，",KEY,104),

	{
		name = "isbeta",
		label = "测试版本",
		hover = "注：可能存在某些未知bug，测试版本包括全技能开启...",
		options =		
			{
				{description = "是", data = true, hover = "如发现某些bug，欢迎到评论区里留言"},
				{description = "否", data = false, hover = "对之前的版本没什么影响"},		
			},
		default = false,
	},
	
}
