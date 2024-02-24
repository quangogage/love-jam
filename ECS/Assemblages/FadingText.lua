---@author Gage Henderson 2024-02-24 10:25
--
---@class FadingText : Entity
--


return function(e, text, x, y, color)
    local color = color or {1, 1, 1, 1}
    e
        :give('position', x, y)
        :give("text", text)
        :give("color", color[1], color[2], color[3])
        :give("alpha", 1)
        :give("isFadingText")
end
