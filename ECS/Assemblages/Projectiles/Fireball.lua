---@author Gage Henderson 2024-02-22 05:04
--
---@class Fireball : Entity
---@field position {x: number, y: number}
---@field movement Movement
---@field dimensions {width: number, height: number}
---@field damageOnContact DamageOnContact
--

local Vec2 = require('Classes.Types.Vec2')

local dimensions = Vec2(30, 30)

local animations = {
    defaultAnimation = {
        name = '1',
        playOnce = false
    },
    list = {
        ['1'] = {
            framerate = 0.1,
            frames = {
                love.graphics.newImage('assets/images/fireball/fireball_1.png'),
                love.graphics.newImage('assets/images/fireball/fireball_2.png'),
                love.graphics.newImage('assets/images/fireball/fireball_3.png'),
                love.graphics.newImage('assets/images/fireball/fireball_4.png')
            }
        }
    }
}


return function (e, x, y, dir, damageAmount, attacker)
    e
        :give('position', x, y)
        :give('movement', {
            direction = dir,
            movementPreset = 'move forwards',
        })
        :give('dimensions', dimensions.width, dimensions.height)
        :give('damageOnContact', damageAmount, attacker)
        :give('rotation', dir + math.pi / 2)
        :give('unselectable')
        -- :give('renderRectangle', dimensions.width, dimensions.height)
        :give("animations", animations)
        :give('deleteOOB')

    if attacker:get('friendly') then
        e:give('friendly')
    else
        e:give('hostile')
    end
end
