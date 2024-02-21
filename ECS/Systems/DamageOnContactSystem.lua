---@author Gage Henderson 2024-02-21 08:18
--
--

return function (concord)
    ---@class DamageOnContactSystem : System
    ---@field damagingEntities Arrow[] | Entity[] | table[]
    ---@field friendlyTargets BasicPawn[] | Pawn[] | table[]
    ---@field enemyTargets BasicPawn[] | Pawn[] | table[]
    local DamageOnContactSystem = concord.system({
        damagingEntities = { 'damageOnContact', 'position', 'dimensions' },
        friendlyTargets  = { 'friendly', 'health' },
        enemyTargets     = { 'hostile', 'health' }
    })

    function DamageOnContactSystem:update(dt)
        local world = self:getWorld()
        if not world then return end
        for _, e1 in ipairs(self.damagingEntities) do
            local targets = e1.hostile and self.friendlyTargets or self.enemyTargets
            local attacker = e1.damageOnContact.attacker

            for _, e2 in ipairs(targets) do
                if e1.position.x + e1.dimensions.width / 2 > e2.position.x - e2.dimensions.width / 2 and
                e1.position.x - e1.dimensions.width / 2 < e2.position.x + e2.dimensions.width / 2 and
                e1.position.y + e1.dimensions.height / 2 > e2.position.y - e2.dimensions.height / 2 and
                e1.position.y - e1.dimensions.height / 2 < e2.position.y + e2.dimensions.height / 2 then
                    world:emit('entity_attemptAttack', attacker, e2, e1.damageOnContact.damageAmount)
                    e1:destroy()
                    break
                end
            end
        end
    end

    return DamageOnContactSystem
end
