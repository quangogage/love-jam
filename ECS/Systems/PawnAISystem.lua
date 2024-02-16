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
local DEFAULT_ARRIVAL_THRESHOLD = 50
-- ──────────────────────────────────────────────────────────────────────

return function (concord)
    local PawnAISystem = concord.system({
        entities = { 'target' }
    })

    --------------------------
    -- [[ Core Functions ]] --
    --------------------------
    function PawnAISystem:update(dt)
        for _, e in ipairs(self.entities) do
            local target = e.target
            self:_moveTowardsTarget(e, dt)
        end
    end


    -----------------------------
    -- [[ Private Functions ]] --
    -----------------------------
    -- Move an entity towards either `target.position` or the `target.entity`.
    ---@param e Pawn | table
    ---@param dt number
    function PawnAISystem:_moveTowardsTarget(e, dt)
        local world = self:getWorld()
        if world then
            local distance = self:_getDistanceToTarget(e)
            local arrivalThreshold
            local x, y

            -- Are we targeting a position or an entity?
            if e.target.position then
                x, y = e.target.position.x, e.target.position.y
                arrivalThreshold = DEFAULT_ARRIVAL_THRESHOLD
            elseif e.target.entity then
                x, y = e.target.entity.position.x, e.target.entity.position.y
                arrivalThreshold = self:_getArrivalThreshold(e)
            end
            

            if distance > arrivalThreshold then
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
                    e.position.x = e.position.x +
                        math.cos(direction) * e.movement.walkSpeed * dt
                    e.position.y = e.position.y +
                        math.sin(direction) * e.movement.walkSpeed * dt
                end
            end
        end
    end

    -- Get how close the pawn needs to be to the target before they
    -- stop moving.
    ---@param e Pawn | table
    ---@return number
    function PawnAISystem:_getArrivalThreshold(e)
        return e.combatProperties.range or 50
    end

    -- Get the distance between the pawn and the target.
    -- The bottom of each entity is used as the reference point.
    function PawnAISystem:_getDistanceToTarget(e)
        local targetX, targetY
        if e.target.position then
            targetX, targetY = e.target.position.x, e.target.position.y
        else
            targetX = e.target.entity.position.x
            targetY = e.target.entity.position.y + e.target.entity.dimensions.height / 2
        end
        return math.sqrt(
            (targetX - e.position.x) ^ 2 +
            (targetY - e.position.y) ^ 2
        )
    end
    return PawnAISystem
end
