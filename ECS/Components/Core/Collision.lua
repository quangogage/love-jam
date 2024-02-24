---@author Gage Henderson 2024-02-24 09:18
--
---@class Collision : Component
--

return function(concord)
    concord.component("collision", function(c, data)
        c.behavior = data.behavior or "dynamic"
        c.radius = data.radius or 50
    end)
end
