--require不加GLOBAL是去官方的scripts里搜索，加了就是在modmain附记找
local Widget = require "widgets/widget" --Widget，所有widget的祖先类
local ImageButton = require "widgets/imagebutton"	--图片按键是上面的子类

local Sollyzwheel = Class(Widget, function(self,owner,atlas,tex,tb) 
	Widget._ctor(self, "Sollyzwheel") --父类构函
	
	self.owner = owner	--客户端的没有组件
	self.skillname = tb.skillname
	self.state = tb.state  --点击状态 开/关
	self.strcolor = tb.strcolor  --判断类型用 "green"等
	self.type = tb.type

	self.visible = true  --如果没永远，把这个改了

	self.button = self:AddChild(ImageButton(atlas,tex,nil,nil,nil,nil,{1,1}))

	--	RGB表参考 https://tool.oschina.net/commons?type=3
	self.button:SetImageNormalColour(255,255,255,1)	
	self.button:SetImageSelectedColour(255,255,255,1)	
	self.button:SetImageDisabledColour(255,255,255,0.4)
	self:UpdateColor()

	self:Hide()
end)


function Sollyzwheel:Changestate(state) --ClickFN
	if state~=nil then 
		self.state = state
	else
		self.state = not self.state 
	end 
	self:UpdateColor()
end

function Sollyzwheel:UpdateColor()
	local a = self.state and 1 or 0.4
	self.button:SetImageNormalColour(255,255,255,a)
	self.button:SetImageFocusColour(255,255,255,a)	
	if self.state  then self.button:OnEnable() else self.button:OnDisable()	end
end


return Sollyzwheel