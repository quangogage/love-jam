---@author Gage Henderson 2024-02-17 09:23

local util              = require('util')({ 'graphics' })
local Element           = require('Classes.Elements.Element')
local MiniPowerupIcon   = require('Classes.Elements.MiniPowerupIcon')

local NAME_FONT         = love.graphics.newFont(fonts.title, 18)
local COIN_FONT      = love.graphics.newFont(fonts.speechBubble, 16)
local BACKGROUND_IMAGE  = love.graphics.newImage('assets/images/pawn_ui/pawn_rounded.png')
local COIN_ICON = love.graphics.newImage('assets/images/pawn_ui/coins.png')

---@class PawnSelectionCard : Element
---@field anchor table
---@field offset table
---@field name string
---@field description string
---@field price number
---@field powerups table<string, table>
---@field assemblageName string
---@field width number
---@field height number
---@field hovered boolean
---@field icon love.Image
---@field iconSize table
local PawnSelectionCard = Goop.Class({
    extends = Element,
    parameters = {
        { 'anchor',         'table' },
        { 'offset',         'table' },
        { 'name',           'string' },
        { 'description',    'string' },
        { 'assemblageName', 'string' },
        { 'price',          'number' },
        { 'powerups',       'table' },
        'icon'
    },
    dynamic = {
        width = 300,
        height = 100,
        hovered = false,
        iconSize = {width = 45, height = 45},
        lift = 0,
        targetLift = 0,
        liftSpeed = 10
    }
})


--------------------------
-- [[ Core Functions ]] --
--------------------------
function PawnSelectionCard:init()
    self:_initPowerupIcons()
end
function PawnSelectionCard:update(dt)
    Element.update(self)
    self:_checkHover()
    self:_updateLift(dt)
end
function PawnSelectionCard:draw()
    local x = self.position.x
    local y = self.position.y + 20
    self:_drawBackground()
    x,y = self:_drawIcon(x,y)
    x,y = self:_printName(x,y)
    x,y = self:_drawCost(x,y)
    x,y = self:_drawPowerupIcons(x,y)
end


-----------------------------
-- [[ Private Functions ]] --
-----------------------------
function PawnSelectionCard:_drawBackground()
    local scale = util.graphics.getScaleForDimensions(BACKGROUND_IMAGE, self.width, self.height)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(
        BACKGROUND_IMAGE,
        self.position.x,
        self.position.y + self.lift,
        0,
        scale.x, scale.y
    )
end
---@param x number
---@param y number
---@return number, number
function PawnSelectionCard:_drawIcon(x,y)
    local scale = util.graphics.getScaleForDimensions(self.icon, self.iconSize.width, self.iconSize.height)
    x = x + 20
    y = self.position.y + 15
    love.graphics.setColor(1,1,1)
    love.graphics.draw(
        self.icon,
        x,
        y + self.lift,
        0,
        scale.x, scale.y
    )
    return x+self.icon:getWidth()*scale.x/2, y + self.icon:getHeight() * scale.y
end
---@param x number
---@param y number
---@return number, number
function PawnSelectionCard:_printName(x,y)
    love.graphics.setFont(NAME_FONT)
    love.graphics.setColor(1,1,1)
    love.graphics.print(self.name, math.floor(x - NAME_FONT:getWidth(self.name)/2), y + self.lift)
    return x - NAME_FONT:getWidth(self.name)/2, y + NAME_FONT:getHeight()
end

---@param x number
---@param y number
---@return number, number
function PawnSelectionCard:_drawCost(x,y)
    love.graphics.setFont(COIN_FONT)
    love.graphics.setColor(1,1,1)
    love.graphics.print(self.price, math.floor(x), math.floor(y+self.lift))
    love.graphics.draw(COIN_ICON, x + COIN_FONT:getWidth(self.price), y + self.lift, 0, 0.5, 0.5)
    return x, y + COIN_FONT:getHeight()
end

function PawnSelectionCard:_checkHover()
    local x, y = love.mouse.getPosition()
    if x > self.position.x and x < self.position.x + self.width and y > self.position.y and y < self.position.y + self.height then
        self.hovered = true
    else
        self.hovered = false
    end
end

---@param x number
---@param y number
---@return number, number
function PawnSelectionCard:_drawPowerupIcons(x,y)
    x = self.position.x + 70
    y = self.position.y + 20
    for _,icon in pairs(self.powerupIcons) do
        if x + icon.dimensions.width > self.position.x + self.width then
            x = self.position.x + 75
            y = y + icon.dimensions.height + 5
        end
        icon:draw(x,y + self.lift)
        x = x + icon.dimensions.width + 5
    end
end

function PawnSelectionCard:_initPowerupIcons()
    self.powerupIcons = {}
    for _,powerup in pairs(self.powerups) do
        table.insert(self.powerupIcons, MiniPowerupIcon({
            image = powerup.image,
            powerupRef = powerup,
            dimensions = {width = 32, height = 32},
            position = {x = 0, y = 0},
        }))
    end
end

function PawnSelectionCard:_updateLift(dt)
    if self.hovered then
        if love.mouse.isDown(1) then
            self.targetLift = 5
        else
            self.targetLift = -15
        end
    else
        self.targetLift = 0
    end
    self.lift = self.lift + (self.targetLift - self.lift) * self.liftSpeed * dt
end

return PawnSelectionCard
