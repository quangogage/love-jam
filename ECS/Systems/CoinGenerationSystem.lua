---@author Gage Henderson 2024-02-20 19:01
--
---@class CoinGenerationSystem : System
-- Stupid simple class that really shouldn't exist at all.
--
-- Is a way to easily disable coin generation during prep phase.
--

---@param concord Concord
---@param coinManager CoinManager
return function (concord, coinManager)
    local CoinGenerationSystem = concord.system({})

    function CoinGenerationSystem:event_newLevel()
        self.playerHasCommanded = false
    end
    function CoinGenerationSystem:event_playerCommand()
        self.playerHasCommanded = true
    end

    function CoinGenerationSystem:update(dt)
        if self.playerHasCommanded then
            coinManager:generateCoins(dt)
        end
    end

    return CoinGenerationSystem
end
