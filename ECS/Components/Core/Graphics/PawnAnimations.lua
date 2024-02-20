---@author Gage Henderson 2024-02-20 04:47
--
---@class pawnAnimations : Component
-- Load / store all animation data, for entities that can face different
-- directions.
-- 
-- animationList only needs to specify directories for animations,
-- this component will load them in.
--
-- ──────────────────────────────────────────────────────────────────────
-- animationList = {
--     running = {
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
        for animationName, directionFilepaths in pairs(animationList) do
            c[animationName] = {
                framerate = directionFilepaths.framerate or DEFAULT_FRAMERATE
            }
            for direction, filepath in pairs(directionFilepaths) do
                local files = love.filesystem.getDirectoryItems(filepath)
                c[animationName][direction] = {}
                for i, file in ipairs(files) do
                    c[animationName][direction][i] = love.graphics.newImage(filepath .. "/" .. file)
                end
            end
        end
    end)
end
