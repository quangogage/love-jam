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
        enemyEntities    = { 'hostile', 'combatProperties' },
        friendlyEntities = { 'friendly' }
    })


    ----------------------------
    -- [[ Public Functions ]] --
    ----------------------------
    function EnemyPawnTargetSystem:event_pawnSpawned(pawn)
        if pawn.hostile then
            self:_targetClosestFriendlyPawn(pawn)
        else
            for _, e in ipairs(self.enemyEntities) do
                self:_targetClosestFriendlyPawn(e)
            end
        end
    end
    function EnemyPawnTargetSystem:event_entityDied(pawn)
        if pawn.friendly then
            self._shouldRetarget = true
        end
    end

    --------------------------
    -- [[ Core Functions ]] --
    --------------------------
    function EnemyPawnTargetSystem:update()
        if self._shouldRetarget then
            for _, e in ipairs(self.enemyEntities) do
                self:_targetClosestFriendlyPawn(e)
            end
            self._shouldRetarget = false
        end
    end

    -----------------------------
    -- [[ Private Functions ]] --
    -----------------------------
    -- Target the closest friendly pawn.
    ---@param enemyPawn Pawn | table
    function EnemyPawnTargetSystem:_targetClosestFriendlyPawn(enemyPawn)
        local closestFriendlyPawn = nil
        local closestDistance     = math.huge

        for _, friendlyEntity in ipairs(self.friendlyEntities) do
            local distance = math.sqrt(
                (enemyPawn.position.x - friendlyEntity.position.x) ^ 2 +
                (enemyPawn.position.y - friendlyEntity.position.y) ^ 2
            )
            if distance < closestDistance then
                closestDistance = distance
                closestFriendlyPawn = friendlyEntity
            end
        end

        if closestFriendlyPawn then
            enemyPawn:give('target', { entity = closestFriendlyPawn })
        else
            enemyPawn:remove('target')
        end
    end


    return EnemyPawnTargetSystem
end
