---@author Gage Henderson 2024-02-16 11:35
--
---@class BasicTower : Tower
---@field color Color
---@field renderRectangle RenderRectangle
---@field dimensions Dimensions
---@field pawnGeneration PawnGeneration

local TowerAssemblage = require('ECS.Assemblages.Towers.Tower')

local imageSets = {
    melee = {
        idle = love.graphics.newImage("assets/images/tower/tower_sm/idle.png"),
        dead = love.graphics.newImage("assets/images/tower/tower_sm/dead.png"),
        damage = {
            love.graphics.newImage("assets/images/tower/tower_sm/damage/1.png"),
            love.graphics.newImage("assets/images/tower/tower_sm/damage/2.png"),
            love.graphics.newImage("assets/images/tower/tower_sm/damage/3.png"),
            love.graphics.newImage("assets/images/tower/tower_sm/damage/4.png"),
        }
    },
    ranged = {
        idle = love.graphics.newImage("assets/images/tower/tower_md/idle.png"),
        dead = love.graphics.newImage("assets/images/tower/tower_md/dead.png"),
        damage = {
            love.graphics.newImage("assets/images/tower/tower_md/damage/1.png"),
            love.graphics.newImage("assets/images/tower/tower_md/damage/2.png"),
            love.graphics.newImage("assets/images/tower/tower_md/damage/3.png"),
            love.graphics.newImage("assets/images/tower/tower_md/damage/4.png"),
        }
    }
}

return function (e, x, y, enemyType, spawnAmount)
    local imageSet
    local collisionRadius = 105
    enemyType = enemyType or 'melee'
    spawnAmount = spawnAmount or 1
    local pawnTypes = {}
    if enemyType == 'melee' then
        pawnTypes = {'LilMeleeEnemy'}
        imageSet = imageSets.melee
    elseif enemyType == 'ranged' then
        pawnTypes = {'RangedEnemy'}
        imageSet = imageSets.ranged
        collisionRadius = 134
    else
        pawnTypes = {'RangedEnemy', 'LilMeleeEnemy'}
        imageSet = imageSets.ranged
        collisionRadius = 134
    end
    e
        :assemble(TowerAssemblage, x, y)
        :give('health', KNOBS.enemyTower.health)
        :give('dimensions', 170, 310, nil, 0, 80)
        :give('images', imageSet)
        :give('image',imageSet.idle)
        :give("collision", {radius = collisionRadius})
        :give('pawnGeneration', {
            pawnTypes = pawnTypes,
            spawnRate = KNOBS.enemyTower.spawnRate,
            spawnAmount = spawnAmount
        })
end
