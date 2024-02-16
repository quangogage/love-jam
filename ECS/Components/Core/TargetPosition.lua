---@author Gage Henderson 2024-02-16 10:58
--
---@class TargetPosition : Component
-- Indiciate that an entity wants to move to a position.
-- Stores the x and y coordinates of the target position.
---@field x number
---@field y number

return function(concord)
    concord.component("targetPosition", function(c, x, y)
        c.x = x or 0
        c.y = y or 0
    end)
end
