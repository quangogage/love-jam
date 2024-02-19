---@author Gage Henderson 2024-02-17 09:23

local Vec2 = require('Classes.Types.Vec2')
local Element = require('Classes.Elements.Element')

---@class PawnSelectionCard : Element
local PawnSelectionCard = Goop.Class({
    extends = Element,
    parameters = {
        { 'anchor',      'table' },
        { 'offset',      'table' },
        { 'name',        'string' },
        { 'description', 'string' },
        { 'powerups',    'table' }
    }
})


--------------------------
-- [[ Core Functions ]] --
--------------------------
function PawnSelectionCard:update(dt)
    Element.update(self, dt)
end
function PawnSelectionCard:draw()
end

local PawnSelectionCard
