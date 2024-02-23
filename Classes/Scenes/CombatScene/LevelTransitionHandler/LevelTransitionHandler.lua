---@author Gage Henderson 2024-02-19 08:22
--
--

local transitions = {
    ['level-starting']           = require("Classes.Scenes.CombatScene.LevelTransitionHandler.Transitions.LevelStartingTransition"),
    ['level-complete']           = require("Classes.Scenes.CombatScene.LevelTransitionHandler.Transitions.LevelCompleteTransition"),
    ['powerup-selection-ending'] = require("Classes.Scenes.CombatScene.LevelTransitionHandler.Transitions.PowerupSelectionEndingTransition"),
}

---@class LevelTransitionHandler
---@field eventManager EventManager
---@field renderCanvas RenderCanvas
local LevelTransitionHandler = Goop.Class({
    arguments = { 'eventManager', 'combatScene', 'renderCanvas' },
    static = {
        state = 'level-starting'
    }
})


----------------------------
-- [[ Public Functions ]] --
----------------------------
---@param state string
function LevelTransitionHandler:setState(state)
    self.state = state
    if transitions[state] then
        self.currentTransition = transitions[state](self, self.eventManager, self.renderCanvas)
    end
end
function LevelTransitionHandler:setIdle()
    self.state = "idle"
    self.currentTransition = nil
end


--------------------------
-- [[ Core Functions ]] --
--------------------------
function LevelTransitionHandler:update(dt)
    if self.currentTransition then
        self.currentTransition:update(dt)
    end
end
function LevelTransitionHandler:draw()
    if self.currentTransition then
        self.currentTransition:draw()
    end
end
function LevelTransitionHandler:mousepressed()
    if self.currentTransition then
        if self.currentTransition.mousepressed then
            self.currentTransition:mousepressed()
        end
    end
end
function LevelTransitionHandler:keypressed(key)
    if self.currentTransition then
        if self.currentTransition.keypressed then
            self.currentTransition:keypressed(key)
        end
    end
end


return LevelTransitionHandler
