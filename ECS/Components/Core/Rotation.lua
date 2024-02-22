---@author Gage Henderson 2024-02-21 18:26
--
---@class Rotation : Component
-- How did I get this far into the game without a rotation component?
---@field value number
--

return function(concord)
    concord.component('rotation', function(c, value)
        c.value = value
    end)
end
