---@author Gage Henderson 2024-02-16 07:14
--
---@class Movement : Component
---@field walkSpeed number
---@field targetLocation Vec2 - Used in MovementSystem.

local Vec2 = require("Classes.Types.Vec2")

return function (concord)
    concord.component("movement", function(c, data)
        data = data or {}
        c.walkSpeed      = data.walkSpeed or 1200
        c.targetLocation = Vec2(0, 0)
        c.direction      = data.direction or 0
        c.moveSpeed      = data.moveSpeed or 200
        c.movementPreset = data.movementPreset
    end)
end
