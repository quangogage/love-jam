---@author Gage Henderson 2024-02-19 08:55
--
--

local FONT = love.graphics.newFont("assets/fonts/BebasNeue-Regular.ttf", 48)

---@class LevelCompleteTransition
---@field transitionHandler LevelTransitionHandler
---@field eventManager EventManager
---@field timer number
---@field overlay table
---@field text table
---@field fadeBackIn boolean
local LevelCompleteTransition = Goop.Class({
    arguments = { 'transitionHandler', 'eventManager' },
    dynamic = {
        timer = 0,
        fadeBackIn = false,
        overlay = {
            alpha     = 0,
            fadeSpeed = 2,
            waitTime  = 1,
        },
        text = {
            alpha     = 0,
            fadeSpeed = 2,
            holdTime  = 2
        }
    }
})


--------------------------
-- [[ Core Functions ]] --
--------------------------
function LevelCompleteTransition:init()
    self.eventManager:broadcast("disableWorldUpdate")
end
function LevelCompleteTransition:update(dt)
    self.timer = self.timer + dt
    self:_handleFade(dt)
end
function LevelCompleteTransition:draw()
    self:_drawOverlay()
    self:_printText()
end
function LevelCompleteTransition:mousepressed()
    self.eventManager:broadcast("openPowerupSelectionMenu")
    self.transitionHandler:setIdle()
end
function LevelCompleteTransition:keypressed(key)
    if key == "space" then -- REMOVE THIS LATER
        self.eventManager:broadcast("openPowerupSelectionMenu")
        self.transitionHandler:setIdle()
    end
end


-----------------------------
-- [[ Private Functions ]] --
-----------------------------
function LevelCompleteTransition:_handleFade(dt)
    if self.timer <= self.text.holdTime then
        if self.text.alpha < 1 then
            self.text.alpha = self.text.alpha + self.text.fadeSpeed * dt
        end
    else
        self.text.alpha = self.text.alpha - self.text.fadeSpeed * dt
        if self.text.alpha <= 0 then
            self.eventManager:broadcast("openPowerupSelectionMenu")
            self.fadeBackIn = true
        end
    end
    if self.fadeBackIn then
        self.overlay.alpha = self.overlay.alpha - self.overlay.fadeSpeed * dt
        if self.overlay.alpha <= 0 then
            self.transitionHandler:setIdle()
        end
    else
        if self.timer >= self.overlay.waitTime then
            if self.overlay.alpha < 1 then
                self.overlay.alpha = self.overlay.alpha + self.overlay.fadeSpeed * dt
            end
        end
    end
end
function LevelCompleteTransition:_drawOverlay()
    love.graphics.setColor(0, 0, 0, self.overlay.alpha)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
end
function LevelCompleteTransition:_printText()
    love.graphics.setColor(1, 1, 1, self.text.alpha)
    love.graphics.setFont(FONT)
    love.graphics.printf("Level Complete", 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
end
return LevelCompleteTransition
