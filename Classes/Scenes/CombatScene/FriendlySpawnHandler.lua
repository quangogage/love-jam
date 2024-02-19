---@author Gage Henderson 2024-02-18 07:33
--
-- Handles spawning friendly pawns via the interface.
--

local util = require('util')({ 'entityAssembler' })

---@class FriendlySpawnHandler
---@field eventManager EventManager
---@field world World
---@field powerupStateManager PowerupStateManager
---@field combatScene CombatScene
---@field spawnZone table
local FriendlySpawnHandler = Goop.Class({
    arguments = {
        { 'eventManager',        'table' },
        { 'world',               'table' },
        { 'powerupStateManager', 'table' },
        { 'combatScene',         'table' },
    },
    static = {
        spawnZone = { x = 0, y = 0, width = 0, height = 0 }
    }
})


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
        util.entityAssembler.assemble(
            self.world, pawnTypeAssemblage, x, y, true, powerups
        )
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

return FriendlySpawnHandler
