---@author Gage Henderson 2024-02-18 10:03
--
-- Keeps track of what powerups have been collected / what pawn types they
-- are associated with.
--


---@class PowerupStateManager
---@field eventManager EventManager
---@field pawnTypes table<string, table<string, {name: string, count: integer}>>
-- pawnTypes = {
--    ["BasicPawn"] = {
--        ["Fast Walker"] = {
--            name = "Fast Walker",
--            count = 1
--        }
--    },
--    ...
--}
local PowerupStateManager = Goop.Class({
    arguments = { 'eventManager' },
    static = {
        pawnTypes = {}
    }
})


----------------------------
-- [[ Public Functions ]] --
----------------------------
---@param pawnType string
---@param powerupName string
function PowerupStateManager:addPowerup(pawnType, powerupName)
    local thisType = self.pawnTypes[pawnType]
    if not thisType then
        self.pawnTypes[pawnType] = {}
        thisType = self.pawnTypes[pawnType]
    end

    if not thisType[powerupName] then
        self.pawnTypes[pawnType][powerupName] = {name = powerupName, count = 1}
    else
        self.pawnTypes[pawnType][powerupName].count = thisType[powerupName].count + 1
    end

    -- As of writing only resolved in PawnSelectionMenu.
    self.eventManager:broadcast('interface_syncPowerupState', self.pawnTypes)
end

function PowerupStateManager:getPowerupsForType(pawnType)
    return self.pawnTypes[pawnType]
end


--------------------------
-- [[ Core Functions ]] --
--------------------------
function PowerupStateManager:init()
    self:_createSubscriptions()
end
function PowerupStateManager:destroy()
    self:_destroySubscriptions()
end


-----------------------------
-- [[ Private Functions ]] --
-----------------------------
function PowerupStateManager:_createSubscriptions()
    self.subscriptions = {}
    -- Called from PowerupSelectionMenu.
    self.subscriptions["interface_addPowerupToType"] = self.eventManager:subscribe(
        "interface_addPowerupToType", function(pawnType, powerupName)
            self:addPowerup(pawnType, powerupName)
        end)
end
function PowerupStateManager:_destroySubscriptions()
    for eventName, uuid in pairs(self.subscriptions) do
        self.eventManager:unsubscribe(eventName, uuid)
    end
end
return PowerupStateManager
