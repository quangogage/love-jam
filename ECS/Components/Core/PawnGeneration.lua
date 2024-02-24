---@author Gage Henderson 2024-02-17 03:52
--
---@class PawnGeneration : Component
-- To be used by towers to store information about the pawns they generate.
-- See `ECS.Systems.PawnGenerationSystem` for more info.
---@field pawnTypes string[]
---@field spawnRate number
---@field spawnTimer number

return function (concord)
    concord.component('pawnGeneration', function (c, data)
        data         = data or {}
        c.pawnTypes   = data.pawnTypes or {'BasicPawn'}
        c.spawnAmount = data.spawnAmount or 1
        c.spawnRate  = data.spawnRate or 4
        c.spawnTimer = 0

    end)
end
