---@author Gage Henderson 2024-02-16 15:03
--
-- In order for an entity to attack it must have both a Target and
-- CombatProperties component.
--
-- See `ECS.Systems.Pawn.PawnAISystem` for more information about pawn
-- behavior: targeting, movement, etc,.
--
-- See `ECS.Systems.DamageSystem` for attack resolution.

return function (concord)
    ---@class PawnAttackSystem : System
    ---@field entities table[] | Pawn[]
    local PawnAttackSystem = concord.system({
        entities = { 'target', 'combatProperties' },
    })

    --------------------------
    -- [[ Core Functions ]] --
    --------------------------
    -- If the pawn is targeting an entity,
    -- start attackin'.
    function PawnAttackSystem:update(dt)
        for _, e in ipairs(self.entities) do
            if e.target.entity then
                if e.combatProperties.type == 'melee' then
                    self:_meleeAttack(e, dt)
                end
            end
        end
    end

    -----------------------------
    -- [[ Private Functions ]] --
    -----------------------------
    -- Try melee attacking target entity.
    ---@param e Pawn | table
    ---@param dt number
    function PawnAttackSystem:_meleeAttack(e, dt)
        local world          = self:getWorld()
        local targetEntity   = e.target.entity
        local bottomOfTarget = targetEntity.position.y +
            targetEntity.dimensions.height
        local bottomOfPawn = e.position.y + e.dimensions.height
        local distance     = math.sqrt(
            (e.position.x - targetEntity.position.x) ^ 2 +
            (bottomOfPawn - bottomOfTarget) ^ 2
        )

        e.combatProperties.attackTimer = e.combatProperties.attackTimer + dt

        -- Start attacking once we are in range.
        if distance >= e.combatProperties.range then return end -- Too far away.
        if e.combatProperties.attackTimer >= e.combatProperties.attackSpeed then
            world:emit('entity_attemptAttack',
                e, targetEntity, e.combatProperties.damageAmount
            )
            e.combatProperties.attackTimer = 0
        end
    end

    return PawnAttackSystem
end
