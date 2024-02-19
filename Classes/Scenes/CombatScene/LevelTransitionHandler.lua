---@author Gage Henderson 2024-02-19 08:22
--
--

local transitions = {
    ['level-starting'] = require("Classes.Scenes.CombatScene.LevelTransitionHandler.Transitions.LevelStartingTransition")
}

---@class LevelTransitionHandler
local LevelTransitionHandler = Goop.Class({
    arguments = { 'eventManager', 'combatScene' },
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
        self.currentTransition = transitions[state](self, self.eventManager)
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
function LevelTransitionHandler:keypressed()
    if self.currentTransition then
        if self.currentTransition.keypressed then
            self.currentTransition:keypressed()
        end
    end
end


return LevelTransitionHandler
