---@author Gage Henderson 2024-02-17 09:23

local Vec2 = require('Classes.Types.Vec2')

---@class PawnSelectionCard
---@field position {x: number, y: number}
---@field name string
---@field assemblageName string
---@field description string
---@field height number
---@field dimensions {width: number, height: number}
---@field backgroundColor table
---@field nameFont love.Font
---@field descriptionFont love.Font
---@field textPadding number
---@field eventManager EventManager
local PawnSelectionCard = Goop.Class({
    parameters = {
        { 'position',       'table' },
        { 'name',           'string' },
        { 'assemblageName', 'string' },
        { 'description',    'string' },
        { 'height',         'number' },
        { 'eventManager',   'table' }
    },
    static = {
        nameFont        = love.graphics.newFont(16),
        descriptionFont = love.graphics.newFont(11),
    },
    dynamic = {
        position        = { x = 0, y = 0 },
        backgroundColor = { 0.5, 0.5, 0.5 },
        dimensions      = Vec2(200, 0),
        textPadding     = 10,
    }
})


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
end
function PawnSelectionCard:mousepressed(x, y, button)
    if x > self.position.x and x < self.position.x + self.dimensions.width and
    y > self.position.y and y < self.position.y + self.dimensions.height and
    button == 1 then
        self.eventManager:broadcast(
            'interface_attemptSpawnPawn', self.assemblageName
        )
    end
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
    return y + self.nameFont:getHeight() + self.textPadding
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
    return y + self.descriptionFont:getHeight() + self.textPadding
end

return PawnSelectionCard
