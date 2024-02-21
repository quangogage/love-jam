---@author Gage Henderson 2024-02-16 15:16
--
---@class CombatProperties : Component
-- Describe how a pawn should behave in combat.
---@field type "melee" | "bullet" | "missile" etc.
---@field damageAmount number
---@field attackSpeed number
---@field attackTimer number
---@field range number
---@field attackSpawnDistance number How far away from our entity should we spawn the attack?
---@field meleeHitboxSize number
---@field sounds love.Source[]

return function (concord)
    ---@param c CombatProperties
    ---@param type "melee" | "bullet" | "missile" etc.
    ---@param data table
    concord.component('combatProperties', function (c, type, data)
        c.type                = type or 'melee'
        c.damageAmount        = data.damageAmount or 1
        c.attackSpeed         = data.attackSpeed or 1
        c.attackTimer         = 0
        c.range               = data.range or 150
        c.attackSpawnDistance = data.attackSpawnDistance or 30
        c.meleeHitboxSize     = data.meleeHitboxSize or 30
        -- Default to sword sounds.
        c.sounds              = data.sounds or {
            love.audio.newSource('assets/audio/sfx/attacks/sword-slash-1.wav', 'static'),
            love.audio.newSource('assets/audio/sfx/attacks/sword-slash-2.wav', 'static'),
            love.audio.newSource('assets/audio/sfx/attacks/sword-slash-3.wav', 'static'),
            love.audio.newSource('assets/audio/sfx/attacks/sword-slash-4.wav', 'static')
        }
        for _, sound in pairs(c.sounds) do
            sound:setVolume(settings:getVolume("sfx") * 0.7)
        end
    end)
end
