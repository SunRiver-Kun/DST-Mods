--请保证已一键GLOBAL
--[[    提示
    1. print出来的东西在，我的文档/Klei/DoNotStarveTogether[Rail]/client_log.txt
    2. 如果是开洞穴了，print的在，我的文档/Klei/DoNotStarveTogether[Rail]/xxx/Cluster_?/Master or Caves/backup/
]]
-- --加载官方代码
require("consolecommands")
require("debugcommands")
require("debughelpers") --DumpComponent、DumpEntity、DumpUpvalues
require("debugmenu")
require("debugtools")
require("util")

local lastinst = nil
local lastui = nil

local function emptyfn() end

function AddCommand(fnname,fn,params,ch_des,en_des)
    modassert(fnname and string.len(fnname)>2, "The fnname need to be len>2")
    if fn then 
        if GLOBAL.rawget(GLOBAL, fnname) then
            moderror("Client: This fnname is existed. ".. fnname)  --当不开洞穴且开有Extension时，优先用服务器的
        else
            GLOBAL.global(fnname)  --注册到global
            GLOBAL.rawset(GLOBAL, fnname, fn)
        end
    end
    params = params or ""
    ch_des = ch_des or ""
    en_des = en_des or ""
    SR_DEBUGCOMMAND[fnname] = params..(isChinese and ch_des or en_des)
    
end


--仅添加提示

AddCommand("TheSim")
AddCommand("TheInput")
AddCommand("TheNet")

AddCommand("TheInventory")
AddCommand("TheCraftingMenuProfile")
AddCommand("TheMixer")
AddCommand("TheCamera")
AddCommand("TheFrontEnd")
AddCommand("TheWorld")
AddCommand("ThePlayer")
AddCommand("AllPlayers")
AddCommand("TheRecipeBook")
AddCommand("TheCookbook")
--AddCommand("ThePlantRegistry")

AddCommand("components")

AddCommand("Transform")
AddCommand("AnimState")
AddCommand("Phiysics")
AddCommand("Light")
AddCommand("Network")
AddCommand("MiniMapEntity")
AddCommand("MiniMap")
AddCommand("SoundEmitter")

AddCommand("TUNING")
AddCommand("STRING")
AddCommand("CONSTANT")

--添加Extension的提示
AddCommand("sr_help")
AddCommand("sr_printf")
AddCommand("sr_say")
AddCommand("sr_findinst")
AddCommand("sr_get")
AddCommand("sr_inst")
AddCommand("sr_component")
AddCommand("sr_entity")
AddCommand("sr_upvalues")
AddCommand("sr_fn")

--添加官方代码
AddCommand("s_component", DumpComponent,"component:table, such as ThePlayer.components.talker","打印组件","Print component")
AddCommand("s_entity", DumpEntity,"entity:table, such as ThePlayer","打印实体","Print entity")    --几乎把所有entity的东西都打印出来了
AddCommand("s_upvalues", DumpUpvalues,"func:function ","打印函数的upvalues","Print the upvalues of fn")

--添加自定义函数

AddCommand("s_help", function ()
    print("--------------Help--------------")
    for i, k, v in sorted_pairs(SR_DEBUGCOMMAND) do
        if v~="" then 
            print(k,v)
        end
    end
    print("-------------EndHelp------------")
    return SR_DEBUGCOMMAND
end,nil,"显示所有的命令","Show all command")

AddCommand("s_say", function(str)
    if ThePlayer and ThePlayer.components.talker then 
        ThePlayer.components.talker:Say(tostring(str))
    else
        print(str) 
    end 
end,"str:string ","让角色说话","Let player says something")

AddCommand("s_get",function()
    lastinst = ConsoleWorldEntityUnderMouse()
    if lastinst then
        s_say(lastinst.prefab or lastinst)
    end 
    return lastinst
end,nil,"返回当前鼠标下的物体","Return the entity under mouse")

AddCommand("s_inst", function()
    return lastinst or s_get()
end,nil,"返回上一个获取的物体或鼠标下的物体","Return the last entity returned by s_get(), when nil return s_get()")

AddCommand("s_getui", function()
    TheFrontEnd:PopScreen() --必须先离开控制台界面
    lastui = #TheFrontEnd.screenstack>0 and TheFrontEnd.screenstack[#TheFrontEnd.screenstack]:GetDeepestFocus() or nil
    if lastui then
        s_say(lastui.name or lastui)
    end 
    return lastui
end,nil,"返回当前鼠标下的UI","Return the ui under mouse")

AddCommand("s_ui",function ()
    return lastui or s_getui()
end,nil,"返回上一个获取的UI或鼠标下的UI","Return the last ui returned by s_getui(), when nil return s_getui()")

AddCommand("s_fn",function (fn)
    local tb = debug.getinfo(fn,"S")
    if tb==nil then print("s_fn fails to get the info of fn") return end
    print(fn,tb.what,tb.source)
end,"fn:function ","打印一个函数的来源","Print the source of fn")

AddCommand("s_print",function(...)  
    local tb = {...}
    if #tb<1 then print("s_print: nil") return end
    for _, v in ipairs(tb) do
        print("s_print: "..tostring(v))
        if type(v)=="table" then
            for key, value in pairs(v) do
                print("\t"..key,value) 
            end
        end
    end
end,"... ","打印信息","Simple to print something")

AddCommand("s_show", function(tb) 
    if not SR_DEBUGMENU then print("Please make sure you enable debugmenu in config.") return end
    SR_DEBUGMENU:Clear()
    SR_DEBUGMENU:Show()
    if not tb then return end
    local vtype = type(tb)
    if vtype=="table" then
        SR_DEBUGMENU:Push(tb)
    elseif vtype=="function" then
        SR_DEBUGMENU:Push( getmetatable(tb) )
    elseif vtype=="userdata" then
        SR_DEBUGMENU:Push( getmetatable(tb) or {} ) 
    else 
        SR_DEBUGMENU:Push( {tb} ) 
    end
    
    if not SR_DEBUGMENU.bt_expand.isexpand then
        SR_DEBUGMENU.bt_expand.onclick()
    end

end,"tb:any ","***显示调试菜单，并可视化该表***","***Show debugmenu by param***")

AddCommand("s_data", function ()
    if not SR_DEBUGMENU then print("Please make sure you enable debugmenu in config.") return end
    return SR_DEBUGMENU:GetCurrentData()
end,nil,"返回当前调试菜单的对象 : table","Return current debug menu table")

--s_test 调试用，随便改  c_remote(fnstr) 直接偷渡
AddCommand("s_test",function(str)
    
end)