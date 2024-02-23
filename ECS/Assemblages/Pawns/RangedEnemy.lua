---@author Gage Henderson 2024-02-22 17:05
--
---@class RangedEnemy : Pawn
--

local Vec2                = require('Classes.Types.Vec2')
local CharacterAssemblage = require('ECS.Assemblages.Pawns.Pawn')
local dimensions          = Vec2(40, 80)

local attackSounds        = {
    love.audio.newSource('assets/audio/sfx/attacks/archer/1.wav', 'static'),
}
for _, sound in ipairs(attackSounds) do
    sound:setVolume(settings:getVolume('sfx'))
end

---@param e Archer
---@param x number
---@param y number
---@param friendly boolean
---@param powerups table See PowerupStateManager / FriendlySpawnHandler...+more...
return function (e, x, y, friendly, powerups)
    e
        :assemble(CharacterAssemblage, x, y)
        :give('health', KNOBS.rangedEnemy.health)
        :give('dimensions', dimensions.width, dimensions.height)
        :give('combatProperties', 'bow', {
            damageAmount = KNOBS.rangedEnemy.damageAmount,
            attackSpeed  = KNOBS.rangedEnemy.attackSpeed,
            range        = KNOBS.rangedEnemy.range,
            sounds       = attackSounds
        })
    -- :give('pawnAnimations', 'rangedEnemy')
        :give('renderRectangle', dimensions.width, dimensions.height)
        :give("color", 1, 0.5, 0.3)
        :give('pushbackRadius', 35)
        :give('groundPosition', 0, 30)
        :give('movement', {
            walkSpeed = KNOBS.rangedEnemy.walkSpeed
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
