---@author Gage Henderson 2024-02-20 04:57
--
---@class Knight : Pawn

local ANIMATION_FRAMERATE = 0.1
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
        :give('renderRectangle', 25, 50)
        :give('dimensions', 25, 50)
        :give('combatProperties', 'melee', {
            damageAmount = 1,
            attackSpeed = 1,
            range = 50
        })
        :give('pawnAnimations', {
            attack = {
                framerate = ANIMATION_FRAMERATE,
                up        = 'assets/images/knight/attack_up',
                down      = 'assets/images/knight/attack_down',
                left      = 'assets/images/knight/attack_left',
                right     = 'assets/images/knight/attack_right',
                downRight = 'assets/images/knight/attack_down_right',
                downLeft  = 'assets/images/knight/attack_down_left',
                upRight   = 'assets/images/knight/attack_up_right',
                upLeft    = 'assets/images/knight/attack_up_left',
            },
            walk = {
                framerate = ANIMATION_FRAMERATE,
                up        = 'assets/images/knight/walk_up',
                down      = 'assets/images/knight/walk_down',
                left      = 'assets/images/knight/walk_left',
                right     = 'assets/images/knight/walk_right',
                downRight = 'assets/images/knight/walk_down_right',
                downLeft  = 'assets/images/knight/walk_down_left',
                upRight   = 'assets/images/knight/walk_up_right',
                upLeft    = 'assets/images/knight/walk_up_left',
            },
        })

    if friendly then
        e:give('friendly')
        e:give('color', 1, 1, 1)
    else
        e:give('hostile')
        e:give('color', 1, 0.1, 0.1)
    end

    if powerups then
        e:give('powerups', powerups)
    end
end
