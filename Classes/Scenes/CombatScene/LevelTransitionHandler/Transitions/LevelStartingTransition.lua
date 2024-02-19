---@author Gage Henderson 2024-02-19 08:33
--
-- Brief animation when starting a new level.

local FONT = love.graphics.newFont(fonts.title, 48)

---@class LevelStartingTransition
---@field timer number
---@field overlay table
---@field text table
---@field transitionHandler LevelTransitionHandler
---@field eventManager EventManager
local LevelStartingTransition = Goop.Class({
    arguments = { 'transitionHandler', 'eventManager' },
    dynamic = {
        timer = 0,
        skipBuffer = 0.5,
        overlay = {
            alpha = 1,
            fadeSpeed = 1,
            holdTime = 1
        },
        text = {
            alpha = 1,
            fadeSpeed = 2,
            holdTime = 2
        }
    }
})


----------------------------
-- [[ Public Functions ]] --
----------------------------
function LevelStartingTransition:endTransition()
    self.eventManager:broadcast("enableCameraControls")
    self.transitionHandler:setIdle()
end


--------------------------
-- [[ Core Functions ]] --
--------------------------
function LevelStartingTransition:init()
    self.eventManager:broadcast("disableCameraControls")
end
function LevelStartingTransition:update(dt)
    self.timer = self.timer + dt
    self:_handleFades(dt)
    self.eventManager:broadcast("centerCameraOnFriendlyBase")
end
function LevelStartingTransition:draw()
    self:_drawOverlay()
    self:_printText()
end
function LevelStartingTransition:keypressed(key)
    if self.timer >= self.skipBuffer then
        self:endTransition()
    end
end
function LevelStartingTransition:mousepressed()
    if self.timer >= self.skipBuffer then
        self:endTransition()
    end
end


-----------------------------
-- [[ Private Functions ]] --
-----------------------------
function LevelStartingTransition:_drawOverlay()
    love.graphics.setColor(0, 0, 0, self.overlay.alpha)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
end
function LevelStartingTransition:_printText()
    love.graphics.setColor(1, 1, 1, self.text.alpha)
    love.graphics.setFont(FONT)
    love.graphics.printf("Level Starting", 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
end

function LevelStartingTransition:_handleFades(dt)
    if self.overlay.alpha > 0 and self.timer >= self.overlay.holdTime then
        self.overlay.alpha = self.overlay.alpha - self.overlay.fadeSpeed * dt
    end

    if self.text.alpha > 0 and self.timer >= self.text.holdTime then
        self.text.alpha = self.text.alpha - self.text.fadeSpeed * dt
    end
end

return LevelStartingTransition
