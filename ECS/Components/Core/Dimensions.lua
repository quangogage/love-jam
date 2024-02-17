---@author Gage Henderson 2024-02-16 11:17
--
---@class Dimensions : Component
-- Dimensions used to determine mouse interaction with an entity.
---@field width number
---@field height number
---@field depth number

return function(concord)
    ---@param c Dimensions
    ---@param width number
    ---@param height number
    ---@param depth number
    concord.component("dimensions", function(c, width, height, depth)
        c.width  = width or 10
        c.height = height or 10
        c.depth  = depth or height * 0.33
    end)
end
