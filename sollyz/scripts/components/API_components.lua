--[[
AddComponentPostInit("grower", function(self)
self.PlantItem = function (self,item, doer)
    if item.components.plantable == nil then
        return false
    end

    self:Reset()

    local prefab = nil
    if item.components.plantable.product and type(item.components.plantable.product) == "function" then
        prefab = item.components.plantable.product(item)
    else
        prefab = item.components.plantable.product or item.prefab
    end

    self.inst:AddTag("NOCLICK")

    local pos = self.inst:GetPosition()

    for i, v in ipairs(self.croppoints) do
        local plant1 = SpawnPrefab("plant_normal")
        plant1.persists = false
        plant1.components.crop:StartGrowing(prefab, item.components.plantable.growtime * self.growrate, self.inst)
        plant1.Transform:SetPosition(pos.x + v.x, pos.y + v.y, pos.z + v.z)

        self.crops[plant1] = true
    end

    self.isempty = false

    if self.onplantfn ~= nil then
        self.onplantfn(item)
    end
    item:Remove()

    TheWorld:PushEvent("itemplanted", { doer = doer, pos = pos }) --this event is pushed in other places too
------------------------只添
	--print("api grower is ok!!")
	doer:PushEvent("sollyz_greencane_itemplanted",{item = item, pos = pos })	--table
------------------------
    return true
end
end)

AddComponentPostInit("deployable", function(self)
self.Deploy = function (self,pt, deployer, rot)
    if not self:CanDeploy(pt, nil, deployer) then
        return
    end
    local isplant = self.inst:HasTag("deployedplant")
    if self.ondeploy ~= nil then
        self.ondeploy(self.inst, pt, deployer, rot or 0)
    end
    -- self.inst is removed during ondeploy
    deployer:PushEvent("deployitem", { prefab = self.inst.prefab })
    if isplant then
        TheWorld:PushEvent("itemplanted", { doer = deployer, pos = pt }) --this event is pushed in other places too
		-------------------只添
			--print("api deployable is ok")
		deployer:PushEvent("sollyz_greencane_itemplanted",{item = self.inst, pos = pt})	--table
		--------------------		
    end
    return true
end
end)--]]