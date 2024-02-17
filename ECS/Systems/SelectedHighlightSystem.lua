---@author Gage Henderson 2024-02-17 05:52
--
---@class SelectedHighlightSystem : System
-- A very focused and simple system for visually distinguishing selected
-- entities.
--

local FONT = love.graphics.newFont(12)
local COLOR = { 1, 0, 1 }


return function (concord)
    local SelectedHighlightSystem = concord.system({
        entities = { 'selected' }
    })

    function SelectedHighlightSystem:draw()
        love.graphics.setColor(COLOR)
        love.graphics.setFont(FONT)
        for _, e in ipairs(self.entities) do
            love.graphics.print('v', e.position.x - FONT:getWidth('v') / 2,
                e.position.y - e.dimensions.height / 2 - FONT:getHeight()
            )
        end
    end

    return SelectedHighlightSystem
end
