---@author Gage Henderson 2024-02-20 12:29
--
-- As of right now pawns will retaliate when attacked so long as they are not
-- already targeting something.

return function (concord)
    ---@class RetaliationSystem : System
    local RetaliationSystem = concord.system()

    ----------------------------
    -- [[ Public Functions ]] --
    ----------------------------
    ---@param successfulAttack SuccessfulAttack
    function RetaliationSystem:event_damageDealt(successfulAttack)
        local attacker = successfulAttack.attacker
        local target = successfulAttack.target
        if target:get("isPawn") then

            -- If the person who attacked is not dead.
            -- And the person who was attacked is not already targeting something.
            if not attacker:get("isDead") and not target:get("target") then
                target:give('target', { entity = attacker })
            end
        end
    end

    return RetaliationSystem
end
