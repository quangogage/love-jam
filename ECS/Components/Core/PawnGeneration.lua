---@author Gage Henderson 2024-02-17 03:52
--
---@class PawnGeneration : Component
-- To be used by towers to store information about the pawns they generate.
---@field pawnType string
---@field spawnRate number
---@field spawnTimer number

return function (concord)
    concord.component('pawnGeneration', function (c, data)
        data         = data or {}
        c.pawnType   = data.pawnType or 'BasicPawn'
        c.spawnRate  = data.spawnRate or 3
        c.spawnTimer = 0
    end)
end
