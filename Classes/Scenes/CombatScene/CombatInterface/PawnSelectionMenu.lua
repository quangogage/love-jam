---@author Gage Henderson 2024-02-17 08:49
--
-- Initialized in `CombatInterface`.
--
-- The menu at the bottom of the screen listing every pawn you can buy.
--
-- Actual creation of the cards is handled in `FriendlySpawnHandler` via the
-- `interface_attemptSpawnPawn` event.
--

local palette               = require('lists.interfaceColorPalette')
local pawnTypes             = require('lists.pawnTypes')
local PawnSelectionCard     = require('Classes.Scenes.CombatScene.CombatInterface.PawnSelectionCard')

---@class PawnSelectionMenu
---@field height number
---@field cards PawnSelectionCard[]
---@field eventManager EventManager
---@field powerupStateManager PowerupStateManager
local PawnSelectionMenu     = Goop.Class({
    arguments = { 'eventManager', 'powerupStateManager' },
    static = {
        cards  = {},
        height = 100
    }
})


--------------------------
-- [[ Core Functions ]] --
--------------------------
function PawnSelectionMenu:init()
    self:_initCards()
    self:_createSubscriptions()
end
function PawnSelectionMenu:destroy()
    self:_destroySubscriptions()
end
function PawnSelectionMenu:update()
end
function PawnSelectionMenu:draw()
    self:_drawBackground()
    self:_drawCards()
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
            if x > card.position.x and x < card.position.x + card.dimensions.width and
            y > card.position.y and y < card.position.y + card.dimensions.height then
                -- Resolved in CombatScene.
                self.eventManager:broadcast(
                    'interface_attemptSpawnPawn', card.assemblageName
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

function PawnSelectionMenu:_createSubscriptions()
    self.subscriptions = {}

    -- Broadcast from `PowerupStateManager`.
    -- Sync powerup information for each card.
    self.subscriptions['interface_syncPowerupState'] = self.eventManager:subscribe(
        'interface_syncPowerupState',
        function (pawnTypePowerups)
            for _, card in pairs(self.cards) do
                if pawnTypePowerups[card.name] then
                    card:syncPowerups(pawnTypePowerups[card.name])
                end
            end
        end
    )
end
function PawnSelectionMenu:_destroySubscriptions()
end

return PawnSelectionMenu
