---@author Gage Henderson 2024-02-19 09:24
--
--

local util         = require('util')({ 'graphics', 'math' })
local Element      = require('Classes.Elements.Element')

local NAME_FONT    = love.graphics.newFont(fonts.title, 34 * 0.85)
local DESC_FONT    = love.graphics.newFont(fonts.sub, 18 * 0.85)
local TEXT_PADDING = 35


---@class PowerupSelectionCard : Element
---@field anchor table
---@field offset table
---@field name string
---@field description string
---@field timer number
---@field animationOffset number
---@field width number
---@field height number
---@field animation table
---@field bgImage love.Image
---@field hovered boolean
---@field lift number
---@field liftAmount number
---@field liftSpeed number
---@field liftShadowInfluence number
---@field spawnSound love.Source
---@field hoverSound love.Source
---@field clickSound love.Source
local PowerupSelectionCard = Goop.Class({
    extends = Element,
    parameters = {
        { 'anchor',      'table' },
        { 'offset',      'table' },
        { 'name',        'string' },
        { 'description', 'string' },
        'icon'
    },
    dynamic = {
        spawnSound          = love.audio.newSource('assets/audio/sfx/cards/deal.mp3', 'static'),
        hoverSound          = love.audio.newSource('assets/audio/sfx/cards/hover.mp3', 'static'),
        clickSound          = love.audio.newSource('assets/audio/sfx/cards/click.mp3', 'static'),
        timer               = 0,
        animationOffset     = 0,
        width               = 260 * 0.85,
        height              = 358 * 0.85,
        hovered             = false,
        lift                = 0,
        liftAmount          = 25,
        liftSpeed           = 15,
        liftShadowInfluence = 0.002,
        iconSize            = 50,
        animation           = {
            y     = 50,
            speed = 2,
            alpha = 0
        },
        bgImage             = love.graphics.newImage('assets/images/ui/card.png'),
    }
})
PowerupSelectionCard.spawnSound:setVolume(settings:getVolume('interface'))
PowerupSelectionCard.hoverSound:setVolume(settings:getVolume('interface'))
PowerupSelectionCard.clickSound:setVolume(settings:getVolume('interface'))


----------------------------
-- [[ Public Functions ]] --
----------------------------
function PowerupSelectionCard:select()
    local sound = self.clickSound
    if sound:isPlaying() then
        sound = sound:clone()
    end
    sound:play()
    self.selected = true
end
function PowerupSelectionCard:unselect()
    self.selected = false
end

--------------------------
-- [[ Core Functions ]] --
--------------------------
function PowerupSelectionCard:update(dt)
    self.timer = self.timer + dt
    Element.update(self)
    self:_updateAnimation(dt)
    self:_checkHover()
    self:_updateLift(dt)
end
function PowerupSelectionCard:draw()
    if self.position.x ~= 0 then
        self:_drawShadow()
        self:_drawBackground()
        self:_drawIcon()
        self:_printName()
        self:_printDescription()
    end
end


-----------------------------
-- [[ Private Functions ]] --
-----------------------------
function PowerupSelectionCard:_updateAnimation(dt)
    if self.timer > self.animationOffset then
        if not self.spawnSoundPlayed then
            self.spawnSound:play()
            self.spawnSoundPlayed = true
        end
        self.animation.y = self.animation.y - self.animation.y * self.animation.speed * dt
        if self.animation.alpha < 1 then
            self.animation.alpha = self.animation.alpha + self.animation.speed * dt
        end
    end
    self.position.y = self.position.y + self.animation.y
end
function PowerupSelectionCard:_drawBackground()
    local scale = util.graphics.getScaleForDimensions(self.bgImage, self.width, self.height)
    love.graphics.setColor(1, 1, 1, self.animation.alpha)
    if self.selected then
        love.graphics.setColor(0, 1, 0, self.animation.alpha)
    end
    love.graphics.draw(self.bgImage, self.position.x, self.position.y - self.lift, 0, scale.x, scale.y)
end
function PowerupSelectionCard:_drawIcon()
    local scale = util.graphics.getScaleForDimensions(self.icon, self.iconSize, self.iconSize)
    love.graphics.setColor(1,1,1, self.animation.alpha)
    love.graphics.draw(self.icon,
        self.position.x + self.width / 2,
        self.position.y + self.height * 0.45 - self.lift,
        0, scale.x, scale.x,
        self.icon:getWidth() / 2, self.icon:getHeight() / 2
    )
end
function PowerupSelectionCard:_printName()
    love.graphics.setFont(NAME_FONT)
    love.graphics.setColor(1, 1, 1, self.animation.alpha)
    love.graphics.printf(self.name,
        math.floor(self.position.x + TEXT_PADDING / 2),
        math.floor(self.position.y + 30 - self.lift), self.width - TEXT_PADDING,
        'center'
    )
end
function PowerupSelectionCard:_printDescription()
    love.graphics.setFont(DESC_FONT)
    love.graphics.setColor(1, 1, 1, self.animation.alpha)
    love.graphics.printf(self.description,
        math.floor(self.position.x + TEXT_PADDING / 2),
        math.floor(self.position.y + self.height - 105 - self.lift),
        self.width - TEXT_PADDING, 'center'
    )
end
function PowerupSelectionCard:_checkHover()
    local x, y = love.mouse.getPosition()
    if x > self.position.x and x < self.position.x + self.width and 
    y > self.position.y and y < self.position.y + self.height then
        if not self.hovered then
            local sound = self.hoverSound
            if sound:isPlaying() then
                sound = sound:clone()
            end
            sound:play()
            self.hovered = true
        end
    else
        self.hovered = false
    end
end
function PowerupSelectionCard:_updateLift(dt)
    local target = self.hovered and self.liftAmount or 0
    if self.hovered and love.mouse.isDown(1) then
        target = 0
    end
    self.lift = util.math.lerp(self.lift, target, self.liftSpeed * dt)
end

function PowerupSelectionCard:_drawShadow()
    local scale = 1 + self.lift * self.liftShadowInfluence
    local width = self.width * scale
    local height = self.height * scale
    local x = self.position.x + self.width / 2 - width / 2
    local y = self.position.y + self.height / 2 - height / 2
    love.graphics.setColor(0, 0, 0, self.animation.alpha * 0.34)
    love.graphics.rectangle('fill', x, y, width, height, 15, 15)
end
return PowerupSelectionCard
