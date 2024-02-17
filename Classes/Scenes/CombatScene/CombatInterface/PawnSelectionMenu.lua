---@author Gage Henderson 2024-02-17 08:49
--
---@class PawnSelectionMenu
--

local palette = require("lists.interfaceColorPalette")

local PawnSelectionMenu = Goop.Class({
    static = {
        cards = {},
        height = 200,
    }
})


--------------------------
-- [[ Core Functions ]] --
--------------------------
function PawnSelectionMenu:update(dt)
end
function PawnSelectionMenu:draw()
    self:_drawBackground()
end


-----------------------------
-- [[ Private Functions ]] --
-----------------------------
function PawnSelectionMenu:_drawBackground()
    love.graphics.setColor(palette.background)
    love.graphics.rectangle("fill",
        0, love.graphics.getHeight() - self.height,
        love.graphics.getWidth(), self.height
    )
end

return PawnSelectionMenu
