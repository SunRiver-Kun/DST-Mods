name = "SR_DebugHelperExtension"
description = [[
This a mod for modmaker. It is very helpful for write you mod.
* This mod is the extension of SR_DebugHelper. It run in server and can get the server data correctly
* most of commands are same as s_xxx() but prefix is sr, such as sr_help()
* the sr_commands usually run in remote, but lisk s_commands in local
* Different:
	sr_get() will no return value
	sr_inst() only return last value.
* Add:	
	sr_findinst(x,y,z): get the inst in world position.
	printf(...): print something to client, you can also use sr_print(...).
* Wait:
	sr_show(), sr_data()	--It's difficult to change the server's value in client. I will try... 
]]
author = "SunRiver"
version = "1.1"
api_version_dst = 10
priority = 0
dst_compatible = true
client_only_mod = false
server_filter_tags = {}
icon_atlas = "modicon.xml"
icon = "modicon.tex"
forumthread = ""
deslog = ""

configuration_options =
{
	-- {
	-- 	name = "language",
	-- 	label = "Language",
	-- 	hover = "",
	-- 	options =		
	-- 		{
	-- 			{description = "中文", data = true, hover = ""},
	-- 			{description = "English", data = false, hover = ""},		
	-- 		},
	-- 	default = true,
	-- },
}

