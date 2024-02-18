---@author Gage Henderson 2024-02-18 10:03
--
-- Keeps track of what powerups have been collected / what pawn types they
-- are associated with.
--


---@class PowerupStateManager
---@field eventManager EventManager
---@field pawnTypes table<string, table<string, {name: string, count: integer}>>
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
        thisType[powerupName] = {name = powerupName, count = 1}
    else
        thisType[powerupName].count = thisType[powerupName].count + 1
    end
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
