---@author Gage Henderson 2024-02-17 08:49

local palette           = require("lists.interfaceColorPalette")
local pawnTypes         = require("lists.pawnTypes")
local PawnSelectionCard = require("Classes.Scenes.CombatScene.CombatInterface.PawnSelectionCard")

---@class PawnSelectionMenu
---@field height number
local PawnSelectionMenu = Goop.Class({
    static = {
        cards = {},
        height = 200,
    }
})


--------------------------
-- [[ Core Functions ]] --
--------------------------
function PawnSelectionMenu:init()
    self:_initCards()
end
function PawnSelectionMenu:update(dt)
end
function PawnSelectionMenu:draw()
    self:_drawBackground()
end


-----------------------------
-- [[ Private Functions ]] --
-----------------------------
function PawnSelectionMenu:_initCards()
end
function PawnSelectionMenu:_drawBackground()
    love.graphics.setColor(palette.background)
    love.graphics.rectangle("fill",
        0, love.graphics.getHeight() - self.height,
        love.graphics.getWidth(), self.height
    )
end

return PawnSelectionMenu
