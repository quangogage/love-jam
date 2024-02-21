---@author Gage Henderson 2024-02-21 05:56
--
---@class AnimatedEffect : Entity
-- An enitty that has no real interaction with the world.
--
-- Plays an animation and then executes some behavior on completion.
--
-- Useful for things like impact effects or even death animations.
--
-- ──────────────────────────────────────────────────────────────────────
local exampleAnimations = {
    defaultAnimation = {
        name = 'attack',
        playOnce = true
    },
    list = {
        attack = {
            framerate = 0.1,
            frames = {
                -- love.graphics.newImage('assets/images/knight/attack_up_1.png'),
                -- love.graphics.newImage('assets/images/knight/attack_up_2.png'),
                -- love.graphics.newImage('assets/images/knight/attack_up_3.png'),
                -- ...
            }
        }
    }
}
-- ──────────────────────────────────────────────────────────────────────
---@param e AnimatedEffect
---@param position {x: number, y: number}
---@param animations {defaultAnimation: {name: string, playOnce: boolean}, list: table<string, {framerate: number, frames: love.Image}>}
---@param renderInfo {scale: {x: number, y: number}, offset: {x: number, y: number}}
---@param onComplete function
return function (e, position, animations, renderInfo, onComplete)
    renderInfo = renderInfo or {}
    local scale = renderInfo.scale or { x = 1, y = 1 }
    local offset = renderInfo.offset or { x = 0, y = 0 }

    animations.list[animations.defaultAnimation.name].onComplete = function ()
        onComplete(e)
    end
    e
        :give('position', position.x, position.y)
        :give('animations', animations)
        :give('scale', scale.x, scale.y)
        :give('offset', offset.x, offset.y)
end
