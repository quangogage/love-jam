---@author Gage Henderson 2024-02-17 08:49

local palette               = require('lists.interfaceColorPalette')
local pawnTypes             = require('lists.pawnTypes')
local PawnSelectionCard     = require('Classes.Scenes.CombatScene.CombatInterface.PawnSelectionCard')

local CARD_SPACING          = 15
local VERTICAL_CARD_PADDING = 10

---@class PawnSelectionMenu
---@field height number
---@field cards PawnSelectionCard[]
---@field eventManager EventManager
local PawnSelectionMenu     = Goop.Class({
    arguments = {'eventManager'},
    static = {
        cards = {},
        height = 200,
    }
})


--------------------------
-- [[ Core Functions ]] --
--------------------------
function PawnSelectionMenu:init()
    self:_initCards()
end
function PawnSelectionMenu:update()
end
function PawnSelectionMenu:draw()
    self:_drawBackground()
    self:_drawCards()
end
function PawnSelectionMenu:mousepressed(x, y, button)
    for _, card in ipairs(self.cards) do
        card:mousepressed(x, y, button)
    end
    return y > love.graphics.getHeight() - self.height
end

-----------------------------
-- [[ Private Functions ]] --
-----------------------------
function PawnSelectionMenu:_initCards()
    local x = CARD_SPACING
    for _, pawnType in ipairs(pawnTypes) do
        local card = PawnSelectionCard({
            position       = {
                x = x,
                y = love.graphics.getHeight() - self.height +
                VERTICAL_CARD_PADDING / 2
            },
            name           = pawnType.name,
            assemblageName = pawnType.assemblageName,
            description    = pawnType.description,
            height         = self.height - VERTICAL_CARD_PADDING,
            eventManager   = self.eventManager
        })
        table.insert(self.cards, card)
        x = x + card.dimensions.width + CARD_SPACING
    end
end
function PawnSelectionMenu:_drawBackground()
    love.graphics.setColor(palette.background)
    love.graphics.rectangle('fill',
        0, love.graphics.getHeight() - self.height,
        love.graphics.getWidth(), self.height
    )
end

function PawnSelectionMenu:_drawCards()
    for _, card in ipairs(self.cards) do
        card:draw()
    end
end

return PawnSelectionMenu

