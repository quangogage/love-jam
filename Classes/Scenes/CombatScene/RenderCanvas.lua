---@author Gage Henderson 2024-02-22 09:12
--
-- Render all of the ecs game-world onto a canvas.
--
-- ╭─────────────────────────────────────────────────────────╮
-- │ TODO: Resize.                                           │
-- ╰─────────────────────────────────────────────────────────╯
--

---@class RenderCanvas
---@field canvas love.Canvas
local RenderCanvas = Goop.Class({})


----------------------------
-- [[ Public Functions ]] --
----------------------------
function RenderCanvas:startDrawing()
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear(0,0,0,0)
end
function RenderCanvas:stopDrawing()
    love.graphics.setCanvas()
end

--------------------------
-- [[ Core Functions ]] --
--------------------------
function RenderCanvas:init()
    self.canvas = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight())
end
function RenderCanvas:draw()
    love.graphics.setColor(1,1,1)
    love.graphics.draw(self.canvas, 0, 0)
end

return RenderCanvas
