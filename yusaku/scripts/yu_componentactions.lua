--客户端判断并插入动作，使之可以播放对应动画

local COMPONENT_ACTIONS = {
    SCENE = { -- args: inst, doer, actions, right

    },
    USEITEM = { -- args: inst, doer, target, actions, right     对别人、其他物品使用
        yu_sanityhealer = function(inst, doer, target, actions) --除了玩家，什么生物有sanity呢？
            if target.replica.sanity ~= nil then
                table.insert(actions, ACTIONS.YU_SANITYHEAL)
            end
        end
    },
    POINT = { -- args: inst, doer, pos, actions, right

    },
    EQUIPPED = { -- args: inst, doer, target, actions, right

    },
    INVENTORY = { -- args: inst, doer, actions, right   物品栏，或放在自己身上
        yu_sanityhealer = function(inst, doer, actions)
            if doer.replica.sanity ~= nil then
                table.insert(actions, ACTIONS.YU_SANITYHEAL)
            end
        end
    }
}

for actiontype, tb in pairs(COMPONENT_ACTIONS) do
    for component, fn in pairs(tb) do
        AddComponentAction(actiontype, component, fn)
    end
end
