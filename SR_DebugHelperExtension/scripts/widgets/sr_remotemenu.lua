require("util")
local Widget = require("widgets/widget")
local Text = require("widgets/text")
local ImageButton = require("widgets/imagebutton")
local TextButton = require("widgets/textbutton")
local TextEdit = require("widgets/textedit")
local ScrollableList = require("widgets/scrollablelist")
local SR_InputScreen = require("screens/sr_inputscreen")

local function RGB(r, g, b, a)
    return { r / 255, g / 255, b / 255, a or 1 }
end

local function emptyfn()
end

local function compare(a,b)
    return tostring(a) < tostring(b)
end

--默认key构造器
local function GetKeys(tb,comp)
    local keys = {}
    comp = comp or compare
    --pairs don't get the metatable
    for k,v in pairs(tb) do
        table.insert(keys,k)
    end

    local props = rawget(tb, "_")
    if props then
        for k, v in pairs(props) do
            table.insert(keys,k)
        end
    end

    table.sort(keys,comp)

    local meta = getmetatable(tb)
    if meta then
        for k,v in pairs(meta) do
            table.insert(keys, k)
        end
    end

    return keys
end

local function GetTextButton(str,w,h,fontsize,color,fn)
    local widget = TextButton()
    widget.text:SetSize(fontsize)
    widget.text:SetHAlign(ANCHOR_LEFT)
    widget.text:SetRegionSize(w,h)
    
    widget:SetTextFocusColour(color) 
    widget:SetTextColour(color[1],color[2],color[3],0.9)
    
    widget:SetText(str)
    widget:SetOnClick(fn)

    return widget
end

local function GetTabelButton(self,showstr,addstr,tb,color)
    return GetTextButton(showstr, self.scrollitemsize.x, self.scrollitemsize.y, self.textsize, color, function ()
        self.text:SetString(self.text:GetString().."."..addstr)
        self:Push(tb)
    end)
end

local function GetDataButton(self,str,color,tb,k,callback)
    return GetTextButton(str,self.scrollitemsize.x, self.scrollitemsize.y, self.textsize, color,function ()
        TheFrontEnd:PushScreen( SR_InputScreen(tb,k,callback) )
    end)
end

local default_colors = {
    tablecolor = RGB(222, 222, 99 ),
    functioncolor = RGB(125, 81,  156),
    userdatacolor = RGB(208, 120, 86) ,
    defaultcolor = RGB(149, 191, 242)
}

local SR_RemoteMenu = Class(Widget,function (self,colors)
    Widget._ctor(self, "SR_RemoteMenu")

    self.colors = colors or default_colors
    self:DoInit()
end)

function SR_RemoteMenu:DoInit()

    self.stack = nil

    self.scrollitemsize = Vector3(400,40)
    self.textsize = 30
    
    local scrollpadding = 5
    local buttonsize = Vector3(self.scrollitemsize.x/6.0, RESOLUTION_Y*0.1) 
    local searchtextsize = Vector3(buttonsize.x*6, buttonsize.y*0.7)
    local x = buttonsize.x/2 - self.scrollitemsize.x
    local y = RESOLUTION_Y*0.45

    self.scroll_list = self:AddChild( ScrollableList({},self.scrollitemsize.x,RESOLUTION_Y*0.8,self.scrollitemsize.y,scrollpadding,nil,nil,nil,nil,nil,nil,nil,nil,"GOLD") )
    local old_OnGainFocus = self.scroll_list.OnGainFocus
    local old_OnLoseFocus = self.scroll_list.OnLoseFocus
    self.scroll_list.OnGainFocus = function (scroll_list)
        if TheCamera then 
            TheCamera:SetControllable(false)
        end   
        old_OnGainFocus(scroll_list)
    end
    self.scroll_list.OnLoseFocus = function (scroll_list)
        if TheCamera then 
            TheCamera:SetControllable(true)
        end   
        old_OnLoseFocus(scroll_list)
    end
    
    self.bt_return = self:AddChild(ImageButton("images/hud.xml","turnarrow_icon.tex"))
    self.bt_return:SetRotation(180)
    self.bt_return:ForceImageSize(buttonsize.x, buttonsize.y)
    self.bt_return:SetPosition(x, y)
    self.bt_return:SetOnClick(function ()
        self:Pop()
    end)

    x = x + buttonsize.x
    self.bt_refresh = self:AddChild(ImageButton("images/avatars.xml","loading_indicator.tex"))
    self.bt_refresh:ForceImageSize(buttonsize.x, buttonsize.y)
    self.bt_refresh:SetPosition(x, y)
    self.bt_refresh:SetOnClick(function ()
        self:RefreshInput()
        self:ShowTop(0)
    end)

    x = x + buttonsize.x
    self.bt_expand = self:AddChild(ImageButton("images/hud.xml","turnarrow_icon.tex"))
    self.bt_expand.isexpand = true
    self.bt_expand:SetRotation(90)
    self.bt_expand:ForceImageSize(buttonsize.x, buttonsize.y)
    self.bt_expand:SetPosition(x, y)
    self.bt_expand:SetOnClick(function ()
        self.bt_expand.isexpand = not self.bt_expand.isexpand
        if self.bt_expand.isexpand then
            self.bt_expand:SetRotation(90)
            self.scroll_list:Show()
        else
            self.bt_expand:SetRotation(270)
            self.scroll_list:Hide()
        end
    end)

    x = x + buttonsize.x/2 + searchtextsize.x/2
    self.tx_search = self:AddChild( TextEdit(BODYTEXTFONT,self.textsize,"") )
    self.tx_search:SetIdleTextColour(1,1,1,1)
    self.tx_search:SetEditTextColour(1,1,1,1)
    self.tx_search:SetEditCursorColour(0,0,0,1)
    self.tx_search:SetTextLengthLimit( searchtextsize.x )
    self.tx_search:EnableRegionSizeLimit(true)
    self.tx_search:SetAllowNewline(false) 
    self.tx_search:SetRegionSize(searchtextsize.x,searchtextsize.y)
    self.tx_search:SetPosition(x,y)
    self.tx_search.OnTextEntered = function (str)
        self:Search(str)
    end
    self.tx_search.bg = self.tx_search:AddChild( Image("images/sr_white.xml","sr_white.tex") )
    self.tx_search.bg:ScaleToSize(searchtextsize.x,searchtextsize.y)
    self.tx_search.bg:SetTint(0.5,0.5,0.5,0.5)
    self.tx_search.bg:MoveToBack()

    x = x + buttonsize.x/2 + searchtextsize.x/2
    self.bt_search = self:AddChild( ImageButton("images/hud.xml","magnifying_glass_off.tex") )
    self.bt_search:ForceImageSize(buttonsize.x, buttonsize.y)
    self.bt_search:SetPosition(x,y)
    self.bt_search:SetOnClick( function ()
        self.tx_search:OnProcess() 
    end)

    self.text = self:AddChild( Text(BODYTEXTFONT, self.textsize, "?") )
    self.text:SetHAnchor(ANCHOR_MIDDLE)
    self.text:SetVAnchor(ANCHOR_TOP)
    self.text:SetPosition(0,-self.textsize-5)
end

function SR_RemoteMenu:Search(str)
    if not ( self.stack and #self.stack>0 ) then return end 
    local source = self.stack[#self.stack]

    if not str or str=="" or str=="." then
        self:ShowTop(0)
    end

    local newkeys = {}
    for _,k in pairs(source.keys) do 
        if string.find(tostring(k), str) then 
            table.insert(newkeys, k)
        end
    end
    self:RefreshInput()
    self:ShowTop(0,newkeys)

end

function SR_RemoteMenu:ScrollToTop()
    self.scroll_list:Scroll( -self.scroll_list.view_offset, true) 
end

function SR_RemoteMenu:ScrollTo(offset)
    self.scroll_list:Scroll(offset - self.scroll_list.view_offset, true)
end

function SR_RemoteMenu:TableToWidgets(tb,keys)
    modassert(tb and type(tb)=="table", "TableToWidgets: tb is a table")
    keys = keys or GetKeys(tb)
    local widgets = {}
    local callback = function ()
        self:RefreshScroll()
    end

    for _,k in pairs(keys) do
        local v = tb[k]
        local vtype = type(v)
        if vtype=="table" then
            table.insert(widgets, GetTabelButton(self, "> "..tostring(k).." : "..vtype, tostring(k), v, self.colors.tablecolor))
        elseif vtype=="function" then
            table.insert(widgets, GetTabelButton(self, "> "..tostring(k).." : "..vtype, tostring(k), debug.getinfo(v), self.colors.functioncolor))
        elseif vtype=="userdata" then
            local meta = getmetatable(v)
            if meta then 
                table.insert(widgets, GetTabelButton(self, "> "..tostring(k).." : "..vtype, tostring(k), meta, self.colors.userdatacolor))
            end
        else
            local str = ( type(k)=="number" and "["..k.."]" or tostring(k) ).." = "..tostring(v)
            str = str .. "\t : " .. vtype
            table.insert(widgets, GetDataButton(self, str, self.colors.defaultcolor, tb, k, callback))
        end
    end

    return widgets,keys
end

function SR_RemoteMenu:GetCurrentData()
    return self.stack and #self.stack>0 and self.stack[#self.stack].data or nil
end

function SR_RemoteMenu:ShowTop(pos,keys)
    if not (self.stack and #self.stack > 0 ) then return end
    local source = self.stack[#self.stack]
    local widgets,newkeys = self:TableToWidgets(source.data,keys)
    source.keys = newkeys
    self.scroll_list:SetList(widgets)
    if pos then
        self:ScrollTo(pos)
    end
end

function SR_RemoteMenu:Push(tb,keys)
    local widgets,showkeys = self:TableToWidgets(tb,keys)
    self:PushWidgets(widgets,showkeys)
    if not self.stack then self.stack = {} end
    if #self.stack>0 then
        self.stack[#self.stack].scrollpos = self.scroll_list.view_offset
    end  
    self.stack[#self.stack+1] = { data = tb, scrollpos = 0, keys = showkeys, basekeys = keys}
    self.scroll_list:SetList(widgets)
    self:ScrollToTop()   --回到最上面
end

function SR_RemoteMenu:Pop()
    if not self.stack then self:Hide() return end
    self.stack[#self.stack] = nil
    if #self.stack>0 then
        local source = self.stack[#self.stack]
        self:ShowTop(source.scrollpos)
        local str = self.text:GetString()
        local pos = string.rfind(str,".",1,true)    --最后一个参数，关掉模糊匹配
        str = string.sub(str, 1, pos and pos-1 or nil)  
        self.text:SetString(str)
    else
        self:Clear()
        self:Hide()
    end
    SendModRPCToServer(MOD_RPC[modname]["Menu_Pop"])
end

function SR_RemoteMenu:Clear()
    self.text:SetString("?")
    self.stack = nil
    self.scroll_list:Clear()
    SendModRPCToServer(MOD_RPC[modname]["Menu_Clear"])
end

function SR_RemoteMenu:RefreshInput()
    self.tx_search:SetString("")
    self.tx_search:SetEditing(false)
    TheInputProxy:FlushInput()
end

function SR_RemoteMenu:RefreshScroll()
    if not (self.stack and #self.stack > 0 ) then return end
    local source = self.stack[#self.stack]
    local widgets = self:TableToWidgets(source.data,source.keys)
    self.scroll_list:SetList(widgets)
end

--------------------------for extension
function SR_RemoteMenu:GetTableFromStr(str)
    -- key=value:type,...,
    local tb = {}
    for k,v,vtype in string.gmatch(str,"(%w+)=(%w+):(%w+)") do
        k = tonumber(k) or k
        if vtype=="table" then
            tb[k] = {}
        elseif vtype=="function" then
            tb[k] = emptyfn
        elseif vtype=="userdata" then
            tb[k] = newproxy()
        elseif vtype=="boolean" then
            tb[k] = (v=="true")
        elseif vtype=="number" then
            tb[k] = tonumber(v)
        elseif vtype=="string" then
            tb[k] = v
        else
            print("ignore thread data, "..v)
        end
    end
    return tb
end


return SR_RemoteMenu