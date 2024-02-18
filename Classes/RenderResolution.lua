---@author Gage Henderson 2024-02-18 14:32
--
-- Should be the final canvas before rendering to the screen.
--
-- Handles scaling things properly to fit different resolutions while
-- maintaining the aspect ratio.
--
-- Intended to be global.
--

local Vec2 = require("Classes.Types.Vec2")

---@class RenderResolution
---@field canvas love.Canvas
---@field scale number
---@field width number
---@field height number
local RenderResolution = Goop.Class({
    static = {
        width  = 1920,
        height = 1080,
        scale  = 1
    }
})


----------------------------
-- [[ Public Functions ]] --
----------------------------
function RenderResolution:startDrawing()
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()
end
function RenderResolution:stopDrawing()
    love.graphics.setCanvas()
end
---@return number, number
function RenderResolution:getMousePosition()
    local x,y = love.mouse.getPosition()
    return x / self.scale, y / self.scale
end

--------------------------
-- [[ Core Functions ]] --
--------------------------
function RenderResolution:init()
    self.canvas = love.graphics.newCanvas(self.width, self.height)
end
function RenderResolution:draw()
    local windowWidth, windowHeight = love.graphics.getDimensions()
    local canvasWidth, canvasHeight = self.canvas:getDimensions()
    local scale = math.min(windowWidth / canvasWidth, windowHeight / canvasHeight)
    local x = (windowWidth - (canvasWidth * scale)) / 2
    local y = (windowHeight - (canvasHeight * scale)) / 2

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.canvas, x, y, 0, self.scale, self.scale)

    self.scale = scale
end


return RenderResolution
