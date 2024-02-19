---@author Gage Henderson 2024-02-18 20:59
--
---@class Element
---@field position table
---@field dimensions table
---@field anchor table
---@field offset table
--
-- Base class for all UI elements.
--
-- Primarily exists to implement anchoring functionality.
-- Anchor points are normalvectors that are used to position the element
-- relative to the screen.
--
-- offset is a vector that is added to the position of the element after
-- it has been anchored.

local Element = Goop.Class({
    static = {
        type = 'Element',
    },
    dynamic = {
        position   = { x     = 0, y      = 0 },
        dimensions = { width = 0, height = 0 },
        anchor     = { x     = 0, y      = 0 },
        offset     = { x     = 0, y      = 0 },
    }
})

function Element:setPosition()
    self.position.x = love.graphics.getWidth() * self.anchor.x + self.offset.x
    self.position.y = love.graphics.getHeight() * self.anchor.y + self.offset.y
end

function Element:update()
    self:setPosition()
end

return Element
