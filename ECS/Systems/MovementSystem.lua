---@author Gage Henderson datetime
--
---@class MovementSystem : System
-- Simple class that probs shouldn't exist.
--

return function (concord)
    local MovementSystem = concord.system({
        entities = {'movement', 'position'}
    })

    function MovementSystem:update(dt)
        for _,e in ipairs(self.entities) do
            local movement = e.movement
            if movement.movementPreset == "move forwards" then
                e.position.x = e.position.x + (math.cos(movement.direction) * movement.walkSpeed * dt)
                e.position.y = e.position.y + (math.sin(movement.direction) * movement.walkSpeed * dt)
            end
        end
    end

    return MovementSystem
end
