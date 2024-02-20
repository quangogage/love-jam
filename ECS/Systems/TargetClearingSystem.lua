---@author Gage Henderon 2024-02-18 08:50
--
---@class TargetClearingSystem : System
-- Extremely stupid simple class that removes dead entity targets.
--

return function(concord)
    local TargetClearingSystem = concord.system({
        entities = { 'target' }
    })

    function TargetClearingSystem:update()
        local world = self:getWorld()
        for _,e in ipairs(self.entities) do
            if e.target.entity then
                if e.target.entity.isDead then
                    e:remove('target')
                    world:emit("entity_stoppedTargeting", e)
                end
            end
        end
    end

    return TargetClearingSystem
end
