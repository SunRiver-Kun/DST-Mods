
local MakePlayerCharacter = require "prefabs/player_common"

local assets = {Asset("SCRIPT", "scripts/prefabs/player_common.lua"),}

local prefabs = {}

local start_inv = {"manrabbit_tail", "carrot_seeds", "healingsalve", }

local function lunatic(inst)
if not (inst.components.health:IsDead() or inst:HasTag("playerghost")) then
	if inst.components.sanity.current > 25 and inst.components.sanity.current <=100 then
		inst.components.locomotor.walkspeed = ( 1.15 * TUNING.WILSON_WALK_SPEED )
		inst.components.locomotor.runspeed = ( 1.15 * TUNING.WILSON_RUN_SPEED )
		
		inst.components.sanity.neg_aura_mult = 1.5
		inst.components.sanity.night_drain_mult = 1.5
		inst.components.sanity.dapperness = ( TUNING.DAPPERNESS_MED * -0.85 )
		inst.Light:Enable(false)
		
		if inst.components.sanity.current%5 <= 0.001 then
		inst.components.combat.damagemultiplier = 1 + 0.3*(100-inst.components.sanity.current)/25
		inst.components.health.absorb = 0-0.15*(100-inst.components.sanity.current)/25
		end
		
	elseif inst.components.sanity.current>1 then 
		inst.components.combat.damagemultiplier = 2.20
		inst.components.health.absorb = -0.60
		inst.Light:Enable(false)
	else
	
		inst.components.locomotor.walkspeed = ( 1.3 * TUNING.WILSON_WALK_SPEED )
		inst.components.locomotor.runspeed = ( 1.3 * TUNING.WILSON_RUN_SPEED )
		
		inst.components.sanity.neg_aura_mult = 3.0
		inst.components.sanity.night_drain_mult = 3.0
		inst.components.sanity.dapperness = ( TUNING.DAPPERNESS_MED * -1.5 )
	
		inst.components.combat.damagemultiplier = 2.50
		inst.components.health.absorb = -0.75
	
		inst.Light:Enable(true)
	end	
end
end

local function oneat(inst, food)
	if food and food.components.edible and food.prefab == "carrot" or food.prefab == "carrot_cooked" then		
		inst.components.sanity:DoDelta(100)		
	end
	
end

local common_postinit = function(inst)

	inst.MiniMapEntity:SetIcon( "reisen.tex" )
	inst.soundsname = "willow"
	
end

local master_postinit = function(inst)

	inst.components.health:SetMaxHealth(300)
	inst.components.hunger:SetMax(200)
	inst.components.sanity:SetMax(100)
	
	--inst.OnLoad = onload
    --inst.OnNewSpawn = onload
	
	inst.components.temperature.inherentinsulation = ( TUNING.INSULATION_PER_BEARD_BIT * 1.5 )
	
	inst.components.hunger.hungerrate = ( 0.85 * TUNING.WILSON_HUNGER_RATE )
	
	inst:AddTag("reisen")
	inst:RemoveTag("scarytoprey")		--官方自带标签，吓跑小动物用
	
	lunatic(inst)
	inst.components.eater:SetOnEatFn(oneat)
	
	inst.entity:AddLight()
		inst.Light:SetRadius(6)
		inst.Light:SetFalloff(.6)
		inst.Light:SetIntensity(.6)
		inst.Light:SetColour(255/255,0/255,0/255)
	inst.Light:Enable(false)
	
	inst:ListenForEvent("sanitydelta",lunatic)
	inst:WatchWorldState("phase",lunatic)
	inst:ListenForEvent("ms_respawnedfromghost",function (inst,data)
		if inst.Light then 
			inst.Light:SetRadius(6)
			inst.Light:SetFalloff(.6)
			inst.Light:SetIntensity(.6)
			inst.Light:SetColour(255/255,0/255,0/255)
			inst.Light:Enable(false)
		end
	end)
	return inst
	
end

return MakePlayerCharacter("reisen", prefabs, assets, common_postinit, master_postinit, start_inv)

-- Character Mod Made By: Senshimi [http://steamcommunity.com/id/Senshimi/]
