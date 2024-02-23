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
local LevelCompleteTransition = Goop.Class({
    arguments = { 'transitionHandler', 'eventManager', 'renderCanvas' },
    dynamic = {
        timer    = 0,
        waitTime = 1,
    }
})


--------------------------
-- [[ Core Functions ]] --
--------------------------
function LevelCompleteTransition:init()
    self.eventManager:broadcast("disableWorldUpdate")
    self.renderCanvas:beginZoomOut()
end
function LevelCompleteTransition:update(dt)
    self.timer = self.timer + dt
    if self.timer >= self.waitTime then
        self.eventManager:broadcast("openPowerupSelectionMenu")
        self.transitionHandler:setIdle()
    end
end

return LevelCompleteTransition
