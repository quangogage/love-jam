---@author Gage Henderson 2024-02-20 04:57
--
---@class Knight : Pawn


local Vec2                = require('Classes.Types.Vec2')
local CharacterAssemblage = require('ECS.Assemblages.Pawns.Pawn')
local dimensions          = Vec2(40, 80)

-- ──────────────────────────────────────────────────────────────────────
local onSpawnSounds       = {
    love.audio.newSource('assets/audio/sfx/knight-vox/1.mp3', 'static'),
    love.audio.newSource('assets/audio/sfx/knight-vox/2.mp3', 'static'),
    love.audio.newSource('assets/audio/sfx/knight-vox/3.mp3', 'static'),
    love.audio.newSource('assets/audio/sfx/knight-vox/4.mp3', 'static'),
    love.audio.newSource('assets/audio/sfx/knight-vox/5.mp3', 'static'),
    love.audio.newSource('assets/audio/sfx/knight-vox/6.mp3', 'static')
}
local pitch               = 1.5
for _, sound in ipairs(onSpawnSounds) do
    sound:setVolume(settings:getVolume('interface') * 0.6)
    sound:setPitch(pitch)
end

-- ──────────────────────────────────────────────────────────────────────

---@param e Entity
---@param x number
---@param y number
---@param friendly boolean
---@param powerups table See PowerupStateManager / FriendlySpawnHandler...+more...
return function (e, x, y, friendly, powerups)
    e
        :assemble(CharacterAssemblage, x, y)
        :give('health', KNOBS.knight.health)
        :give('dimensions', dimensions.width, dimensions.height)
        :give('combatProperties', 'melee', {
            damageAmount = KNOBS.knight.damageAmount,
            attackSpeed = KNOBS.knight.attackSpeed,
            range = KNOBS.knight.range
        })
        :give('pawnAnimations', 'knight')
        :give('pushbackRadius', 35)
        :give('groundPosition', 0, 20)
        :give("movement", {
            walkSpeed = KNOBS.knight.walkSpeed
        })

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
