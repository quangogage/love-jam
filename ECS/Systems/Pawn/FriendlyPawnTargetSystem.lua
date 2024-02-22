---@author Gage Henderson 2024-02-21 10:18
--
---@class FriendlyPawnTargetSystem : System
--
-- Handles some auto-target behvaior for friendly pawns.

return function (concord)
    local FriendlyPawnTargetSystem = concord.system({
        friendlyEntities = { 'friendly', 'combatProperties' },
        enemyEntities    = { 'hostile', 'health' }
    })


    ----------------------------
    -- [[ Public Functions ]] --
    ----------------------------
    function FriendlyPawnTargetSystem:event_newLevel()
        self.playerHasCommanded = false
    end
    function FriendlyPawnTargetSystem:event_playerCommand()
        self.playerHasCommanded = true
    end

    -- If a friendly pawn's target dies, have it auto-target
    -- the next nearest enemy pawn.
    ---@param pawn BasicPawn | Pawn | Entity | table
    function FriendlyPawnTargetSystem:event_entityDied(pawn)
        if pawn.hostile then
            for _, e in ipairs(self.friendlyEntities) do
                if e.target then
                    if e.target.entity == pawn then
                        self:_targetClosestEnemyPawn(e, { pawn })
                    end
                end
            end
        end
    end

    -- After a new friendly pawn is spawned, have it auto-target.
    -- (so long as the player has made their first move in the level).
    ---@param pawn BasicPawn | Pawn | Entity | table
    function FriendlyPawnTargetSystem:event_spawnedFriendlyPawn(pawn)
        if self.playerHasCommanded then
            self:_targetClosestEnemyPawn(pawn)
        end
    end


    -----------------------------
    -- [[ Private Functions ]] --
    -----------------------------
    -- Target the closest enemy pawn.
    ---@param friendlyPawn BasicPawn | Pawn | Entity | table
    ---@param ignoreEntities? table
    function FriendlyPawnTargetSystem:_targetClosestEnemyPawn(friendlyPawn, ignoreEntities)
        local closestEnemyPawn = nil
        local closestDistance = math.huge
        ignoreEntities = ignoreEntities or {}

        local shouldIgnore = function (entity)
            for _, e in ipairs(ignoreEntities) do
                if entity == e then
                    return true
                end
            end
            return false
        end

        for _, enemyTarget in ipairs(self.enemyEntities) do
            if not shouldIgnore(enemyTarget) and not enemyTarget:get("isDead") then
                local distance = math.sqrt(
                    (friendlyPawn.position.x - enemyTarget.position.x) ^ 2 +
                    (friendlyPawn.position.y - enemyTarget.position.y) ^ 2
                )
                if distance < closestDistance then
                    closestDistance = distance
                    closestEnemyPawn = enemyTarget
                end
            end
        end

        if closestEnemyPawn then
            friendlyPawn:give('target', { entity = closestEnemyPawn })
        else
            friendlyPawn:remove('target')
        end
    end


    return FriendlyPawnTargetSystem
end
