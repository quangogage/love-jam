---@author Gage Henderson 2024-02-16 18:28
--
-- Handles inflicting and receiving damage.
--

return function (concord)

    ---@class DamageSystem : System
    ---@field healthEntities Pawn[] | table[]
    local DamageSystem = concord.system({
        healthEntities    = { 'health' },
    })


    ----------------------------
    -- [[ Public Functions ]] --
    ----------------------------
    ---@param attacker Pawn | table
    ---@param target Pawn | table
    ---@param damageAmount number
    function DamageSystem:entity_attemptAttack(attacker, target, damageAmount)
        if target.health then
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
                    entity:destroy()
                end
            end
        end
    end

    return DamageSystem
end
