---@author Gage Henderson 2024-02-15 12:20
--
---@class FinalOutputCanvas
-- Crude scaling.
---@field canvas love.Canvas
---@field resolution Vec2
---@field scale {x: number, y: number}
--

local Vec2 = require("Classes.Types.Vec2")

local FinalOutputCanvas = Goop.Class({
    static = {
        resolution = Vec2(1920, 1080),
        scale = Vec2(1, 1)
    }
})


----------------------------
-- [[ Public Functions ]] --
----------------------------
function FinalOutputCanvas:startDrawing()
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()
end

function FinalOutputCanvas:stopDrawing()
    love.graphics.setCanvas()
end

--------------------------
-- [[ Core Functions ]] --
--------------------------
function FinalOutputCanvas:init()
    self.canvas = love.graphics.newCanvas(self.resolution.x, self.resolution.y)
    self:_calculateScale()
end

function FinalOutputCanvas:draw()
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.canvas, 0, 0, 0, self.scale.x, self.scale.y)
    love.graphics.setBlendMode('alpha')
end

function FinalOutputCanvas:resize(w, h)
    self:_calculateScale(w, h)
end

-----------------------------
-- [[ Private Functions ]] --
-----------------------------
function FinalOutputCanvas:_calculateScale(w, h)
    w = w or love.graphics.getWidth()
    h = h or love.graphics.getHeight()
    self.scale = Vec2(w / self.resolution.x, h / self.resolution.y)
end

return FinalOutputCanvas
