---@author Gage Henderson 2024-02-18 07:33
--
-- Handles spawning friendly pawns via the interface.
--

local util = require('util')({ 'entityAssembler' })
local pawnTypes = require('lists.pawnTypes')

---@class FriendlySpawnHandler
---@field eventManager EventManager
---@field world World
---@field powerupStateManager PowerupStateManager
---@field combatScene CombatScene
---@field coinManager CoinManager
---@field spawnZone table
local FriendlySpawnHandler = Goop.Class({
    arguments = {
        { 'eventManager',        'table' },
        { 'world',               'table' },
        { 'powerupStateManager', 'table' },
        { 'combatScene',         'table' },
        { 'coinManager',         'table' }
    },
    static = {
        spawnZone = { x = 0, y = 0, width = 0, height = 0 }
    }
})

local coinSounds = {
    love.audio.newSource('assets/audio/sfx/coins/1.mp3', 'static'),
    love.audio.newSource('assets/audio/sfx/coins/2.mp3', 'static'),
    love.audio.newSource('assets/audio/sfx/coins/3.mp3', 'static'),
}
for _, sound in ipairs(coinSounds) do
    sound:setVolume(settings:getVolume('sfx'))
end

----------------------------
-- [[ Public Functions ]] --
----------------------------
-- Triggered by the `interface_attemptSpawnPawn` event.
---@param pawnTypeAssemblage string The name of the assemblage to spawn.
---@param pawnName string
---@param x? number
---@param y? number
function FriendlySpawnHandler:attemptSpawnPawn(pawnTypeAssemblage, pawnName, x, y)
    if not self.combatScene.disableWorldUpdate then
        local powerups = self.powerupStateManager:getPowerupsForPawnType(pawnName)
        x = self.combatScene.friendlyBase.position.x or self.spawnZone.x or 0
        y = self.combatScene.friendlyBase.position.y or self.spawnZone.y or 0

        local price = self:_getPawnPrice(pawnTypeAssemblage)

        if self.coinManager.coins >= price then
            local newPawn = util.entityAssembler.assemble(
                self.world, pawnTypeAssemblage, x, y, true, powerups
            )

            local sound = coinSounds[math.random(1, #coinSounds)]
            if sound:isPlaying() then
                sound = sound:clone()
            end
            sound:play()

            self.coinManager:removeCoins(price)

            self.world:emit("event_spawnedFriendlyPawn", newPawn)
        end

    end
end

---@param x number
---@param y number
---@param width number
---@param height number
function FriendlySpawnHandler:setSpawnZone(x, y, width, height)
    self.spawnZone = { x = x, y = y, width = width, height = height }
end


--------------------------
-- [[ Core Functions ]] --
--------------------------
function FriendlySpawnHandler:init()
    self:_createSubscriptions()
end
function FriendlySpawnHandler:destroy()
    self:_destroySubscriptions()
end



-----------------------------
-- [[ Private Functions ]] --
-----------------------------
function FriendlySpawnHandler:_createSubscriptions()
    self.subscriptions = {}
    self.subscriptions['interface_attemptSpawnPawn'] = self.eventManager:subscribe(
        'interface_attemptSpawnPawn', function (pawnTypeAssemblage, x, y)
            self:attemptSpawnPawn(pawnTypeAssemblage, x, y)
        end
    )
end
function FriendlySpawnHandler:_destroySubscriptions()
    for eventName, uuid in pairs(self.subscriptions) do
        self.eventManager:unsubscribe(eventName, uuid)
    end
end

---@param pawnTypeAssemblage string
---@return number
function FriendlySpawnHandler:_getPawnPrice(pawnTypeAssemblage)
    for _, pawn in ipairs(pawnTypes) do
        if pawn.assemblageName == pawnTypeAssemblage then
            return pawn.price
        end
    end
    console:log('WARN: didnt find pawn price for ' .. pawnTypeAssemblage)
    return 0
end

return FriendlySpawnHandler
