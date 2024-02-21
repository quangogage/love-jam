---@author Gage Henderson 2024-02-20 05:06
--

local WALKING_VELOCITY_THRESHOLD = 15 -- Only play walking animation if the pawn is moving faster than this.
local TURNING_VELOCITY_THRESHOLD = 15 -- Only change the pawn's direction if it's moving faster than this (while walking only).
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
    ---@class PawnAnimationSystem : System
    ---@field entities Pawn[] | table[]
    local PawnAnimationSystem = concord.system({
        entities = { 'pawnAnimations' }
    })


    ----------------------------
    -- [[ Public Functions ]] --
    ----------------------------
    ---@param entity Pawn | table
    ---@param animationName string
    ---@param direction? number
    function PawnAnimationSystem:pawn_setLoopingAnimation(entity, animationName, direction)
        if entity.pawnAnimations then
            if entity.pawnAnimations.currentAnimation ~= animationName then
                entity.pawnAnimations.currentAnimation = animationName
                entity.pawnAnimations.timer            = 0
                entity.pawnAnimations.frame            = 1
            end
            if direction and not entity.pawnAnimations.oneShotAnimationName then
                if math.abs(entity.physics.velocity.x) > WALKING_VELOCITY_THRESHOLD or
                math.abs(entity.physics.velocity.y) > WALKING_VELOCITY_THRESHOLD then
                    entity.pawnAnimations.direction = self:_getAnimationDirection(direction)
                end
            end
        end
    end

    ---@param entity Pawn | table
    ---@param animationName string
    ---@param direction? number
    function PawnAnimationSystem:pawn_playAnimationOnce(entity, animationName, direction)
        if entity.pawnAnimations then
            entity.pawnAnimations.oneShotAnimationName = animationName
            entity.pawnAnimations.timer = 0
            entity.pawnAnimations.frame = 1
            if direction then
                entity.pawnAnimations.direction = self:_getAnimationDirection(direction)
            end
        end
    end


    --------------------------
    -- [[ Core Functions ]] --
    --------------------------
    function PawnAnimationSystem:update(dt)
        for _, e in ipairs(self.entities) do
            self:_setLoopingAnimationState(e)
            self:_runAnimation(e, dt)
            if e.target and e.combatProperties then
                self:_faceTarget(e)
            end
        end
    end


    -----------------------------
    -- [[ Private Functions ]] --
    -----------------------------
    ---@param e Pawn | table
    ---@param dt number
    function PawnAnimationSystem:_runAnimation(e, dt)
        local c = e.pawnAnimations --- "c" is short for "component".
        local anim = self:_getAnimation(e)
        local framerate = self:_getFramerate(e)
        c.timer = c.timer + dt

        if c.timer >= framerate then

            e:give('image', anim[c.frame])

            if c.frame < #anim then
                c.frame = c.frame + 1
            else
                if c.oneShotAnimationName then
                    c.oneShotAnimationName = nil
                end
                c.frame = 1
            end
            c.timer = 0
        end
    end


    -- Return the oneshot animation if it exists, otherwise return the looping animation.
    ---@param e Pawn | table
    ---@return table
    function PawnAnimationSystem:_getAnimation(e)
        local c = e.pawnAnimations
        if c.oneShotAnimationName then
            return c[c.oneShotAnimationName][c.direction]
        else
            return c[c.currentAnimation][c.direction]
        end
    end

    -- Given the direction in radians, return the appropriate animation direction.
    -- ie up, down, left, right.
    ---@param radianDirection number
    function PawnAnimationSystem:_getAnimationDirection(radianDirection)
        radianDirection = self:_getAbsoluteRotation(radianDirection)
        local direction = 'down'
        local minDistance = math.abs(radianDirection - animationDirections[direction])
        for k, v in pairs(animationDirections) do
            local distance = math.abs(radianDirection - v)
            if distance < minDistance then
                direction = k
                minDistance = distance
            end
        end
        return direction
    end


    -- Set the looping animation of the pawn depending on it's movement.
    ---@param e Pawn | table
    function PawnAnimationSystem:_setLoopingAnimationState(e)
        local velocity = e.physics.velocity
        if velocity then
            local direction = math.atan2(velocity.y, velocity.x)
            local speed = math.sqrt(velocity.x^2 + velocity.y^2)
            if speed > WALKING_VELOCITY_THRESHOLD then
                self:pawn_setLoopingAnimation(e, 'walk', direction)
            else
                self:pawn_setLoopingAnimation(e, 'idle', direction)
            end
        end
    end

    -- Get the absolute rotation.
    -- Don't get any negative values or values greater than 2 * pi.
    function PawnAnimationSystem:_getAbsoluteRotation(rotation)
        if rotation < 0 then
            rotation = 2 * math.pi + rotation
        end
        return rotation
    end

    -- Get the framerate of the current animation / frame.
    ---@param e Pawn | table
    ---@return number
    function PawnAnimationSystem:_getFramerate(e)
        local c = e.pawnAnimations
        local anim = c[c.currentAnimation]
        if c.oneShotAnimation then
            anim = c[c.oneShotAnimation]
        end
        return anim.perFrameFramerateOffset[c.frame] or anim.framerate
    end

    -- Face your target - Assumes you have a combatProperties and target
    -- component.
    ---@param e Pawn | table
    function PawnAnimationSystem:_faceTarget(e)
        if e.target.entity then
            if e.groundPosition and e.target.groundPosition then
                local range = e.combatProperties.range

                if math.sqrt((e.groundPosition.x - e.target.groundPosition.x)^2 +
                (e.groundPosition.y - e.target.groundPosition.y)^2) < range then
                    e.pawnAnimations.direction = math.atan2(
                        e.target.groundPosition.y - e.groundPosition.y,
                        e.target.groundPosition.x - e.groundPosition.x
                    )
                end
            end
        end
    end

    return PawnAnimationSystem
end
