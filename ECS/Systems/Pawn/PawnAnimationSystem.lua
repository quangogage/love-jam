---@author Gage Henderson 2024-02-20 05:06
--

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
    ---@param direction? string
    function PawnAnimationSystem:pawn_setAnimation(entity, animationName, direction)
        if entity.pawnAnimations then
            if entity.pawnAnimations.currentAnimation ~= animationName then
                entity.pawnAnimations.currentAnimation = animationName
                entity.pawnAnimations.timer            = 0
                entity.pawnAnimations.frame            = 1
            end
            entity.pawnAnimations.direction = direction or entity.pawnAnimations.direction
        end
    end


    --------------------------
    -- [[ Core Functions ]] --
    --------------------------
    function PawnAnimationSystem:update(dt)
        for _, e in ipairs(self.entities) do
            self:_runAnimation(e, dt)
        end
    end


    -----------------------------
    -- [[ Private Functions ]] --
    -----------------------------
    ---@param e Pawn | table
    ---@param dt number
    function PawnAnimationSystem:_runAnimation(e, dt)
        local c = e.pawnAnimations --- "c" is short for "component".
        local anim = c[c.currentAnimation][c.direction]
        c.timer = c.timer + dt

        if c.timer >= c[c.currentAnimation].framerate then

            e:give("image", anim[c.frame])

            if c.frame < #anim then
                c.frame = c.frame + 1
            else
                c.frame = 1
            end
            c.timer = 0
        end
    end

    return PawnAnimationSystem
end
