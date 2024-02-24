---@author Gage Henderson 2024-02-21 07:57
--
---@class Arrow : Entity
---@field position {x: number, y: number}
---@field movement Movement
---@field dimensions {width: number, height: number}
---@field damageOnContact DamageOnContact


local Vec2 = require('Classes.Types.Vec2')

local dimensions = Vec2(20, 20)

local image = love.graphics.newImage('assets/images/arrow.png')
local scale = Vec2(1, 1)

return function (e, x, y, dir, damageAmount, attacker)
    e
        :give('position', x, y)
        :give('movement', {
            direction = dir,
            movementPreset = 'move forwards',
        })
        :give('dimensions', dimensions.width, dimensions.height)
        :give('damageOnContact', damageAmount, attacker)
        :give('image', image)
        :give('scale', scale.x, scale.y)
        :give('rotation', dir+math.pi/2)
        :give('deleteOOB')
        :give('unselectable')

    if attacker:get('friendly') then
        e:give('friendly')
    else
        e:give('hostile')
    end
end
