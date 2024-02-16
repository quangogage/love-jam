---@author Gage Henderson 2024-02-16 06:06
--
---@class Health : Component
---@field value number
---@field max number

return function(concord)
    concord.component("health", function(c, max)
        c.max   = max or 100
        c.value = c.max
    end)
end
