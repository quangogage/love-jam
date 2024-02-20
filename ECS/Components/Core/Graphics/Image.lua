---@author Gage Henderson 2024-02-20 05:16
--
---@class Image : Component
---@field value love.Image

return function(concord)
    concord.component('image', function(c, value)
        c.value = value
    end)
end
