---@author Gage Henderson 2024-02-18 10:03
--
-- Keeps track of what powerups have been collected / what pawn types they
-- are associated with.
--

local util                = require('util')({ 'table' })
local powerups            = require('lists.powerups')
local pawnTypes           = require('lists.pawnTypes')
local Powerup             = require('Classes.Types.Powerup')

---@class PowerupStateManager
---@field eventManager EventManager
---@field state table<string, table<string, Powerup>>
--
-- State stores a copy of every powerup for each pawn type:
-- ──────────────────────────────────────────────────────────────────────
-- state = {
--    ["Basic Pawn"] = {
--        ["Fast Walker"] = {
--             name = "Fast Walker",
--             description = "Move 20% faster",
--             count = 1,
--             onPawnCreation = function(self, pawn),
--             ...
--        },
--        ["Bloodlust"] = {
--            name = "Bloodlust",
--            description = "Deal 15% more damage",
--            count = 0,
--            onPawnCreation = function(self, pawn),
--            ...
--        },
--        ...
--    }
-- }
-- ──────────────────────────────────────────────────────────────────────
local PowerupStateManager = Goop.Class({
    arguments = { 'eventManager' },
    static = {
        state = {}
    }
})


----------------------------
-- [[ Public Functions ]] --
----------------------------
-- Add a powerup to a pawn type.
---@param pawnType string
---@param powerupName string
function PowerupStateManager:addPowerup(pawnType, powerupName)
    local thisType = self.state[pawnType]
    self.state[pawnType][powerupName].count = thisType[powerupName].count + 1

    -- As of writing only resolved in PawnSelectionMenu.
    self.eventManager:broadcast('interface_syncPowerupState', self.state)
end

-- Get a list of powerups for a pawn type.
---@param pawnType string
---@return table<string, Powerup>
function PowerupStateManager:getPowerupsForPawnType(pawnType)
    return self.state[pawnType]
end

--------------------------
-- [[ Core Functions ]] --
--------------------------
function PowerupStateManager:init()
    self:_createSubscriptions()
    self:_createPowerupList()
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
    -- Adds a powerup to a pawn type.
    self.subscriptions['interface_addPowerupToType'] =
        self.eventManager:subscribe('interface_addPowerupToType',
            function (pawnType, powerupName)
                self:addPowerup(pawnType, powerupName)
            end
        )
end
function PowerupStateManager:_destroySubscriptions()
    for eventName, uuid in pairs(self.subscriptions) do
        self.eventManager:unsubscribe(eventName, uuid)
    end
end
-- Create a copy of all of the powerups for each pawn type.
function PowerupStateManager:_createPowerupList()
    self.state = {}
    for _, pawnTypeDef in ipairs(pawnTypes) do
        local name = pawnTypeDef.name
        self.state[name] = {}
        for _, powerup in pairs(powerups) do
            self.state[name][powerup.name] = Powerup(powerup)
        end
    end
end
return PowerupStateManager
