---@author Gage Henderson 2024-02-20 11:15
--
---@class GroundPosition
---@field x number
---@field y number
---@field offsetX number
---@field offsetY number
-- Where this entity's "feet" are on the ground.
--
-- Continously updated to be set at the bottom middle of the entity,
-- but can provide offset values to adjust.
--

return function (concord)
    concord.component('groundPosition', function (c, x, y)
        c.x = 0
        c.y = 0
        c.offsetX = x or 0
        c.offsetY = y or 0
    end)
end
