---@author Gage Henderson 2024-02-16 18:28
--
-- Handles inflicting and receiving damage.
--

local SuccessfulAttack = require("Classes.Types.SuccessfulAttack")

---@param concord Concord | table
---@param onLevelComplete function
return function (concord, onLevelComplete)

    ---@class DamageSystem : System
    ---@field healthEntities Pawn[] | table[]
    ---@field targetingEntities Pawn[] | table[]
    ---@field enemyBases Base[] | table[]
    local DamageSystem = concord.system({
        healthEntities    = { 'health' },
        targetingEntities = { 'target' },
        enemyBases        = { 'isBase', 'hostile' }
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
                local direction = math.atan2(target.position.y - attacker.position.y, target.position.x - attacker.position.x)
                local successfulAttack = SuccessfulAttack({
                    attacker  = attacker,
                    target    = target,
                    damage    = damageAmount,
                    direction = direction
                })
                target.health.value = target.health.value - damageAmount
                target.health.mostRecentDamage = successfulAttack
                world:emit('event_damageDealt', successfulAttack)
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
                    world:emit('event_entityDied', entity, entity.health.mostRecentDamage)
                    entity:give("isDead")
                    entity:destroy()
                end
            end
        end
        self:_checkLevelComplete()
    end


    -----------------------------
    -- [[ Private Functions ]] --
    -----------------------------
    -- Check, after killing something, if the level is complete.
    -- Right now this just means destroying the enemy base.
    function DamageSystem:_checkLevelComplete()
        if #self.enemyBases == 0 then
            onLevelComplete()
        end
    end

    return DamageSystem
end
