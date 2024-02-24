---@author Gage Henderson 2024-02-24 10:58
--
---@class Shadow : Component
--

return function(concord)
    concord.component("shadow", function(c, size)
        c.size = size or 25
    end)
end
