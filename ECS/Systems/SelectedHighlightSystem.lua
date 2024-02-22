---@author Gage Henderson 2024-02-17 05:52
--
---@class SelectedHighlightSystem : System
-- A very focused and simple system for visually distinguishing selected
-- entities.
--

local COLOR = { 0, 1, 0 }


return function (concord)
    local SelectedHighlightSystem = concord.system({
        entities = { 'selected', 'friendly' }
    })

    function SelectedHighlightSystem:draw()
        love.graphics.setColor(COLOR)
        for _, e in ipairs(self.entities) do
            local image     = e:get('image').value
            local offset    = e:get('offset') or { x = 0.5, y = 0.5 }
            local scale     = e:get('scale') or { x = 1, y = 1 }
            local increase = 1.2
            love.graphics.setColor(0,1,0,1)
            love.graphics.draw(image,
                e.position.x, e.position.y - e.position.z,
                0, scale.x*increase, scale.y*increase,
                image:getWidth() * offset.x, image:getHeight() * offset.y
            )
        end
    end

    return SelectedHighlightSystem
end
