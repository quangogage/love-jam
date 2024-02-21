---@author Gage Henderson 2024-02-21 08:06
--
---@class DamageOnContact : Component
---@field damageAmount number
---@field attacker BasicPawn | Pawn | Entity | table
--

return function(concord)
    concord.component("damageOnContact", function(c, damageAmount, attacker)
        c.damageAmount = damageAmount
        c.attacker     = attacker
    end)
end
