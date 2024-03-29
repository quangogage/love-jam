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

local util = require("util")({ 'entityAssembler' })
local Powerup = require('Classes.Types.Powerup')

return {
    Powerup({
        -- Applied in PowerupSetupSystem.
        name = 'Fast Walker',
        description = 'Move 15% faster',
        image = love.graphics.newImage("assets/images/icon/increase_speed.png"),
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
        description = 'Deal 10% more damage',
        image = love.graphics.newImage("assets/images/icon/increase_damage.png"),
        ---@param self Powerup
        ---@param value number
        getValue = function (self, value)
            local multiplier = 1 + (self.count * 0.10)
            return value * multiplier
        end
    }),
    Powerup({
        -- Applied in PowerupSetupSystem.
        name = 'Shield of Fortitude',
        description = 'Take 10% less damage',
        image = love.graphics.newImage("assets/images/icon/shield_of_fortitude.png"),
        ---@param self Powerup
        ---@param pawn BasicPawn | Pawn | table
        onPawnCreation = function (self, pawn)
            for _ = 1, self.count do
                pawn.armor.value = math.min(0.9, pawn.armor.value + 0.10)
            end
        end
    }),
    Powerup({
        name = "Fortified Fate",
        description = "+10% Chance when spawned to have double health",
        image = love.graphics.newImage("assets/images/icon/foritified_fate.png"),
        ---@param self Powerup
        ---@param pawn BasicPawn | Pawn | table
        onPawnCreation = function (self, pawn)
            local chance = 0.10 * self.count
            if math.random() < chance then
                local color = pawn:get("friendly") and {0, 1, 0} or {1, 0, 0}
                pawn.health.value = pawn.health.value * 2
                pawn.health.max = pawn.health.max * 2
                util.entityAssembler.assemble(pawn:getWorld(), 'FadingText', 'Fortified Fate:\nDouble Health!', pawn.position.x, pawn.position.y, color)
            end
        end
    }),
    Powerup({
        name = "Fateful Fury",
        description = "+10% Chance when spawned to deal double damage",
        image = love.graphics.newImage("assets/images/icon/fateful_fury.png"),
        ---@param self Powerup
        ---@param pawn BasicPawn | Pawn | table
        onPawnCreation = function (self, pawn)
            local chance = 0.1 * self.count
            if math.random() < chance then
                local color = pawn:get("friendly") and {0, 1, 0} or {1, 0, 0}
                pawn.combatProperties.damageAmount = pawn.combatProperties.damageAmount * 2
                util.entityAssembler.assemble(pawn:getWorld(), 'FadingText', 'Fateful Fury:\nDouble damage!', pawn.position.x, pawn.position.y, color)
            end
        end
    }),
    Powerup({
        -- Applied in PawnAttackSystem
        name = 'Quickening Quiver',
        description = 'Attack 15% faster',
        image = love.graphics.newImage("assets/images/icon/quiver_agile.png"),
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
        description = '+10% Chance to immediately respawn at your base upon death.',
        image = love.graphics.newImage("assets/images/icon/soul_renewal.png"),
        ---@param self Powerup
        getValue = function (self)
            -- See DamageSystem.
            return math.min(0.9,0.1 * self.count) -- 10% chance per-stack.
        end,
    }),
    -- Powerup({
    --     -- Applied in DamageSystem (see DamageSystem.update).
    --     name = "Shattering Impact",
    --     description = "Knockback enemies on hit",
    --     ---@param self Powerup
    --     ---@param successfulAttack SuccessfulAttack
    --     onSuccessfulAttack = function (self, successfulAttack)
    --         local force = 150 * self.count
    --         local dir = successfulAttack.direction
    --         local target = successfulAttack.target
    --         if target:get("physics") then
    --             target.physics.velocity.x = target.physics.velocity.x + math.cos(dir) * force
    --             target.physics.velocity.y = target.physics.velocity.y + math.sin(dir) * force
    --         end
    --     end
    -- }),
    Powerup({
        -- Applied in DamageSystem
        name = "Shadow's Touch",
        description = "+0.35% chance to instantly kill a target when you attack them.",
        image = love.graphics.newImage("assets/images/icon/shadows_touch.png"),
        ---@param self Powerup
        ---@return number
        getValue = function (self)
            return math.min(0.9,self.count * 0.0035)
        end
    }),
}
