---@author Gage Henderson 2024-02-24 08:00
--
-- Keeps track of how many times the player has looped through the entire set
-- of levels.
--
-- Also what powerups the enemies have then therefore been given.
--

local util     = require('util')({ 'table'})
local powerups = require('lists.powerups')
local Powerup  = require("Classes.Types.Powerup")

---@class LoopStateManager
---@field loop integer
---@field powerupList table<string, Powerup>
local LoopStateManager = Goop.Class({
    dynamic = {
        loop = 0,
        powerupList = {}
    }
})


----------------------------
-- [[ Public Functions ]] --
----------------------------
function LoopStateManager:addLoop()
    self.loop = self.loop + 1
    self:_addPowerups()
end
function LoopStateManager:getPowerups()
    return self.powerupList
end


--------------------------
-- [[ Core Functions ]] --
--------------------------
function LoopStateManager:init()
    self:_createPowerupList()
end


-----------------------------
-- [[ Private Functions ]] --
-----------------------------
-- For every loop, add one random powerup.
function LoopStateManager:_addPowerups()
    for _=1,self.loop do
        local powerupNameList = util.table.getKeysAsArray(self.powerupList)
        local randomPowerupName = powerupNameList[love.math.random(1, #powerupNameList)]
        local randomPowerup = self.powerupList[randomPowerupName]
        randomPowerup.count = randomPowerup.count + 1
    end
end

-- Create a new list of powerups to keep track of specifically for enemy pawns.
function LoopStateManager:_createPowerupList()
    for _,powerup in pairs(powerups) do
        self.powerupList[powerup.name] = Powerup(powerup)
    end
end

return LoopStateManager
