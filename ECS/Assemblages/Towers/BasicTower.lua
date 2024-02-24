---@author Gage Henderson 2024-02-16 11:35
--
---@class BasicTower : Tower
---@field color Color
---@field renderRectangle RenderRectangle
---@field dimensions Dimensions
---@field pawnGeneration PawnGeneration

local TowerAssemblage = require('ECS.Assemblages.Towers.Tower')

return function (e, x, y, enemyType, spawnAmount)
    local color
    enemyType = enemyType or 'melee'
    spawnAmount = spawnAmount or 1
    console:log(spawnAmount)
    local pawnTypes = {}
    if enemyType == 'melee' then
        color = {1, 0, 0}
        pawnTypes = {'LilMeleeEnemy'}
    elseif enemyType == 'ranged' then
        color = {1, 0.45, 0.45}
        pawnTypes = {'RangedEnemy'}
    else
        color = {1, 0.45, 0}
        pawnTypes = {'RangedEnemy', 'LilMeleeEnemy'}
    end
    e
        :assemble(TowerAssemblage, x, y)
        :give('health', KNOBS.enemyTower.health)
        :give('color', color[1], color[2], color[3])
        :give('renderRectangle', 50, 100)
        :give('dimensions', 50, 100)
        :give('pawnGeneration', {
            pawnTypes = pawnTypes,
            spawnRate = KNOBS.enemyTower.spawnRate,
            spawnAmount = spawnAmount
        })
end
