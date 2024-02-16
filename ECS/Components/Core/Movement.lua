---@author Gage Henderson 2024-02-16 07:14
--
---@class Movement : Component
---@field walkSpeed number
--

return function (concord)
    concord.component("movement", function(c, data)
        c.walkSpeed = data.walkSpeed or 100
    end)
end
