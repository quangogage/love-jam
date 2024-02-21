---@author Gage Henderson 2024-02-20 19:01
--
---@class CoinGenerationSystem : System
-- Stupid simple class that really shouldn't exist at all.
--
-- Is a way to easily disable coin generation during prep phase.
--
-- Also rewards money when killing tings.

local sound = love.audio.newSource("assets/audio/sfx/earn-coins.mp3", "static")
sound:setVolume(settings:getVolume("sfx") * 0.7)

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

    function CoinGenerationSystem:event_entityDied(e)
        if e:get("hostile") and e:get("coinValue") then
            coinManager:addCoins(e:get("coinValue").value)
            if sound:isPlaying() then
                sound = sound:clone()
            end
            sound:play()
        end
    end

    function CoinGenerationSystem:update(dt)
        if self.playerHasCommanded then
            coinManager:generateCoins(dt)
        end
    end

    return CoinGenerationSystem
end
