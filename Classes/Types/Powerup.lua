---@author Gage Henderson 2024-02-18 20:08
--
---@class Powerup
-- Basic info and *extremely* basic behavior for a powerup.
---@field name string
---@field description string
---@field count integer

local Powerup = Goop.Class({
    parameters = {
        {'name', 'string'},
        {'description', 'string'},
    },
    dynamic = {
        count = 0
    }
})

function Powerup:onPawnCreation(pawn)
end
return Powerup
