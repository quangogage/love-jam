---@author Gage Henderson 2024-02-16 06:11
--
---@class Physics : Component
-- Stores basic physics information for an entity.
-- See PhysicsSystem for more info.
---@field velocity {x: number, y: number}
---@field friction number

return function(concord)
    concord.component("physics", function(c, data)
        data = data or {}
        c.velocity = data.velocity or {x = 0, y = 0}
        c.friction = data.friction or 8
    end)
end
