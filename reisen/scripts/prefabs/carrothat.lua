
local assets=
{
	Asset("ANIM", "anim/carrothat.zip"),  --动画文件
	Asset("IMAGE", "images/inventoryimages/carrothat.tex"), --物品栏贴图
	Asset("ATLAS", "images/inventoryimages/carrothat.xml"),
}

local prefabs =
{
}
local function onequiphat(inst, owner) --装备的函数
    owner.AnimState:OverrideSymbol("swap_hat", "carrothat", "swap_hat")
								--替换的动画部件	使用的动画  第三个照样也是文件夹的名字
    owner.AnimState:Show("HAT")
    owner.AnimState:Show("HAT_HAIR")
    owner.AnimState:Hide("HAIR_NOHAT")
    owner.AnimState:Hide("HAIR")
        
    if owner:HasTag("player") then --隐藏head  显示head——hat
            owner.AnimState:Hide("HEAD")
            owner.AnimState:Show("HEAD_HAT")
		if owner:HasTag("Reisen")	then 
			owner:AddTag("carrothat")
			if owner.components.hunger then 
			owner.components.hunger.hungerrate = 3 * owner.components.hunger.hungerrate	--3倍饥饿速度 3*0.85*1/6
			end
		end
    end
      --[[  if inst.components.fueled ~= nil then --如果有耐久 那么开始掉
            inst.components.fueled:StartConsuming()
        end
	--]]
end

local function onunequiphat(inst, owner) --解除帽子
    owner.AnimState:Hide("HAT")
    owner.AnimState:Hide("HAT_HAIR")
    owner.AnimState:Show("HAIR_carrothat")
    owner.AnimState:Show("HAIR")
    
        if owner:HasTag("player") then
            owner.AnimState:Show("HEAD")
            owner.AnimState:Hide("HEAD_HAT")
			
			if owner:HasTag("Reisen")	then
				owner:RemoveTag("carrothat") 
				if owner.components.hunger then 
				owner.components.hunger.hungerrate =  owner.components.hunger.hungerrate /3 	--还原饥饿速度
				end
			end
        end
	
	
       
	 --[[  if inst.components.fueled ~= nil then --停止掉耐久
            inst.components.fueled:StopConsuming()
        end
	--]]
end


local function fn(Sim)
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("carrothat")  --里
    inst.AnimState:SetBuild("carrothat")
    inst.AnimState:PlayAnimation("anim")

	inst:AddTag("carrothat")
	inst:AddTag("show_spoilage")	--加这个就有保鲜度动画
    	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable") --可检查
		
    inst:AddComponent("inventoryitem") --物品组件
	inst.components.inventoryitem.imagename = "carrothat"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/carrothat.xml"
       
	inst:AddComponent("equippable") --装备组件
	
	inst.components.equippable.equipslot = EQUIPSLOTS.HEAD --装在头上
	inst.components.equippable:SetOnEquip( onequiphat ) --装备
    inst.components.equippable:SetOnUnequip( onunequiphat ) --解除装备
	
	MakeInventoryFloatable(inst)	--可以飘在水上	
	MakeHauntableLaunchAndPerish(inst) --作祟相关
	
	inst.components.equippable.dapperness = TUNING.DAPPERNESS_LARGE	
	
	inst:AddComponent("perishable")	--腐烂的
    inst.components.perishable:SetPerishTime(0.5 * TUNING.PERISH_FAST)	
    inst.components.perishable:StartPerishing()
    inst.components.perishable:SetOnPerishFn(inst.Remove)
	
	 MakeHauntableLaunchAndPerish(inst)
   return inst
end 
    
return Prefab( "common/inventory/carrothat", fn, assets, prefabs) 