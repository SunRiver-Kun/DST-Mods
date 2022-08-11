name = "SR_DebugHelperExtension"
description = [[
This a mod for modmaker. It is very helpful for debug.
* The extension of SR_DebugHelper，run in server	SR_DebugHelper的扩展
* sr_xxx is similar to s_xxx()	sr_xxx和s_xxx相似
* sr_xxx remote server data, local client data  远程服务器数据，本地服务器数据
* Different:
	sr_inst() only return last value.	只返回上一次的数据
* Add:		
	sr_findinst(x,y,z): get the inst in world position.	返回坐标下的实体
	printf(...): print something to client  打印服务器信息到客户端
* Wait:  太难摆烂
	sr_show(), sr_data()	
]]
author = "SunRiver"
version = "1.2"
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

