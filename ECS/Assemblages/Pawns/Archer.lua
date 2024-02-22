---@author Gage Henderson 2024-02-21 07:40
--
---@class Archer : Pawn
--

local Vec2                = require("Classes.Types.Vec2")
local CharacterAssemblage = require('ECS.Assemblages.Pawns.Pawn')
local dimensions          = Vec2(40, 80)

-- ──────────────────────────────────────────────────────────────────────
local onSpawnSounds = {
    love.audio.newSource("assets/audio/sfx/knight-vox/1.mp3", "static"),
    love.audio.newSource("assets/audio/sfx/knight-vox/2.mp3", "static"),
    love.audio.newSource("assets/audio/sfx/knight-vox/3.mp3", "static"),
    love.audio.newSource("assets/audio/sfx/knight-vox/4.mp3", "static"),
    love.audio.newSource("assets/audio/sfx/knight-vox/5.mp3", "static"),
    love.audio.newSource("assets/audio/sfx/knight-vox/6.mp3", "static")
}
local pitch = 1.5
for _, sound in ipairs(onSpawnSounds) do
    sound:setVolume(settings:getVolume("sfx"))
    sound:setPitch(pitch)
end
-- ──────────────────────────────────────────────────────────────────────
local attackSounds = {
    love.audio.newSource("assets/audio/sfx/attacks/archer/1.wav", "static"),
}
for _, sound in ipairs(attackSounds) do
    sound:setVolume(settings:getVolume("sfx"))
end

---@param e Archer
---@param x number
---@param y number
---@param friendly boolean
---@param powerups table See PowerupStateManager / FriendlySpawnHandler...+more...
return function (e, x, y, friendly, powerups)
    e
        :assemble(CharacterAssemblage, x, y)
        :give('health', 7)
        :give('dimensions', dimensions.width, dimensions.height)
        :give('combatProperties', 'bow', {
            damageAmount = 1,
            attackSpeed  = 1.2,
            range        = 420.69,
            sounds       = attackSounds
        })
        :give('pawnAnimations', 'archer')
        :give('pushbackRadius', 35)
        :give('groundPosition',0,30)

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
