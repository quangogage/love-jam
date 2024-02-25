---@author Gage Henderson 2024-02-24 17:46
--
---@class CommandIcon : Entity
-- Should briefly appear where you command.
--

local images = {
    position = love.graphics.newImage('assets/images/icons/crosshair_1.png'),
    entity = love.graphics.newImage('assets/images/icons/crosshair_2.png'),
}

return function(e, x, y, image)
    e
        :give('position',x,y)
        :give("alpha",1)
        :give('image', image == "position" and images.position or images.entity)
        :give('fadeOut')
        :give('drawOnTop')
end
