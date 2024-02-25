---@author Gage Henderson 2024-02-17 17:38
--
---@class Base : Entity
-- The home base of a team (player or enemy).
---@field position Position
---@field hostile? Hostile
---@field friendly? Friendly
---@field health Health
---@field dimensions Dimensions
---@field unselectable Unselectable
---@field isBase IsBase

local friendlyImage = love.graphics.newImage('assets/images/friendly_base/idle.png')
local enemyImage = love.graphics.newImage('assets/images/enemy_base/idle.png')

---@param e Entity
---@param x number
---@param y number
---@param friendly boolean
return function (e, x, y, friendly)
    e
        :give('position', x, y)
        :give('dimensions', 205, 170, nil, nil, 32)
        :give('health', 50)
        -- :give('renderRectangle', 60, 30)
        :give("unselectable")
        :give("isBase")
        :give("groundPosition", 0, 100)
        -- :give('scale', 0.5, 0.5)
        :give('coinValue', KNOBS.enemyCoinReward.base)

    if friendly then
        e:give('friendly')
        :give('image', friendlyImage)
    else
        e:give('hostile')
        :give('image', enemyImage)
    end
end
