---@author Gage Henderson 2024-02-19 09:24
--
--

local util         = require('util')({ 'graphics' })
local Element      = require('Classes.Elements.Element')

local NAME_FONT    = love.graphics.newFont(fonts.title, 34 * 0.85)
local DESC_FONT    = love.graphics.newFont(fonts.sub, 18 * 0.85)
local TEXT_PADDING = 35


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
---@field bgImage love.Image
---@field hovered boolean
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
        width           = 260 * 0.85,
        height          = 358 * 0.85,
        hovered         = false,
        animation       = {
            y     = 50,
            speed = 2,
            alpha = 0
        },
        bgImage         = love.graphics.newImage('assets/images/ui/card.png'),
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
    self:_checkHover()
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
    local scale = util.graphics.getScaleForDimensions(self.bgImage, self.width, self.height)
    love.graphics.setColor(1, 1, 1, self.animation.alpha)
    love.graphics.draw(self.bgImage, self.position.x, self.position.y, 0, scale.x, scale.y)
end
function PowerupSelectionCard:_printName()
    love.graphics.setFont(NAME_FONT)
    love.graphics.setColor(1, 1, 1, self.animation.alpha)
    love.graphics.printf(self.name, self.position.x + TEXT_PADDING / 2, self.position.y + 30, self.width - TEXT_PADDING,
        'center')
end
function PowerupSelectionCard:_printDescription()
    love.graphics.setFont(DESC_FONT)
    love.graphics.setColor(1, 1, 1, self.animation.alpha)
    love.graphics.printf(self.description, self.position.x + TEXT_PADDING / 2, self.position.y + self.height - 115,
        self.width - TEXT_PADDING, 'center')
end
function PowerupSelectionCard:_checkHover()
    local x, y = love.mouse.getPosition()
    if x > self.position.x and x < self.position.x + self.width and y > self.position.y and y < self.position.y + self.height then
        self.hovered = true
    else
        self.hovered = false
    end
end

return PowerupSelectionCard
