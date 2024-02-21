---@author Gage Henderson 2024-02-20 16:42
--
-- Very simple class that keeps tracks of how many coins the player has
-- collected throughout a level.
--
-- Provides an interface for adding, removing, and resetting coins.

local STARTING_AMOUNT = 3

---@class CoinManager
---@field coins integer
local CoinManager = Goop.Class({
    dynamic = {
        coins = STARTING_AMOUNT
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


return CoinManager
