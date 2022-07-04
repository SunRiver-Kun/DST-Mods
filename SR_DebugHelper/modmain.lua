GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(t,k) or GLOBAL.rawget(GLOBAL,k) end})

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
    for k,v in pairs(SR_DEBUGCOMMAND) do 
        local delim = k:sub(1,2)
        local word = k:sub(3)
 
        local issame = false  --判断前缀是否存在
        local olddic = self.console_edit.prediction_widget.word_predictor.dictionaries
        for i,d in pairs(olddic) do 
            if d.delim == delim then
                issame = true
                if not table.contains(d.words, word) then 
                    table.insert(d.words,word)
                end
                break
            end
        end
            
        if not issame then
                self.console_edit:AddWordPredictionDictionary({delim=delim,words={word}})
        end
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

AddClassPostConstruct("screens/consolescreen",function (self)
    
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