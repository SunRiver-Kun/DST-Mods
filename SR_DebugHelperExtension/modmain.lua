GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(t,k) or GLOBAL.rawget(GLOBAL,k) end})

modimport("scripts/helpers")  

local function GetTableStr(tb)
    -- key=value:type,
    local str = ""
    local vtype = nil
    local vstr = ""
    for k, v in pairs(tb) do
        modassert(type(k)=="string" or type(k)=="number","The key of table must be string or number!")
        vtype = type(v)
        if vtype=="table" then
            vstr = " :table"
        elseif vtype=="function" then
            vstr = " :function"
        elseif vtype=="userdata" then
            vstr = " :userdata"
        else
            vstr = tostring(v)..":"..vtype
        end
        str = str..tostring(k).."="..vstr..","
    end

    local meta = getmetatable(tb)
    if meta then
        for k, v in pairs(meta) do
            modassert(type(k)=="string" or type(k)=="number","The key of table must be string or number!")
            vtype = type(v)
            if vtype=="table" then
                vstr = " :table"
            elseif vtype=="function" then
                vstr = " :function"
            elseif vtype=="userdata" then
                vstr = " :userdata"
            else
                vstr = tostring(v)..":"..vtype
            end
            str = str..tostring(k).."="..vstr..","
        end
    end
    return str
end

-------------------------------For sr_show
AddModRPCHandler(modname, "Menu_Clear", function(player) 

end)

AddModRPCHandler(modname, "Menu_Pop", function(player) 

end)

-- local tbstack = {}
-- AddModRPCHandler("sr_debughelperextension", "changevalue", function (player,key,value)
--     if #tbstack==0 then return end
--     local tb = tbstack[#tbstack]
--     tb[key] = value
-- end)
-- AddModRPCHandler("sr_debughelperextension", "push", function (player,key)
--     if #tbstack==0 then return end
--     local tb = tbstack[#tbstack]
--     local vtype = type(tb[key])
--     if vtype=="table" then

--     elseif vtype=="function" then

--     elseif vtype=="userdata" then

--     end
-- end)
-- AddClientModRPCHandler("sr_debughelperextension", "push",function (str)
--     local SR_DEBUGMENU = ThePlayer and ThePlayer.SR_DEBUGMENU
--     if SR_DEBUGMENU then
        
--     end
-- end)
-- AddModRPCHandler("sr_debughelperextension", "pop", function ()
--     if #tbstack==0 then return end
--     local tb = tbstack[#tbstack]
--     tb[key] = value
-- end)