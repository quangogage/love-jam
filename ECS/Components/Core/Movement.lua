---@author Gage Henderson 2024-02-16 07:14
--
---@class Movement : Component
---@field walkSpeed number
---@field targetLocation Vec2 - Used in MovementSystem.

local Vec2 = require("Classes.Types.Vec2")

return function (concord)
    concord.component("movement", function(c, data)
        data = data or {}
        c.walkSpeed = data.walkSpeed or 750
        c.targetLocation = Vec2(0, 0)
    end)
end
