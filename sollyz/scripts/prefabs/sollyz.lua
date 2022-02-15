--技能在skills_sollyz
local MakePlayerCharacter = require "prefabs/player_common"

local assets = 
{	
	Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
}	
local prefabs = {}
local start_inv = {	--初始装备，在modmain里面那个只是显示而已
"fishingrod","nohat",
----debug
}

local function runner(inst)
	local max_upgrades = 300
	local upgrades = math.min(inst.level, max_upgrades)
	local walkspeed,runspeed,hspeedup = 4,6,0
	local hungerpercent = inst.components.hunger:GetPercent()
													--9,8,7 + 1 = 10,9,8 -->* 1.25 = 12.5,11.25,10 
			if TheWorld.state.phase == "day" then 	--手杖(0.25),鹅卵石(0.3),猪背包,冰帽(-0.1),蜘蛛丝(-0.4),换算不是简单的相加
				walkspeed = 4 + upgrades / 100 --7
				runspeed = 6 + upgrades / 100  --9(8~10),不能调太快，看了眼花
				if inst.Light and not inst.Light:IsEnabled() then inst.components.hunger.hungerrate =1.2 * TUNING.WILSON_HUNGER_RATE end	--早上饿得快,开夜视的时候饥饿速度不受这个影响
			elseif TheWorld.state.phase == "dusk" then
				walkspeed = 4 + upgrades / 120 --6.5
				runspeed = 6 + upgrades / 150  --8(7~9)
				if inst.Light and not inst.Light:IsEnabled() then inst.components.hunger.hungerrate = TUNING.WILSON_HUNGER_RATE end
			elseif TheWorld.state.phase == "night" then
				walkspeed = 4 + upgrades / 150 --6
				runspeed = 6 + upgrades / 300 --7(6~8)
				if inst.Light and not inst.Light:IsEnabled() then inst.components.hunger.hungerrate =0.8 * TUNING.WILSON_HUNGER_RATE end
			end
	
		if inst:HasTag("sollyz_miss_canuse") then 	--身手灵敏
			walkspeed = walkspeed + 0.25	 --因为上面的公式是定的
			runspeed = runspeed  + 0.25	--不用当心这个会持续叠加
			if inst:HasTag("sollyz_miss_speed") then	--身手灵敏打怪的时候
				runspeed = runspeed + 1
			end		
		end
		
		if hungerpercent > 0.9 then		
			hspeedup = 1	
		elseif hungerpercent > 0.7 then
			hspeedup = 0.8
		elseif hungerpercent > 0.5 then
			hspeedup = 0.5
		elseif hungerpercent > 0.3 then
			hspeedup = 0.3
		elseif hungerpercent > 0.1 then
			hspeedup = 0
		else
			hspeedup = -1
		end
		
		runspeed = runspeed + hspeedup
					
		inst.components.locomotor.walkspeed = walkspeed		
		inst.components.locomotor.runspeed = runspeed 
		if TUNING.sollyz_isbeta then	--不用担心这个，不是每秒都刷新
			inst.speed:set(inst.components.locomotor.runspeed*10*inst.components.locomotor.GetSpeedMultiplier(inst.components.locomotor))	--因为当初定义是整型，不用担心这个总是刷新
			inst.levell:set(inst.level)
			inst.combat:set(inst.components.combat.damagemultiplier*10)
		end
		
end

local function applyupgrades(inst,str)
		
	local hunger_percent = inst.components.hunger:GetPercent()
	local health_percent = inst.components.health:GetPercent()
	local sanity_percent = inst.components.sanity:GetPercent()

	inst.components.hunger.max = math.ceil (150 + inst.level * 0.5) --300		math.ceil返回大于或等于x的最小整数
	inst.components.health.maxhealth = math.ceil (100 + inst.level * 0.4) --220
	inst.components.sanity.max = math.ceil (90 + inst.level * 0.2) --150
	
	inst.components.combat.damagemultiplier = 1+ inst.level/300		--2	  伤害加成
	
	if TUNING.sollyz_isbeta then
		inst.levell:set(inst.level)
		inst.combat:set(inst.components.combat.damagemultiplier*10)	
	end
	
	inst.components.talker:Say(str or "Level : "..inst.level)

	inst.components.hunger:SetPercent(hunger_percent)	--当前饥饿值 = 满饥饿值 * 比例
	inst.components.health:SetPercent(health_percent)
	inst.components.sanity:SetPercent(sanity_percent)
	
	runner(inst)
	
end

local function oneat(inst, food)
	
	--if food and food.components.edible and food.components.edible.foodtype == "HELLO" then
	if food and food.components.edible and (
	food.prefab == "fish" or 	--改括号里面的食物名即可
	food.prefab == "pondfish" or --新版活的鱼
	food.prefab == "fish_cooked" or
	food.prefab == "fishmeat" or 
	food.prefab == "fishmeat_small" or
	food.prefab == "eel" or		--鳗鱼
	food.prefab == "eel_cooked" or 
	food.prefab == "fishsticks" or	--烤鱼排
	food.prefab == "fishtacos" or	--鱼肉玉米卷
	food.prefab == "unagi" or	--鳗鱼料理
	food.prefab == "californiaroll" or 	--加州卷，海草卷着鱼
	food.prefab == "seafoodgumbo" or	--海鲜浓汤，浓浓的鱼香味
	food.prefab == "surfnturf" or	--海鲜牛排
	food.prefab == "frogfishbowl" or 	--蓝带鱼排
	food.prefab == "ceviche" 	--酸橘汁腌鱼
	) then
		--give an upgrade!
		
			
		if food.prefab == "seafoodgumbo" then 
			inst.level = inst.level + 5
		elseif	 food.prefab == "fishsticks" or food.prefab == "fishtacos" or food.prefab == "unagi" or food.prefab == "californiaroll" then
			inst.level = inst.level + 3
		elseif food.prefab == "fishmeat" or food.prefab == "surfnturf" or food.prefab == "frogfishbowl" or food.prefab == "ceviche" then
			inst.level = inst.level + 2
		
		else
			inst.level = inst.level + 1
		end
	
		applyupgrades(inst)	
		inst.SoundEmitter:PlaySound("dontstarve/characters/wx78/levelup")	--升级音效，本来先改来着不过找不到合适的声音

	end
end

local function onpreload(inst, data)
	if data and data.level then
		inst.level = data.level
		applyupgrades(inst)
	
		if TUNING.sollyz_isbeta then
		inst.levell:set(inst.level)	--设置数据
		inst.speed:set(inst.components.locomotor.runspeed*10)
		inst.combat:set(inst.components.combat.damagemultiplier*10)
		end
	end

end

local function onsave(inst, data)
	data.level = inst.level
	--data.charge_time = inst.charge_time
end


local common_postinit = function(inst) 	--主客机都加载的
	inst.soundsname = "willow"
	inst.MiniMapEntity:SetIcon( "sollyz.tex" )
	
	if TUNING.sollyz_isbeta then
	--网络变量
		inst.levell = net_ushortint(inst.GUID,"sollyz_levell","sollyz_info")	--编号,??(好像没用啊),大事件(widget里面监视)
    	inst.speed=	net_byte(inst.GUID,"sollyz_speed","sollyz_info")	--别问，问就是节约内存
    	inst.combat= net_byte(inst.GUID,"sollyz_combat","sollyz_info")
		inst.sollyz_onlight = net_bool(inst.GUID,"sollyz_onlight","sollyz_light")
	end
end

local function LostAllSollyz_weapons(inst)
		if inst.sollyz_weapons then
			for _,v in pairs(inst.sollyz_weapons) do
				if v.Transform then		--没被移除的时候
					local myprefab = SpawnPrefab("deer_ice_flakes")
					myprefab.AnimState:SetAddColour(0,1,0,0.3)
					myprefab.Transform:SetPosition(v.Transform:GetWorldPosition())
					myprefab:DoTaskInTime(2, myprefab.Remove)
					
					v:Remove()		--技能武器移除的时候会自己把sollyz_weapons里对应的清除
				end
			end
		end
end

local master_postinit = function(inst)
	inst.level = 0
	inst.sollyz_weapons = {} 	--技能武器表
	inst.lostallsollyz_weapons = LostAllSollyz_weapons
	
	
	inst.components.eater:SetOnEatFn(oneat)
	applyupgrades(inst)
		
	inst:AddTag("sollyz")
	
	inst.components.health:SetMaxHealth(100)
	inst.components.hunger:SetMax(150)
	inst.components.sanity:SetMax(90)
	inst.components.locomotor.walkspeed = 4
	inst.components.locomotor.runspeed = 6

	inst.components.combat.damagemultiplier = 1
	inst.OnSave = onsave
	inst.OnPreLoad = onpreload
	
	--灯光
	if not inst.Light then inst.entity:AddLight() end
	inst.Light:SetRadius(6)	--设置半径,过低会被查理打
	inst.Light:SetFalloff(.6)	--设置下降高度
	inst.Light:SetIntensity(0.6)  --设计强度
	inst.Light:SetColour(234/255,234/255,234/255)  --设计颜色
	inst.Light:Enable(false)
		
	inst:WatchWorldState("phase", runner )

	if TUNING.sollyz_isbeta then
		inst:ListenForEvent("sollyz_getinfo",runner)
		inst:ListenForEvent("sollyz_changelevel",applyupgrades)	
		inst:ListenForEvent("ms_playerleft",function(src,data) 
			if data and data==inst then
				inst:lostallsollyz_weapons() 
			end
		end, TheWorld)

		inst:ListenForEvent("onremove",inst.lostallsollyz_weapons)
	end
end



return MakePlayerCharacter("sollyz", prefabs, assets, common_postinit, master_postinit, start_inv)
