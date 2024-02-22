---@author Gage Henderson 2024-02-17 06:04
--
-- Implements logic for what enemy pawns should target.
--
-- Listens for a lot of different events.
--

return function (concord)
    ---@class EnemyPawnTargetSystem : System
    ---@field enemyEntities Pawn[] | table[]
    ---@field friendlyEntities Pawn[] | table[]
    local EnemyPawnTargetSystem = concord.system({
        enemyEntities    = { 'hostile', 'combatProperties', 'health' },
        friendlyEntities = { 'friendly', 'health' },
        friendlyPawns    = { 'friendly', 'isPawn' },
    })


    ----------------------------
    -- [[ Public Functions ]] --
    ----------------------------
    function EnemyPawnTargetSystem:event_newLevel()
        self.playerHasCommanded = false
    end
    function EnemyPawnTargetSystem:event_playerCommand()
        self:_initialTargeting()
        self.playerHasCommanded = true
    end

    -- When a new enemy pawn spawns, target the closest friendly pawn.
    -- When a new friendly pawn spawns, have all enemy pawns retarget to the
    -- closest friendly pawn.
    function EnemyPawnTargetSystem:event_pawnSpawned(pawn)
        if pawn.hostile then
            self:_targetClosestFriendlyPawn(pawn)
        else
            for _, e in ipairs(self.enemyEntities) do
                self:_targetClosestFriendlyPawn(e)
            end
        end
    end

    -- Retarget all enemy pawns if a friendly pawn dies.
    ---@param pawn Pawn | table
    function EnemyPawnTargetSystem:event_entityDied(pawn)
        if pawn.friendly then
            for _, e in ipairs(self.enemyEntities) do
                -- Pass the dead pawn as an ignore entity.
                -- This is because this event is triggered before the
                -- pawn is destroyed.
                --
                -- See `DamageSystem`.
                self:_targetClosestFriendlyPawn(e, { pawn })
            end
        end
    end


    -----------------------------
    -- [[ Private Functions ]] --
    -----------------------------
    -- Target the closest friendly pawn.
    ---@param enemyPawn Pawn | table
    ---@param ignoreEntities? Pawn[] | table[]
    function EnemyPawnTargetSystem:_targetClosestFriendlyPawn(enemyPawn, ignoreEntities)
        if not self.playerHasCommanded then
            return
        end
        local closestFriendlyPawn = nil
        local closestDistance     = math.huge
        ignoreEntities            = ignoreEntities or {}

        local shouldIgnore        = function (entity)
            for _, ignoreEntity in ipairs(ignoreEntities) do
                if entity == ignoreEntity then
                    return true
                end
            end
            return false
        end

        for _, friendlyEntity in ipairs(self.friendlyEntities) do
            if not shouldIgnore(friendlyEntity) and not friendlyEntity:get('isDead') then
                local distance = math.sqrt(
                    (enemyPawn.position.x - friendlyEntity.position.x) ^ 2 +
                    (enemyPawn.position.y - friendlyEntity.position.y) ^ 2
                )
                if distance < closestDistance then
                    closestDistance = distance
                    closestFriendlyPawn = friendlyEntity
                end
            end
        end

        if closestFriendlyPawn then
            enemyPawn:give('target', { entity = closestFriendlyPawn })
        else
            enemyPawn:remove('target')
        end
    end


    -- Targeting behavior when the player makes their first move in the level.
    function EnemyPawnTargetSystem:_initialTargeting()
        for _, e in ipairs(self.enemyEntities) do
            if #self.friendlyPawns > 0 then
                local nearestPawn = self.friendlyPawns[1]
                local nearestPawnDistance = math.huge
                for _, friendlyPawn in ipairs(self.friendlyPawns) do
                    local thisDistance = math.sqrt(
                        (e.groundPosition.x - friendlyPawn.groundPosition.x) ^ 2 +
                        (e.groundPosition.y - friendlyPawn.groundPosition.y) ^ 2
                    )
                    if thisDistance < nearestPawnDistance then
                        nearestPawn = friendlyPawn
                        nearestPawnDistance = thisDistance
                    end
                end
                e:give('target', { entity = nearestPawn })
            end
        end
    end


    return EnemyPawnTargetSystem
end
