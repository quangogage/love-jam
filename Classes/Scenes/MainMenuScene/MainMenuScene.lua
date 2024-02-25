---@author Gage Henderson 2024-02-18 03:45
--
-- Just like all other interface stuff in this project - This code and
-- overall way of doing things is bad!

local OptionsMenuLayout = require('Classes.OptionsMenuLayout')
local Button = require('Classes.Elements.Button')

---@class MainMenuScene
---@field startGame function - Provided by creator.
---@field elements Button[] | table[]
---@field eventManager table
---@field song love.Source
local MainMenuScene = Goop.Class({
    arguments = {
        { 'startGame', 'function' },
        { 'eventManager', 'table' }
    },
    dynamic = {
        elements    = {},
        song = love.audio.newSource('assets/audio/songs/Fortunes-Misfavor.mp3', 'stream'),
    }
})

local startGameSound = love.audio.newSource('assets/audio/sfx/start-game.mp3', 'static')
startGameSound:setVolume(settings:getVolume('sfx'))

--------------------------
-- [[ Core Functions ]] --
--------------------------
function MainMenuScene:init()
    self:_setMenu('main')
    self.song:setLooping(true)
    self.song:setVolume(settings:getVolume("music"))
    self.song:play()
end
function MainMenuScene:destroy()
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
        cursor:set("hand")
    else
        cursor:set("arrow")
    end
end
function MainMenuScene:draw()
    for _, el in ipairs(self.elements) do
        el:draw()
    end
    self:_printCredits()
end
function MainMenuScene:mousepressed(_, _, button)
    local x, y = love.mouse.getPosition()
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
                offset = { x = 100, y = 0 },
                onClick = function ()
                    startGameSound:play()
                    self.startGame()
                    self.song:stop()
                end
            }),
            Button({
                text = "How To Play",
                anchor = { x = 0, y = 0.5 },
                offset = { x = 100, y = 50 },
                onClick = function()
                    self.eventManager:broadcast('openHowTo')
                end
            }),
            Button({
                text = 'Options',
                anchor = { x = 0, y = 0.5 },
                offset = { x = 100, y = 100 },
                onClick = function ()
                    self:_setMenu('options')
                end
            }),
            Button({
                text = 'Quit',
                anchor = { x = 0, y = 0.5 },
                offset = { x = 100, y = 150 },
                onClick = function ()
                    love.event.quit()
                end
            }),
        }
    elseif name == 'options' then
        self.elements = {
            OptionsMenuLayout(
                self.eventManager,self,
                function()
                    self:_setMenu('main')
                end
            )
        }
    end
end


local subFont = love.graphics.newFont(fonts.sub, 15)
local titleFont = love.graphics.newFont(fonts.sub, 20)
local xPadding = 100
local lineSpacing = 0
function MainMenuScene:_printCredits()
    local y = love.graphics.getHeight() * 0.5 - 150
    local print = function(text, bold)
        local font = bold and titleFont or subFont
        if  bold and #text > 0 then
            text = text .. " -"
        end
        local x = love.graphics.getWidth() - font:getWidth(text) - xPadding
        love.graphics.setFont(font)
        love.graphics.print(text, x, y)
        y = y + font:getHeight() + lineSpacing
    end
    love.graphics.setColor(1,1,1)
    print("Gage Henderson",true)
    print("Twitter @gage_69_420",true)
    print("Programming")
    print("Music")
    print("Sound Effects")
    print("Design")

    print("")
    print("")
    print("Keaton",true)
    print("Twitter @keatonf",true)
    print("Artwork")
    print("Design")

    print("")
    print("")
    print("Derek Riggs",true)
    print("Design")
    print("Writing")
    print("Testing")
end

return MainMenuScene
