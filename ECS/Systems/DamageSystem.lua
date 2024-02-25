---@author Gage Henderson 2024-02-16 18:28
--
-- Handles inflicting and receiving damage.
--

local util = require('util')({ 'entityAssembler' })
local SuccessfulAttack = require('Classes.Types.SuccessfulAttack')

local hitSounds = {
    love.audio.newSource('assets/audio/sfx/hits/1.mp3', 'static'),
    love.audio.newSource('assets/audio/sfx/hits/2.mp3', 'static'),
    love.audio.newSource('assets/audio/sfx/hits/3.mp3', 'static')
}
local hitSoundVolume = 0.5
for _, sound in pairs(hitSounds) do
    sound:setVolume(settings:getVolume('sfx') * hitSoundVolume)
end


---@param concord Concord | table
---@param onLevelComplete function
return function (concord, onLevelComplete, playerLost)

    ---@class DamageSystem : System
    ---@field healthEntities Pawn[] | table[]
    ---@field targetingEntities Pawn[] | table[]
    ---@field enemyBases Base[] | table[]
    local DamageSystem = concord.system({
        healthEntities    = { 'health' },
        targetingEntities = { 'target' },
        enemyBases        = { 'isBase', 'hostile' },
        enemyTowers       = { 'isTower', 'hostile' },
        enemies           = { 'hostile', 'isPawn' },
        friendlyBases     = { 'isBase', 'friendly' },
    })


    ----------------------------
    -- [[ Public Functions ]] --
    ----------------------------
    ---@param attacker Pawn | table
    ---@param target Pawn | table
    ---@param damageAmount number
    ---@param disableSoundEffect boolean - Used for melee attacks.
    function DamageSystem:entity_attemptAttack(attacker, target, damageAmount, disableSoundEffect)
        local world = self:getWorld()
        if world then
            if target.health then
                local direction        = math.atan2(target.position.y - attacker.position.y,
                    target.position.x - attacker.position.x)
                local successfulAttack = SuccessfulAttack({
                    attacker  = attacker,
                    target    = target,
                    damage    = damageAmount,
                    direction = direction
                })

                -- Armor damage reduction
                -- (Armor reduction powerup applied in PowerupSetupSystem).
                local armorAmount      = target.armor and target.armor.value or 0
                damageAmount           = damageAmount * (1 - armorAmount)

                -- Powerups
                if attacker:get('powerups') then
                    -- Increase outgoing damage per attacker's bloodlust powerup.
                    damageAmount = attacker.powerups.list['Bloodlust']:getValue(damageAmount)

                    for _, powerup in pairs(attacker.powerups.list) do
                        powerup:onSuccessfulAttack(successfulAttack)
                    end
                end

                -- Play ouchie sound.
                if not disableSoundEffect then
                    local hitSound = hitSounds[love.math.random(1, #hitSounds)]
                    if hitSound:isPlaying() then
                        hitSound = hitSound:clone()
                    end
                    love.audio.play(hitSound)
                end

                target.health.value            = target.health.value - damageAmount
                target.health.mostRecentDamage = successfulAttack
                world:emit('event_damageDealt', successfulAttack)

                -- Shadow's touch powerup
                -- Chance to insta-kill.
                if attacker:get('powerups') and not target.isBase then
                    if love.math.random() <= attacker.powerups.list["Shadow's Touch"]:getValue() then
                        local color = attacker.hostile and { 1, 0, 0, 1 } or { 0, 1, 0, 1 }
                        target.health.value = 0
                        util.entityAssembler.assemble(world, 'FadingText', 'Shadow\'s touch: Insta-kill!', attacker.position.x, attacker.position.y, color)
                    end
                end
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

                        -- On death powerup callbacks.
                        for _, powerup in pairs(entity.powerups.list) do
                            powerup:onPawnDeath(entity)
                        end

                        -- Prevent death via powerup:
                        -- name = 'Soul Renewal',
                        -- description = 'Immediately respawn at your base upon death.',
                        if love.math.random() <= entity.powerups.list['Soul Renewal']:getValue() then
                            local color = entity.hostile and { 1, 0, 0, 1 } or { 0, 1, 0, 1 }
                            local x, y = world.friendlyBase.position.x, world.friendlyBase.position.y
                            shouldStillDie = false
                            entity:remove('isDead')
                            entity.health.value = entity.health.max
                            if entity:get('hostile') then
                                x, y = world.enemyBase.position.x, world.enemyBase.position.y
                            end
                            util.entityAssembler.assemble(world, 'FadingText', 'Soul Renewed!', entity.position.x, entity.position.y, color)
                            entity.position.x = x
                            entity.position.y = y
                        end
                    end

                    if shouldStillDie then -- The powerup did not prevent death... (see above).
                        world:emit('entity_createCorpse', entity)
                        world:emit('entity_createTowerCorpse', entity)
                        entity:destroy()
                    end
                end
            end
        end
        self:_checkLevelComplete()
        self:_checkPlayerLost()
    end


    -----------------------------
    -- [[ Private Functions ]] --
    -----------------------------
    -- Check, after killing something, if the level is complete.
    -- Right now this just means destroying the enemy base.
    function DamageSystem:_checkLevelComplete()
        if not self.__debug_testRoom then
            if #self.enemyBases == 0 or #self.enemies == 0 and #self.enemyTowers == 0 then
                onLevelComplete()
            end
        end
    end

    -- Check if the player lost (their base was destroyed).
    function DamageSystem:_checkPlayerLost()
        if #self.friendlyBases == 0 then
            playerLost()
        end
    end

    return DamageSystem
end
