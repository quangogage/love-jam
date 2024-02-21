---@author Gage Henderson 2024-02-16 18:28
--
-- Handles inflicting and receiving damage.
--

local SuccessfulAttack = require('Classes.Types.SuccessfulAttack')

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
                local direction = math.atan2(target.position.y - attacker.position.y,
                    target.position.x - attacker.position.x)
                local successfulAttack = SuccessfulAttack({
                    attacker  = attacker,
                    target    = target,
                    damage    = damageAmount,
                    direction = direction
                })

                -- Powerups
                if target:get('powerups') then
                    damageAmount = target.powerups.list['Bloodlust']:getValue(damageAmount)
                end

                -- Armor damage reduction
                local armorAmount              = target.armor and target.armor.value or 0
                damageAmount                   = damageAmount * (1 - armorAmount)

                target.health.value            = target.health.value - damageAmount
                target.health.mostRecentDamage = successfulAttack
                world:emit('event_damageDealt', successfulAttack)
            end
        end
    end

    -- Debug function (see DebugSystem).
    -- Prevents continuing to the next level when all entities are dead.
    -- See `DamageSystem._checkLevelComplete`.
    function DamageSystem:testRoom()
        self.__debug_testRoom = true
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
                    local shouldStillDie = true
                    world:emit('event_entityDied', entity, entity.health.mostRecentDamage)
                    entity:give('isDead')

                    -- Powerups
                    if entity:get('powerups') then
                        for _, powerup in pairs(entity.powerups.list) do
                            powerup:onPawnDeath(entity)
                        end

                        -- Prevent death via powerup:
                        -- name = 'Soul Renewal',
                        -- description = 'Immediately respawn at your base upon death.',
                        if love.math.random() <= entity.powerups.list['Soul Renewal']:getValue() then
                            local x, y = world.friendlyBase.position.x, world.friendlyBase.position.y
                            shouldStillDie = false
                            entity:remove('isDead')
                            entity.health.value = entity.health.max
                            if entity:get('hostile') then
                                x, y = world.enemyBase.position.x, world.enemyBase.position.y
                            end
                            entity.position.x = x
                            entity.position.y = y
                        end
                    end

                    if shouldStillDie then -- The powerup did not prevent death... (see above).
                        entity:destroy()
                    end
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
        if #self.enemyBases == 0 and not self.__debug_testRoom then
            onLevelComplete()
        end
    end

    return DamageSystem
end
