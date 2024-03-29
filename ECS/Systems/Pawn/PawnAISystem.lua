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
        entities = { 'target' },
    })


    --------------------------
    -- [[ Core Functions ]] --
    --------------------------
    function PawnAISystem:update(dt)
        for _, e in ipairs(self.entities) do
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
            local arrivalThreshold = self:_getArrivalThreshold(e)
            local x, y


            -- Are we targeting a position or an entity?
            if e.target.position then
                x, y = e.target.position.x, e.target.position.y
            elseif e.target.entity then
                x, y = e.target.entity.groundPosition.x, e.target.entity.groundPosition.y
            end

            if distance >= arrivalThreshold then
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
            elseif e.target.position then
                e:remove('target')
            end
        end
    end

    -- Get the distance between the pawn and the target.
    -- The bottom of each entity is used as the reference point.
    function PawnAISystem:_getDistanceToTarget(e)
        local targetX, targetY
        if e.target.position then
            targetX, targetY = e.target.position.x, e.target.position.y
        elseif e.target.entity and e.target.entity.groundPosition then
            targetX = e.target.entity.groundPosition.x
            targetY = e.target.entity.groundPosition.y
        end
        if e.groundPosition then
            return math.sqrt(
                (targetX - e.groundPosition.x) ^ 2 +
                (targetY - e.groundPosition.y) ^ 2
            )
        else
            return math.sqrt(
                (targetX - e.position.x) ^ 2 +
                (targetY - e.position.y) ^ 2
            )
        end
    end

    function PawnAISystem:_getArrivalThreshold(e)
        if e.target.entity then
            local threshold = 0
            if e.combatProperties.range then
                threshold = threshold + e.combatProperties.range * 0.85
            end
            if e.target.entity.collision then
                threshold = threshold + e.target.entity.collision.radius
            end
            if e.collision then
                threshold = threshold + e.collision.radius
            end
            return threshold
        end
        return DEFAULT_ARRIVAL_THRESHOLD
    end

    return PawnAISystem
end
