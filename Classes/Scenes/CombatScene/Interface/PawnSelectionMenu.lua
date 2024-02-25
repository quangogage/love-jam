---@author Gage Henderson 2024-02-17 08:49
--
-- Initialized in `CombatInterface`.
--
-- The menu at the bottom of the screen listing every pawn you can buy.
--
-- Actual creation of the cards is handled in `FriendlySpawnHandler` via the
-- `interface_attemptSpawnPawn` event.
--

local FALLBACK_ICON = love.graphics.newImage('assets/images/pawn_ui/knight.png')

local palette           = require('lists.interfaceColorPalette')
local pawnTypes         = require('lists.pawnTypes')
local PawnSelectionCard = require('Classes.Scenes.CombatScene.Interface.PawnSelectionCard')

---@class PawnSelectionMenu
---@field height number
---@field cardWidth number
---@field cardHeight number
---@field cards PawnSelectionCard[]
---@field eventManager EventManager
---@field powerupStateManager PowerupStateManager
---@field coinManager CoinManager
---@field cardScreenPadding number
---@field cardSpacing number
local PawnSelectionMenu = Goop.Class({
    arguments = { 'eventManager', 'powerupStateManager', 'coinManager' },
    static = {
        cards             = {},
        height            = 125,
        cardScreenPadding = 15,
        cardSpacing       = 7,
        cardWidth         = 300,
        cardHeight        = 115
    }
})


--------------------------
-- [[ Core Functions ]] --
--------------------------
function PawnSelectionMenu:init()
    self:_initCards()
end
---@return boolean If you are hovering over a card
function PawnSelectionMenu:update()
    local hovered = false
    for _, card in ipairs(self.cards) do
        card:update()
        if card.hovered then
            hovered = true
        end
    end
    return hovered
end
function PawnSelectionMenu:draw()
    self:_drawCards()
    self:_printCoinCount()
end
function PawnSelectionMenu:keypressed(key)
    if self.cards[tonumber(key)] then
        -- Resolved in `FriendlySpawnHandler`.
        self.eventManager:broadcast(
            'interface_attemptSpawnPawn', self.cards[tonumber(key)].assemblageName, self.cards[tonumber(key)].name
        )
        self.eventManager:broadcast('interface_selectPawnType', self.cards[tonumber(key)].name)
    end
end
function PawnSelectionMenu:mousepressed(x, y, button)
    if button == 1 then
        for _, card in ipairs(self.cards) do
            if card.hovered then
                -- Resolved in CombatScene.
                self.eventManager:broadcast(
                    'interface_attemptSpawnPawn', card.assemblageName, card.name
                )
                self.eventManager:broadcast('interface_selectPawnType', card.name)
                break
            end
        end
    end
    return y > love.graphics.getHeight() - self.height
end

-----------------------------
-- [[ Private Functions ]] --
-----------------------------
function PawnSelectionMenu:_initCards()
    local x = self.cardScreenPadding
    self.cards = {}
    for _, pawnType in ipairs(pawnTypes) do
        if not pawnType.hostileOnly then
            local newCard = PawnSelectionCard({
                anchor         = { x = 0, y = 1 },
                offset         = { x = x, y = -self.height / 2 - self.cardHeight / 2 },
                width          = self.cardWidth,
                height         = self.cardHeight,
                name           = pawnType.name,
                icon           = pawnType.icon or FALLBACK_ICON,
                description    = pawnType.description,
                price          = pawnType.price,
                powerups       = self.powerupStateManager:getPowerupsForPawnType(pawnType.name),
                assemblageName = pawnType.assemblageName
            })
            x = x + self.cardWidth + self.cardSpacing
            table.insert(self.cards, newCard)
        end
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

function PawnSelectionMenu:_printCoinCount()
    -- Generation rate floored to the second decimal place.
    local genRate = math.floor(self.coinManager:getGenerationRate() * 100) / 100
    love.graphics.setColor(1,1,1)
    love.graphics.print("COINS: " .. self.coinManager.coins, 10, love.graphics.getHeight() - self.height - 20)
    love.graphics.print("Generation Rate: " .. genRate .. " / second", 100, love.graphics.getHeight() - self.height - 20)
end
return PawnSelectionMenu
