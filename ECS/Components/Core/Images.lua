---@author Gage Henderson 2024-02-24 08:48
--
---@class Images : Component
-- Used to store images, shouldn't be used directly.
--

-- data = {
--     imageKey = love.graphics.newImage('path/to/image.png'),
--     imageKey2 = love.graphics.newImage('path/to/image2.png'),
-- }
-- c['imageKey']
return function(concord)
    concord.component('images', function(c, data)
        for k, v in pairs(data) do
            c[k] = v
        end
    end)
end
