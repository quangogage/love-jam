---@author Gage Henderson 2024-02-21 06:30
--
---@class Animations : Component
-- Stores information about simple animations.
--
-- If you are looking for how characters/pawns are animated, see PawnAnimations.
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
return function(concord)
    concord.component("animations", function(c, data)
        for k, v in pairs(data) do
            c[k] = v
        end
        c.timer      = 0
        c.frame      = 1
    end)
end
