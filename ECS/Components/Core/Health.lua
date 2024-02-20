---@author Gage Henderson 2024-02-16 06:06
--
---@class Health : Component
---@field value number
---@field max number
---@field bar table Various information about displaying a health bar.
---@field mostRecentDamage SuccessfulAttack Used in DamageSystem.

return function (concord)
    concord.component('health', function (c, max)
        c.max   = max or 100
        c.value = c.max
        c.bar   = {
            -- How long to display the health bar after taking damage.
            duration = 2.5,
            timer    = 0,
            hidden   = true
        }
    end)
end
