---@author Gage Henderson 2024-02-23 14:38
--
---@class Cursor
-- Intended to be global.
-- Make adjustments n stuff to the cursor easily.
--

local Cursor = Goop.Class({
    dynamic = {
        cursors = {
            hand = love.mouse.getSystemCursor('hand'),
            arrow = love.mouse.getSystemCursor('arrow'),
        }
    }
})


----------------------------
-- [[ Public Functions ]] --
----------------------------
---@param cursor string
function Cursor:set(cursor)
    love.mouse.setCursor(self.cursors[cursor])
end


--------------------------
-- [[ Core Functions ]] --
--------------------------
function Cursor:init()
    self:set('arrow')
end

return Cursor
