---@author Gage Henderson 2024-02-18 09:15
--
-- Must have at least 3.
--
-- This table is mapped to a table for each pawn type in PowerupStateManager.
--
-- Whenever a pawn is created, it is given a deep copy of that table stored in
-- `pawn.powerups`.

local Powerup  = require("Classes.Types.Powerup")
return {
    Powerup({
        name = 'Fast Walker',
        description = 'Move 20% faster',

        ---@param self Powerup
        ---@param pawn BasicPawn | Pawn | table
        onPawnCreation = function (self, pawn)
            for _ = 1, self.count do
                pawn.movement.walkSpeed = pawn.movement.walkSpeed * 1.20
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
        getMultipliedValue = function (self, value)
            for i = 1, self.count do
                value = value * 1.15
            end
            return value
        end
    }),
    Powerup({
        name = 'Tough Skin',
        description = 'Take 15% less damage'
    })
}
