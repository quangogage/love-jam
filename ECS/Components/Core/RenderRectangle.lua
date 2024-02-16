---@author Gage Henderson 2024-02-16 05:10
--
---@class RenderRectangle : Component
-- Pretty limited component. Render a rectangle, origin at center.
---@field width number
---@field height number

return function (concord)
    concord.component('renderRectangle', function (c, width, height)
        c.width = width
        c.height = height
    end)
end
