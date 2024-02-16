---@author Gage Henderson
--

---@class Game
local Game = Goop.Class({})
local sceneClasses = {
    CombatScene = require('Classes.Scenes.CombatScene'),
}


----------------------------
-- [[ Public Functions ]] --
----------------------------
---@param sceneName string
---@vararg any
function Game:setScene(sceneName, ...)
    self.currentScene = sceneClasses[sceneName](...)
end


--------------------------
-- [[ Core Functions ]] --
--------------------------
function Game:update(dt)
    if self.currentScene then
        self.currentScene:update(dt)
    end
end
function Game:draw()
    if self.currentScene then
        self.currentScene:draw()
    end
end
function Game:buttonpressed(button)
    if self.currentScene then
        self.currentScene:buttonpressed(button)
    end
end

return Game
