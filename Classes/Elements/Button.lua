---@author Gage Henderson 2024-02-18 03:47
--
---@class Button : Element
---@field position {x: number, y: number}
---@field dimensions {width: number, height: number}
---@field text string
---@field font love.Font
---@field color number[]
---@field hoverColor number[]
---@field onClick function
---@field currentColor number[]

local util = require('util')({ 'table' })
local Vec2 = require('Classes.Types.Vec2')
local Element = require("Classes.Elements.Element")

local Button = Goop.Class({
    extends = Element,
    parameters = {
        { 'anchor', 'table' },
        { 'offset', 'table' },
        { 'text',     'string' },
        { 'onClick',  'function' }
    },
    dynamic = {
        color            = { 1, 1, 1, 1 },
        hoverColor       = { 0.2, 0.2, 0.2, 1 },
        font             = love.graphics.newFont(
        'assets/fonts/RobotoCondensed-Light.ttf', 30),
        dimensions       = Vec2(0, 0),
        colorChangeSpeed = 15,
    }
})


--------------------------
-- [[ Core Functions ]] --
--------------------------
function Button:init()
    self.dimensions = Vec2(
        self.font:getWidth(self.text),
        self.font:getHeight()
    )
    self.currentColor = util.table.createDeepCopy(self.color)
end
function Button:update(dt)
    Element.update(self, dt)
    local mouseX, mouseY = love.mouse.getPosition()
    if mouseX > self.position.x and mouseX < self.position.x + self.dimensions.x and
    mouseY > self.position.y and mouseY < self.position.y + self.dimensions.y then
        self.hovered = true
    else
        self.hovered = false
    end
    self:_updateColor(dt)
end
function Button:draw()
    love.graphics.setColor(self.currentColor)
    love.graphics.setFont(self.font)
    love.graphics.print(self.text, self.position.x, self.position.y)
end
function Button:mousepressed(_, _, button)
    if self.hovered and button == 1 then
        self.onClick()
    end
end


-----------------------------
-- [[ Private Functions ]] --
-----------------------------
function Button:_updateColor(dt)
    local targetColor = self.color
    if self.hovered then
        targetColor = self.hoverColor
    end

    for i = 1, 4 do
        self.currentColor[i] = self.currentColor[i] +
        (targetColor[i] - self.currentColor[i]) * self.colorChangeSpeed * dt
    end
end



return Button
