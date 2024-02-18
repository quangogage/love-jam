---@author: Gage Henderson a long time ago
--
-- Basic camera class that I use in my games.
--

local util = require('util')({ 'table' }) ---@type util

---@class Camera
---@field position {x:number, y:number}
---@field followSpeed number
---@field zoom number
local Camera = Goop.Class({
    static = {
        type         = 'Camera',
        followSpeed  = 7
    },
    dynamic = {
        position = {
            x = 0,
            y = 0
        },
        rotation = 0,
        zoom = 1,
        shakeValues = {
            x = 0,
            y = 0,
            amount = 0,
            resetSpeed = 70,
            randomizeSpeed = 0.025,
            randomizeTimer = 0
        }
    }
})


----------------------------
-- [[ Public Functions ]] --
----------------------------
function Camera:getTranslatedMousePosition()
    local x, y = love.mouse.getPosition()
    return x * self.zoom + self.position.x, y * self.zoom + self.position.y
end
function Camera:centerOn(x, y)
    self.position.x = x - love.graphics.getWidth() / 2
    self.position.y = y - love.graphics.getHeight() / 2
end

function Camera:shake(amount)
    self.shakeValues.amount = amount
end

function Camera:set()
    love.graphics.push()
    love.graphics.rotate(-self.rotation)
    love.graphics.scale(1 / self.zoom, 1 / self.zoom)
    love.graphics.translate(-self.position.x - self.shakeValues.x,
        -self.position.y - self.shakeValues.y)
end

function Camera:unset()
    love.graphics.pop()
end

function Camera:follow(x, y, dt)
    self.position.x  = self.position.x + (x - self.position.x) * self.followSpeed * dt
    self.position.y  = self.position.y + (y - self.position.y) * self.followSpeed * dt
end


--------------------------
-- [[ Core Functions ]] --
--------------------------
function Camera:update(dt)
    self:_handleShake(dt)
end

-----------------------------
-- [[ Private Functions ]] --
-----------------------------
function Camera:_handleShake(dt)
    local shake = self.shakeValues
    shake.randomizeTimer = shake.randomizeTimer + dt
    if shake.randomizeTimer >= shake.randomizeSpeed then
        shake.x = love.math.random(-shake.amount, shake.amount)
        shake.y = love.math.random(-shake.amount, shake.amount)
        shake.randomizeTimer = 0
    end
    if shake.amount > 0 then
        shake.amount = shake.amount - shake.resetSpeed * dt
    else
        shake.amount = 0
    end
end

return Camera
