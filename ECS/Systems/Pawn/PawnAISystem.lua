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

local animationDirections = {
    right     = 0,
    down      = math.pi / 2,
    downRight = math.pi / 4,
    downLeft  = 3 * math.pi / 4,
    left      = math.pi,
    up        = 3 * math.pi / 2,
    upRight   = 7 * math.pi / 4,
    upLeft    = 5 * math.pi / 4
}

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
            local arrivalThreshold
            local x, y

            -- Are we targeting a position or an entity?
            if e.target.position then
                x, y = e.target.position.x, e.target.position.y
                arrivalThreshold = DEFAULT_ARRIVAL_THRESHOLD
            elseif e.target.entity then
                x, y = e.target.entity.position.x, e.target.entity.position.y
                arrivalThreshold = e.combatProperties.range * 0.85 -- Get a little closer than the attack range.
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
                world:emit('pawn_setAnimation', e, 'walk', self:_getAnimationDirection(e))
            end
        end
    end

    -- Get the distance between the pawn and the target.
    -- The bottom of each entity is used as the reference point.
    function PawnAISystem:_getDistanceToTarget(e)
        local targetX, targetY
        if e.target.position then
            targetX, targetY = e.target.position.x, e.target.position.y
        elseif e.target.entity then
            targetX = e.target.entity.position.x
            targetY = e.target.entity.position.y +
                e.target.entity.dimensions.height / 2
        end
        return math.sqrt(
            (targetX - e.position.x) ^ 2 +
            (targetY - e.position.y) ^ 2
        )
    end


    -- Get the nearest animation direction based on the pawn's velocity.
    function PawnAISystem:_getAnimationDirection(e)
        local movingDirection = self:_getAbsoluteRotation(math.atan2(e.physics.velocity.y, e.physics.velocity.x))
        local direction = 'down'
        local minDistance = math.abs(movingDirection - animationDirections[direction])
        for k, v in pairs(animationDirections) do
            local distance = math.abs(movingDirection - v)
            if distance < minDistance then
                direction = k
                minDistance = distance
            end
        end
        return direction
    end

    -- Get the absolute rotation.
    -- Don't get any negative values or values greater than 2 * pi.
    function PawnAISystem:_getAbsoluteRotation(rotation)
        if rotation < 0 then
            rotation = 2 * math.pi + rotation
        end
        return rotation
    end

    return PawnAISystem
end
