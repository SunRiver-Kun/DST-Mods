local Screen = require "widgets/screen"
local TextEdit = require "widgets/textedit"
local Widget = require "widgets/widget"
local Text = require "widgets/text"

local SR_InputScreen = Class(Screen, function (self,tb,key,callback)
    --from chartinputscreen
    Screen._ctor(self, "SR_InputScreen")
    self.tb = tb
    self.key = key
    self.callback = callback
    self:DoInit()
end)

function SR_InputScreen:DoInit()
    TheInput:EnableDebugToggle(false)

    local label_height = 50
    local fontsize = 30
    local edit_width = 850
    local chat_type_width = 400
    local x = -505

    self.root = self:AddChild(Widget("chat_input_root"))
    self.root:SetScaleMode(SCALEMODE_PROPORTIONAL)
    self.root:SetHAnchor(ANCHOR_MIDDLE)
    self.root:SetVAnchor(ANCHOR_BOTTOM)
    self.root = self.root:AddChild(Widget(""))

    self.root:SetPosition(45.2, 100, 0)

	if not TheInput:PlatformUsesVirtualKeyboard() then
	    self.chat_type = self.root:AddChild(Text(TALKINGFONT, fontsize))
	    self.chat_type:SetPosition(x, 0, 0)
	    self.chat_type:SetRegionSize(chat_type_width, label_height)
	    self.chat_type:SetHAlign(ANCHOR_RIGHT)
        self.chat_type:SetString( tostring(self.key).." : " )
	    self.chat_type:SetColour(.6, .6, .6, 1)

        x = x + chat_type_width/2
	end

    x = x + edit_width/2
    self.chat_edit = self.root:AddChild(TextEdit(TALKINGFONT, fontsize, ""))
    self.chat_edit.edit_text_color = WHITE
    self.chat_edit.idle_text_color = WHITE
    self.chat_edit:SetEditCursorColour(unpack(WHITE))
    self.chat_edit:SetPosition(x, 0, 0)
    self.chat_edit:SetRegionSize(edit_width , label_height)
    self.chat_edit:SetHAlign(ANCHOR_LEFT)

    self.chat_edit.OnTextEntered = function() self:Run() self:Close() end
    self.chat_edit:SetPassControlToScreen(CONTROL_CANCEL, true)
    self.chat_edit:SetTextLengthLimit(MAX_CHAT_INPUT_LENGTH)
    self.chat_edit:EnableRegionSizeLimit(true)
    self.chat_edit:EnableScrollEditWindow(false)

    self.chat_edit:SetString(tostring(self.tb[self.key]))
	self.chat_edit:SetForceEdit(true)
    self.chat_edit.OnStopForceEdit = function() self:Close() end
end

function SR_InputScreen:OnBecomeActive()
    SR_InputScreen._base.OnBecomeActive(self)

    self.chat_edit:SetFocus()
    self.chat_edit:SetEditing(true)

	if IsConsole() then
		TheFrontEnd:LockFocus(true)
	end
end

function SR_InputScreen:OnControl(control, down)
    if SR_InputScreen._base.OnControl(self, control, down) then return true end
    if control == CONTROL_OPEN_DEBUG_CONSOLE then
        return true
    end

	if not down and (control == CONTROL_CANCEL) then
		self:Close()
		return true
	end
end

function SR_InputScreen:Run()
    local chat_string = self.chat_edit:GetString() or ""
    local value = self.tb[self.key]
    local vtype = type( value )
    if vtype=="boolean" then
        self.tb[self.key] = tostring(value)==chat_string and value or not value
    elseif vtype=="number" then
        self.tb[self.key] = tonumber(chat_string) or value
    elseif vtype=="string" then
        self.tb[self.key] = chat_string
    end
    if self.callback then
        self.callback()
    end
end

function SR_InputScreen:Close()
    --SetPause(false)
    TheInput:EnableDebugToggle(true)
    TheFrontEnd:PopScreen(self)
end

return SR_InputScreen