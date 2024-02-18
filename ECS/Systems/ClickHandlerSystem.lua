---@author Gage Henderson 2024-02-18 02:32
--
---@class ClickHandlerSystem : System
-- An extremely focused and simple class that handles clicking within the
-- game-world.
--
-- TODO: Sort allEntities by depth...
--
-- ──────────────────────────────────────────────────────────────────────
-- ╭─────────────────────────────────────────────────────────╮
-- │ Callback Event:                                         │
-- ╰─────────────────────────────────────────────────────────╯
-- `event_mousepressed(x, y, button, topEntity, allEntities)`
-- - x: number
-- - y: number
-- - button: number
-- - topEntity: Entity The top entity you clicked on.
-- - allEntities: table All entities you clicked on, including the top one.
--
-- allEntities will be in order of depth.
-- ──────────────────────────────────────────────────────────────────────

return function (concord, camera)
    local ClickHandlerSystem = concord.system({
        entities = { 'position', 'dimensions' }
    })

    function ClickHandlerSystem:mousepressed(_, _, button)
        self:_handle(button,'pressed')
    end
    function ClickHandlerSystem:mousereleased(_, _, button)
        self:_handle(button,'released')
    end

    function ClickHandlerSystem:_handle(button,event)
        local world = self:getWorld()
        if not world then return end
        local x, y = camera:getTranslatedMousePosition()

        local clickedEntities = {}
        for _, e in ipairs(self.entities) do
            local pos = e.position
            local dim = e.dimensions
            if x > pos.x - dim.width / 2 and x < pos.x + dim.width / 2 and
            y > pos.y - dim.height / 2 and y < pos.y + dim.height / 2 then
                table.insert(clickedEntities, e)
            end
        end
        world:emit('event_mouse' .. event,
            x, y, button, clickedEntities[1], clickedEntities
        )
    end

    return ClickHandlerSystem
end
