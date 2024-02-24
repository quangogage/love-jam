---@author Gage Henderson 2024-02-24 08:25
--
---@class LoopStatSystem
-- Adds health and damage to hostile entities as they spawn depending on
-- the current loop.
--

---@param concord Concord
---@param loopStateManager LoopStateManager
return function(concord, loopStateManager)
    local LoopStatSystem = concord.system({
        hostileEntities = { "hostile", "health" }
    })

    function LoopStatSystem:update()
        for _, entity in ipairs(self.hostileEntities) do
            if not entity.hostile.loopStatsApplied then
                local loop = loopStateManager.loop
                for _=1,loop do
                    entity.health.max = entity.health.max * KNOBS.loop.healthMultiplier
                end
                entity.health.value = entity.health.max
                entity.hostile.loopStatsApplied = true
            end
        end
    end
    return LoopStatSystem
end
