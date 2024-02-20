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

return function(concord)
    concord.component("pawnAnimations", function(c, animationList)
        c.timer = 0
        c.direction = "down"
        c.frame = 1
        for animationName, directionFilepaths in pairs(animationList) do
            c.currentAnimation = animationName -- Ensure this value is set to *something*.
            c[animationName] = {
                perFrameFramerateOffset = directionFilepaths.perFrameFramerateOffset or {},
                framerate = directionFilepaths.framerate or DEFAULT_FRAMERATE
            }
            for direction, filepath in pairs(directionFilepaths) do
                if direction ~= "framerate" and direction ~= "perFrameFramerateOffset" then
                    local files = love.filesystem.getDirectoryItems(filepath)
                    c[animationName][direction] = {}
                    for i, file in ipairs(files) do
                        local filename  = file:match("(.+)%.(.+)")
                        c[animationName][direction][tonumber(filename)] = love.graphics.newImage(filepath .. "/" .. file)
                    end
                end
            end
        end
    end)
end
