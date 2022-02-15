
--通过 event 来gotoState, state再通过事件goto下一个State

local events =
{
	EventHandler("sollyz_recover", function(inst, data)
        if not inst.sg:HasStateTag("busy") then
			inst.sg:GoToState("sollyz_recover")
        end
    end),
}


for k,v in pairs(events) do 
	AddStategraphEvent("wilson", v)
	AddStategraphEvent("wilson_client", v)
end

--[[debug
TheInput:AddKeyDownHandler(KEY_H, function()
	ThePlayer:PushEvent("sollyz_recover")
	print("push event")
end)
--]]

---[[
local states =
{
	State
    {
        name = "sollyz_recover",		
        tags = { "busy","nointerrupt"},		--nointerrupt不可打断
									
		onenter = function(inst)	
			inst.components.locomotor:Stop()
			inst.AnimState:PlayAnimation("staff")
			--inst.AnimState:PlayAnimation("sollyz_handsup")			
		end,
		--[[
		timeline = 
        {
            TimeEvent(0.6*FRAMES, function(inst) inst.AnimState:Show("ARM_carry") inst.AnimState:Hide("ARM_normal") end),	--动画的第n秒做...
			TimeEvent(4.167*FRAMES, function(inst) inst.AnimState:Hide("ARM_carry") inst.AnimState:Show("ARM_normal") end)
	   }, --]]
		
		events =	
        {
            EventHandler("animover", function(inst)		
                if inst.AnimState:AnimDone() then
                   	inst:PushEvent("sollyz_recover_animover",{success = true})
				else
					inst:PushEvent("sollyz_recover_animover",{success = false})
                end
				 inst.sg:GoToState("idle")	--]]
				 
				 --inst.sg:GoToState("jumpin_pre")		--	ThePlayer.sg:GoToState("idle")
            end)
        },
    },	
}
for k,v in pairs(states) do
	AddStategraphState("wilson",v)
	AddStategraphState("wilson_client", v)
end



--]]






















