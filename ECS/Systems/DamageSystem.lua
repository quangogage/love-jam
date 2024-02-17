---@author Gage Henderson 2024-02-16 18:28
--
-- Handles inflicting and receiving damage.
--
-- Ensures entities don't target dead entities.

return function (concord)

    ---@class DamageSystem : System
    ---@field healthEntities Pawn[] | table[]
    ---@field targetingEntities Pawn[] | table[]
    local DamageSystem = concord.system({
        healthEntities    = { 'health' },
        targetingEntities = { 'target' },
    })


    ----------------------------
    -- [[ Public Functions ]] --
    ----------------------------
    ---@param attacker Pawn | table
    ---@param target Pawn | table
    ---@param damageAmount number
    function DamageSystem:entity_attemptAttack(attacker, target, damageAmount)
        if target.health then
            console:log("hit")
            target.health.value = target.health.value - damageAmount
        end
    end


    --------------------------
    -- [[ Core Functions ]] --
    --------------------------
    -- Check and handle if any entities are dead.
    function DamageSystem:update()
        local world = self:getWorld()
        if world then
            for i = 1, #self.healthEntities do
                local entity = self.healthEntities[i]
                if entity.health.value <= 0 then
                    world:emit('event_entityDied', entity)
                    self:_stopTargetingEntity(entity)
                    entity:destroy()
                end
            end
        end
    end


    -----------------------------
    -- [[ Private Functions ]] --
    -----------------------------
    ---@param entity Pawn | table
    function DamageSystem:_stopTargetingEntity(entity)
        for _, targetingEntity in ipairs(self.targetingEntities) do
            if targetingEntity.target.entity == entity then
                targetingEntity:remove("target")
            end
        end
    end
    return DamageSystem
end
