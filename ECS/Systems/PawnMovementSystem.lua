---@author Gage Henderson 2024-02-16 11:06
--
---@class PawnMovementSystem : System
-- A simple class that moves pawns towards their target position's.
--

-- ──────────────────────────────────────────────────────────────────────
-- ╭─────────────────────────────────────────────────────────╮
-- │ Configuration:                                          │
-- ╰─────────────────────────────────────────────────────────╯
local ARRIVAL_THRESHOLD = 15
-- ──────────────────────────────────────────────────────────────────────

return function (concord)
    local PawnMovementSystem = concord.system({
        entities = { 'position', 'targetPosition' }
    })

    --------------------------
    -- [[ Core Functions ]] --
    --------------------------
    function PawnMovementSystem:update(dt)
        for _, e in ipairs(self.entities) do
            self:_moveTowardsTarget(e, dt)
        end
    end


    -----------------------------
    -- [[ Private Functions ]] --
    -----------------------------
    ---@param e Pawn | table
    ---@param dt number
    function PawnMovementSystem:_moveTowardsTarget(e, dt)
        local world = self:getWorld()
        if world then
            local distance = math.sqrt(
                (e.targetPosition.x - e.position.x) ^ 2 +
                (e.targetPosition.y - e.position.y) ^ 2
            )
            if distance > ARRIVAL_THRESHOLD then
                local direction = math.atan2(
                    e.targetPosition.y - e.position.y,
                    e.targetPosition.x - e.position.x
                )
                e:ensure('movement')
                if e.physics then
                    world:emit('physics_applyForce', e,
                        math.cos(direction) * e.movement.walkSpeed,
                        math.sin(direction) * e.movement.walkSpeed
                    )
                else
                    e.position.x = e.position.x + math.cos(direction) * e.movement.walkSpeed * dt
                    e.position.y = e.position.y + math.sin(direction) * e.movement.walkSpeed * dt
                end
            end
        end
    end

    return PawnMovementSystem
end
