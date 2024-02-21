---@author Gage Henderson 2024-02-21 07:57
--
---@class Arrow : Entity
---@field position {x: number, y: number}
---@field movement Movement
---@field dimensions {width: number, height: number}
---@field damageOnContact DamageOnContact


local Vec2 = require("Classes.Types.Vec2")

local dimensions = Vec2(20,20)

return function(e, x, y, dir, damageAmount, attacker)
    e
        :give("position",x,y)
        :give("movement", {
            direction = dir,
            movementPreset = "move fowards"
        })
        :give("dimensions", dimensions.width, dimensions.height)
        :give("damageOnContact",damageAmount, attacker)

    if attacker:get("friendly") then
        e:give("friendly")
    else
        e:give("hostile")
    end
end
