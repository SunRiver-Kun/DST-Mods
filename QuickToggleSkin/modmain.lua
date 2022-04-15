GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(t, k) or GLOBAL.rawget(GLOBAL, k) end })

local Image = require "widgets/image"
local ImageButton = require "widgets/imagebutton"
AddClassPostConstruct("widgets/redux/craftingmenu_pinslot", function(self)
    local function GetValidSkins(recipe_name)
        if not recipe_name then return nil end

        local tb = {}
        if PREFAB_SKINS[recipe_name] then
            for k, v in pairs(PREFAB_SKINS[recipe_name]) do
                if TheInventory:CheckOwnershipGetLatest(v) then
                    table.insert(tb, v)
                end
            end
        end
        if #tb > 0 then
            table.insert(tb, recipe_name)
            return tb
        else
            return nil
        end
    end

    local function GetSkinIndex(skinlist, skin_name)
        if not skinlist or not skin_name then return 1 end
        for k, v in pairs(skinlist) do
            if v == skin_name then
                return k
            end
        end
        return 1
    end

    local function ToggleButtonShow(show)
        if show then
            self.bt_skinleft:Show()
            self.bt_skinright:Show()
        else
            self.bt_skinleft:Hide()
            self.bt_skinright:Hide()
        end
    end

    local arrow_scale = 0.6
    self.bt_skinleft = self.recipe_popup:AddChild(ImageButton("images/crafting_menu.xml", "page_arrow_hl.tex"))
    self.bt_skinleft:SetPosition(-20, 50)
    self.bt_skinleft:SetScale(-arrow_scale, arrow_scale)
    self.bt_skinleft:SetOnClick(function()
        if not self.skinlist or not self.skinindex then return end
        self.skinindex = #self.skinlist - (#self.skinlist - self.skinindex + 1) % (#self.skinlist)
        self:SetRecipe(self.recipe_name, self.skinlist[self.skinindex])
    end)
    self.bt_skinleft:Hide()
    
    self.bt_skinright = self.recipe_popup:AddChild(ImageButton("images/crafting_menu.xml", "page_arrow_hl.tex"))
    self.bt_skinright:SetPosition(20, 50)
    self.bt_skinright:SetScale(arrow_scale, arrow_scale)
    self.bt_skinright:SetOnClick(function()
        if not self.skinlist or not self.skinindex then return end
        self.skinindex = 1 + self.skinindex % #self.skinlist
        self:SetRecipe(self.recipe_name, self.skinlist[self.skinindex])
    end)
    self.bt_skinright:Hide()

    --当显示制作时，我们检查recipe_name是否改变
    local ShowRecipe = self.ShowRecipe
    local lastrecipe_name = nil
    self.ShowRecipe = function (self)
        ShowRecipe(self)
        if lastrecipe_name~=self.recipe_name then
            lastrecipe_name = self.recipe_name
            self.skinlist = GetValidSkins(self.recipe_name)
            self.skinindex = GetSkinIndex(self.skinlist, self.skin_name)
            ToggleButtonShow(self.skinlist)
        end
    end
end)
