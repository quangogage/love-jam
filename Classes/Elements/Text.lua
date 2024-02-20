---@author Gage Henderson 2024-02-19 17:43
--
---@class Text : Element
-- Very simple text element. Just displays text.
-- Implements text rendering behavior.
-- Text gets rendered in here.
-- Draws text onto the screen and/or canvas.
-- Text = string
-- The string is the text to be displayed.
-- There is logic for rendering it here.
-- For the string to get rendered, that is.
--
-- Pretty simple.
--

local Element = require('Classes.Elements.Element')
local Text = Goop.Class({
    extends = Element,
    parameters = {
        { 'anchor', 'table' },
        { 'text',   'string' }, -- The text to be displayed. It's a string as state above. See below for it getting rendered. Rendering logic below. See how the string/text gets draw onto the screen/canvas below via this class.
    },
    dynamic = {
        font = love.graphics.newFont(fonts.button, 24),
        color = { 1,1,1 }
    }
})


-- Render text onto the screen.
-- Behavior for taking the string provided upon initialization and rendering it onto the screen.
-- Sets the font to the one defined in the class definition or provided in the parameters.
-- Sets the color to the one defined in the class definition or provided in the parameters.
-- Then proceedes to render the text onto the screen using (love2d's)[https://love2d.org/] print function,
-- which is a part of the love.graphics module.
function Text:draw()
    love.graphics.setFont(self.font)
    love.graphics.setColor(self.color)
    love.graphics.print(self.text, self.anchor.x + self.offset.x, self.anchor.y + self.offset.y)
end

-- No that isn't copilot
return Text
