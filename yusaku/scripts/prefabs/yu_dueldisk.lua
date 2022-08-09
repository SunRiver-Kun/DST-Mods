local assets = {
    Asset("ANIM", "anim/yu_dueldisk.zip"),
    Asset("ATLAS", "images/inventoryimages/yu_dueldisk.xml")
}

local function startduel(target)
    
end

local function endduel(target)
    
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("yu_dueldisk")
    inst.AnimState:SetBuild("yu_dueldisk")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst, "small", 0.05, 0.95)

    --添加replica标签，让客户端自动添加对应组件
    inst:AddTag("_yu_shifter")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    --移除replica标签，让添加对应组件时自动添加对应标签
    inst:RemoveTag("_yu_shifter")

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/yu_dueldisk.xml"

    inst:AddComponent("yu_shifter")


    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("yu_dueldisk", fn, assets)