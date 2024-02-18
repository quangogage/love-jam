---@author Gage Henderson 2024-02-17 19:20
--

local FRICTION              = 9
local SCREEN_EDGE_THRESHOLD = 5
local ZOOM_INCREMENT        = 0.1
local ZOOM_MIN              = 0.1
local ZOOM_MAX              = 2
local Vec2     = require("Classes.Types.Vec2")

---@class CameraControls
---@field camera Camera
---@field velocity Vec2
---@field lastMouseX number
---@field lastMouseY number
local CameraControls = Goop.Class({
    arguments = {"camera"},
    static = {
        velocity = Vec2(0, 0)
    }
})


--------------------------
-- [[ Core Functions ]] --
--------------------------
function CameraControls:update(dt)
    self:_applyVelocityAndFriction(dt)
    self:_keyboardMovement(dt)
    self:_mousePushMovement(dt)
    self:_updateDrag(dt)
    self:_cameraZoom()
end
function CameraControls:wheelmoved(x,y)
    self:_cameraZoom(y)
end


-----------------------------
-- [[ Private Functions ]] --
-----------------------------
---@param dt number
function CameraControls:_applyVelocityAndFriction(dt)
    self.camera.position.x = self.camera.position.x + CameraControls.velocity.x * dt
    self.camera.position.y = self.camera.position.y + CameraControls.velocity.y * dt
    self.velocity.x = self.velocity.x * (1 - FRICTION * dt)
    self.velocity.y = self.velocity.y * (1 - FRICTION * dt)
end

---@param dt number
function CameraControls:_keyboardMovement(dt)
    local speed = settings.cameraWASDMoveSpeed
    if love.keyboard.isDown("w") then
        self.velocity.y = self.velocity.y - speed * dt
    elseif love.keyboard.isDown("s") then
        self.velocity.y = self.velocity.y + speed * dt
    end
    if love.keyboard.isDown("a") then
        self.velocity.x = self.velocity.x - speed * dt
    elseif love.keyboard.isDown("d") then
        self.velocity.x = self.velocity.x + speed * dt
    end
end

-- Move the camera by pushing your mouse to the edge of the screen.
function CameraControls:_mousePushMovement(dt)
    local x, y = love.mouse.getPosition()
    local speed = settings.cameraPushMoveSpeed

    if x < SCREEN_EDGE_THRESHOLD then
        self.velocity.x = self.velocity.x - speed * dt
    elseif x > love.graphics.getWidth() - SCREEN_EDGE_THRESHOLD then
        self.velocity.x = self.velocity.x + speed * dt
    end
    if y < SCREEN_EDGE_THRESHOLD then
        self.velocity.y = self.velocity.y - speed * dt
    elseif y > love.graphics.getHeight() - SCREEN_EDGE_THRESHOLD then
        self.velocity.y = self.velocity.y + speed * dt
    end
end

function CameraControls:_updateDrag(dt)
    local speed = settings.cameraPanSpeed
    if love.mouse.isDown(2) then
        if self.lastMouseX then
            local x, y = love.mouse.getPosition()
            local dx = (x - self.lastMouseX) * dt
            local dy = (y - self.lastMouseY) * dt
            self.velocity.x = self.velocity.x - dx * speed * dt
            self.velocity.y = self.velocity.y - dy * speed * dt
        end
        self.lastMouseX, self.lastMouseY = love.mouse.getPosition()
    else
        self.lastMouseX = nil
        self.lastMouseY = nil
    end
end

function CameraControls:_cameraZoom(y)
    local originalWidth  = love.graphics.getWidth() * self.camera.zoom
    local originalHeight = love.graphics.getHeight() * self.camera.zoom
    local didScroll      = false
    if y then
        if y < 0 then
            self.camera.zoom = math.min(ZOOM_MAX, self.camera.zoom + ZOOM_INCREMENT)
            didScroll = true
        elseif y > 0 then
            self.camera.zoom = math.max(ZOOM_MIN, self.camera.zoom - ZOOM_INCREMENT)
            didScroll = true
        end

        if didScroll then
            local newWidth  = love.graphics.getWidth() * self.camera.zoom
            local newHeight = love.graphics.getHeight() * self.camera.zoom
            local xDiff = (newWidth - originalWidth) / 2
            local yDiff = (newHeight - originalHeight) / 2
            self.camera.position.x = self.camera.position.x - xDiff
            self.camera.position.y = self.camera.position.y - yDiff
        end
    end
end

return CameraControls

