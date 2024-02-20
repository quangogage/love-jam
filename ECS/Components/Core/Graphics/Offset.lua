---@author Gage Henderson 2024-02-20 05:20
--
---@class Offset : Component
---@field x number
---@field y number

return function(concord)
    concord.component("offset", function(c, x, y)
        c.x = x or 0.5
        c.y = y or 0.5
    end)
end
