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
        local world = self:getWorld()
        if not world then return end

        for _, e in ipairs(self.entities) do
            local targetEntity = e.target.entity
            e.combatProperties.attackTimer = e.combatProperties.attackTimer + dt
            if targetEntity then
                local distance = math.sqrt(
                    (e.position.x - targetEntity.position.x) ^ 2 +
                    (e.groundPosition.y - targetEntity.groundPosition.y) ^ 2
                )
                local attackSpeed = e.combatProperties.attackSpeed
                if e.powerups then
                    attackSpeed = e.powerups.list['Quickening Quiver']:getValue(attackSpeed)
                end

                if distance >= e.combatProperties.range then return end -- Too far away.
                if e.combatProperties.attackTimer >= attackSpeed then
                    if e.combatProperties.type == 'melee' then
                        self:_meleeAttack(e, dt)
                    end

                    local sound = e.combatProperties.sounds[math.random(1, #e.combatProperties.sounds)]
                    love.audio.play(sound)

                    e.combatProperties.attackTimer = 0
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
        local world        = self:getWorld()
        local targetEntity = e.target.entity

        local direction    = math.atan2(
            targetEntity.position.y - e.position.y,
            targetEntity.position.x - e.position.x
        )
        world:emit('entity_attemptAttack',
            e, targetEntity, e.combatProperties.damageAmount, true
        )
        world:emit('pawn_playAnimationOnce', e, 'attack', direction)
    end

    return PawnAttackSystem
end
