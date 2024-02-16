---@author Gage Henderson 2024-02-16 05:06
--
---@class Position : Component
---@field x number
---@field y number

return function(concord)
    concord.component("position", function(c, x, y)
        c.x = x or 0
        c.y = y or 0
    end)
end
