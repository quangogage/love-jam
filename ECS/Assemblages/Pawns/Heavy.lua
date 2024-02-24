---@author Gage Henderson 2024-02-22 10:15
--
---@class Heavy : Pawn
--

local Vec2                = require('Classes.Types.Vec2')
local CharacterAssemblage = require('ECS.Assemblages.Pawns.Pawn')
local dimensions          = Vec2(60, 110)
local scale               = Vec2(1.2,1.2)

-- ──────────────────────────────────────────────────────────────────────
local onSpawnSounds       = {
    love.audio.newSource('assets/audio/sfx/knight-vox/1.mp3', 'static'),
    love.audio.newSource('assets/audio/sfx/knight-vox/2.mp3', 'static'),
    love.audio.newSource('assets/audio/sfx/knight-vox/3.mp3', 'static'),
    love.audio.newSource('assets/audio/sfx/knight-vox/4.mp3', 'static'),
    love.audio.newSource('assets/audio/sfx/knight-vox/5.mp3', 'static'),
    love.audio.newSource('assets/audio/sfx/knight-vox/6.mp3', 'static')
}
local pitch               = 0.7
for _, sound in ipairs(onSpawnSounds) do
    sound:setVolume(settings:getVolume('sfx'))
    sound:setPitch(pitch)
end
-- ──────────────────────────────────────────────────────────────────────

---@param e Heavy
---@param x number
---@param y number
---@param friendly boolean
---@param powerups table See PowerupStateManager / FriendlySpawnHandler...+more...
return function (e, x, y, friendly, powerups)
    e
        :assemble(CharacterAssemblage, x, y)
        :give('health', KNOBS.heavy.health)
        :give('dimensions', dimensions.x, dimensions.y)
        :give('combatProperties', 'melee', {
            damageAmount = KNOBS.heavy.damageAmount,
            attackSpeed = KNOBS.heavy.attackSpeed,
            range = KNOBS.heavy.range
        })
        :give('pawnAnimations', 'heavy')
        :give('pushbackRadius', 45)
        :give('groundPosition', 0, 20)
        :give('scale', scale.x, scale.y)
        :give("movement", {
            walkSpeed = KNOBS.heavy.walkSpeed
        })

    if friendly then
        e:give('friendly')
    else
        e:give('hostile')
    end

    if powerups then
        e:give('powerups', powerups)
    end

    local sound = onSpawnSounds[math.random(1, #onSpawnSounds)]
    if sound:isPlaying() then
        sound = sound:clone()
    end
    sound:play()

end
