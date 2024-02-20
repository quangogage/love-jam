---@author Gage Henderson 2024-02-20 12:29
--

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
            if not attacker:get("isDead") then
                target:give('target', { entity = attacker })
            end
        end
    end

    return RetaliationSystem
end
