---@author Gage Henderson 2024-02-16 18:28
--
-- Handles inflicting and receiving damage.
--
-- Makes sure entities stop targeting dead entities.

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
        local world = self:getWorld()
        if world then
            if target.health then
                target.health.value = target.health.value - damageAmount
                world:emit("event_damageDealt", attacker, target, damageAmount)
            end
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
                    self:_stopTargetingDeadEntity(entity)
                    entity:destroy()
                end
            end
        end
    end


    -----------------------------
    -- [[ Private Functions ]] --
    -----------------------------
    ---@param deadEntity Pawn | table
    function DamageSystem:_stopTargetingDeadEntity(deadEntity)
        for _,e in ipairs(self.targetingEntities) do
            if e.target.entity == deadEntity then
                e:remove('target')
            end
        end
    end

    return DamageSystem
end
