---@author Gage Henderson 2024-02-19 09:12
--
--

local util = require('util')({ 'graphics' })
local powerups = require('lists.powerups')
local PowerupSelectionCard = require('Classes.Scenes.CombatScene.Interface.PowerupSelectionCard')

local CARD_ANIMATION_OFFSET = 0.5

---@class PowerupSelectionMenu
---@field eventManager EventManager
---@field combatScene CombatScene
---@field active boolean
---@field cards PowerupSelectionCard[]
---@field selectedPowerupName string - Set by clicking a card.
---@field fadingOut boolean
---@field hasSelected boolean
---@field song love.Source
---@field songWaitTime number
---@field songWaitTimer number
---@field playedSong boolean
---@field bgImage love.Image
---@field teller table
local PowerupSelectionMenu = Goop.Class({
    arguments = { 'eventManager', 'combatScene' },
    dynamic = {
        active        = false,
        cards         = {},
        songWaitTime  = 0,
        songWaitTimer = 0.2,
        song          = love.audio.newSource('assets/audio/songs/Fortune-Teller.mp3', 'stream'),
        bgImage       = love.graphics.newImage('assets/images/ui/bg.png'),
    }
})
PowerupSelectionMenu.song:setVolume(settings:getVolume('music'))
PowerupSelectionMenu.song:setLooping(true)

----------------------------
-- [[ Public Functions ]] --
----------------------------
function PowerupSelectionMenu:open()
    self.hasSelected = false
    self.active = true
    self.eventManager:broadcast('disableWorldUpdate')
    self:_generateCards()
    self.songWaitTime = 0
    self.playedSong = false
end
function PowerupSelectionMenu:close()
    self.active = false
    self.selectedPowerupName = nil
    self.eventManager:broadcast('enableWorldUpdate')
    self.song:stop()
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
    for _, card in ipairs(self.cards) do
        card:update(dt)
    end
    if self.active then
        self.songWaitTime = self.songWaitTime + dt
        if self.songWaitTime > self.songWaitTimer and not self.playedSong then
            self.song:play()
            self.playedSong = true
        end
    end
end
function PowerupSelectionMenu:draw()
    if self.active then
        for _, card in ipairs(self.cards) do
            card:draw()
        end
    end
end
function PowerupSelectionMenu:drawBackground()
    local scale = util.graphics.getScaleForDimensions(self.bgImage, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.bgImage, 0, 0, 0, scale.x, scale.y)
end
function PowerupSelectionMenu:mousepressed(x, y, button)
    self:_selectCard(x, y, button)
end


-----------------------------
-- [[ Private Functions ]] --
-----------------------------
function PowerupSelectionMenu:_generateCards()
    self.cards = {}
    for i = 1, 3 do
        local anchor = { x = 0.5, y = 0.5 }
        local powerupDef = powerups[love.math.random(1, #powerups)]
        if i == 1 then
            anchor.x = 0.25
        elseif i == 3 then
            anchor.x = 0.75
        end
        local card = PowerupSelectionCard({
            anchor          = anchor,
            offset          = { x = 0, y = 0 },
            name            = powerupDef.name,
            description     = powerupDef.description,
            animationOffset = CARD_ANIMATION_OFFSET * i
        })
        card.offset.x = -card.width / 2
        card.offset.y = -card.height / 2
        table.insert(self.cards, card)
    end
end
function PowerupSelectionMenu:_selectCard(x, y, button)
    if self.active and button == 1 then
        for _, card in ipairs(self.cards) do
            if x > card.position.x and x < card.position.x + card.width and
            y > card.position.y and y < card.position.y + card.height then
                self:_unselectAllCards()
                card:select()
                self.selectedPowerupName = card.name
            end
        end
    end
end

function PowerupSelectionMenu:_unselectAllCards()
    for _, card in ipairs(self.cards) do
        card:unselect()
    end
end

function PowerupSelectionMenu:_createSubscriptions()
    self.subscriptions = {}
    self.subscriptions['interface_selectPawnType'] = self.eventManager:subscribe('interface_selectPawnType',
        function (
            pawnType)
            if self.active and self.selectedPowerupName and not self.hasSelected then
                self.eventManager:broadcast('interface_addPowerupToType', pawnType, self.selectedPowerupName)
                self.hasSelected = true
                self.eventManager:broadcast('endPowerupSelection')
            end
        end)
end
function PowerupSelectionMenu:_destroySubscriptions()
    for event, uuid in pairs(self.subscriptions) do
        self.eventManager:unsubscribe(event, uuid)
    end
end

return PowerupSelectionMenu
