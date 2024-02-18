---@author Gage Henderson 2024-02-18 09:07
--
-- Choose wisely...
--
-- Initialized in LevelTransitionHandler
--
-- See `PowerupStateManager` for how powerups are tracked / applied.
--

local CHOICES              = 3

local powerups             = require('lists.powerups')
local PowerupCard          = require('Classes.Scenes.CombatScene.PowerupSelectionMenu.PowerupCard')

---@class PowerupSelectionMenu
---@field eventManager EventManager
---@field powerupCards PowerupCard[]
---@field active boolean
---@field selectedPowerupName string
local PowerupSelectionMenu = Goop.Class({
    arguments = { 'eventManager' },
    static = {
        powerupCards = {}
    }
})


----------------------------
-- [[ Public Functions ]] --
----------------------------
function PowerupSelectionMenu:show()
    self:_generatePowerupCards()
    self.active = true
end


--------------------------
-- [[ Core Functions ]] --
--------------------------
function PowerupSelectionMenu:init()
    self:_createSubscriptions()
end
function PowerupSelectionMenu:destroy()
    self:_destroySubscriptions()
end
function PowerupSelectionMenu:update(dt)
    if self.active then
        for _, card in ipairs(self.powerupCards) do
            card:update(dt)
        end
    end
end
function PowerupSelectionMenu:draw()
    if self.active then
        -- Temp:
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

        for _, card in ipairs(self.powerupCards) do
            card:draw()
        end
    end
end
function PowerupSelectionMenu:mousepressed(x, y, button)
    if self.active and button == 1 then
        for _, card in ipairs(self.powerupCards) do
            if x > card.position.x and x < card.position.x + card.width and
            y > card.position.y and y < card.position.y + card.height then
                self:_unselectAllCards()
                card:select()
                self.selectedPowerupName = card.name
            end
        end
    end
end


-----------------------------
-- [[ Private Functions ]] --
-----------------------------
function PowerupSelectionMenu:_generatePowerupCards()
    local powerupChoices = {}
    table.move(powerups, 1, #powerups, 1, powerupChoices)

    for i = 1, CHOICES do
        local x = 0
        local y = love.graphics.getHeight() / 2
        local index = math.random(1, #powerupChoices)
        local powerup = powerupChoices[index]
        if i == 1 then
            x = love.graphics.getWidth() * 0.25
        elseif i == 2 then
            x = love.graphics.getWidth() * 0.5
        elseif i == 3 then
            x = love.graphics.getWidth() * 0.75
        end
        local card = PowerupCard({
            position    = { x = x, y = y },
            name        = powerup.name,
            description = powerup.description
        })

        table.insert(self.powerupCards, card)
        table.remove(powerupChoices, index)
    end
end
function PowerupSelectionMenu:_unselectAllCards()
    for _, card in ipairs(self.powerupCards) do
        card:unselect()
    end
end
function PowerupSelectionMenu:_selectCard(card)
    card:select()
end

function PowerupSelectionMenu:_createSubscriptions()
    self.subscriptions = {}

    -- Triggered in `PawnSelectionMenu`
    self.subscriptions['interface_selectPawnType'] = self.eventManager:subscribe(
        'interface_selectPawnType',
        function (pawnType)
            self:_selectPawnType(pawnType)
        end
    )
end
function PowerupSelectionMenu:_destroySubscriptions()
    for eventName, uuid in pairs(self.subscriptions) do
        self.eventManager:unsubscribe(eventName, uuid)
    end
end

---@param pawnType string
function PowerupSelectionMenu:_selectPawnType(pawnType)
    if self.selectedPowerupName then
        -- Resolved in `PowerupStateManager`
        self.eventManager:broadcast("interface_addPowerupToType", pawnType, self.selectedPowerupName)
    end
end

return PowerupSelectionMenu
