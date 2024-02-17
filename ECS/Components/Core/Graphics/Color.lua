---@author Gage Henderson 2024-02-16 05:11
--
---@class Color : Component
-- Define how to color the entity when being rendered. Separate from alpha/opacity.
---@field r number
---@field g number
---@field b number

return function(concord)
    concord.component('color', function(c, r, g, b)
        c.r = r
        c.g = g
        c.b = b
    end)
end

