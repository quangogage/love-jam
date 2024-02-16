---@author Gage Henderson 2024-02-16 11:57
--
---@class PawnAISystem : System
-- Control Pawns.
-- Behavior is determined by the `Target` component.
--

-- ──────────────────────────────────────────────────────────────────────
-- ╭─────────────────────────────────────────────────────────╮
-- │ Configuration:                                          │
-- ╰─────────────────────────────────────────────────────────╯
local ARRIVAL_THRESHOLD = 15
-- ──────────────────────────────────────────────────────────────────────


return function(concord)
    local PawnAISystem = concord.system({
        entities = { "target" }
    })

    --------------------------
    -- [[ Core Functions ]] --
    --------------------------
    function PawnAISystem:update(dt)
        for _, e in ipairs(self.entities) do
            local target = e.target
            if target.position then
                self:_moveToPosition(e, target.position.x, target.position.y, dt)
            end
        end
    end


    -----------------------------
    -- [[ Private Functions ]] --
    -----------------------------
    -- Move an entity towards the specified location.
    ---@param e Pawn | table
    ---@param x number
    ---@param y number
    ---@param dt number
    function PawnAISystem:_moveToPosition(e, x, y, dt)
        local world = self:getWorld()
        if world then
            local distance = math.sqrt(
                (x - e.position.x) ^ 2 +
                (y - e.position.y) ^ 2
            )
            if distance > ARRIVAL_THRESHOLD then
                local direction = math.atan2(
                    y - e.position.y,
                    x - e.position.x
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
    return PawnAISystem
end
