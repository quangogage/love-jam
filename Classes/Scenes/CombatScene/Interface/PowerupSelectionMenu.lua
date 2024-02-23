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
---@field speechBubble table
---@field description table
---@field finger table
local PowerupSelectionMenu = Goop.Class({
    arguments = { 'eventManager', 'combatScene' },
    dynamic = {
        active        = false,
        cards         = {},
        songWaitTime  = 0,
        songWaitTimer = 0.2,
        song          = love.audio.newSource('assets/audio/songs/Fortune-Teller.mp3', 'stream'),
        bgImage       = love.graphics.newImage('assets/images/ui/bg.png'),
        speechBubble  = {
            alpha  = 0,
            wiggleIntensity = 5,
            wiggleSpeed = 2.2,
            text   = '',
            font   = love.graphics.newFont(fonts.speechBubble, 30),
            image  = love.graphics.newImage('assets/images/ui/chat.png'),
            padding = 100,
            prompts = {
                "Choose wisely.",
                "The battle is won before it begins.",
                "It seems you will do well.",
            },
            anchor = { x = 0.25, y = 0 },
            offset = { x = 0, y = 20 }
        },
        description = {
            text = "Choose a powerup to take, then click on a pawn to give it to them.",
            font = love.graphics.newFont(fonts.speechBubble, 25),
            image = love.graphics.newImage('assets/images/ui/info.png'),
            anchor = { x = 1, y = 0 },
            offset = { x = -400, y = 20 },
            padding = 65
        },
        finger = {
            animX    = 0, animY = 0,
            image    = love.graphics.newImage('assets/images/icons/finger.png'),
            anchor   = { x = 0, y = 0 },
            offset   = { x = 0, y = 0 },
            rotation = 0,
            scale    = { x = -0.9, y = 0.9 },
            wiggleIntensity = 10,
            wiggleSpeed = 8.5,
            selectingPowerup = {
                anchor = {x = 0.18, y = 0.5},
                offset = {x = -185, y = 0},
                rotation = -math.pi/2
            },
            selectingPawn = {
                anchor = {x = 0.18, y = 1},
                offset = {x = -185, y = -200},
                rotation = 0
            }
        }
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
    self.speechBubble.text = self.speechBubble.prompts[love.math.random(1, #self.speechBubble.prompts)]
    self:_setFingerState('selectingPowerup')
end
function PowerupSelectionMenu:close()
    self.active = false
    self.selectedPowerupName = nil
    self.eventManager:broadcast('enableWorldUpdate')
    self.song:stop()
    cursor:set('arrow')
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
---@return boolean If you are hovering over a card.
function PowerupSelectionMenu:update(dt)
    local hovered = false
    for _, card in ipairs(self.cards) do
        card:update(dt)
        if card.hovered then
            hovered = true
        end
    end
    if self.active then
        self.songWaitTime = self.songWaitTime + dt
        if self.songWaitTime > self.songWaitTimer and not self.playedSong then
            self.song:play()
            self.playedSong = true
        end
    end
    self:_updateFinger(dt)
    self:_updateSpeechBubble(dt)

    if not self.selectedPowerupName then
        self:_setFingerState("selectingPowerup")
    else
        self:_setFingerState("selectingPawn")
    end
    return hovered
end
function PowerupSelectionMenu:draw()
    self:_drawSpeechBubble()
    self:_drawDescription()
    self:_drawFinger()
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
            if card.hovered then
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

function PowerupSelectionMenu:_drawSpeechBubble()
    love.graphics.setColor(1, 1, 1, self.speechBubble.alpha)
    love.graphics.draw(self.speechBubble.image,
        love.graphics.getWidth() * self.speechBubble.anchor.x + self.speechBubble.offset.x,
        love.graphics.getHeight() * self.speechBubble.anchor.y + self.speechBubble.offset.y + self.speechBubble.animY
    )
    love.graphics.setFont(self.speechBubble.font)
    love.graphics.setColor(1, 0, 1, self.speechBubble.alpha)
    love.graphics.printf(self.speechBubble.text,
        love.graphics.getWidth() * self.speechBubble.anchor.x + self.speechBubble.offset.x + self.speechBubble.padding / 2,
        love.graphics.getHeight() * self.speechBubble.anchor.y + self.speechBubble.offset.y + 20 + self.speechBubble.animY,
        self.speechBubble.image:getWidth() - self.speechBubble.padding,
        'left'
    )
end
function PowerupSelectionMenu:_updateSpeechBubble(dt)
    if self.active then
        self.speechBubble.alpha = math.min(self.speechBubble.alpha + dt * 2, 1)
    else
        self.speechBubble.alpha = math.max(self.speechBubble.alpha - dt * 2, 0)
    end
    local currentAmt = self.speechBubble.wiggleIntensity * math.sin(self.speechBubble.wiggleSpeed * love.timer.getTime())
    self.speechBubble.animY = currentAmt
end
function PowerupSelectionMenu:_drawDescription()
    love.graphics.setColor(1, 1, 1, self.speechBubble.alpha)
    love.graphics.draw(self.description.image,
        love.graphics.getWidth() * self.description.anchor.x + self.description.offset.x,
        love.graphics.getHeight() * self.description.anchor.y + self.description.offset.y,
        0, 0.5, 0.5
    )


    love.graphics.setColor(0, 0, 0, self.speechBubble.alpha)
    love.graphics.setFont(self.description.font)
    love.graphics.printf(self.description.text,
        love.graphics.getWidth() * self.description.anchor.x + self.description.offset.x + self.description.padding / 2,
        love.graphics.getHeight() * self.description.anchor.y + self.description.offset.y + 40,
        self.description.image:getWidth() * 0.5 - self.description.padding,
        'left'
    )
end

function PowerupSelectionMenu:_setFingerState(state)
    self.finger.anchor.x = self.finger[state].anchor.x
    self.finger.anchor.y = self.finger[state].anchor.y
    self.finger.offset.x = self.finger[state].offset.x
    self.finger.offset.y = self.finger[state].offset.y
    self.finger.rotation = self.finger[state].rotation
end

function PowerupSelectionMenu:_drawFinger()
    love.graphics.setColor(1,1,1,self.speechBubble.alpha)
    love.graphics.draw(self.finger.image,
        love.graphics.getWidth() * self.finger.anchor.x + self.finger.offset.x + self.finger.animX,
        love.graphics.getHeight() * self.finger.anchor.y + self.finger.offset.y + self.finger.animY,
        self.finger.rotation,
        self.finger.scale.x, self.finger.scale.y,
        self.finger.image:getWidth() / 2, self.finger.image:getHeight() / 2
    )
end
function PowerupSelectionMenu:_updateFinger(dt)
    local currentAmt = self.finger.wiggleIntensity * math.sin(love.timer.getTime() * self.finger.wiggleSpeed)
    local direction = self.finger.rotation + math.pi / 2
    self.finger.animX = math.cos(direction) * currentAmt
    self.finger.animY = math.sin(direction) * currentAmt
end

return PowerupSelectionMenu
