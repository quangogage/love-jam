---@author Gage Henderson 2024-02-20 19:01
--
---@class CoinGenerationSystem : System
-- Stupid simple class that really shouldn't exist at all.
--
-- Is a way to easily disable coin generation during prep phase.
--
-- Also rewards money when killing tings.

local util = require("util")({ 'entityAssembler' })
local sound = love.audio.newSource("assets/audio/sfx/earn-coins.mp3", "static")
local coinImage = love.graphics.newImage("assets/images/pawn_ui/coins.png")
local coinFont = love.graphics.newFont(fonts.speechBubble, 40)
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

    -- Add coins when an enemy dies.
    function CoinGenerationSystem:event_entityDied(e)
        if e:get("hostile") and e:get("coinValue") then
            coinManager:addCoins(e:get("coinValue").value)
            local text = util.entityAssembler.assemble(self:getWorld(), 'FadingText', '+5', e.position.x + 2, e.position.y-17, {0,0,0})
            text.text.font = coinFont
            text = util.entityAssembler.assemble(self:getWorld(), 'FadingText', '+5', math.floor(e.position.x-2), math.floor(e.position.y-13), {0,0,0})
            text.text.font = coinFont
            text = util.entityAssembler.assemble(self:getWorld(), 'FadingText', '+5', math.floor(e.position.x), math.floor(e.position.y-15), {0,1,0})
            text.text.font = coinFont
            local coin = util.entityAssembler.assemble(self:getWorld(), 'CommandIcon', e.position.x+2, e.position.y+2)
            coin:give('image', coinImage)
            coin:give("scale",2,2)
            coin:give('color',0,0,0)

            coin = util.entityAssembler.assemble(self:getWorld(), 'CommandIcon', e.position.x, e.position.y)
            coin:give('image', coinImage)
            coin:give("scale",1.6,1.6)
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
