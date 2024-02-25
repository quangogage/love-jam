---@author Gage Henderson
--

local Concord = require('libs.Concord')
local EventManager = require('Classes.EventManager')
local sceneClasses = {
    CombatScene = require('Classes.Scenes.CombatScene.CombatScene'),
    MainMenuScene = require('Classes.Scenes.MainMenuScene.MainMenuScene'),
    HowToScene = require('Classes.Scenes.HowToScene.HowToScene')
}

---@class Game
local Game = Goop.Class({})

----------------------------
-- [[ Public Functions ]] --
----------------------------
---@param sceneName string
---@vararg any
function Game:setScene(sceneName, ...)
    if self.currentScene then
        self.currentScene:destroy()
    end
    self.currentScene = sceneClasses[sceneName](...)
end


--------------------------
-- [[ Core Functions ]] --
--------------------------
function Game:init()
    self.eventManager = EventManager()
    self:_createSubscriptions()
    self:_loadComponents()
    self:setScene('MainMenuScene', function ()
        self:setScene('CombatScene', self.eventManager)
    end, self.eventManager)
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
function Game:mousepressed(x, y, button)
    if self.currentScene then
        self.currentScene:mousepressed(x, y, button)
    end
end
function Game:mousereleased(x, y, button)
    if self.currentScene then
        self.currentScene:mousereleased(x, y, button)
    end
end
function Game:wheelmoved(x, y)
    if self.currentScene then
        self.currentScene:wheelmoved(x, y)
    end
end
function Game:keypressed(key)
    if self.currentScene then
        self.currentScene:keypressed(key)
    end
end
function Game:resize(w, h)
    if self.currentScene then
        if self.currentScene.resize then
            self.currentScene:resize(w, h)
        end
    end
end


-----------------------------
-- [[ Private Functions ]] --
-----------------------------
function Game:_createSubscriptions()
    self.eventManager:subscribe('openMainMenu', function ()
        self:setScene('MainMenuScene', function ()
            self:setScene('CombatScene', self.eventManager)
        end, self.eventManager)
    end)
    self.eventManager:subscribe('restart', function ()
        self:setScene('CombatScene', self.eventManager)
    end)
    self.eventManager:subscribe('openHowTo', function ()
        self:setScene('HowToScene', self.eventManager)
    end)
end
function Game:_loadComponents()
    local function loadFilesInDir(dir)
        local files = love.filesystem.getDirectoryItems(dir)
        for _, file in ipairs(files) do
            if string.match(file, '%.lua') then
                local filename = file:gsub('%.lua$', '')
                require(dir .. filename)(Concord)
            elseif love.filesystem.getInfo(dir .. file).type == 'directory' then
                loadFilesInDir(dir .. file .. '/')
            end
        end
    end
    loadFilesInDir('/ECS/Components/')
end

return Game
