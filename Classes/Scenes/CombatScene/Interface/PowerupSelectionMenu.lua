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
---@field playedSong boolean
---@field bgImage love.Image
---@field teller table
---@field speechBubble table
---@field description table
---@field highlightBar table
---@field closeSound love.Source
local PowerupSelectionMenu = Goop.Class({
    arguments = { 'eventManager', 'combatScene' },
    dynamic = {
        timer        = 0,
        active       = false,
        cards        = {},
        songWaitTime = 0,
        song         = love.audio.newSource('assets/audio/songs/Fortune-Teller.mp3', 'stream'),
        closeSound   = love.audio.newSource('assets/audio/sfx/exit-powerup-menu.mp3', 'static'),
        applyPowerupSound = love.audio.newSource('assets/audio/sfx/apply-powerup.mp3', 'static'),
        bgImage      = love.graphics.newImage('assets/images/ui/bg.png'),
        highlightBar = {
            image = love.graphics.newImage('assets/images/ui/yellow_gradient.png'),
            scale = { x = 1, y = 0.85 },
            anchor = { x = 0, y = 0.5 },
            alpha = 0,
            waitTime = 1,
            targetAlpha = 0.5
        },
        speechBubble = {
            alpha           = 0,
            wiggleIntensity = 5,
            wiggleSpeed     = 2.2,
            text            = '',
            font            = love.graphics.newFont(fonts.speechBubble, 26),
            image           = love.graphics.newImage('assets/images/ui/chat.png'),
            padding         = 75,
            prompts         = {
                -- Would've used gpt to generate some of these, but wow is it bad right now.
                'So another battle will be won.',
                'I still see fear in you. Do not let it taint your judgement.',
                'The cards whisper of great powers, yet your wisdom will ultimately decide your future.',
                'We cannot fight our destiny, but we can shape it.',
                'The fate of your men is in your hands.',
                'You fear the unknown, yet within it lie many paths to certainty.',
                'Victory is often the result of many decisions - Defeat may be the result of just one.',
            },
            anchor          = { x = 0.25, y = 0 },
            offset          = { x = 0, y = 20 }
        },
        description  = {
            text = 'Choose a powerup to take, then click on a pawn to give it to them.',
            font = love.graphics.newFont(fonts.speechBubble, 25),
            image = love.graphics.newImage('assets/images/ui/info.png'),
            anchor = { x = 1, y = 0 },
            offset = { x = -400, y = 20 },
            padding = 65
        },
    }
})
PowerupSelectionMenu.song:setVolume(settings:getVolume('music'))
PowerupSelectionMenu.song:setLooping(true)
PowerupSelectionMenu.closeSound:setVolume(settings:getVolume('interface'))
PowerupSelectionMenu.applyPowerupSound:setVolume(settings:getVolume('interface'))

----------------------------
-- [[ Public Functions ]] --
----------------------------
function PowerupSelectionMenu:open()
    self.hasSelected = false
    self.active = true
    self.eventManager:broadcast('disableWorldUpdate')
    self:_generateCards()
    self.timer = 0
    self.playedSong = false
    self.speechBubble.text = self.speechBubble.prompts[love.math.random(1, #self.speechBubble.prompts)]
end
function PowerupSelectionMenu:close()
    self.active = false
    self.selectedPowerupName = nil
    self.eventManager:broadcast('enableWorldUpdate')
    self.song:stop()
    self.closeSound:play()
    self.cards = {}
    cursor:set('arrow')
end

--------------------------
-- [[ Core Functions ]] --
--------------------------
function PowerupSelectionMenu:init()
    self:_createSubscriptions()
end
function PowerupSelectionMenu:destroy()
    self.song:stop()
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
        self.timer = self.timer + dt
        if self.timer > self.songWaitTime and not self.playedSong then
            self.song:play()
            self.playedSong = true
        end
        if self.timer >= self.highlightBar.waitTime then
            self.highlightBar.alpha = self.highlightBar.alpha +
            (self.highlightBar.targetAlpha - self.highlightBar.alpha) * 5 * dt
        else
            self.highlightBar.alpha = 0
        end
    else
        self.highlightBar.alpha = 0
    end
    self:_updateSpeechBubble(dt)

    if not self.selectedPowerupName then
        self.highlightBar.anchor.y = 0.5
    else
        self.highlightBar.anchor.y = 1
    end
    return hovered
end
function PowerupSelectionMenu:draw()
    self:_drawHighlightBar()
    self:_drawSpeechBubble()
    self:_drawDescription()
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
            animationOffset = CARD_ANIMATION_OFFSET * i,
            icon            = powerupDef.image
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
                self.applyPowerupSound:play()
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
        love.graphics.getWidth() * self.speechBubble.anchor.x + self.speechBubble.offset.x +
        self.speechBubble.padding / 2,
        love.graphics.getHeight() * self.speechBubble.anchor.y + self.speechBubble.offset.y + 10 +
        self.speechBubble.animY,
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


function PowerupSelectionMenu:_drawHighlightBar()
    love.graphics.setColor(1, 1, 1, self.highlightBar.alpha)
    love.graphics.draw(self.highlightBar.image,
        love.graphics.getWidth() * self.highlightBar.anchor.x,
        love.graphics.getHeight() * self.highlightBar.anchor.y,
        0, self.highlightBar.scale.x, self.highlightBar.scale.y,
        0, self.highlightBar.image:getHeight() / 2
    )
end

return PowerupSelectionMenu
