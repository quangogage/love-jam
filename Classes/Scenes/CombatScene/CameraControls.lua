---@author Gage Henderson 2024-02-17 19:20
--

local SCREEN_EDGE_THRESHOLD = 5
local ZOOM_INCREMENT        = 0.1
local ZOOM_MIN              = 0.1
local ZOOM_MAX              = 2
local Vec2                  = require('Classes.Types.Vec2')

---@class CameraControls
---@field camera Camera
---@field velocity Vec2
---@field lastMouseX number
---@field lastMouseY number
---@field world World
local CameraControls        = Goop.Class({
    arguments = { 'camera', 'world' },
    static = {
        velocity = Vec2(0, 0)
    }
})


--------------------------
-- [[ Core Functions ]] --
--------------------------
function CameraControls:update(dt)
    self:_keyboardMovement(dt)
    self:_mousePushMovement(dt)
    self:_updateDrag(dt)
    self:_cameraZoom()
    self:_enforceWorldBounds()
end
function CameraControls:wheelmoved(x, y)
    self:_cameraZoom(y)
end


-----------------------------
-- [[ Private Functions ]] --
-----------------------------
---@param dt number
function CameraControls:_keyboardMovement(dt)
    local speed = settings.cameraWASDMoveSpeed * (1 / self.camera:getScale())
    if love.keyboard.isDown('w') or love.keyboard.isDown('up') then
        self.camera.velocity.y = self.camera.velocity.y - speed * dt
    elseif love.keyboard.isDown('s') or love.keyboard.isDown('down') then
        self.camera.velocity.y = self.camera.velocity.y + speed * dt
    end
    if love.keyboard.isDown('a') or love.keyboard.isDown('left') then
        self.camera.velocity.x = self.camera.velocity.x - speed * dt
    elseif love.keyboard.isDown('d') or love.keyboard.isDown('right') then
        self.camera.velocity.x = self.camera.velocity.x + speed * dt
    end
end

-- Move the camera by pushing your mouse to the edge of the screen.
function CameraControls:_mousePushMovement(dt)
    local x, y = love.mouse.getPosition()
    local speed = settings.cameraPushMoveSpeed * (1 / self.camera:getScale())

    if x < SCREEN_EDGE_THRESHOLD then
        self.camera.velocity.x = self.camera.velocity.x - speed * dt
    elseif x > love.graphics.getWidth() - SCREEN_EDGE_THRESHOLD then
        self.camera.velocity.x = self.camera.velocity.x + speed * dt
    end
    if y < SCREEN_EDGE_THRESHOLD then
        self.camera.velocity.y = self.camera.velocity.y - speed * dt
    elseif y > love.graphics.getHeight() - SCREEN_EDGE_THRESHOLD then
        self.camera.velocity.y = self.camera.velocity.y + speed * dt
    end
end

function CameraControls:_updateDrag(dt)
    local speed = settings.cameraPanSpeed * (1 / self.camera:getScale())
    if love.mouse.isDown(2) then
        if self.lastMouseX then
            local x, y = love.mouse.getPosition()
            local dx = (x - self.lastMouseX) / dt
            local dy = (y - self.lastMouseY) / dt
            self.camera.velocity.x = self.camera.velocity.x - dx * speed * dt
            self.camera.velocity.y = self.camera.velocity.y - dy * speed * dt
        end
        self.lastMouseX, self.lastMouseY = love.mouse.getPosition()
    else
        self.lastMouseX = nil
        self.lastMouseY = nil
    end
end

function CameraControls:_cameraZoom(y)
    if y then
        if y > 0 then
            self.camera:setZoom(math.min(ZOOM_MAX, self.camera.zoom + ZOOM_INCREMENT))
        elseif y < 0 then
            self.camera:setZoom(math.max(ZOOM_MIN, self.camera.zoom - ZOOM_INCREMENT))
        end
    end
end
function CameraControls:_enforceWorldBounds()
    local cameraWidth, cameraHeight = self.camera:getDimensions()
    local center = {
        x = self.camera.position.x + cameraWidth / 2,
        y = self.camera.position.y + cameraHeight / 2
    }

    if center.x < self.world.bounds.x then
        self.camera.position.x = self.world.bounds.x - cameraWidth / 2
    elseif center.x > self.world.bounds.x + self.world.bounds.width then
        self.camera.position.x = self.world.bounds.x + self.world.bounds.width - cameraWidth / 2
    end
    if center.y < self.world.bounds.y then
        self.camera.position.y = self.world.bounds.y - cameraHeight / 2
    elseif center.y > self.world.bounds.y + self.world.bounds.height then
        self.camera.position.y = self.world.bounds.y + self.world.bounds.height - cameraHeight / 2
    end
end

return CameraControls
