---@author Gage Henderson 2024-02-18 03:45
--
-- Just like all other interface stuff in this project - This code and
-- overall way of doing things is bad!

local Button = require('Classes.Elements.Button')

---@class MainMenuScene
---@field startGame function - Provided by creator.
---@field elements Button[] | table[]
---@field hoverCursor love.Cursor
local MainMenuScene = Goop.Class({
    arguments = {
        { 'startGame', 'function' }
    },
    static = {
        elements    = {},
        hoverCursor = love.mouse.getSystemCursor('hand'),
    }
})


--------------------------
-- [[ Core Functions ]] --
--------------------------
function MainMenuScene:init()
    self:_setMenu('main')
end
function MainMenuScene:update(dt)
    local isHovered = false
    for _, el in ipairs(self.elements) do
        el:update(dt)
        if el.hovered then
            isHovered = true
        end
    end
    if isHovered then
        love.mouse.setCursor(self.hoverCursor)
    else
        love.mouse.setCursor()
    end
end
function MainMenuScene:draw()
    for _, el in ipairs(self.elements) do
        el:draw()
    end
end
function MainMenuScene:mousepressed(_, _, button)
    local x,y = love.mouse.getPosition()
    for _, el in ipairs(self.elements) do
        el:mousepressed(x, y, button)
    end
end
function MainMenuScene:mousereleased(x, y, button)
end
function MainMenuScene:keypressed(key)
end
function MainMenuScene:wheelmoved(x, y)
end


-----------------------------
-- [[ Private Functions ]] --
-----------------------------
---@param name string
function MainMenuScene:_setMenu(name)
    if name == 'main' then
        self.elements = {
            Button({
                text = 'Start Game',
                anchor = { x = 0, y = 0.5 },
                offset = { x =  100, y = 0 },
                onClick = function ()
                    love.mouse.setCursor()
                    self.startGame()
                end
            }),
            Button({
                text = 'Settings',
                anchor = { x = 0, y = 0.5 },
                offset = { x =  100, y = 100 },
                onClick = function ()
                    console:log('open settings here........')
                end
            }),
            Button({
                text = 'Quit',
                anchor = { x = 0, y = 0.5 },
                offset = { x =  100, y = 200 },
                onClick = function ()
                    love.event.quit()
                end
            }),
        }
    end
end

return MainMenuScene
