---@author Gage Henderson 2024-02-23 03:45
--
---@class PowerupSelectionCompleteTransition
-- Transition to the next level after you select a powerup.
--

local PowerupSelectionCompleteTransition = Goop.Class({
    arguments = { 'transitionHandler', 'eventManager', 'renderCanvas' },
    dynamic = {
        timer    = 0,
        waitTime = 1,
    }
})


--------------------------
-- [[ Core Functions ]] --
--------------------------
function PowerupSelectionCompleteTransition:update(dt)
    self.timer = self.timer + dt
    if self.timer >= self.waitTime then
        self.eventManager:broadcast("closePowerupSelectionMenu")
        self.eventManager:broadcast("loadNextLevel")
        self.eventManager:broadcast("enableCameraControls")
        self.renderCanvas:beginZoomIn()
        self.transitionHandler:setIdle()
    end
end

return PowerupSelectionCompleteTransition
