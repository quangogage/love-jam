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
            idle = {
                framerate = ANIMATION_FRAMERATE,
                up        = 'assets/images/knight/idle_up',
                down      = 'assets/images/knight/idle_down',
                left      = 'assets/images/knight/idle_left',
                right     = 'assets/images/knight/idle_right',
                downRight = 'assets/images/knight/idle_down_right',
                downLeft  = 'assets/images/knight/idle_down_left',
                upRight   = 'assets/images/knight/idle_up_right',
                upLeft    = 'assets/images/knight/idle_up_left',
            }
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
