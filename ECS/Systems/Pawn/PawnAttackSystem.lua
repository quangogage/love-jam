---@author Gage Henderson 2024-02-16 15:03
--
-- In order for an entity to attack it must have both a Target and
-- CombatProperties component.
--

local util = require('util')({ 'entityAssembler' })

return function (concord)
    ---@class PawnAttackSystem : System
    ---@field entities table[] | Pawn[]
    ---@field enemies table[] | Pawn[]
    ---@field friendlies table[] | Pawn[]
    local PawnAttackSystem = concord.system({
        entities   = { 'target', 'combatProperties' },
        enemies    = { 'health', 'hostile' },
        friendlies = { 'health', 'friendly' }
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
        local targetEntity             = e.target.entity
        local bottomOfTarget           = targetEntity.position.y +
            targetEntity.dimensions.height
        local bottomOfPawn             = e.position.y + e.dimensions.height
        local distance                 = math.sqrt(
            (e.position.x - targetEntity.position.x) ^ 2 +
            (bottomOfPawn - bottomOfTarget) ^ 2
        )
        local angle                    = math.atan2(
            targetEntity.position.y - e.position.y,
            targetEntity.position.x - e.position.x
        )

        e.combatProperties.attackTimer = e.combatProperties.attackTimer + dt

        -- Start attacking once we are in range.
        if distance >= e.combatProperties.range then return end -- Too far away.
        if e.combatProperties.attackTimer >= e.combatProperties.attackSpeed then
            local ignoreEntities, targetEntities
            if e.target.entity.hostile then
                ignoreEntities = self.enemies
                targetEntities = self.friendlies
            else
                ignoreEntities = self.friendlies
                targetEntities = self.enemies
            end
            -- Create melee attack hitbox.
            util.entityAssembler.assemble(
                self:getWorld(),
                'meleeHitbox',
                e.position.x + math.cos(angle) * e.combatProperties.attackSpawnDistance,
                e.position.y + math.sin(angle) * e.combatProperties.attackSpawnDistance,
                e.combatProperties.meleeHitboxSize,
                e.combatProperties.meleeHitboxSize,
                targetEntities,
                ignoreEntities
            )
            e.combatProperties.attackTimer = 0
        end
    end

    return PawnAttackSystem
end
