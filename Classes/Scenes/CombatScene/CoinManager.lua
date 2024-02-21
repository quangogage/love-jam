---@author Gage Henderson 2024-02-20 16:42
--
-- Very simple class that keeps tracks of how many coins the player has
-- collected throughout a level.
--
-- Provides an interface for adding, removing, and resetting coins.
--
-- See Pawn & Tower assemblages respectively to change how much gold they
-- are worth when killed.
--
-- See CoinGenerationSystem for where those coins actually get added.

local STARTING_AMOUNT = 3

---@class CoinManager
---@field coins integer
---@field genTimer number
---@field genRate number
local CoinManager = Goop.Class({
    dynamic = {
        coins    = STARTING_AMOUNT,
        genTimer = 0,
        genRate  = 5
    }
})

----------------------------
-- [[ Public Functions ]] --
----------------------------
---@param amount integer
function CoinManager:addCoins(amount)
    self.coins = self.coins + amount
end
---@param amount integer
function CoinManager:removeCoins(amount)
    self.coins = self.coins - amount
end
function CoinManager:resetCoins()
    self.coins = STARTING_AMOUNT
end
-- Get a number representing the amount of coins being generated per second.
---@return number
function CoinManager:getGenerationRate()
    return 1 / self.genRate
end
-- Called from CoinGenerationSystem.... don't ask...
function CoinManager:generateCoins(dt)
    self.genTimer = self.genTimer + dt
    if self.genTimer >= self.genRate then
        self:addCoins(1)
        self.genTimer = 0
    end
end


return CoinManager
