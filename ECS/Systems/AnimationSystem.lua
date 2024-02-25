---@author Gage Henderson 2024-02-21 06:32
--
---@class AnimationSystem : System
-- Handles updating simple animations.
--
-- If you are looking for pawn/character animations see PawnAnimationSystem.
--

return function (concord)
    local AnimationSystem = concord.system({
        entities = { 'animations', 'position' },
    })


    ----------------------------
    -- [[ Public Functions ]] --
    ----------------------------
    ---@param e table
    ---@param animationName string
    function AnimationSystem:entity_playOnce(e, animationName)
        e.animations.playOnceAnimation = e.animations.list[animationName]
        e.animations.frame = 1
        e.animations.timer = 0
        -- TODO: Store this callback somewhere more logical.
        e.animations.onComplete = e.animations.playOnceAnimation.onComplete
    end

    ---@param e table
    ---@param animationName string
    function AnimationSystem:entity_playLooping(e, animationName)
        e.animations.loopingAnimation = e.animations.list[animationName]
        e.animations.frame = 1
        e.animations.timer = 0
    end

    --------------------------
    -- [[ Core Functions ]] --
    --------------------------
    function AnimationSystem:update(dt)
        for _, e in ipairs(self.entities) do
            self:_checkDefaultAnimation(e)
            self:_runAnimation(e, dt)
        end
    end


    -----------------------------
    -- [[ Private Functions ]] --
    -----------------------------
    -- Check if a default animation was defined.
    -- If so make sure we start playing it if we haven't already.
    ---@param e table
    function AnimationSystem:_checkDefaultAnimation(e)
        if not e.animations.checked then
            if e.animations.defaultAnimation then
                if e.animations.defaultAnimation.playOnce then
                    self:entity_playOnce(e, e.animations.defaultAnimation.name)
                else
                    self:entity_playLooping(e, e.animations.defaultAnimation.name)
                    -- Loop
                end
            end
            e.animations.checked = true
        end
    end

    ---@param e table
    ---@param dt number
    function AnimationSystem:_runAnimation(e, dt)
        local anim = e.animations.playOnceAnimation or e.animations.loopingAnimation
        local c    = e.animations

        if anim then
            c.timer = c.timer + dt
            if c.timer > anim.framerate then
                local complete = false
                if c.frame < #anim.frames then
                    c.frame = c.frame + 1
                else
                    complete = true
                    c.frame = 1
                    c.playOnceAnimation = nil
                end
                e:give('image', anim.frames[c.frame])
                c.timer = 0

                if complete and c.onComplete then
                    c.onComplete()
                end

            end
        end
    end
    return AnimationSystem
end
