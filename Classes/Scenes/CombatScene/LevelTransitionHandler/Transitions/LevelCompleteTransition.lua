---@author Gage Henderson 2024-02-19 08:55
--
--

local FONT = love.graphics.newFont(fonts.title, 48)

---@class LevelCompleteTransition
---@field transitionHandler LevelTransitionHandler
---@field eventManager EventManager
---@field timer number
---@field overlay table
---@field text table
---@field fadeBackIn boolean
---@field skipBuffer number
---@field renderCanvas RenderCanvas
---@field waitTime number
---@field zoomWaitTime number
---@field openMenuWaitTime number
local LevelCompleteTransition = Goop.Class({
    arguments = { 'transitionHandler', 'eventManager', 'renderCanvas' },
    dynamic = {
        timer = 0,
        zoomWaitTime = 1,
        openMenuWaitTime = 3,
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
    -- Wait a moment before zooming out.
    if self.timer >= self.zoomWaitTime and not self.zoomedOut then
        self.renderCanvas:beginZoomOut()
        self.zoomedOut = true
    end

    -- Wait to actually open the powerup menu.
    if self.timer >= self.openMenuWaitTime then
        self.eventManager:broadcast("openPowerupSelectionMenu")
        self.transitionHandler:setIdle()
    end
end

return LevelCompleteTransition
