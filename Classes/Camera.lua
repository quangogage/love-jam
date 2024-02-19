---@author: Gage Henderson a long time ago
--
-- Basic camera class that I use in my games.
--

local FRICTION = 9
local ZOOM_MIN = 0.3
local ZOOM_MAX = 1.7
local ZOOM_SPEED = 5

local Vec2 = require('Classes.Types.Vec2')

---@class Camera
---@field position {x:number, y:number}
---@field followSpeed number
---@field zoom number More like 'targetZoom'
---@field currentZoom number Continously tries to reach 'zoom'
---@field zoomSpeed number How fast 'currentZoom' tries to reach 'zoom'
---@field velocity Vec2
---@field rotation number
local Camera = Goop.Class({
    static = {
        type = 'Camera',
    },
    dynamic = {
        position = {
            x = 0,
            y = 0
        },
        rotation    = 0,
        zoom        = 1,
        currentZoom = 1,
        velocity    = Vec2(0, 0),
        screenScaleMultiplier = 1
    }
})


----------------------------
-- [[ Public Functions ]] --
----------------------------
function Camera:setToMaxZoom()
    self.zoom = ZOOM_MAX
end
function Camera:setZoom(zoom)
    self.zoom = zoom
end
function Camera:getZoom()
    return self.currentZoom
end
function Camera:getTranslatedMousePosition()
    local x, y = love.mouse.getPosition()
    local cameraX, cameraY = self:getPosition()
    return x * self.currentZoom + cameraX, y * self.currentZoom + cameraY
end
function Camera:getCameraDimensions()
    local scale = 1 / self.screenScaleMultiplier * self.currentZoom
    return love.graphics.getWidth() / scale, love.graphics.getHeight() / scale
end
function Camera:getScale()
    return 1 / self.screenScaleMultiplier * self.currentZoom
end
function Camera:set()
    local scale = self:getScale()
    love.graphics.push()
    love.graphics.rotate(-self.rotation)
    love.graphics.scale(scale, scale)
    love.graphics.translate(-self.position.x, -self.position.y)
end
function Camera:unset()
    love.graphics.pop()
end
---@param x number
---@param y number
function Camera:centerOnPosition(x, y)
    local scaledWidth = love.graphics.getWidth() * self.currentZoom
    local scaledHeight = love.graphics.getHeight() * self.currentZoom
    self.position.x = x - scaledWidth / 2
    self.position.y = y - scaledHeight / 2
end
function Camera:getPosition()
    return self.position.x, self.position.y
end
function Camera:setPosition(x,y)
    self.position.x = x or self.position.x
    self.position.y = y or self.position.y
end


--------------------------
-- [[ Core Functions ]] --
--------------------------
function Camera:update(dt)
    self:_applyFrictionAndVelocity(dt)
    self:_updateZoom(dt)
    self:_getScreenScaleMultiplier()
end


-----------------------------
-- [[ Private Functions ]] --
-----------------------------
function Camera:_applyFrictionAndVelocity(dt)
    self.position.x = self.position.x + self.velocity.x * dt
    self.position.y = self.position.y + self.velocity.y * dt
    self.velocity.x = self.velocity.x * (1 - FRICTION * dt)
    self.velocity.y = self.velocity.y * (1 - FRICTION * dt)
end
function Camera:_updateZoom(dt)
    local oldZoom = self.currentZoom
    self.currentZoom = self.currentZoom + (self.zoom - self.currentZoom) * ZOOM_SPEED * dt
    self.currentZoom = math.max(ZOOM_MIN, math.min(ZOOM_MAX, self.currentZoom))
    local dx = (love.graphics.getWidth() / self.currentZoom - love.graphics.getWidth() / oldZoom) / 2
    local dy = (love.graphics.getHeight() / self.currentZoom - love.graphics.getHeight() / oldZoom) / 2
    self.position.x = self.position.x - dx
    self.position.y = self.position.y - dy
end

-- Make sure you can always see the same amount of the world no matter the
-- screen size.
-- assume the screen will always be 16:9
function Camera:_getScreenScaleMultiplier()
    self.screenScaleMultiplier = referenceResolution.width / love.graphics.getWidth()
end

return Camera
