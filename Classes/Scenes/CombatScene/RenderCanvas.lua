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
---@field shader love.Shader
---@field distortionAmount number
---@field refractionAmount number
---@field zoomFactor number
local RenderCanvas = Goop.Class({
    dynamic = {
        shader = love.graphics.newShader(require("shaders.ballShader")),
        distortionAmount = 0,
        refractionAmount = 0,
        zoomFactor = 1
    }
})

----------------------------
-- [[ Public Functions ]] --
----------------------------
function RenderCanvas:startDrawing()
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear(0, 0, 0, 0)
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
function RenderCanvas:update(dt)
    self.shader:send("distortionAmount", self.distortionAmount)
    self.shader:send("refractionAmount", self.refractionAmount)
    self.shader:send("zoomFactor", self.zoomFactor)
end
function RenderCanvas:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setShader(self.shader)
    love.graphics.draw(self.canvas, 0, 0)
    love.graphics.setShader()
end

return RenderCanvas
