---@author Gage Henderson 2024-02-16 05:16
--
---@class Alpha : Component
-- Alpha / opacity
---@field value number
--

return function(concord)
    concord.component('alpha', function(c, value)
        c.value = value or 1
    end)
end
