---@author: Gage Henderson a long time ago
--
-- Basic camera class that I use in my games.
--

local FRICTION = 9
local ZOOM_MIN = 0.1
local ZOOM_MAX = 2
local ZOOM_SPEED = 5

local Vec2 = require('Classes.Types.Vec2')

---@class Camera
---@field position {x:number, y:number}
---@field followSpeed number
---@field zoom number More like 'targetZoom'
---@field currentZoom number Continously tries to reach 'zoom'
---@field zoomSpeed number How fast 'currentZoom' tries to reach 'zoom'
---@field zoomOffset Vec2
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
        zoomOffset  = Vec2(0, 0),
        velocity    = Vec2(0, 0)
    }
})


----------------------------
-- [[ Public Functions ]] --
----------------------------
-- Zoom the camera out all the way smoothly while staying centered using
-- zoomOffset.
function Camera:setToMaxZoom()
    self.zoom = ZOOM_MAX
    self.zoomOffset.x = (renderResolution.width / 2) * (1 - self.zoom)
    self.zoomOffset.y = (renderResolution.height / 2) * (1 - self.zoom)
end
function Camera:setZoom(zoom)
    self.zoom = zoom
end
function Camera:getZoom()
    return self.currentZoom
end
function Camera:getTranslatedMousePosition()
    local x, y = renderResolution:getMousePosition()
    local cameraX, cameraY = self:getPosition()
    return x * self.currentZoom + cameraX, y * self.currentZoom + cameraY
end
function Camera:set()
    love.graphics.push()
    love.graphics.rotate(-self.rotation)
    love.graphics.scale(1 / self.currentZoom, 1 / self.currentZoom)
    love.graphics.translate(-self.position.x - self.zoomOffset.x, -self.position.y - self.zoomOffset.y)
end
function Camera:unset()
    love.graphics.pop()
end
---@return number, number
function Camera:getPosition()
    return self.position.x + self.zoomOffset.x, self.position.y + self.zoomOffset.y
end
---@param x number | nil
---@param y number | nil
function Camera:setPosition(x,y)
    if x then
        self.position.x = x - self.zoomOffset.x
    end
    if y then
        self.position.y = y - self.zoomOffset.y
    end
end
---@param x number
---@param y number
function Camera:centerOnPosition(x, y)
    local scaledWidth = renderResolution.width * self.currentZoom
    local scaledHeight = renderResolution.height * self.currentZoom
    self.position.x = x - scaledWidth / 2 - self.zoomOffset.x
    self.position.y = y - scaledHeight / 2 - self.zoomOffset.y
end


--------------------------
-- [[ Core Functions ]] --
--------------------------
function Camera:update(dt)
    self:_applyFrictionAndVelocity(dt)
    self:_updateZoom(dt)
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
    self.currentZoom = self.currentZoom + (self.zoom - self.currentZoom) * ZOOM_SPEED * dt
    self.currentZoom = math.max(ZOOM_MIN, math.min(ZOOM_MAX, self.currentZoom))
    self.zoomOffset.x = (renderResolution.width / 2) * (1 - self.currentZoom)
    self.zoomOffset.y = (renderResolution.height / 2) * (1 - self.currentZoom)
end

return Camera
