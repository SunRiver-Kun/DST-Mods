
local YU_Shiftable = Class(function(self, inst)
    self.inst = inst

end)


function YU_Shiftable:Shift(shifter)
    print("Shift++++++++++++", shifter)
end

return YU_Shiftable
