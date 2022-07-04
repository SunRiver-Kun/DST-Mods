GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(t,k) or GLOBAL.rawget(GLOBAL,k) end})

modimport("scripts/helpers")  

--override console  写在了SR_DebugHelper里
-- AddClassPostConstruct("screens/consolescreen",function (self)
--     local Run = self.Run
--     self.Run = function (self)
--         local fnstr = self.console_edit:GetString()
--         if string.find(fnstr,"sr_get") then    --self.toggle_remote_execute and
--             local inst = s_get()
--             if inst then
--                 local x,y,z = inst.Transform:GetWorldPosition()
--                 c_remote("sr_findinst("..x..","..y..","..z..")")
--             else
--                 c_remote("sr_findinst()")
--             end
--         end
--         Run(self)
--     end    
-- end)