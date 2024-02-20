---@author Gage Henderson 2023-10-26 21:58
---
---@class ConsoleMessages
-- Handles logic for and renders messages outputted by the console.
---
-- Does not handle any user input.
---
---@field messages table<string> - The messages to be displayed.
---@field font love.Font
---@field color table<number>
---@field alpha number
---@field leftPadding number
---@field bottomPadding number
---@field fadeTimer number
---@field fadeWaitTime number
---@field fadeSpeed number
---
local ConsoleMessages = Goop.Class({
    dynamic = {
        messages      = {},
        font          = love.graphics.newFont(12),
        color     = {1,1,1},
        alpha         = 1,
        leftPadding   = 15,
        bottomPadding = 150,
        fadeTimer     = 0,
        fadeWaitTime  = 5,
        fadeSpeed     = 1
    }
})


----------------------------
-- [[ Public Functions ]] --
----------------------------
-- Adds a message.
---@param message string
function ConsoleMessages:addMessage(message)
    table.insert(self.messages, 1, message)
end

--------------------------
-- [[ Core Functions ]] --
--------------------------
function ConsoleMessages:update(dt)
end
function ConsoleMessages:draw()
    local x       = self.leftPadding
    local originY = love.graphics.getHeight() - self.bottomPadding
    love.graphics.setColor(self.color[1],self.color[2],self.color[3],self.alpha)
    love.graphics.setFont(self.font)
    for i=#self.messages,1,-1 do
        local text = self.messages[i]
        local y = originY - (self.font:getHeight() * (i-1))
        love.graphics.print(text, x, y)
    end
end

return ConsoleMessages
