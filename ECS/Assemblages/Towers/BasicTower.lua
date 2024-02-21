---@author Gage Henderson 2024-02-16 11:35
--
---@class BasicTower : Tower
---@field color Color
---@field renderRectangle RenderRectangle
---@field dimensions Dimensions
---@field pawnGeneration PawnGeneration

local TowerAssemblage = require('ECS.Assemblages.Towers.Tower')

return function (e, x, y)
    e
        :assemble(TowerAssemblage, x, y)
        :give('health', 20)
        :give('color', 1, 0, 0)
        :give('renderRectangle', 50, 100)
        :give('dimensions', 50, 100)
        :give('pawnGeneration', {
            pawnType = 'Knight',
            spawnRate = 10,
        })
end
