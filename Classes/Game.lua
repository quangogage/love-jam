---@author Gage Henderson
--

local EventManager = require('Classes.EventManager')
local sceneClasses = {
    CombatScene = require('Classes.Scenes.CombatScene.CombatScene'),
}

---@class Game
local Game         = Goop.Class({})

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
function Game:init()
    self.eventManager = EventManager()
    self:setScene('CombatScene', self.eventManager)
end
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
function Game:mousepressed(x,y,button)
    if self.currentScene then
        self.currentScene:mousepressed(x,y,button)
    end
end
function Game:mousereleased(x,y,button)
    if self.currentScene then
        self.currentScene:mousereleased(x,y,button)
    end
end
function Game:keypressed(key)
    if self.currentScene then
        self.currentScene:keypressed(key)
    end
end

return Game
