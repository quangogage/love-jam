---@author Gage Henderson 2024-02-20 04:57
--
---@class Knight : Pawn

local CharacterAssemblage = require('ECS.Assemblages.Pawns.Pawn')

---@param e Entity
---@param x number
---@param y number
---@param friendly boolean
---@param powerups table See PowerupStateManager / FriendlySpawnHandler...+more...
return function (e, x, y, friendly, powerups)
    e
        :assemble(CharacterAssemblage, x, y)
        :give('health', 5)
        :give('dimensions', 25, 50)
        :give('combatProperties', 'melee', {
            damageAmount = 1,
            attackSpeed = 1,
            range = 50
        })
        :give('pawnAnimations', 'knight')

    if friendly then
        e:give('friendly')
    else
        e:give('hostile')
    end

    if powerups then
        e:give('powerups', powerups)
    end
end
