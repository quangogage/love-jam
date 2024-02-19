---@author Gage Henderson 2024-02-19 09:12
--
--

local powerups = require('lists.powerups')
local PowerupSelectionCard = require('Classes.Scenes.CombatScene.Interface.PowerupSelectionCard')

local CARD_ANIMATION_OFFSET = 0.5

---@class PowerupSelectionMenu
---@field eventManager EventManager
---@field combatScene CombatScene
---@field active boolean
local PowerupSelectionMenu = Goop.Class({
    arguments = { 'eventManager', 'combatScene' },
    dynamic = {
        active = false,
        cards = {}
    }
})


----------------------------
-- [[ Public Functions ]] --
----------------------------
function PowerupSelectionMenu:open()
    self.active = true
    self.eventManager:broadcast('disableWorldUpdate')
    self:_generateCards()
end
function PowerupSelectionMenu:close()
    self.active = false
    self.combatScene.disableWorldUpdate = false
    self.eventManager:broadcast('enableWorldUpdate')
end

--------------------------
-- [[ Core Functions ]] --
--------------------------
function PowerupSelectionMenu:update(dt)
    if self.active then
        for _, card in ipairs(self.cards) do
            card:update(dt)
        end
    end
end
function PowerupSelectionMenu:draw()
    if self.active then
        self:_drawBackgroundOverlay()
        for _, card in ipairs(self.cards) do
            card:draw()
        end
    end
end
function PowerupSelectionMenu:mousepressed(x, y, button)
end


-----------------------------
-- [[ Private Functions ]] --
-----------------------------
function PowerupSelectionMenu:_drawBackgroundOverlay()
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
end
function PowerupSelectionMenu:_generateCards()
    self.cards = {}
    for i = 1, 3 do
        local anchor = { x = 0.5, y = 0.5 }
        if i == 1 then
            anchor.x = 0.25
        elseif i == 3 then
            anchor.x = 0.75
        end
        local card = PowerupSelectionCard({
            anchor          = anchor,
            offset          = { x = 0, y = 0 },
            name            = powerups[i].name,
            description     = powerups[i].description,
            animationOffset = CARD_ANIMATION_OFFSET * i
        })
        card.offset.x = -card.width / 2
        card.offset.y = -card.height / 2
        table.insert(self.cards, card)
    end
end
return PowerupSelectionMenu
