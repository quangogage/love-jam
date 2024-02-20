---@author Gage Henderson 2024-02-20 04:47
--
---@class pawnAnimations : Component
---@field currentAnimation string
---@field direction string
---@field frame integer
---@field timer number
-- Load / store all animation data, for entities that can face different
-- directions.
-- 
-- animationList only needs to specify directories for animations,
-- this component will load them in.
--
-- ──────────────────────────────────────────────────────────────────────
-- animationList = {
--     running = {
--         perFrameFramerateOffset = {
--             [2] = 0.5
--         }
--         framerate = 0.01,
--
--         up = "assets/animations/running/up",
--         down = "assets/animations/running/down",
--         left = "assets/animations/running/left",
--         right = "assets/animations/running/right"
--
--         -- etc...
--     }
-- }
-- ──────────────────────────────────────────────────────────────────────

local DEFAULT_FRAMERATE = 0.02
local animationSets = require("lists.animationSets")

return function(concord)
    concord.component("pawnAnimations", function(c, animationSet)
        assert(animationSets[animationSet], "Animation set " .. animationSet .. " does not exist. Make sure it is defined in `lists.animationSets`.")
        c.timer     = 0
        c.direction = "down"
        c.frame     = 1
        for animationName, animation in pairs(animationSets[animationSet]) do
            c.currentAnimation = animationName -- Just make sure this is set to a valid animation name
            c[animationName]   = animation
            c[animationName].framerate = animation.framerate or DEFAULT_FRAMERATE
        end
    end)
end
