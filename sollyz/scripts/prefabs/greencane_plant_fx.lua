local assets =
{
    Asset("ANIM", "anim/greencane_plant_fx.zip"),
}

local function OnAnimOver(inst)
    if inst.AnimState:IsCurrentAnimation("ungrow_"..tostring(inst.variation)) then
        inst:Remove()
    else
        local x, y, z = inst.Transform:GetWorldPosition()
        for i, v in ipairs(AllPlayers) do
            if v:HasTag("sollyz_greencane_hold") and
                not (v.components.health:IsDead() or v:HasTag("playerghost")) and
                v.entity:IsVisible() and
                v:GetDistanceSqToPoint(x, y, z) < 4 then
                inst.AnimState:PlayAnimation("idle_"..tostring(inst.variation))
                return
            end
        end
        inst.AnimState:PlayAnimation("ungrow_"..inst.variation)
    end
end

local function SetVariation(inst, variation)	--1~4
    if inst.variation ~= variation then
        inst.variation = variation
        inst.AnimState:PlayAnimation("grow_"..tostring(variation))
    end
end

local function fn()
    local inst = CreateEntity()
	
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    inst:AddTag("greencane_plant_fx")

    inst.AnimState:SetBuild("greencane_plant_fx")
    inst.AnimState:SetBank("greencane_plant_fx")
    inst.AnimState:PlayAnimation("grow_1")

    inst.entity:SetPristine() --初始化

    if not TheWorld.ismastersim then
        return inst
    end

    inst.variation = 1
    inst.SetVariation = SetVariation

    inst:ListenForEvent("animover", OnAnimOver)

    return inst
end

return Prefab("greencane_plant_fx", fn, assets)
