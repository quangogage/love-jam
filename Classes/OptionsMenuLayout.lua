---@author Gage Henderson 2024-02-19 17:34
--
-- I warned you about the GUI stuff in the readme...
--
-- This handles creating and all behavior for the elements within the
-- options menu.
--
-- Intended to be created inside of another menu (ie, main menu > options).
--

local Text              = require('Classes.Elements.Text')
local Button            = require('Classes.Elements.Button')

---@class OptionsMenuLayout
---@field eventManager table
---@field parent table
---@field Elements Text[] | Button[] | Element[]
---@field onExit function
---@field currentResIndex integer
---@field didChangeRes boolean
local OptionsMenuLayout = Goop.Class({
    arguments = {
        { 'eventManager', 'table' },
        { 'parent',       'table' },
        { 'onExit',       'function' }
    },
    dynamic = {
        elements = {},
        didChangeRes = false,
    }
})


--------------------------
-- [[ Core Functions ]] --
--------------------------
function OptionsMenuLayout:init()
    self:_getCurrentResolution()
    self:_createElements()
end
function OptionsMenuLayout:update(dt)
    for _, element in ipairs(self.elements) do
        element:update(dt)
    end
end
function OptionsMenuLayout:draw()
    for _, element in ipairs(self.elements) do
        element:draw()
    end
end
function OptionsMenuLayout:mousepressed(x, y, button)
    for _, element in ipairs(self.elements) do
        element:mousepressed(x, y, button)
    end
end


-----------------------------
-- [[ Private Functions ]] --
-----------------------------
function OptionsMenuLayout:_createElements()
    local res = settings.resolutions[self.currentResIndex]
    self.elements = {
        -- Resolution changer
        Button({
            anchor = { x = 0.1, y = 0.25 },
            text = 'Resolution: ' .. res[1] .. 'x' .. res[2],
            onClick = function (button)
                self.currentResIndex = self.currentResIndex + 1
                if self.currentResIndex > #settings.resolutions then
                    self.currentResIndex = 1
                end
                res = settings.resolutions[self.currentResIndex]
                button.text = 'Resolution: ' .. res[1] .. 'x' .. res[2]
                self.didChangeRes = true
            end
        }),
        -- Back button
        Button({
            anchor = { x = 0.1, y = 0.9 },
            offset = { x = 0, y = -50 },
            text = '< Back + Apply',
            onClick = function ()
                if self.didChangeRes then
                    settings:setResolution(res[1], res[2])
                end
                self.onExit()
            end
        })
    }
end
function OptionsMenuLayout:_getCurrentResolution()
    local width, height = love.window.getMode()
    self.currentResIndex = 1
    for i = 1, #settings.resolutions do
        local res = settings.resolutions[i]
        if res[1] == width and res[2] == height then
            self.currentResIndex = i
            return
        end
    end
end

return OptionsMenuLayout
