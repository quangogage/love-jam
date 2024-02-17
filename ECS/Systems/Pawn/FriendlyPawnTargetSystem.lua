---@author Gage Henderson 2024-02-17 07:00
--
---@class FriendlyPawnTargetSystem : System
-- Handles various behavior for friendly pawns after certain events occur.


-- After your target has been killed, search this far around them
-- for other hostile pawns to target.
local NEARBY_SEARCH_RADIUS = 200

return function(concord)
    local FriendlyPawnTargetSystem = concord.system({
        friendlyPawns = { 'friendly', 'position'},
        hostilePawns = { 'hostile', 'position' }
    })


    ----------------------------
    -- [[ Public Functions ]] --
    ----------------------------
    -- Whenever a pawn dies, check if any friendly pawns were targeting them.
    function FriendlyPawnTargetSystem:event_entityDied(deadEntity)
        for _, friendlyPawn in ipairs(self.friendlyPawns) do
            if not friendlyPawn.target then return end
            if friendlyPawn.target.entity == deadEntity then
                friendlyPawn:remove("target")
                self:_searchNearby(friendlyPawn, deadEntity)
            end
        end
    end


    -----------------------------
    -- [[ Private Functions ]] --
    -----------------------------
    -- Search for a nearby hostile pawns after your target has died.
    ---@param friendlyPawn Pawn | table
    ---@param deadEntity Pawn | table
    function FriendlyPawnTargetSystem:_searchNearby(friendlyPawn, deadEntity)
        local world = self:getWorld()
        if world then
            for _, hostilePawn in ipairs(self.hostilePawns) do
                if hostilePawn ~= deadEntity then
                    local distance = math.sqrt(
                        (hostilePawn.position.x - deadEntity.position.x) ^ 2 +
                        (hostilePawn.position.y - deadEntity.position.y) ^ 2
                    )
                    if distance <= NEARBY_SEARCH_RADIUS then
                        friendlyPawn:give("target", {entity = hostilePawn})
                        break
                    end
                end
            end
        end
    end

    return FriendlyPawnTargetSystem
end
