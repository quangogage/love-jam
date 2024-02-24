---@author Gage Henderson 2024-02-24 10:28
--
---@class Text : Component
---@field value string
---@field font love.Font
--


local fallbackFont = love.graphics.newFont(fonts.speechBubble, 26)

return function(concord)
    concord.component("text", function(c, value, font)
        c.value = value
        c.font = font or fallbackFont
    end)
end
