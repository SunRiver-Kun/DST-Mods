
local function onisduel(self, isduel)
    self.inst.replica.yu_duel:SetDuel(isduel)
    
end

local function redirect(inst, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
    if inst.components.sanity then
        inst.components.sanity:DoDelta(amount)
    end
    return true
end


local YU_Duel = Class(function(self, inst)
    self.inst = inst
    self.redirect = redirect
    self.isduel = false
    self.inst:ListenForEvent("sanitydelta", function (inst, data)
        if data.newpercent <= 0 then
            self:UnDuel()
        end
    end)
end,
nil,
{
    isduel = onisduel
})

function YU_Duel:Duel()
    if self.isduel then return end
    self.isduel = true
    if self.inst.components.health then
        self.inst.components.health.redirect = self.redirect
    end
    self.inst:PushEvent("duel")
end

function YU_Duel:UnDuel()
    if not self.isduel then return end
    self.isduel = false
    if self.inst.components.health then
        self.inst.components.health.redirect = nil
    end
    self.inst:PushEvent("unduel")
end

return YU_Duel
