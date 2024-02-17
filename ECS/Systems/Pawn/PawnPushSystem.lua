---@author Gage Henderson 2024-02-16 16:00
--
---@class PawnPushSystem : System
-- A very simple system that pushes pawns away from each other if they are
-- too close.
--
-- Collision is considered to be the bottom of the pawn, and the depth of the
-- pawn.

local PUSH_FORCE = 1000

return function (concord)
    local PawnPushSystem = concord.system({
        entities = { 'position', 'dimensions', 'physics' }
    })

    function PawnPushSystem:update(dt)
        local world = self:getWorld()
        for i = 1, #self.entities do
            local e1 = self.entities[i]
            for j = i + 1, #self.entities do
                local e2 = self.entities[j]
                local e1Rect = self:_getCollisionRectangle(e1)
                local e2Rect = self:_getCollisionRectangle(e2)
                if self:_isColliding(e1Rect, e2Rect) then
                    local angle = math.atan2(
                        e2Rect.y - e1Rect.y,
                        e2Rect.x - e1Rect.x
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
