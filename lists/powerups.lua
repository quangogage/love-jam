---@author Gage Henderson 2024-02-18 09:15
--
-- Must have at least 3.
--
-- This table is mapped to a table for each pawn type in PowerupStateManager.
--
-- Whenever a pawn is created, it is given a deep copy of that table stored in
-- `pawn.powerups`.
--
-- ──────────────────────────────────────────────────────────────────────
-- Powerups will continue to require some level of bespoke behavior no matter
-- how hard you try to abstract things.
--
--
-- One rule of thumb I'd like to follow for this project:
--
-- ╭─────────────────────────────────────────────────────────╮
-- │ Apply the powerups as close to their actual effect as   │
-- │ possible.                                               │
-- ╰─────────────────────────────────────────────────────────╯
-- For example, a permanent damage increase powerup should not be applied
-- when attacking - But immediately before subtracting that damage amount
-- from the target's health.

local Powerup  = require("Classes.Types.Powerup")
return {
    Powerup({
        name = 'Fast Walker',
        description = 'Move 15% faster',

        ---@param self Powerup
        ---@param pawn BasicPawn | Pawn | table
        onPawnCreation = function (self, pawn)
            pawn:ensure('movement')
            for _ = 1, self.count do
                pawn.movement.walkSpeed = pawn.movement.walkSpeed * 1.15
            end
        end
    }),
    Powerup({
        name = 'Bloodlust',
        description = 'Deal 15% more damage',

        -- Keep this powerup behavior somewhat ambiguous so it can be applied
        -- to different things in the future...
        ---@param self Powerup
        ---@param value number
        getValue = function (self, value)
            local multiplier = 1 + (self.count * 0.15)
            return value * multiplier
        end
    }),
    Powerup({
        name = 'Shield of Fortitude',
        description = 'Take 15% less damage',
        onPawnCreation = function(self, pawn)
            pawn:ensure('armor')
            for _ = 1, self.count do
                pawn.armor.value = pawn.armor.value + 0.15
            end
        end
    }),
    Powerup({
        name = "Quickening Quiver",
        description = "Attack 15% faster",
        getValue = function(self, value)
            local stacks = 1 - (self.count * 0.15)
            return value * stacks
        end
    })
}
