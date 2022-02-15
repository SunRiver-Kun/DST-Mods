GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(t,k) or GLOBAL.rawget(GLOBAL,k) end})

function SendClientRPC(name,...)
    SendModRPCToClient(CLIENT_MOD_RPC[modname][name], ThePlayer.userid,...)
end

--------------------------------Different
function AddServerCommand(fnname,fn)
    if fn and not GLOBAL.rawget(GLOBAL, fnname) then 
        GLOBAL.global(fnname)  --注册到global
        GLOBAL.rawset(GLOBAL, fnname, fn)
    else
        moderror("Server: This fnname is existed. ".. fnname)
    end
end

AddClientModRPCHandler(modname, "printf", function(str) print(str) end)
AddServerCommand("printf", function(...)
    local str = ""
    for _, v in pairs({...}) do
        str = str .. tostring(v) .. "\t"
    end
    if str=="" then str = "nil" end
    SendModRPCToClient(CLIENT_MOD_RPC[modname]["printf"], ThePlayer.userid, str)
end)

AddServerCommand("sr_print", function(...)
    local str = ""
    for _,v in pairs({...}) do
        str = str.."sr_print: "..tostring(v).."\n"
        if type(v)=="table" then
            for key, value in pairs(v) do
                str = str.."\t"..tostring(key).." "..tostring(value).."\n"
            end
        end
    end
    if str=="" then str = "nil" end
    printf(str)
end)

AddServerCommand("sr_say", function(str)
    if ThePlayer and ThePlayer.components.talker then 
        ThePlayer.components.talker:Say(tostring(str))
    else
        printf(str) 
    end 
end)

local lastinst = nil
AddServerCommand("sr_findinst", function (x,y,z)
    if x and y and z then
        local entitys = TheSim:FindEntities(x,y,z,1,{},{})
        lastinst = entitys and entitys[1] or nil
    else
        lastinst = nil
    end
    return lastinst
end)
AddClientModRPCHandler(modname, "sr_findinst", function() 
    local inst = s_get()
    if inst then
        local x,y,z = inst.Transform:GetWorldPosition()
        c_remote("sr_findinst("..x..","..y..","..z..")")
    else
        c_remote("sr_findinst()")
    end
end)
AddServerCommand("sr_get", function (guid)
    SendClientRPC("sr_findinst")
end)

AddServerCommand("sr_inst", function()
    return lastinst
end)

AddServerCommand("sr_show", function(tb)

end)

AddServerCommand("sr_data", function()

end)

AddClientModRPCHandler(modname, "sr_help", function() s_help() end)
AddServerCommand("sr_help", function ()
    SendClientRPC("sr_help")
    local help = "sr_xxx is similar to s_xxx.\n"..
        "Different:\n\tsr_get() will no return value;\n\tsr_inst() only return lastvalue.\n"..
        "Add:\n"..
        "\tsr_findinst(x,y,z): get the inst in world position.\n"..
        "\tprintf(...): print something to client, you can also use sr_print(...)."

    printf(help)
end)

-- same as s_xxx 

AddServerCommand("sr_component", function (comp)
    for name,value in pairs(comp) do
		if type(value) == "function" then
			local info = debug.getinfo(value,"LnS")
			printf(string.format("      %s = function - %s", name, info.source..":"..tostring(info.linedefined)))
		else
			if value and type(value) == "table" and value.IsValid and type(value.IsValid) == "function" then
                printf(string.format("      %s = %s (valid:%s)", name, tostring(value),tostring(value:IsValid())))
			else
                printf(string.format("      %s = %s", name, tostring(value)))
			end
		end
	end
end)

AddServerCommand("sr_entity",function (ent)
	printf("============================================ Dumping entity ",ent,"============================================")
	printf(ent.entity:GetDebugString())
	printf("--------------------------------------------------------------------------------------------------------------------")
	for name,value in pairs(ent) do
		if type(value) == "function" then
			local info = debug.getinfo(value,"LnS")
			printf(string.format("   %s = function - %s", name, info.source..":"..tostring(info.linedefined)))
		else
			if value and type(value) == "table" and value.IsValid and type(value.IsValid) == "function" then
			   printf(string.format("   %s = %s (valid:%s)", name, tostring(value),tostring(value:IsValid())))
			else
			   printf(string.format("   %s = %s", name, tostring(value)))
			end
		end
	end
	printf("--------------------------------------------------------------------------------------------------------------------")
	for i,v in pairs(ent.components) do
		printf("   Dumping component",i)
		DumpComponent(v)
	end
	printf("====================================================================================================================================")
end)

AddServerCommand("sr_upvalues",function (func)
	printf("============================================ Dumping Upvalues ============================================")
	local info = debug.getinfo(func, "nuS")
	printf(string.format("Upvalues (%d of 'em) for function %s defined at %s:%s", info.nups, tostring(info.name), tostring(info.source), tostring(info.linedefined)))
    for i = 1,math.huge do
        local name, v = debug.getupvalue(func,i)
        if name == nil then break end
        printf(string.format("%d:\t %s (%s) \t= %s", i,name,type(v),tostring(v)))
    end
	printf("--------------------------------------------------------------------------------------------------------------------")
end)

AddServerCommand("sr_fn", function(fn)
    local tb = debug.getinfo(fn,"S")
    if tb==nil then printf("sr_fn fails to get the info of fn") return end
    printf(fn,tb.what,tb.source)
end)


--Debug
AddServerCommand("sr_test", function()

end)