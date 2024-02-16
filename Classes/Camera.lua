---@author: Gage Henderson a long time ago
--
-- Basic camera class that I use in my games.
--

local util = require('util')({ 'table' }) ---@type util

---@class Camera
---@field followSpeed number
---@field scale {x:number, y:number}
local Camera = Goop.Class({
    static = {
        type         = 'Camera',
        followSpeed  = 7
    },
    dynamic = {
        x = 0,
        y = 0,
        rotation = 0,
        scale = {
            x = 1,
            y = 1
        },
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
    return (x + self.x) * self.scale.x, (y + self.y) * self.scale.y
end
function Camera:centerOn(x, y)
    self.x = x - love.graphics.getWidth() / 2
    self.y = y - love.graphics.getHeight() / 2
end

function Camera:shake(amount)
    self.shakeValues.amount = amount
end

function Camera:set()
    love.graphics.push()
    love.graphics.rotate(-self.rotation)
    love.graphics.scale(1 / self.scale.x, 1 / self.scale.y)
    love.graphics.translate(-self.x - self.shakeValues.x,
        -self.y - self.shakeValues.y)
end

function Camera:unset()
    love.graphics.pop()
end

function Camera:follow(x, y, dt)
    self.x  = self.x + (x - self.x) * self.followSpeed * dt
    self.y  = self.y + (y - self.y) * self.followSpeed * dt
end


--------------------------
-- [[ Core Functions ]] --
--------------------------
function Camera:update(dt)
    self:_handleShake(dt)
end
---CURRENTLY UNUSED.
function Camera:onWindowResize(width, height)
    self.scale.x = self.referenceDimensions.width / width
    self.scale.y = self.referenceDimensions.height / height
end

function Camera:init()
    self:_generateReferenceDimensions()
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

function Camera:_generateReferenceDimensions()
    self.originalScale = util.table.createDeepCopy(self.scale)
    self.referenceDimensions = {
        width = 1920 * self.originalScale.x,
        height = 1080 * self.originalScale.y
    }
end

return Camera
