---@author Gage Henderson 2024-02-19 10:28
--
--

---@class PowerupSelectionEndingTransition
---@field timer number
---@field overlay table
---@field levelTransitionHandler LevelTransitionHandler
---@field eventManager EventManager
local PowerupSelectionEndingTransition = Goop.Class({
    arguments = { 'levelTransitionHandler', 'eventManager' },
    dynamic = {
        overlay = {
            alpha = 0,
            fadeSpeed = 2
        }
    }
})


--------------------------
-- [[ Core Functions ]] --
--------------------------
function PowerupSelectionEndingTransition:update(dt)
    self.overlay.alpha = self.overlay.alpha + self.overlay.fadeSpeed * dt
    if self.overlay.alpha > 1 then
        self.eventManager:broadcast("closePowerupSelectionMenu")
        self.eventManager:broadcast("loadNextLevel")
        self.levelTransitionHandler:setState("level-starting")
    end
end
function PowerupSelectionEndingTransition:draw()
    self:_drawOverlay()
end


-----------------------------
-- [[ Private Functions ]] --
-----------------------------
function PowerupSelectionEndingTransition:_drawOverlay()
    love.graphics.setColor(0, 0, 0, self.overlay.alpha)
    love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
end

return PowerupSelectionEndingTransition
