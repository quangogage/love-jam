---@author Gage Henderson 2024-02-20 04:57
--
---@class Knight : Pawn

local Vec2                = require("Classes.Types.Vec2")
local CharacterAssemblage = require('ECS.Assemblages.Pawns.Pawn')
local dimensions          = Vec2(40, 80)

-- ──────────────────────────────────────────────────────────────────────
local onSpawnSounds = {
    love.audio.newSource("assets/audio/sfx/knight-vox/1.wav", "static"),
    love.audio.newSource("assets/audio/sfx/knight-vox/2.wav", "static"),
    love.audio.newSource("assets/audio/sfx/knight-vox/3.wav", "static"),
    love.audio.newSource("assets/audio/sfx/knight-vox/4.wav", "static"),
    love.audio.newSource("assets/audio/sfx/knight-vox/5.wav", "static"),
    love.audio.newSource("assets/audio/sfx/knight-vox/6.wav", "static")
}
local pitch = 1.5
for _, sound in ipairs(onSpawnSounds) do
    sound:setVolume(settings:getVolume("sfx"))
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
        :give('health', 5)
        :give('dimensions', dimensions.width, dimensions.height)
        :give('combatProperties', 'melee', {
            damageAmount = 1,
            attackSpeed = 1,
            range = 75
        })
        :give('pawnAnimations', 'knight')
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
    sound:play()
end
