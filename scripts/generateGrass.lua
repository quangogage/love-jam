local util = require('util')({ 'entityAssembler' })

local MIN_GRASS = 3
local MAX_GRASS = 15

return function (world)
    local count = love.math.random(MIN_GRASS, MAX_GRASS)

    for _=1,count do
        util.entityAssembler.assemble(world, "Grass",
            love.math.random(world.bounds.x,world.bounds.x + world.bounds.width),
            love.math.random(world.bounds.y,world.bounds.y + world.bounds.height)
        )
    end
end
