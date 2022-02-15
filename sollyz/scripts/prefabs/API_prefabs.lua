-- 客户端只有replica，初始化最好是ListenForEvent

AddPrefabPostInit("pigman",function(inst)
	if not TheNet:GetIsServer() then return end 
	inst:ListenForEvent("trade",function(inst,data)
		if data.giver.prefab == "sollyz" and data.giver:HasTag("sollyz_naturalfriend") and not inst:HasTag("guard") then
			if inst.components.combat:TargetIs(data.giver) then
                inst.components.combat:SetTarget(nil)
			end
			
			data.giver:PushEvent("makefriend")
	        data.giver.components.leader:AddFollower(inst)
		end
	end)			
end)

AddPrefabPostInit("bunnyman",function(inst)
	if not TheNet:GetIsServer() then return end 
	inst:ListenForEvent("trade",function(inst,data)
		if data.giver.prefab == "sollyz" and data.giver:HasTag("sollyz_naturalfriend") and not inst:HasTag("guard") then
			if inst.components.combat:TargetIs(data.giver) then
                inst.components.combat:SetTarget(nil)
			end
			
			data.giver:PushEvent("makefriend")
	        data.giver.components.leader:AddFollower(inst)
		end
	end)			
end)

AddPrefabPostInit("pondfish",function(inst)
	if not TheNet:GetIsServer() then return end 
	inst:ListenForEvent("onputininventory",function(inst,data) 
		if data and data.prefab=="sollyz" then
			inst:RemoveComponent("murderable")
			inst:AddTag("sollyzfood")
		end
	end)
	inst:ListenForEvent("exitlimbo",function (inst)
		if inst:HasTag("sollyzfood") then
			inst:RemoveTag("sollyzfood")
			inst:AddComponent("murderable")
		end
	end)
end)


local LOOTS =	--要改的话只用改这个就可以了
{
	nightmarefuel = 0.1,  --噩梦燃料
	amulet = 1,		--重生护符
	blueamulet = 1,  --寒冷护符
	gears = 2,	--齿轮
	redgem = 2,	--红宝石
	bluegem = 2,	--蓝宝石
	purplegem = 1,	--紫宝石 
	thulecite = 0.5,	--铥矿
	thulecite_pieces = 1, --铥矿碎片	
	stalker = 0.01,		--复活的骷髅,能挖出来你就是欧皇[滑稽.jpg]
	krampus_sack = 0.01,		--小偷背包
	yellowstaff = 0.1,			--唤星者法杖（黄色）
	opalstaff = 0.1,		--访月者手杖
	greenstaff = 0.1,	--解构魔杖（绿）
	icestaff = 0.5,	--冰魔杖（蓝）
	firestaff = 0.5,	--火焰法杖（红）
	telestaff = 0.3,	--传送魔杖（紫）
	orangestaff	= 0.3,	--瞬移魔杖（橙）
}

AddPrefabPostInit("mound",function (inst)
	if not TheNet:GetIsServer() then return end 
	inst:ListenForEvent("worked",function (inst,data)
		if data.worker and data.worker.skillswheel and data.worker.skillswheel[6].state then inst:AddTag("sollyz_dig") end
	end)

	inst:ListenForEvent("loot_prefab_spawned",function (inst,data)
		if not inst:HasTag("sollyz_dig") then return end
		if data.loot and not string.find(data.loot.prefab, "halloween") then 
			data.loot:Remove()
			local item = math.random() < .1 and PickRandomTrinket() or weighted_random_choice(LOOTS) or nil
        	if item ~= nil then
            	item = SpawnPrefab(item)
				inst.components.lootdropper:FlingItem(item)
        	end
		end
	end)
end)