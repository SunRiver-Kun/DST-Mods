----------辅助函数
local function SpawnEffect(prefab,duration,player,color)	 --刷人物位置刷特效
	if not player or type(prefab)~="string" then return end
	local duration = duration or 0.5
	local myprefab = SpawnPrefab(prefab)
	if color then 	
	--myprefab.AnimState:SetMultColour(color[1],color[2],color[3],color[4])	
	myprefab.AnimState:SetAddColour(color[1],color[2],color[3],color[4])
	end	
    myprefab.Transform:SetPosition(player.Transform:GetWorldPosition())
	myprefab:DoTaskInTime(duration, myprefab.Remove)
end

local function SpawnEffect2(prefab,duration,player)
	if not type(prefab)=="string" then print("SpawnEffect2 input wrong!") return end
	local myprefab = SpawnPrefab(prefab)
	local duration = duration or 3
	if myprefab==nil then print("no prefab!") return end
	myprefab.entity:SetParent(player.entity)
	myprefab:DoTaskInTime(duration,myprefab.Remove)
end

local function distance(x1,y1,z1,x2,y2,z2)	--计算距离，1在饥荒里面就是一个墙的距离
	local distance_two = (x1-x2)*(x1-x2) + (y1-y2)*(y1-y2) + (z1-z2)*(z1-z2)
	return math.sqrt(distance_two),distance_two
end

local function SpawnWeapon(player,name)
	if not player.sollyz_weapons then return end
	player.sollyz_weapons[name] = SpawnPrefab(name)
	player.sollyz_weapons[name].sollyz_owner = player		--方便之后的删除
	player.components.inventory:Equip(player.sollyz_weapons[name])
end		
local function RemoveWeapon(player,name,effectname,durationtime,color)
	if player.sollyz_weapons and player.sollyz_weapons[name] then	--掉落的话直接删除了，写在sollyz_greencane里
		local inst = player.sollyz_weapons[name]
		local keeper = inst.components.inventoryitem.owner	--玩家/箱子/背包
		color = color or {1,1,1,1}
		if keeper and effectname and durationtime then	--退出后keeper就没了,不过自然法杖是退出就掉落
			local myprefab = SpawnPrefab(effectname)			
			myprefab.AnimState:SetAddColour(unpack(color))
			myprefab.Transform:SetPosition(keeper.Transform:GetWorldPosition())
			myprefab:DoTaskInTime(durationtime, myprefab.Remove)
			inst:Remove()
		end				
		inst.sollyz_owner.sollyz_weapons[name] = nil
	end
end

local function IsSkillEnable(player,index)
	return player.skillswheel and player.skillswheel[index] and player.skillswheel[index].state 
end
---------

-----------------------------------------------------------------blue

local function OnDoneFishing_old(inst, reason, lose_tackle, fisher, target)	--oceanfishingrod里的函数
	if inst.components.container ~= nil and lose_tackle then
				inst.components.container:DestroyContents()		--失去钓鱼工具
	end

	if inst.components.container ~= nil and fisher ~= nil and inst.components.equippable ~= nil and inst.components.equippable.isequipped then
				inst.components.container:Open(fisher)	--？？
	end
end
local function OnDoneFishing_sollyz(inst, reason, lose_tackle, fisher, target)	--不会失去鱼具
	if inst.components.container ~= nil and fisher ~= nil and inst.components.equippable ~= nil and inst.components.equippable.isequipped then
				inst.components.container:Open(fisher)	--？？
	end
end

local function equipfishingrod(inst,data)
	if not ( data and data.item) then return end 
	if data.item.prefab == "fishingrod"  and data.item.components.fishingrod then
			data.item.components.fishingrod:SetWaitTimes(0,8)
			data.item.components.fishingrod:SetStrainTimes(6, 16)	--0~6
			inst.components.talker:Say("去掉大鱼！！")
	end
	
	if data.item.prefab == "oceanfishingrod"  and data.item.components.oceanfishingrod then
		data.item.components.oceanfishingrod.ondonefishing = OnDoneFishing_sollyz
		inst.components.talker:Say("去掉大鱼！！")
	end
end

local function unequipfishingrod(inst,data)
	if not ( data and data.item) then return end 
	if data.item.prefab == "fishingrod" and data.item.components.fishingrod then
			data.item.components.fishingrod:SetWaitTimes(0,10)	--还原
			data.item.components.fishingrod:SetStrainTimes(0, 6)
	end
	
	if data.item.prefab == "oceanfishingrod" and data.item.components.oceanfishingrod then
		data.item.components.oceanfishingrod.ondonefishing = OnDoneFishing_old
	end
end

local function e_fishing(player)
	player:ListenForEvent("equip",equipfishingrod)		
	player:ListenForEvent("unequip",unequipfishingrod)	
end
local function l_fishing(player)
	player:RemoveEventCallback("equip",equipfishingrod)		
	player:RemoveEventCallback("unequip",unequipfishingrod)
end
	
local function h_light(player)
	if not IsSkillEnable(player,2) or player.components.health:IsDead() or player:HasTag("playerghost") then
		player.Light:Enable(false)
		if player.components.hunger.hungerrate then 
			player.components.hunger.hungerrate = TUNING.WILSON_HUNGER_RATE 
			player.sollyz_onlight:set(false)
		end
		return 
   end
   
   if player.level >= 150 then		--大于等于150才能自由开关
	   player.Light:SetRadius(6)	--鬼魂状态光的属性好像没改了
	   player.Light:SetRadius(6)	--设置半径,过低会被查理打
	   player.Light:SetFalloff(.6)	--设置下降高度
	   player.Light:SetIntensity(0.6)  --设计强度
	   player.Light:SetColour(234/255,234/255,234/255)  --设计颜色
	   
	   if player.Light:IsEnabled() then	--当前状态是开灯
		   player.Light:Enable(false)
		   player.components.talker:Say("天亮了该休息了~")
		   player.components.hunger.hungerrate = TUNING.WILSON_HUNGER_RATE  --还原饥饿下降速率
		   player.sollyz_onlight:set(false)
	   else
		   if TheWorld.state.phase == "night" then		--只能晚上开，洞穴内一直是晚上
			   player.Light:Enable(true)
			   player.components.hunger.hungerrate = 10 * TUNING.WILSON_HUNGER_RATE	--开夜视饿得快，大概是一秒扣10/6饥饿
			   player.sollyz_onlight:set(true)
			   player.level = player.level - 3
			   player:PushEvent("sollyz_changelevel","狩猎的时间到了！")	--用来改变等级数据（给R轮）
		   else
			   player.components.talker:Say("现在还没到晚上呢，Level: "..player.level)
		   end	
	   end	
   else
	   player.Light:Enable(false)		--保证150以下是关灯的
	   player.components.talker:Say("我的等级还不够，Level: "..player.level)
	   player.components.hunger.hungerrate = TUNING.WILSON_HUNGER_RATE
	   player.sollyz_onlight:set(false)	
   end	--player.level >= 150
   
end

AddClassPostConstruct("widgets/hungerbadge",function (self)
	--self.sollyz_oldOnUpdate = self.OnUpdate 
	local oldfn = self.OnUpdate 
	self.OnUpdate = function (dt)
		if self.owner and self.owner.sollyz_onlight and self.owner.sollyz_onlight:value() and 
			self.owner.replica.hunger ~= nil and 
			self.owner.replica.hunger:GetPercent() > 0 then  
			local anim = "arrow_loop_decrease_most"
			if self.arrowdir ~= anim then
				self.arrowdir = anim
				self.hungerarrow:GetAnimState():PlayAnimation(anim, true)
			end
		else
			--self.sollyz_oldOnUpdate(dt)
			oldfn(dt)
		end
	end
end)


local function sollyz_miss_speed(inst,data)
	if not inst:HasTag("sollyz_miss_speed") then	--1秒内只运行这么一次	
		inst:AddTag("sollyz_miss_speed")
		inst:PushEvent("sollyz_getinfo")	--重置速度
	 
	 inst.lastpos_sollyz_miss = inst:GetPosition()
	 inst.sollyz_miss_fx = inst:DoPeriodicTask(0.2, function(inst)		--特效
			local x,y,z = inst.lastpos_sollyz_miss:Get()
			local newx,newy,newz = inst.Transform:GetWorldPosition()	
			if distance(x,y,z,newx,newy,newz) > 0.5 then
				SpawnEffect( "cane_victorian_fx",0.5,inst)
				inst.lastpos_sollyz_miss = Vector3(newx,newy,newz)
			end
		end)	

	inst:DoTaskInTime(1,function()	--足够你跑了，而且你也不可能叠这个叠得那么高
			inst:RemoveTag("sollyz_miss_speed")	--移除标签以后，sollyz里监视时间变化的函数就会运行，速度也就正常了
			inst.sollyz_miss_fx:Cancel()
			inst:PushEvent("sollyz_getinfo")	--重置速度
		end) 
	end -- sollyz_miss_speed
end

local function e_miss(player)
	player:ListenForEvent("droppedtarget",sollyz_miss_speed)	--取消攻击时或者攻击的目标附记有其他目标时
end
local function l_miss(player)
	player:RemoveEventCallback("droppedtarget",sollyz_miss_speed)
end

--运气buff的定义
local function sollyz_luckbuff_drop(player,data)
	 if  data.victim.components.lootdropper and math.random()<=0.05 then	--0.05/1 = 5% 的几率 ，发动技能
		----- 双倍掉落以及部分物品掉率修改（小偷包，海象牙/帽，黄油，猪皮，兔毛）
            if data.victim.components.freezable or data.victim:HasTag("monster") then
				if data.victim.prefab == "krampus" then
					local krampus_sack = GLOBAL.LootTables.krampus[4][2]
					GLOBAL.LootTables.krampus[4][2] = 0.1 	--改变小偷背包掉率(10%),改为1就是百分比掉落	
				elseif	data.victim.prefab == "walrus" then
					GLOBAL.LootTables.walrus[4][2] =  0.3 	--海象帽
					GLOBAL.LootTables.walrus[4][2] =  0.6 	--海象牙
				elseif data.victim.prefab == "butterfly" then
					data.victim.components.lootdropper.randomloot[1].weight = 0.3 	--改变黄油爆率,你是欧皇吗？
				elseif data.victim.prefab == "pigman" and data.victim.components.lootdropper.randomloot then	--因为猪人和兔人都有两种形态
					data.victim.components.lootdropper.randomloot[2].weight = 1.5	--改变猪皮掉落概率
				elseif data.victim.prefab == "bunnyman" and data.victim.components.lootdropper.randomloot then	--所以要判断是否有randomloot
					data.victim.components.lootdropper.randomloot[2].weight = 1.5  --改变兔毛掉落概率
				end

				data.victim.components.lootdropper:DropLoot()	--双倍掉落,我们这个先执行再到正常物品掉落
				
				--还原掉率，应该data.victim每次都不一样，所以只用改GLOBAL.LootTables
				if data.victim.prefab == "krampus" then		--虽然我不想怎么写，不过也没办法，总不能两次掉落都有爆率加成吧
					GLOBAL.LootTables.krampus[4][2] = krampus_sack or 0.01 	--还原小偷背包掉率					
				elseif	data.victim.prefab == "walrus" then	
					GLOBAL.LootTables.walrus[4][2] =  0.25 	--海象帽
					GLOBAL.LootTables.walrus[4][2] =  0.5 	--海象牙
				end
		   end
		------
		end
end

local function sollyz_luckbuff_pick(player,data)
	if math.random() <= 0.05 then	--发生概率,5%
		if data.object and data.object.components.pickable and not data.object.components.trader and data.object.components.pickable.product then
                local item = SpawnPrefab(data.object.components.pickable.product)
             if item.components.stackable then
                    item.components.stackable:SetStackSize(data.object.components.pickable.numtoharvest)
             end
                player.components.inventory:GiveItem(item, nil, data.object:GetPosition())
		end
	end
end

local function e_luck(player)
	player:ListenForEvent("killed",sollyz_luckbuff_drop)
	player:ListenForEvent("picksomething",sollyz_luckbuff_pick)
end
local function l_luck(player)
	player:RemoveEventCallback("killed",sollyz_luckbuff_drop)
	player:RemoveEventCallback("picksomething",sollyz_luckbuff_pick)
end

-----------------------------------------------------------------------purple

-----------------------------------------------------------------------green
local function sollyz_farmplant_happy(inst)	
	if inst.components.farmplantstress  then  
		local fx = SpawnPrefab("farm_plant_happy")
		fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
		if inst.components.farmplantstress.stress_points>0 then
			 inst.components.farmplantstress.stress_points = inst.components.farmplantstress.stress_points - 1 
		end
	end
end

local function sollyz_recover_health(inst,data)	--回血+给植物加buff
	if data.success then
		local uphealth = 10 + inst.level/10			
		local x,y,z = inst.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x,y,z,12,{"farmplantstress"},{"player","playerghost"})
		local players = TheSim:FindEntities(x,y,z,6,{"player"},{"playerghost"})
		if ents then
			for k,v in pairs(ents) do
				sollyz_farmplant_happy(v)
			end
		end

		if players then
			for k,v in pairs(players) do
				if not v.components.health:IsDead() then	
					v.components.health:DoDelta(uphealth,false,"sollyz_recover")
				end
			end
		end	
	end
end

local function h_recover(player)
	if IsSkillEnable(player, 4) and player.components.inventory.equipslots.hands~=nil and player.components.inventory.equipslots.hands.prefab=="sollyz_greencane" then
		if not player:HasTag("sollyz_recover") and not player:HasTag("playerghost") then		--动作做完前不重复刷新
			if player.level>0 then 
				player:AddTag("sollyz_recover")
				player.level = player.level - 1
				player:PushEvent("sollyz_changelevel")

				SpawnEffect("deer_ice_flakes",2.7,player,{0,1,0,0.5})
				player:PushEvent("sollyz_recover")   --通过事件来触发动作，定义在actions_sollyz.lua
			else 
				player.components.talker:Say("我的等级还不够，Level: "..player.level)
			end
		end
	end
end

AddPrefabPostInit("sollyz",function(inst)	--sollyz_recover_animover
	if not TheNet:GetIsServer() then return end
	inst:ListenForEvent("sollyz_recover_animover",function(inst,data) inst:RemoveTag("sollyz_recover")  sollyz_recover_health(inst,data) end)
end)


---------------------------sollyz_naturalfriend
local function build_naturalitems(inst,data)
	if inst:HasTag("sollyz_naturalfriend") then 
		if data.item.prefab == "bedroll_furry" then
			data.item.components.finiteuses:SetMaxUses(5)
			data.item.components.finiteuses:SetUses(5)		
			data.item.sanity_tick = TUNING.SLEEP_SANITY_PER_TICK * 1.5	
		elseif data.item.prefab == "bedroll_straw" then
			data.item:RemoveComponent("stackable")
			data.item:AddComponent("finiteuses")
			data.item.components.finiteuses:SetConsumption(ACTIONS.SLEEPIN, 1)
			data.item.components.finiteuses:SetMaxUses(3)
			data.item.components.finiteuses:SetUses(3)								
			data.item.sanity_tick = TUNING.SLEEP_SANITY_PER_TICK 
		end
	end
end

local function e_naturalfriend(player)
	player:RemoveTag("scarytoprey")
	player:ListenForEvent("builditem",build_naturalitems)
end
local function l_naturalfriend(player)
	player:AddTag("scarytoprey")	--这个标签官方默认是有的，吓跑动物用
	player:RemoveEventCallback("builditem",build_naturalitems)
end
-- + 与兔人、猪人交易

------------------------------------------

local function l_greencane(player)
	RemoveWeapon(player, "sollyz_greencane", "deer_ice_flakes", 2,{0,1,0,0.3})
end
local function a_greencane(player)
	if player.sollyz_weapons and not player.sollyz_weapons.sollyz_greencane then 
		SpawnWeapon(player, "sollyz_greencane")
	end
end
-------------------------------------------------------------------------

--[[	   14
		 6    10
	11		2		5	
 15	   3	  	  1   13
	7		4		9
		 12    8
			16
--]]

--skillname,strcolor,state,type,,enterfn,leavefn
--刚开始都是关，加载以后才改变,H主动，M被动，R鼠标右键
local function MakeSkill(skillname,strcolor,state,type,enterfn,leavefn,alwaysfn,hfn)
	return { skillname = skillname, strcolor = strcolor,state = state,laststate=false, type = type,enterfn=enterfn,leavefn=leavefn ,alwaysfn = alwaysfn,hfn=hfn}
end

skills_sollyz = {}	--其他文件也有用到
skills_sollyz[2] = MakeSkill("sollyz_light","blue",false,"H",nil,nil,nil,h_light)
skills_sollyz[6] = MakeSkill("sollyz_luck","blue",true,"M",e_luck,l_luck)	
skills_sollyz[10] = MakeSkill("sollyz_fishing","blue",true,"M",e_fishing,l_fishing)
skills_sollyz[14] = MakeSkill("sollyz_miss","blue",true,"M",e_miss,l_miss)

skills_sollyz[4] = MakeSkill("sollyz_recover","green",false,"H",nil,nil,nil,h_recover)
--skills_sollyz[8] = MakeSkill("sollyz_callstart","green",false,"M")
skills_sollyz[12] = MakeSkill("sollyz_naturalfriend","green",false,"M",e_naturalfriend,l_naturalfriend)
skills_sollyz[16] = MakeSkill("sollyz_greencane","green",false,"M",nil,l_greencane,a_greencane)



--连接widget和主机数据
AddPrefabPostInit("sollyz",function (inst)
	if not TheNet:GetIsServer() then return end
	inst.skillswheel = skills_sollyz
end)

--[[ debug
AddPrefabPostInit("sollyz",function (inst)
	if not TheNet:GetIsServer() then return end
	inst:ListenForEvent("nightvision",function (inst,data)
		print("--------------")
		if data then
			print(type(data)) 
			if type(data)=="table" then
				for k,v in data do 
					print(k,v)
				end
			end
		end 
	end)
end)
--]]	


