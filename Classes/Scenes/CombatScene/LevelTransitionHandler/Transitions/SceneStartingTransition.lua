---@author Gage Henderson 2024-02-19 08:33
--
-- Brief animation when starting a run.
--
-- This means it ONLY PLAYS ONCE WHEN YOU START COMBAT SCENE.

local FONT = love.graphics.newFont(fonts.title, 48)

---@class SceneStartingTransition
---@field timer number
---@field overlay table
---@field text table
---@field transitionHandler LevelTransitionHandler
---@field eventManager EventManager
---@field skipBuffer number
---@field renderCanvas RenderCanvas
local SceneStartingTransition = Goop.Class({
    arguments = { 'transitionHandler', 'eventManager' },
    dynamic = {
        timer = 0,
        skipBuffer = 0.1,
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
function SceneStartingTransition:endTransition()
    self.eventManager:broadcast("enableCameraControls")
    self.transitionHandler:setIdle()
end


--------------------------
-- [[ Core Functions ]] --
--------------------------
function SceneStartingTransition:init()
    self.eventManager:broadcast("disableCameraControls")
    self.eventManager:broadcast("centerCameraOnFriendlyBase")
end
function SceneStartingTransition:update(dt)
    self.timer = self.timer + dt
    self:_handleFades(dt)
end
function SceneStartingTransition:draw()
    self:_drawOverlay()
    self:_printText()
end
function SceneStartingTransition:keypressed(key)
    if self.timer >= self.skipBuffer then
        self:endTransition()
    end
end
function SceneStartingTransition:mousepressed()
    if self.timer >= self.skipBuffer then
        self:endTransition()
    end
end


-----------------------------
-- [[ Private Functions ]] --
-----------------------------
function SceneStartingTransition:_drawOverlay()
    love.graphics.setColor(0, 0, 0, self.overlay.alpha)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
end
function SceneStartingTransition:_printText()
    love.graphics.setColor(1, 1, 1, self.text.alpha)
    love.graphics.setFont(FONT)
    love.graphics.printf("Level Starting", 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
end

function SceneStartingTransition:_handleFades(dt)
    if self.overlay.alpha > 0 and self.timer >= self.overlay.holdTime then
        self.overlay.alpha = self.overlay.alpha - self.overlay.fadeSpeed * dt
    end

    if self.text.alpha > 0 and self.timer >= self.text.holdTime then
        self.text.alpha = self.text.alpha - self.text.fadeSpeed * dt
    end
end

return SceneStartingTransition
