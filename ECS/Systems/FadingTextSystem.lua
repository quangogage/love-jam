---@author Gage Henderson 2024-02-24 10:41
--
---@class FadingTextSystem : System
--

local FADE_SPEED = 0.75
local FALL_SPEED = 13

return function(concord)
    local FadingTextSystem = concord.system({
        entitites = {"isFadingText"}
    })

    function FadingTextSystem:update(dt)
        for _, entity in ipairs(self.entitites) do
            if entity.alpha then
                entity.alpha.value = entity.alpha.value - FADE_SPEED * dt
                if entity.alpha.value < 0 then
                    entity:destroy()
                end
                entity.position.y = entity.position.y + FALL_SPEED * dt
            end
        end
    end

    return FadingTextSystem
end
