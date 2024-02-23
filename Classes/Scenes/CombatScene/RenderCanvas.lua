---@author Gage Henderson 2024-02-22 09:12
--
-- Render all of the ecs game-world onto a canvas.
--
-- ╭─────────────────────────────────────────────────────────╮
-- │ TODO: Resize.                                           │
-- ╰─────────────────────────────────────────────────────────╯
--

local Vec2 = require('Classes.Types.Vec2')

---@class RenderCanvas
---@field canvas love.Canvas
---@field shader love.Shader
---@field distortionAmount number
---@field refractionAmount number
---@field zoomFactor number
---@field scale Vec2
---@field position Vec2
---@field offset Vec2
---@field targetValues table
local RenderCanvas = Goop.Class({
    dynamic = {
        shader              = love.graphics.newShader(require('shaders.ballShader')),
        distortionAmount    = 0,
        refractionAmount    = 0,
        zoomFactor          = 1,
        scale               = Vec2(1, 1),
        position            = Vec2(0, 0),
        offset              = Vec2(0.5, 0.5),
        targetValues        = {
            distortionAmount = 0,
            refractionAmount = 0,
            scale            = Vec2(1, 1),
            position         = Vec2(0, 0)
        },
        positionTargetSpeed = 2,
        scaleTargetSpeed    = 2,
        shaderTargetSpeed   = 1
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
-- Called from "LevelCompleteTransition".
function RenderCanvas:beginZoomOut()
    self.targetValues.distortionAmount = 5
    self.targetValues.refractionAmount = 5
    self.targetValues.scale = Vec2(0.5, 0.5)
    self.targetValues.position = Vec2(
        love.graphics.getWidth() * 0.25,
        love.graphics.getHeight() * 0.25
    )
end
function RenderCanvas:beginZoomIn()
    self.targetValues.distortionAmount = 0
    self.targetValues.refractionAmount = 0
    self.targetValues.scale = Vec2(1, 1)
    self.targetValues.position = Vec2(
        love.graphics.getWidth() * 0.5,
        love.graphics.getHeight() * 0.5
    )
end

--------------------------
-- [[ Core Functions ]] --
--------------------------
function RenderCanvas:init()
    self.canvas = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight())
    self.position = Vec2(
        love.graphics.getWidth() * self.offset.x,
        love.graphics.getHeight() * self.offset.y
    )
    self.targetValues.position = self.position
end
function RenderCanvas:update(dt)
    self:_updateTargetValues(dt)
    self.shader:send('distortionAmount', self.distortionAmount)
    self.shader:send('refractionAmount', self.refractionAmount)
    self.shader:send('zoomFactor', self.zoomFactor)
end
function RenderCanvas:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setShader(self.shader)
    love.graphics.draw(self.canvas,
        self.position.x, self.position.y,
        0, self.scale.x, self.scale.y,
        self.canvas:getWidth() * self.offset.x,
        self.canvas:getHeight() * self.offset.y
    )
    love.graphics.setShader()
end


-----------------------------
-- [[ Private Functions ]] --
-----------------------------
function RenderCanvas:_updateTargetValues(dt)
    self.position.x = self.position.x + (self.targetValues.position.x - self.position.x) * self.positionTargetSpeed * dt
    self.position.y = self.position.y + (self.targetValues.position.y - self.position.y) * self.positionTargetSpeed * dt
    self.scale.x = self.scale.x + (self.targetValues.scale.x - self.scale.x) * self.scaleTargetSpeed * dt
    self.scale.y = self.scale.y + (self.targetValues.scale.y - self.scale.y) * self.scaleTargetSpeed * dt
    self.distortionAmount = self.distortionAmount +
    (self.targetValues.distortionAmount - self.distortionAmount) * self.shaderTargetSpeed * dt
    self.refractionAmount = self.refractionAmount +
    (self.targetValues.refractionAmount - self.refractionAmount) * self.shaderTargetSpeed * dt
end

return RenderCanvas
