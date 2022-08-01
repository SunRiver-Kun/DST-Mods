 
local foods = {
    peach_smoothie = {
        -- test = function(cooker, names, tags)
        --     return (names.peach or names.grilled_peach) and (names.peach or names.grilled_peach) >= 2 and tags.dairy and
        --                tags.sweetener and not tags.meat and not tags.egg and not tags.inedible and not tags.monster
        -- end,
        test = function(cooker, names, tags)
            return true
        end,
        priority = 100,
        foodtype = "VEGGIE",
        health = 20,
        hunger = 65,
        sanity = 10,
        perishtime = TUNING.PERISH_MED,
        cooktime = 0.5,
    }
}

for k,v in pairs(foods) do
    v.name = k
    v.weight = v.weight or 1
    v.priority = v.priority or 50

	v.cookbook_category = "cookpot"
    v.cookbook_atlas = "images/inventoryimages/"..v.name..".xml"
    
    AddCookerRecipe("cookpot", v)
end


