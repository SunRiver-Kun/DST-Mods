local assets =
{
    Asset("ANIM", "anim/sollyz_greencane.zip"),  --地上的动画
    Asset("ANIM", "anim/swap_sollyz_greencane.zip"), --手里的动画
	Asset("ATLAS", "images/inventoryimages/sollyz_greencane.xml"), --加载物品栏贴图
    Asset("IMAGE", "images/inventoryimages/sollyz_greencane.tex"),
}


----------------------------

--v:GetDistanceSqToPoint(x, y, z)

local function SetPosition(inst,angle,distance,player)
	local x,y,z = player.Transform:GetWorldPosition()
	inst.Transform:SetPosition(x+math.cos(angle)*distance,y,z+math.sin(angle)*distance)
end
-----------------------------
local function CanShareTarget(inst)
    return (inst.prefab == "leif" or inst.prefab == "leif_sparse" )	--桦树精找不到名字，莫得办法
        and not ( inst.components.health and inst.components.health:IsDead() )
end

local function OnAttacked(inst, data)
	if  data and data.attacker then
		inst.components.combat:ShareTarget(data.attacker, 30, CanShareTarget, 50)
	end	
end


local function onequip(inst, owner) --装备
    owner.AnimState:OverrideSymbol("swap_object", "swap_sollyz_greencane", "swap_sollyz_greencane")
								--替换的动画部件	使用的动画	替换的文件夹（注意这里也是文件夹的名字）
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

	owner:ListenForEvent("attacked",OnAttacked)		--被攻击时周围的树精会帮忙

	if owner.prefab=="wormwood" and  owner.blooming  then	
		--do nothing
	else
		owner:AddTag("sollyz_greencane_hold")	--保持fx必须的标签
		 owner.lastpos_sollyz_greencane = Vector3(owner.Transform:GetWorldPosition())
		 for i=1,8 do
					local myprefab = SpawnPrefab("greencane_plant_fx")
					local angle,distance = math.random()*2* math.pi ,math.random(5,15)/10
					SetPosition(myprefab,angle,distance,owner)
					myprefab:SetVariation(math.random(1,4))
				end
		 
		 owner.greencane_plant_fx = owner:DoPeriodicTask(0.2,function(owner)
			local lastpos = owner.lastpos_sollyz_greencane
			if owner:GetDistanceSqToPoint(lastpos.x, lastpos.y, lastpos.z)>=3 then
				owner.lastpos_sollyz_greencane = Vector3(owner.Transform:GetWorldPosition())
				for i=1,6 do
					local myprefab = SpawnPrefab("greencane_plant_fx")
					local angle,distance = math.random()*2* math.pi ,math.random(5,15)/10
					SetPosition(myprefab,angle,distance,owner)
					myprefab:SetVariation(math.random(1,4))
				end
			end
		 end)
	end
end

local function onunequip(inst, owner) --解除装备
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
	
	owner:RemoveEventCallback("attacked",OnAttacked)
	
	owner:RemoveTag("sollyz_greencane_hold")
	if owner.greencane_plant_fx then
		owner.greencane_plant_fx:Cancel()
		owner.greencane_plant_fx = nil
		owner.lastpos = nil
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("sollyz_greencane")  --地上动画
    inst.AnimState:SetBuild("sollyz_greencane")
    inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("irreplaceable")		--官方标签，离开世界自动掉落

	inst:AddTag("sollyz_weapon")		--
	inst:AddTag("sollyz_greencane")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon") 
    inst.components.weapon:SetDamage(22) 
	inst.components.weapon:SetOnAttack(function(inst,owner,target)	--攻击成功有几率召唤树人（5%）
		if math.random()<0.05 and  target.prefab~="butterfly"  then 
			local x,y,z = inst.Transform:GetWorldPosition()
		    local ents = TheSim:FindEntities(x,0,z,8,nil,{"player","playerghost"})
			if not ents then return end
			for _,v in pairs(ents) do 					
				if v.prefab=="evergreen" and not v:HasTag("burnt") and not v:HasTag("stump")  then  
					local leifscale = 1
					if v.components.growable.stage==1 then
						leifscale = 0.7
					elseif v.components.growable.stage==3 then
						leifscale = 1.25
					end
					
					local leif = SpawnPrefab("leif")
					local rate = math.random()
					leif.AnimState:SetMultColour(v.AnimState:GetMultColour())
					
					if rate<0.2  then	
						leif:SetLeifScale(0.5)
						leif.components.locomotor.walkspeed = 1.5 * 5	--1.5树精正常移速
						leif.components.combat.min_attack_period = 1
					elseif rate<0.4 then
						leif:SetLeifScale(1.35)
						leif.components.combat:SetDefaultDamage(TUNING.LEIF_DAMAGE*leifscale*2)
					elseif rate<0.5 then
						leif:SetLeifScale(1.5)
						leif.components.locomotor.walkspeed = 1.5 * 3
						leif.components.combat:SetDefaultDamage(TUNING.LEIF_DAMAGE*3)
					else
						leif:SetLeifScale(leifscale)			
					end
					
					
					leif.components.combat:SuggestTarget(target)
					if not leif.components.follower then  leif:AddComponent("follower")  end
					leif.components.follower:SetLeader(owner)

					local x, y, z = v.Transform:GetWorldPosition()
					v:Remove()
					leif.Transform:SetPosition(x, y, z)
					leif.sg:GoToState("spawn")

					leif:DoTaskInTime(60,function(leif)
						leif.sg:GoToState("sleeping")		
						leif:DoTaskInTime(2,function(leif)
							local evergreen = SpawnPrefab("evergreen")
							evergreen.Transform:SetPosition(leif.Transform:GetWorldPosition())
							leif:Remove()
						end)
					end)
				
					break
				end--]]
			end
		end
	end)
    -------
	
    inst:AddComponent("inspectable") --可检查组件

    inst:AddComponent("inventoryitem") --物品组件
	inst.components.inventoryitem.atlasname = "images/inventoryimages/sollyz_greencane.xml" --物品贴图

    inst:AddComponent("equippable") --可装备组件
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)
	MakeInventoryFloatable(inst)
	
	inst:ListenForEvent("ondropped",function(inst)		--放背包里丢背包不会触发
		local myprefab = SpawnPrefab("deer_ice_flakes")
		myprefab.AnimState:SetAddColour(0,1,0,0.3)
		myprefab.Transform:SetPosition(inst.Transform:GetWorldPosition())
		myprefab:DoTaskInTime(2, myprefab.Remove)
		
		inst.components.inventoryitem.canbepickedup = false
		inst:DoTaskInTime(0.5,inst.Remove)
	end)
	inst:ListenForEvent("onremove",function(inst) 
		if inst.sollyz_owner then
			inst.sollyz_owner.sollyz_weapons.sollyz_greencane = nil
			inst.sollyz_owner:RemoveTag("sollyz_greencane")
		end
	end)

    return inst
end

return Prefab("sollyz_greencane", fn, assets)