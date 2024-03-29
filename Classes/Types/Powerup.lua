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
        count = 0,
        hostileCount = 0,
        -- Default image.
        image = love.graphics.newImage("assets/images/icon/fateful_fury.png")
    }
})

---@param pawn BasicPawn | Pawn | table
function Powerup:onPawnCreation(pawn)
end
---@param value number
---@return number
function Powerup:getMultipliedValue(value)
    return value
end
---@param pawn BasicPawn | Pawn | table
function Powerup:onPawnDeath(pawn)
end
---@param successfulAttack SuccessfulAttack
function Powerup:onSuccessfulAttack(successfulAttack)
end
return Powerup
