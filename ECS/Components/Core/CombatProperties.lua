---@author Gage Henderson 2024-02-16 15:16
--
---@class CombatProperties : Component
-- Describe how a pawn should behave in combat.
---@field type "melee" | "bullet" | "missile" etc.
---@field damageAmount number
---@field attackSpeed number
---@field attackTimer number
---@field range number

return function(concord)
    ---@param c CombatProperties
    ---@param type "melee" | "bullet" | "missile" etc.
    ---@param data table
    concord.component("combatProperties", function(c, type, data)
        c.type          = type or "melee"
        c.damageAmount  = data.damageAmount or 1
        c.attackSpeed   = data.attackSpeed or 0.5
        c.attackTimer   = 0
        c.range         = data.range or 150
    end)
end
