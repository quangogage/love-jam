---@author Gage Henderson 2024-02-22 16:49
--
---@class LilMeleeEnemy : Pawn
--

local Vec2                = require('Classes.Types.Vec2')
local CharacterAssemblage = require('ECS.Assemblages.Pawns.Pawn')
local dimensions          = Vec2(40, 80)

---@param e LilMeleeEnemy
---@param x number
---@param y number
---@param friendly boolean
---@param powerups table See PowerupStateManager / FriendlySpawnHandler...+more...
return function (e, x, y, friendly, powerups)
    e
        :assemble(CharacterAssemblage, x, y)
        :give('health', KNOBS.meleeEnemy.health)
        :give('dimensions', dimensions.width, dimensions.height)
        :give('combatProperties', 'melee', {
            damageAmount = KNOBS.meleeEnemy.damageAmount,
            attackSpeed = KNOBS.meleeEnemy.attackSpeed,
            range = KNOBS.meleeEnemy.range
        })
        --:give('pawnAnimations', 'knight')
        :give("renderRectangle", dimensions.width, dimensions.height)
        :give("color", 1, 0, 0)
        :give('pushbackRadius', 35)
        :give('groundPosition', 0, 30)
        :give('coinValue', KNOBS.enemyCoinReward.meleeEnemy)

    if friendly then
        e:give('friendly')
    else
        e:give('hostile')
    end

    if powerups then
        e:give('powerups', powerups)
    end

    if friendly then
        local sound = onSpawnSounds[math.random(1, #onSpawnSounds)]
        if sound:isPlaying() then
            sound = sound:clone()
        end
        sound:play()
    end
end
