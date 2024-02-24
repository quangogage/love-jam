---@author Gage Henderson 2024-02-24 12:50
--
---@class Grass : Entity
--

local images = {
    love.graphics.newImage('assets/images/env/grass_1.png'),
    love.graphics.newImage('assets/images/env/grass_2.png'),
    love.graphics.newImage('assets/images/env/grass_3.png'),
    love.graphics.newImage('assets/images/env/grass_4.png'),
}

return function(e, x, y)
    local image = images[love.math.random(1, #images)]
    e
        :give("position", x, y)
        :give("image", images[love.math.random(1, #images)])
        :give('dimensions',image:getWidth(),image:getHeight())
        :give('image',image)
        :give('unselectable')
end
