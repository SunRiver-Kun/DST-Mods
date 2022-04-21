name = "SR_DebugHelper"
description = [[
This a mod for modmaker. It is very helpful for write you mod. 

* Intellisense of code(s_xxx,sr_xxx) and some usual word(ThePlayer, TheSim, ...)
* Visual data: you can use s_show(data:any) to show data in UI and s_data() to return current data of s_show table
* Easy to get Entity: use s_get() to return the entity under mouse.   s_inst() to return the last data of s_get() or s_get() 
* Easy to get UI: use s_getui() to return the ui under mouse.  s_ui() return the last ui of s_getui() or s_getui()
* Easy to print
	s_print(tb:any) : to print a table or othr with a prefix "s_print"
	s_say(str:string) : let Theplayer say something
	s_component(component)
	s_entity(entity) -- not s_entity(ThePlayer.entity), but s_entity(ThePlayer)
	s_upvalues(fn)
	s_fn(fn)
* For help: use s_help()
* Only run in client. This means if not cave, it can get the data of server directly, 
	but get local data only when open cave or join other's world.
* For Cave, add the other mod "SR_DebugHelperExtension".  
]]
author = "SunRiver"
version = "1.2"
api_version_dst = 10
priority = 0
dst_compatible = true
client_only_mod = true
server_filter_tags = {}
icon_atlas = "modicon.xml"
icon = "modicon.tex"
forumthread = ""
deslog = ""

local function MakeColorOption(name,label,colors,index)
	return {name = name, label=label,hover="",options=colors, default=colors[index].data}
end

local Colors =		
{
	{ description="黄色 | YELLOW", data="YELLOW" },
	{ description="紫色 | PURPLE", data="PURPLE" },
	{ description="橙色 | ORANGE", data="ORANGE" },
	{ description="蓝色 | BLUE", data="BLUE" },
	{ description="红色 | RED", data="RED" },
	{ description="绿色 | GREEN", data="GREEN" },
	{ description="白色 | WHITE", data="WHITE" },
}

configuration_options =
{
	{
		name = "language",
		label = "Language",
		hover = "",
		options =		
			{
				{description = "中文", data = true, hover = ""},
				{description = "English", data = false, hover = ""},		
			},
		default = true,
	},
    {
		name = "isuseitemmenu",
		label = "Use debug menu",
		hover = "",
		options =		
			{
				{description = "Yes", data = true, hover = ""},
				{description = "No", data = false, hover = ""},		
			},
		default = true,
	},
	MakeColorOption("tablecolor","Table Color",Colors,1),
	MakeColorOption("functioncolor","Function Color",Colors,2),
	MakeColorOption("userdatacolor","Userdata Color",Colors,3),
	MakeColorOption("defaultcolor","Default Color",Colors,4),
}

