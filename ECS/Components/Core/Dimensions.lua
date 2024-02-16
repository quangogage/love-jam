---@author Gage Henderson 2024-02-16 11:17
--
---@class Dimensions : Component
-- Dimensions used to determine mouse interaction with an entity.
---@field width number
---@field height number

return function(concord)
    concord.component("dimensions", function(c, width, height)
        c.width = width or 10
        c.height = height or 10
    end)
end
