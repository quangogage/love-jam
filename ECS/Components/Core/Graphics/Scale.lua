---@author Gage Henderson 2024-02-20 05:21
--
---@class Scale : Component
---@field x number
---@field y number

return function(concord)
    concord.component("scale", function(c, x, y)
        c.x = x or 0.5
        c.y = y or 0.5
    end)
end
