modimport("scripts/actions_sollyz.lua")
modimport("scripts/skills_sollyz.lua")	--提供 table skills_sollyz

local Sollyzwheel = GLOBAL.require("widgets/sollyzwheel") 
local Text = require "widgets/text"  --在官方目录下找 


local skillswheel = {  
    baseradius = math.min(GLOBAL.TheSim:GetScreenSize())/ 4,
    text = nil,
    strcolor = "blue"
}

--注：界面改变tex位置和大小都不变，所以要手动调节

local buttonangel=
{	-- + 1/2 
	0,1/2,1,3/2,	--内圈,从白圈开始
	1/8,5/8,9/8,13/8,	--左圈
	-1/8,3/8,7/8,11/8,	--右圈
	0,1/2,1,3/2			--上圈
}

local function NewRadius()
	local screenwidth, screenheight = GLOBAL.TheSim:GetScreenSize()
	return  math.min(screenwidth, screenheight) / 4		
end

local function SetPositionPolar(button,radius,angle)  --弧度
    if not button then return end
    radius = radius or 1
    angle = angle or 0
	local x = math.cos(angle)*radius
	local y = math.sin(angle)*radius
	button:SetPosition(x,y,0)
end

function skillswheel:ShowWheel()
    --SetModHUDFocus("Sollyzwheel", true)		--使用这个，你按R键时就无法移动
	local newscale = NewRadius()/self.baseradius

	for i,_ in pairs(skills_sollyz) do
		local v = self[i]   	
        if i<=4 then
            SetPositionPolar(v.button,NewRadius()*5/8,buttonangel[i]*math.pi)  --内圈
		elseif i<=12 then
            SetPositionPolar(v.button,NewRadius(),buttonangel[i]*math.pi)  --中圈
        else
            SetPositionPolar(v.button,NewRadius()*5/4,buttonangel[i]*math.pi)  --外圈
		end
		
    	v.button.focus_scale = {1.2*newscale, 1.2*newscale, 1.2*newscale}
    	v.button.normal_scale = {1*newscale, 1*newscale, 1*newscale}
    	v.button:_RefreshImageState()
	
		if v.visible then	--拥有就展示出来
			v:Show()
		else
			v:Hide()
		end
	end
	
	self.text:Show()
end

function skillswheel:HideWheel()
--	SetModHUDFocus("Sollyzwheel", false)
	for i,_ in pairs(skills_sollyz) do
	    self[i]:Hide()	--都隐藏就好，反正也看不见
	end
	self.text:Hide()
end


local function IsHUDScreen()	--判断是不是非输入界面,HUD就是screen
	local defaultscreen = false
	if TheFrontEnd:GetActiveScreen() and TheFrontEnd:GetActiveScreen().name and type(TheFrontEnd:GetActiveScreen().name) == "string" and TheFrontEnd:GetActiveScreen().name == "HUD" then
		defaultscreen = true
	end
	return defaultscreen
end

--------------------------------
--客->主机通信
AddModRPCHandler(modname, "sollyz_getinfo", function(player)	--用于重置text信息，监视在sollyz.lua
	player:PushEvent("sollyz_getinfo")
end)

AddModRPCHandler(modname, "sollyz_changestate", function(player,index,state)	
	if player.skillswheel and index and player.skillswheel[index] then
		player.skillswheel[index].laststate = player.skillswheel[index].state
		player.skillswheel[index].state = state
	end
end)

AddModRPCHandler(modname, "sollyz_updataskills", function(player)
	if player.skillswheel then 
		for k,v in pairs(player.skillswheel) do 
			---------------------------------
			if v.laststate ~= v.state then
				v.laststate = v.state
				if v.state then 
					if v.enterfn then v.enterfn(player) end
				else
					if v.leavefn then v.leavefn(player) end
				end
			end
			if v.state and v.alwaysfn then 
				v.alwaysfn(player)
			end
			-----------------------------------
		end 
	end
end)

AddModRPCHandler(modname, "sollyz_updataHskills", function(player)  --主动响应
	if player.skillswheel then 
		for k,v in pairs(player.skillswheel) do 
			if v.state and v.hfn then 
				v.hfn(player)
			end
		end
	end
end)

-----------------------------

local function AddSollyzWheel(self)		--第一个参数固定是self，第二个参数填owner的话,下面的self.owner应该可以用owner代替
	if self.owner.prefab~="sollyz" then return  end--owner是客户端的，没有我们需要的大部分东西
	local radius = NewRadius()
	
	for i,v in pairs(skills_sollyz) do --这里只能用pairs
		skillswheel[i] = self:AddChild( Sollyzwheel(self.owner,"images/buttonimages/button"..i..".xml","button"..i..".tex",v) )		
		skillswheel[i]:SetHAnchor(0)		--屏幕中间
		skillswheel[i]:SetVAnchor(0)
		skillswheel[i].button:SetOnClick(function() 
			if skillswheel[i].strcolor == skillswheel.strcolor then 
				skillswheel[i]:Changestate()
				SendModRPCToServer(MOD_RPC[modname]["sollyz_changestate"],i,skillswheel[i].state)
			else
			--不同色时
				for index,_ in pairs(skills_sollyz) do 
					if skillswheel[index].strcolor == skillswheel.strcolor then --关闭之前的颜色
						skillswheel[index]:Changestate(false)
						SendModRPCToServer(MOD_RPC[modname]["sollyz_changestate"],index,skillswheel[index].state)
					elseif skillswheel[i].type=="H" and skillswheel[index].strcolor == skillswheel[i].strcolor then --主技能时随便激活同色技能
						skillswheel[index]:Changestate(true)
						SendModRPCToServer(MOD_RPC[modname]["sollyz_changestate"],index,skillswheel[index].state)
					end
				end
				skillswheel[i]:Changestate(true)
				skillswheel.strcolor = skillswheel[i].strcolor
			end
		end)
	end
	
	skillswheel.text = self:AddChild(Text(UIFONT,35))
	skillswheel.text:SetHAnchor(1)  
	skillswheel.text:SetVAnchor(2)  
	skillswheel.text:SetPosition(90,80,0)   
	
	skillswheel.text.level = self.owner.levell:value()
	skillswheel.text.speed = self.owner.speed:value()/10
	skillswheel.text.combat = self.owner.combat:value()/10
	skillswheel.text:SetString("Level:  "..skillswheel.text.level.."\nSpeed:  "..skillswheel.text.speed.."\nCombat:  "..skillswheel.text.combat)
	
	self.owner:ListenForEvent("sollyz_info",function(owner,data)	--客户端监听网络变量
		skillswheel.text.level = owner.levell:value()
		skillswheel.text.combat = owner.combat:value()/10
		skillswheel.text.speed = owner.speed:value()/10
		skillswheel.text:SetString("Level:  "..skillswheel.text.level.."\nSpeed:  "..skillswheel.text.speed.."\nCombat:  "..skillswheel.text.combat)
	end)
	skillswheel.text:Hide() 
	
	
	local canflash = true	--防止R键按着不放重复刷新
	--------------------------------------------------------按键设置
	GLOBAL.TheInput:AddKeyDownHandler(TUNING.sollyz_key_r, function()	
			if	canflash and IsHUDScreen() and (self.owner.prefab == "sollyz" or self.owner:HasTag("sollyz"))  then		--owner本地的,所以已经等于ThePlayer
				SendModRPCToServer(MOD_RPC[modname]["sollyz_getinfo"])
				skillswheel:ShowWheel()
				canflash = false 
			end
	end)
	GLOBAL.TheInput:AddKeyUpHandler(TUNING.sollyz_key_r, function()	
			if	IsHUDScreen() and (self.owner.prefab == "sollyz" or self.owner:HasTag("sollyz") ) then
				skillswheel:HideWheel()
				SendModRPCToServer(MOD_RPC[modname]["sollyz_getinfo"])		--关闭的时候随便重置下信息
				SendModRPCToServer(MOD_RPC[modname]["sollyz_updataskills"])
				
				canflash = true
			end
	end)

	GLOBAL.TheInput:AddKeyUpHandler(TUNING.sollyz_key_h, function()	
		if IsHUDScreen() and (self.owner.prefab == "sollyz" or self.owner:HasTag("sollyz"))  then		--owner本地的,所以已经等于ThePlayer
			SendModRPCToServer(MOD_RPC[modname]["sollyz_updataHskills"])
		end
	end)
end

AddClassPostConstruct("widgets/controls", AddSollyzWheel) -- 这个函数是官方的MOD API，用于修改游戏中的类的构造函数。第一个参数是类的文件路径，根目录为scripts。第二个自定义的修改函数，第一个参数固定为self，指代要修改的类。

