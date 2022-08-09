local function onstr(self, str)
    self.inst.replica.yu_shifter:SetStr(self:GetStr())
end

local YU_Shifter = Class(function(self, inst)
    self.inst = inst
    self.str = "ShapeShifterAction"
end,
nil,
{
    str = onstr
})

function YU_Shifter:SetStr(str)
   self.str = str
end

function YU_Shifter:GetStr()
    return self.str
end

return YU_Shifter
