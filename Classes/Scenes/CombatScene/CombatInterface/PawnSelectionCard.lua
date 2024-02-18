---@author Gage Henderson 2024-02-17 09:23

local Vec2 = require('Classes.Types.Vec2')

---@class PawnSelectionCard
---@field position {x: number, y: number}
---@field name string
---@field price number
---@field assemblageName string
---@field description string
---@field height number
---@field dimensions {width: number, height: number}
---@field backgroundColor table
---@field nameFont love.Font
---@field descriptionFont love.Font
---@field priceFont love.Font
---@field powerupsFont love.Font
---@field textPadding number
---@field powerups string[]
---@field eventManager EventManager
local PawnSelectionCard = Goop.Class({
    parameters = {
        { 'position',       'table' },
        { 'name',           'string' },
        { 'price',          'number' },
        { 'assemblageName', 'string' },
        { 'description',    'string' },
        { 'height',         'number' },
        { 'eventManager',   'table' }
    },
    static = {
        nameFont        = love.graphics.newFont('assets/fonts/BebasNeue-Regular.ttf', 34),
        descriptionFont = love.graphics.newFont('assets/fonts/RobotoCondensed-Light.ttf', 16),
        priceFont       = love.graphics.newFont('assets/fonts/BebasNeue-Regular.ttf', 35),
        powerupsFont    = love.graphics.newFont('assets/fonts/RobotoCondensed-Light.ttf', 16),
    },
    dynamic = {
        powerups        = {},
        position        = { x = 0, y = 0 },
        backgroundColor = { 0.5, 0.5, 0.5 },
        dimensions      = Vec2(200, 0),
        textPadding     = 10,
    }
})


----------------------------
-- [[ Public Functions ]] --
----------------------------
-- Sync powerups with PowerupStateManager.
---@param powerups table<string, {name: string, count: number}>
function PawnSelectionCard:syncPowerups(powerups)
    self.powerups = {}
    for _, powerup in pairs(powerups) do
        table.insert(self.powerups, powerup.name .. " x" .. powerup.count)
    end
end

--------------------------
-- [[ Core Functions ]] --
--------------------------
function PawnSelectionCard:init()
    self.dimensions.height = self.height
end
function PawnSelectionCard:draw()
    local y = self.textPadding / 2
    self:_drawBackground()
    y = self:_printName(y)
    y = self:_printDescription(y)
    y = self:_printPowerups(y)
    self:_printPrice()
end


-----------------------------
-- [[ Private Functions ]] --
-----------------------------
function PawnSelectionCard:_drawBackground()
    love.graphics.setColor(self.backgroundColor)
    love.graphics.rectangle('fill',
        self.position.x, self.position.y,
        self.dimensions.width, self.dimensions.height
    )
end
---@param y number
---@return number
function PawnSelectionCard:_printName(y)
    love.graphics.setColor(1,1,1)
    love.graphics.setFont(self.nameFont)
    love.graphics.printf(
        self.name,
        self.position.x + self.textPadding/2, self.position.y + y,
        self.dimensions.width - self.textPadding,
        'center'
    )
    return y + self.nameFont:getHeight()
end
---@param y number
---@return number
function PawnSelectionCard:_printDescription(y)
    love.graphics.setColor(1,1,1)
    love.graphics.setFont(self.descriptionFont)
    love.graphics.printf(
        self.description,
        self.position.x + self.textPadding/2, self.position.y + y,
        self.dimensions.width - self.textPadding,
        'center'
    )
    return y + self.descriptionFont:getHeight() + self.textPadding * 2
end
function PawnSelectionCard:_printPrice()
    local stringified = tostring(self.price)
    local str = "$" .. stringified
    love.graphics.setColor(0.3,1,0.3)
    love.graphics.setFont(self.priceFont)
    love.graphics.print(
        str,
        self.position.x + self.dimensions.width / 2 - self.priceFont:getWidth(str) / 2,
        self.position.y + self.dimensions.height - self.priceFont:getHeight() - self.textPadding
    )
end
function PawnSelectionCard:_printPowerups(y)
    love.graphics.setColor(1,1,1)
    love.graphics.setFont(self.powerupsFont)
    for _, powerup in ipairs(self.powerups) do
        love.graphics.print(
            powerup,
            self.position.x + self.textPadding/2, self.position.y + y
        )
        y = y + self.powerupsFont:getHeight()
    end
    return y
end

return PawnSelectionCard
