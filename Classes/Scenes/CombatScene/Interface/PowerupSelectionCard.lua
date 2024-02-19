---@author Gage Henderson 2024-02-19 09:24
--
--

local Element = require('Classes.Elements.Element')

local CARD_CORNER_RADIUS = 10
local NAME_FONT          = love.graphics.newFont("assets/fonts/BebasNeue-Regular.ttf", 34)
local DESC_FONT          = love.graphics.newFont("assets/fonts/RobotoCondensed-Light.ttf", 18)
local TEXT_PADDING       = 10


---@class PowerupSelectionCard : Element
---@field anchor table
---@field offset table
---@field name string
---@field description string
---@field timer number
---@field animationOffset number
---@field width number
---@field height number
---@field animation table
local PowerupSelectionCard = Goop.Class({
    extends = Element,
    parameters = {
        { 'anchor',      'table' },
        { 'offset',      'table' },
        { 'name',        'string' },
        { 'description', 'string' },
    },
    dynamic = {
        timer           = 0,
        animationOffset = 0,
        width           = 200,
        height          = 200,
        animation       = {
            y     = 50,
            speed = 2,
            alpha = 0
        }
    }
})


----------------------------
-- [[ Public Functions ]] --
----------------------------
function PowerupSelectionCard:select()
    self.selected = true
end
function PowerupSelectionCard:unselect()
    self.selected = false
end

--------------------------
-- [[ Core Functions ]] --
--------------------------
function PowerupSelectionCard:update(dt)
    self.timer = self.timer + dt
    Element.update(self)
    self:_updateAnimation(dt)
end
function PowerupSelectionCard:draw()
    if self.position.x ~= 0 then
        self:_drawBackground()
        self:_printName()
        self:_printDescription()
    end
end


-----------------------------
-- [[ Private Functions ]] --
-----------------------------
function PowerupSelectionCard:_updateAnimation(dt)
    if self.timer > self.animationOffset then
        self.animation.y = self.animation.y - self.animation.y * self.animation.speed * dt
        self.animation.alpha = self.animation.alpha + self.animation.speed * dt
    end
    self.position.y = self.position.y + self.animation.y
end
function PowerupSelectionCard:_drawBackground()
    if self.selected then
        love.graphics.setColor(0,1,0)
        love.graphics.rectangle('fill', self.position.x, self.position.y, self.width, self.height, CARD_CORNER_RADIUS, CARD_CORNER_RADIUS)
    end
    love.graphics.setColor(1, 1, 1, self.animation.alpha)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle('line', self.position.x, self.position.y, self.width, self.height, CARD_CORNER_RADIUS, CARD_CORNER_RADIUS)
end
function PowerupSelectionCard:_printName()
    love.graphics.setFont(NAME_FONT)
    love.graphics.setColor(1, 1, 1, self.animation.alpha)
    love.graphics.printf(self.name, self.position.x, self.position.y + 10, self.width - TEXT_PADDING, 'center')
end
function PowerupSelectionCard:_printDescription()
    love.graphics.setFont(DESC_FONT)
    love.graphics.setColor(1, 1, 1, self.animation.alpha)
    love.graphics.printf(self.description, self.position.x, self.position.y + 60, self.width - TEXT_PADDING, 'center')
end

return PowerupSelectionCard
