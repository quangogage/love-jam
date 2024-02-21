---@author Gage Henderson 2024-02-18 09:15
--
-- Must have at least 3.
--
-- This table is mapped to a table for each pawn type in PowerupStateManager.
--
-- Whenever a pawn is created, it is given a deep copy of that table stored in
-- `pawn.powerups`.
--
-- That means even if the pawn has no powerups this table will still be present
-- and the callback functions will still be called.
-- (Although, as of right now only friendly pawns have powerups.)
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
--
-- For example, a permanent damage increase powerup should not be applied
-- when attacking - But immediately before subtracting that damage amount
-- from the target's health.

local util    = require('util')({ 'entityAssembler', 'table' })
local Concord = require('libs.concord')
local Powerup = require('Classes.Types.Powerup')

return {
    Powerup({
        -- Applied in PowerupSetupSystem.
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
        -- Applied in DamageSystem.
        name = 'Bloodlust',
        description = 'Deal 15% more damage',
        ---@param self Powerup
        ---@param value number
        getValue = function (self, value)
            local multiplier = 1 + (self.count * 0.15)
            return value * multiplier
        end
    }),
    Powerup({
        -- Applied in PowerupSetupSystem.
        name = 'Shield of Fortitude',
        description = 'Take 15% less damage',
        ---@param self Powerup
        ---@param pawn BasicPawn | Pawn | table
        onPawnCreation = function (self, pawn)
            for _ = 1, self.count do
                pawn.armor.value = math.min(1, pawn.armor.value + 0.15)
            end
        end
    }),
    Powerup({
        -- Applied in PawnAttackSystem
        name = 'Quickening Quiver',
        description = 'Attack 15% faster',
        ---@param self Powerup
        ---@param value number
        getValue = function (self, value)
            local stacks = 1 - (self.count * 0.15)
            return value * stacks
        end
    }),
    Powerup({
        -- Applied in DamageSystem (see DamageSystem.update).
        name = 'Soul Renewal',
        description = 'Chance to immediately respawn at your base upon death.',
        ---@param self Powerup
        getValue = function (self)
            -- See DamageSystem.
            return 0.1 * self.count -- 10% chance per-stack.
        end,
    }),
    Powerup({
        -- Applied in DamageSystem (see DamageSystem.update).
        name = "Shattering Impact",
        description = "Knockback enemies on hit",
        ---@param self Powerup
        ---@param successfulAttack SuccessfulAttack
        onSuccessfulAttack = function (self, successfulAttack)
            local force = 150 * self.count
            local dir = successfulAttack.direction
            local target = successfulAttack.target
            if target:get("physics") then
                target.physics.velocity.x = target.physics.velocity.x + math.cos(dir) * force
                target.physics.velocity.y = target.physics.velocity.y + math.sin(dir) * force
            end
        end
    })
}
