---@author Gage Henderson 2024-02-18 07:33
--
-- Handles spawning friendly pawns via the interface.
--

local util = require('util')({ 'entityAssembler' })

---@class FriendlySpawnHandler
---@field eventManager EventManager
---@field world World
---@field spawnZone { x: number, y: number, width: number, height: number }
---@field combatScene CombatScene
local FriendlySpawnHandler = Goop.Class({
    arguments = {
        { 'eventManager', 'table' },
        { 'world',        'table' },
        { 'combatScene',  'table' }
    },
    static = {
        spawnZone = { x = 0, y = 0, width = 0, height = 0 }
    }
})


----------------------------
-- [[ Public Functions ]] --
----------------------------
-- Triggered by the `interface_attemptSpawnPawn` event.
---@param pawnType string The type of pawn to spawn.
---@param x number
---@param y number
function FriendlySpawnHandler:_attemptSpawnPawn(pawnType, x, y)
    if not self.combatScene.levelComplete then
        x = x or
            love.math.random(self.spawnZone.x,
                self.spawnZone.x + self.spawnZone.width)
        y = y or
            love.math.random(self.spawnZone.y,
                self.spawnZone.y + self.spawnZone.height)
        util.entityAssembler.assemble(self.world, pawnType, x, y, true)
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
    self.subscriptions['interface_attemptSpawnPawn'] = self.eventManager
                                                           :subscribe(
            'interface_attemptSpawnPawn',
            function (pawnType, x, y)
                self:_attemptSpawnPawn(pawnType, x, y)
            end
        )
end
function FriendlySpawnHandler:_destroySubscriptions()
    for eventName, uuid in pairs(self.subscriptions) do
        self.eventManager:unsubscribe(eventName, uuid)
    end
end

return FriendlySpawnHandler
