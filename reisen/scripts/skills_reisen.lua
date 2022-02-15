
----------辅助函数
local function SpawnEffect(prefab,duration,player,color)	 --刷人物位置刷特效
	if not player or type(prefab)~="string" then return end
	local duration = duration or 0.5
	local myprefab = SpawnPrefab(prefab)
	if color then 	
	--myprefab.AnimState:SetMultColour(color[1],color[2],color[3],color[4])	
	myprefab.AnimState:SetAddColour(color[1],color[2],color[3],color[4])
	end	
    myprefab.Transform:SetPosition(player.Transform:GetWorldPosition())
	myprefab:DoTaskInTime(duration, myprefab.Remove)
end

local function SpawnEffect2(prefab,duration,player,color)
	if not type(prefab)=="string" then print("SpawnEffect2 input wrong!") return end
	local myprefab = SpawnPrefab(prefab)
	local duration = duration or 3
	if myprefab==nil then print("no prefab!") return end
	if color then
		if not myprefab.AnimState then myprefab.entity:AddAnimState() end
		myprefab.AnimState:SetAddColour(color[1],color[2],color[3],color[4])
	end
	myprefab.entity:SetParent(player.entity)
	myprefab:DoTaskInTime(duration,myprefab.Remove)
end

local function distance(x1,y1,z1,x2,y2,z2)	--计算距离，1在饥荒里面就是一个墙的距离
	local distance_two = (x1-x2)*(x1-x2) + (y1-y2)*(y1-y2) + (z1-z2)*(z1-z2)
	return math.sqrt(distance_two),distance_two
end

---------
AddModRPCHandler("reisen", "reisen_redeyes", function(player)	
	if player.components.sanity and player.components.sanity.current>=10 then
		player.components.sanity:SetPercent(0);
		
		local x,y,z = player.Transform:GetWorldPosition()
		local targets = TheSim:FindEntities(x,0,z,6,nil,{"player","playerghost"})
		if targets and type(targets)=="table" then
			for _,v in pairs(targets) do 		
				if v.components.hauntable ~= nil and v.components.hauntable.panicable then
				v.components.hauntable:Panic(TUNING.BATTLESONG_PANIC_TIME*2)
				--AddEnemyDebuffFx("battlesong_instant_panic_fx", v)
				SpawnEffect2("battlesong_instant_panic_fx",5,v,{255,0,0,1})
				end
			end
		end	
	end
end)
----------------------------------------------

AddPlayerPostInit(function(inst)	
	
	inst:DoTaskInTime(0, function()	--定时任务
		if inst == GLOBAL.ThePlayer and inst.prefab == "reisen" then
		------------------------------------------------------------------------------ 
		
				GLOBAL.TheInput:AddKeyDownHandler(KEY_R,function()		--R键主动
					local screen = GLOBAL.TheFrontEnd:GetActiveScreen()		--判断
            		local IsHUDActive = screen and screen.name == "HUD"	---是不是
            		if inst:IsValid() and IsHUDActive then				---IsHUDScreen()					
					--------------------------		
						SendModRPCToServer(MOD_RPC["reisen"]["reisen_redeyes"])	
					-------------------------
					end
				end)
				
		------------------------------------------------------------------------
		end
	end)
end)








