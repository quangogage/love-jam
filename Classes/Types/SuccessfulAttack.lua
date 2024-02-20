---@author Gage Henderson 2024-02-19 15:50
--
---@class SuccessfulAttack
---@field attacker BasicPawn | table
---@field target BasicPawn | table
---@field damageAmount number
---@field direction number

return Goop.Class({
    parameters = {
        { 'attacker',  'table' },
        { 'target',    'table' },
        { 'damage',    'number' },
        { 'direction', 'number' },
    }
})
