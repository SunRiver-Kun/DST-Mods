
local assets=
{
	Asset("ANIM", "anim/nohat.zip"),  --动画文件
	Asset("IMAGE", "images/inventoryimages/nohat.tex"), --物品栏贴图
	Asset("ATLAS", "images/inventoryimages/nohat.xml"),
}

local prefabs =
{
}

local function headfn(inst)
	local now = TheWorld.state.phase
	if inst.components.equippable then
		if now == "dusk" then
		inst.components.equippable.dapperness = TUNING.DAPPERNESS_LARGE
		else
		inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED
		end
	end
end

local function opentop_onequip(inst, owner) 
--这里其实跟装备是一样的 唯一的区别是这个不会隐藏head 这样适用于花环之类的不会遮住头发的帽子
        owner.AnimState:OverrideSymbol("swap_hat", "nohat", "swap_hat")
        owner.AnimState:Show("HAT")
        owner.AnimState:Hide("HAT_HAIR")
        owner.AnimState:Show("HAIR_NOHAT")
        owner.AnimState:Show("HAIR")
        
        owner.AnimState:Show("HEAD")
        owner.AnimState:Hide("HEAD_HAIR")
				
		if inst.components.fueled ~= nil then
            inst.components.fueled:StartConsuming()
        end
       
    end

local function onunequiphat(inst, owner) --解除帽子
    owner.AnimState:Hide("HAT")
    owner.AnimState:Hide("HAT_HAIR")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:Show("HAIR")
    
        if owner:HasTag("player") then
            owner.AnimState:Show("HEAD")
            owner.AnimState:Hide("HEAD_HAT")
        end

        if inst.components.fueled ~= nil then --停止掉耐久
            inst.components.fueled:StopConsuming()
        end
end


local function fn(Sim)
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("nohat")  --里
    inst.AnimState:SetBuild("nohat")
    inst.AnimState:PlayAnimation("anim")

	inst:AddTag("hat")
	inst:AddTag("icebox_valid")		--加这个就可以放进冰箱
    inst:AddTag("show_spoilage")	--加这个就有保鲜度动画	
		
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable") --可检查
		
    inst:AddComponent("inventoryitem") --物品组件
	inst.components.inventoryitem.imagename = "nohat"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/nohat.xml"
       
	inst:AddComponent("equippable") --装备组件
	
	inst.components.equippable.equipslot = EQUIPSLOTS.HEAD --装在头上
    headfn(inst)
	inst.components.equippable:SetOnEquip( opentop_onequip ) --装备
    inst.components.equippable:SetOnUnequip( onunequiphat ) --解除装备
	
	MakeInventoryFloatable(inst)	--可以飘在水上	
	MakeHauntableLaunchAndPerish(inst) --作祟相关
	
	inst:WatchWorldState("phase", headfn )
		
	inst:AddComponent("perishable")	--腐烂的
    inst.components.perishable:SetPerishTime( TUNING.PERISH_FAST * 2)	--6天 * 2 ，新鲜 50%  变质  20% 腐烂
    inst.components.perishable:StartPerishing()
	inst.components.perishable:SetOnPerishFn(function(inst) -- 腐烂以后调用
		local moonbutterfly = SpawnPrefab("moonbutterfly") 
			moonbutterfly.Transform:SetPosition(inst.Transform:GetWorldPosition())
			inst:Remove()
	end)
	inst:ListenForEvent("forceperishchange",function(inst)	--变质的时候直接改腐败，然后调用上面那个函数
		if not inst:HasTag("fresh") then
			inst.components.perishable:SetPercent(0)		
		end
	end)

	
   return inst
end 
    
return Prefab( "common/inventory/nohat", fn, assets, prefabs) 