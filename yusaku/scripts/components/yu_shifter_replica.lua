local YU_Shifter = Class(function(self, inst)
    self.inst = inst
    self.str = net_string(inst.GUID, "yu_shifter.str", "shifter_strchanged")
end)

function YU_Shifter:GetStr()
    return self.str:value()
end

--下面是仅服务器函数
function YU_Shifter:SetStr(str)
    if not TheWorld.ismastersim then return end
    self.str:set(str)
end

return YU_Shifter
