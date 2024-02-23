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
            attackSpeed  = KNOBS.meleeEnemy.attackSpeed,
            range        = KNOBS.meleeEnemy.range
        })
        :give('pawnAnimations', 'enemy_knight')
        :give('pushbackRadius', 35)
        :give('groundPosition', 0, 30)
        :give('coinValue', KNOBS.enemyCoinReward.meleeEnemy)
        :give('movement', {
            walkSpeed = KNOBS.meleeEnemy.walkSpeed
        })

    if friendly then
        e:give('friendly')
    else
        e:give('hostile')
    end

    if powerups then
        e:give('powerups', powerups)
    end
end
