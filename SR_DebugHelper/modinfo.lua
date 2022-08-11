name = "SR_DebugHelper"
description = [[
!Only run in client(no cave), for cave add mod SR_DebugHelperExtension!
This a mod for modmaker. It is very helpful for debug. 
* Intellisense of code	代码提示
* Visual data:	可视化数据
	s_show(data:any)  show data 显示数据
 	s_data()  return showing data  返回数据
* Get Entity:  返回实体
	s_get()  return the entity under mouse. 返回鼠标下实体   
	s_inst() return the last data or s_get()  返回上一个或鼠标下实体
* Get UI: 返回UI
	s_getui() return the ui under mouse.  返回鼠标下UI
	s_ui() return the last ui or s_getui() 返回上一个或鼠标下UI
* Print:  打印
	s_print(tb:any)  print a table or othr with a prefix "s_print"
	s_say(str:string)  player say something	 玩家说话
	s_component(component)	print the detail of component
	s_entity(entity)  print a entity, such as s_entity(ThePlayer) 
	s_upvalues(fn)	print the upvalues of function
	s_fn(fn)  print the source of function
* Help:  帮助 
	s_help()
* Note: 注意
	no cave:
		s_get -> get the data of server	获取服务器数据
		s_getui  -> get the ui of client
	cave:
		s_get -> get the data of client  获取客户端数据
		s_getui  -> get the ui of client
]]
author = "SunRiver"
version = "1.3"
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
	{
		name = "autododmode",
		label = "godmode",
		hover = "上帝模式和物品全制作",
		options =		
			{
				{description = "Yes", data = true, hover = ""},
				{description = "No", data = false, hover = ""},		
			},
		default = false,
	},
	MakeColorOption("tablecolor","Table Color",Colors,1),
	MakeColorOption("functioncolor","Function Color",Colors,2),
	MakeColorOption("userdatacolor","Userdata Color",Colors,3),
	MakeColorOption("defaultcolor","Default Color",Colors,4),
}

