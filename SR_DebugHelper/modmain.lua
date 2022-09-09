GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})	

Assets = {
    Asset( "IMAGE", "images/sr_white.tex" ),	
    Asset( "ATLAS", "images/sr_white.xml" ),
}

require("constants")
--控制台
SR_DEBUGCOMMAND = {}
SR_DEBUGMENU = nil
isUseDebugMenu = GetModConfigData("isuseitemmenu")
isChinese = GetModConfigData("language")

modimport("scripts/helpers")  

AddClassPostConstruct("screens/consolescreen",function (self)   
    --追加提示
    local dictionarys = {}
    for k,v in pairs(SR_DEBUGCOMMAND) do 
        local delim = k:sub(1,2)
        local word = k:sub(3)
        if not dictionarys[delim] then
            dictionarys[delim] = {}
        end
        table.insert(dictionarys[delim], word)
    end
    for delim, words in pairs(dictionarys) do
        self.console_edit:AddWordPredictionDictionary({words = words, delim = delim, num_chars = 0})
    end
-------------- sr_get
    local Run = self.Run
    self.Run = function (self)
        local fnstr = self.console_edit:GetString()
        if string.find(fnstr,"sr_get") then    --self.toggle_remote_execute and
            local inst = s_get()
            if inst then
                local x,y,z = inst.Transform:GetWorldPosition()
                c_remote("sr_findinst("..x..","..y..","..z..")")
            else
                c_remote("sr_findinst()")
            end
        end
        Run(self)
    end
end)

if isUseDebugMenu then
    local colors = {
        tablecolor = PLAYERCOLOURS[GetModConfigData("tablecolor")] or {1,1,1,1} ,
        functioncolor = PLAYERCOLOURS[GetModConfigData("functioncolor")] or {1,1,1,1} ,
        userdatacolor = PLAYERCOLOURS[GetModConfigData("userdatacolor")] or {1,1,1,1} ,
        defaultcolor = PLAYERCOLOURS[GetModConfigData("defaultcolor")] or {1,1,1,1} 
    }

    AddClassPostConstruct("widgets/controls",function (self)
        local root = self:AddChild(require("widgets/widget")())
        root:SetHAnchor(ANCHOR_MIDDLE)
        root:SetVAnchor(ANCHOR_MIDDLE)
        root:SetScaleMode(SCALEMODE_PROPORTIONAL)
        SR_DEBUGMENU = root:AddChild(require("widgets/sr_debugmenu")(colors))
        SR_DEBUGMENU:Hide()
    end)
end

if GetModConfigData("autododmode") then
    AddPlayerPostInit(function (player)
        c_select(player)
        c_godmode()
        c_freecrafting()
    end)	
end