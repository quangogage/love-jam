---@author Gage Henderson 2024-02-16 16:00
--
---@class PawnPushSystem : System
-- A very simple system that pushes pawns away from each other if they are
-- too close.
--
-- Collision is considered to be the bottom of the pawn, and the depth of the
-- pawn.

local PUSH_FORCE = 240

return function (concord)
    local PawnPushSystem = concord.system({
        friendly = { 'position', 'dimensions', 'physics', 'friendly' },
        hostile = { 'position', 'dimensions', 'physics', 'hostile' }
    })

    function PawnPushSystem:update()
        local world = self:getWorld()
        for i = 1, 2 do
            local entities = i == 1 and self.friendly or self.hostile
            for i = 1, #entities do
                local e1 = entities[i]
                for j = i + 1, #entities do
                    local e2 = entities[j]
                    local e1Circle = {
                        x = e1.position.x,
                        y = e1.position.y + e1.dimensions.height / 2,
                        radius = e1.pushbackRadius.value
                    }
                    local e2Circle = {
                        x = e2.position.x,
                        y = e2.position.y + e2.dimensions.height / 2,
                        radius = e2.pushbackRadius.value
                    }
                    local distance = math.sqrt(
                        (e1Circle.x - e2Circle.x) ^ 2 +
                        (e1Circle.y - e2Circle.y) ^ 2
                    )
                    if distance <= e1Circle.radius + e2Circle.radius then
                        local angle = math.atan2(
                            e2.position.y - e1.position.y,
                            e2.position.x - e1.position.x
                        )
                        world:emit('physics_applyForce', e1,
                            math.cos(angle) * -PUSH_FORCE,
                            math.sin(angle) * -PUSH_FORCE
                        )
                        world:emit('physics_applyForce', e2,
                            math.cos(angle) * PUSH_FORCE,
                            math.sin(angle) * PUSH_FORCE
                        )
                    end
                end
            end
        end
    end


    ---@return {x: number, y: number, width: number, height: number}
    function PawnPushSystem:_getCollisionRectangle(e)
        return {
            x = e.position.x,
            y = e.position.y + e.dimensions.height - e.dimensions.depth / 2,
            width = e.dimensions.width,
            height = e.dimensions.depth
        }
    end

    ---@param r1 {x: number, y: number, width: number, height: number}
    ---@param r2 {x: number, y: number, width: number, height: number}
    function PawnPushSystem:_isColliding(r1, r2)
        return r1.x + r1.width / 2 > r2.x - r2.width / 2 and
            r1.x - r1.width / 2 < r2.x + r2.width / 2 and
            r1.y + r1.height / 2 > r2.y - r2.height / 2 and
            r1.y - r1.height / 2 < r2.y + r2.height / 2
    end

    return PawnPushSystem
end
