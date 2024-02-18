---@author Gage Henderson 2024-02-18 05:27
--
-- Really ugly crude and hazardous way of doing this.
-- Primarily wanted to move this logic out of CombatScene to keep it a
-- little cleaner.
-- But this is far from the best way to do that.

local CAMERA_MOVE_SPEED = 2500
local LOCATION_ARRIVAL_THRESHOLD = 20

---@class LevelStartAnimation
---@field camera Camera
---@field combatScene CombatScene
---@field active boolean
---@field timer number
---@field cameraWaitTime number
---@field overlay table
---@field text table
---@field levelNumber integer
local LevelStartAnimation = Goop.Class({
    arguments = {
        'camera',
        'combatScene',
        'levelNumber'
    },
    static = {
        active         = false,
        timer          = 0,
        cameraWaitTime = 0.7,
        overlay        = {
            alpha = 1,
            fadeSpeed = 0.5,
            holdTime = 0.5
        },
        text = {
            alpha     = 1,
            holdTime  = 1.5,
            fadeSpeed = 1,
            font      = love.graphics.newFont('assets/fonts/BebasNeue-Regular.ttf', 100)
        }
    }
})


----------------------------
-- [[ Public Functions ]] --
----------------------------
function LevelStartAnimation:endAnimation()
    if self.active then
        self.camera.velocity.x = 0
        self.camera.velocity.y = 0
        self.camera:centerOnPosition(
            self.combatScene.friendlyBase.position.x,
            self.combatScene.friendlyBase.position.y
        )
        self.camera:setToMaxZoom()
        self.active = false
    end
end


--------------------------
-- [[ Core Functions ]] --
--------------------------
function LevelStartAnimation:init()
    self.active = true
    self.camera:centerOnPosition(
        self.combatScene.enemyBase.position.x,
        self.combatScene.enemyBase.position.y
    )
end
function LevelStartAnimation:update(dt)
    if self.active then
        self.timer = self.timer + dt
        self:_fadeOverlay(dt)
        self:_fadeText(dt)
        self:_moveCamera(dt)
        self:_checkForArrival()
    end
end
function LevelStartAnimation:draw()
    if self.active then
        self:_drawOverlay()
        self:_printText()
    end
end


-----------------------------
-- [[ Private Functions ]] --
-----------------------------
function LevelStartAnimation:_moveCamera(dt)
    if self.active and self.timer >= self.cameraWaitTime then
        local cameraX, cameraY = self.camera:getPosition()
        local scaledWidth      = love.graphics.getWidth() * self.camera.zoom
        local scaledHeight     = love.graphics.getHeight() * self.camera.zoom
        local targetX          = self.combatScene.friendlyBase.position.x - scaledWidth / 2
        local targetY          = self.combatScene.friendlyBase.position.y - scaledHeight / 2
        if targetX < cameraX then
            self.camera.velocity.x = self.camera.velocity.x - CAMERA_MOVE_SPEED * dt
        elseif targetX > cameraX then
            self.camera.velocity.x = self.camera.velocity.x + CAMERA_MOVE_SPEED * dt
        end
        if targetY < cameraY then
            self.camera.velocity.y = self.camera.velocity.y - CAMERA_MOVE_SPEED * dt
        elseif targetY > cameraY then
            self.camera.velocity.y = self.camera.velocity.y + CAMERA_MOVE_SPEED * dt
        end
    end
end
function LevelStartAnimation:_fadeOverlay(dt)
    if self.active and self.timer >= self.overlay.holdTime then
        if self.overlay.alpha > 0 then
            self.overlay.alpha = self.overlay.alpha - self.overlay.fadeSpeed * dt
        end
    end
end
function LevelStartAnimation:_fadeText(dt)
    if self.active and self.timer >= self.text.holdTime then
        if self.text.alpha > 0 then
            self.text.alpha = self.text.alpha - self.text.fadeSpeed * dt
        end
    end
end

function LevelStartAnimation:_checkForArrival()
    local cameraX, cameraY = self.camera:getPosition()
    local scaledWidth      = love.graphics.getWidth() * self.camera.zoom
    local scaledHeight     = love.graphics.getHeight() * self.camera.zoom
    local targetX          = self.combatScene.friendlyBase.position.x - scaledWidth / 2
    local targetY          = self.combatScene.friendlyBase.position.y - scaledHeight / 2

    if math.abs(targetX - cameraX) < LOCATION_ARRIVAL_THRESHOLD and
    math.abs(targetY - cameraY) < LOCATION_ARRIVAL_THRESHOLD then
        self:endAnimation()
    end
end

function LevelStartAnimation:_drawOverlay()
    love.graphics.setColor(0, 0, 0, self.overlay.alpha)
    love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
end

function LevelStartAnimation:_printText()
    local str = "LEVEL " .. self.levelNumber
    love.graphics.setFont(self.text.font)
    love.graphics.setColor(1, 1, 1, self.text.alpha)
    love.graphics.printf(
        str,
        0,
        love.graphics.getHeight() / 2 - self.text.font:getHeight() / 2,
        love.graphics.getWidth(),
        'center'
    )
end
return LevelStartAnimation
