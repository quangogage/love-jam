---@author Gage Henderson 2024-02-24 10:41
--
---@class FadeOutSystem : System
--

local FADE_SPEED = 0.75
local FALL_SPEED = 0

return function(concord)
    local FadeOutSystem = concord.system({
        entities = {"fadeOut"}
    })

    function FadeOutSystem:update(dt)
        for _, entity in ipairs(self.entities) do
            entity:ensure('alpha')
            entity.alpha.value = entity.alpha.value - FADE_SPEED * dt
            if entity.alpha.value < 0 then
                entity:destroy()
            end
            entity.position.y = entity.position.y + FALL_SPEED * dt
        end
    end

    return FadeOutSystem
end
