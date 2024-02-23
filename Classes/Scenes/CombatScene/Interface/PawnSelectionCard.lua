---@author Gage Henderson 2024-02-17 09:23

local Element           = require('Classes.Elements.Element')

local TEXT_PADDING      = 10
local BOTTOM_PADDING    = 10
local NAME_FONT         = love.graphics.newFont(fonts.title, 24)
local POWERUP_FONT         = love.graphics.newFont(fonts.sub, 16)
-- local DESC_FONT         = love.graphics.newFont(fonts.sub, 16)
-- local PRICE_FONT     = love.graphics.newFont(fonts.title, 24)

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
local PawnSelectionCard = Goop.Class({
    extends = Element,
    parameters = {
        { 'anchor',         'table' },
        { 'offset',         'table' },
        { 'name',           'string' },
        { 'description',    'string' },
        { 'assemblageName', 'string' },
        { 'price',          'number' },
        { 'powerups',       'table' }
    },
    dynamic = {
        width = 300,
        height = 100,
        hovered = false
    }
})


--------------------------
-- [[ Core Functions ]] --
--------------------------
function PawnSelectionCard:update(dt)
    Element.update(self)
    self:_checkHover()
end
function PawnSelectionCard:draw()
    local y = TEXT_PADDING / 2
    self:_drawBackground()
    y = self:_printName(y)
    self:_printPowerups(y)
end


-----------------------------
-- [[ Private Functions ]] --
-----------------------------
function PawnSelectionCard:_drawBackground()
    love.graphics.setColor(0.2, 0.2, 0.2, 1)
    love.graphics.rectangle(
        'fill',
        self.position.x,
        self.position.y,
        self.width,
        self.height
    )
end
function PawnSelectionCard:_printName(y)
    love.graphics.setFont(NAME_FONT)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(
        self.name,
        self.position.x + TEXT_PADDING,
        self.position.y + y
    )
    return y + NAME_FONT:getHeight()
end
function PawnSelectionCard:_printPowerups(y)
    love.graphics.setFont(POWERUP_FONT)
    love.graphics.setColor(1, 1, 1, 1)
    for _, powerup in pairs(self.powerups) do
        love.graphics.print(
            powerup.name .. " x" .. powerup.count,
            self.position.x + TEXT_PADDING,
            self.position.y + y
        )
        y = y + POWERUP_FONT:getHeight()
    end
end
function PawnSelectionCard:_checkHover()
    local x, y = love.mouse.getPosition()
    if x > self.position.x and x < self.position.x + self.width and y > self.position.y and y < self.position.y + self.height then
        self.hovered = true
    else
        self.hovered = false
    end
end

return PawnSelectionCard
