name = "SR_DebugHelper"
description = "SunRiver Make this for debug mod."
author = "SunRiver"
version = "1.1"
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

