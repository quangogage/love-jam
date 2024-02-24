---@author Gage Henderson 2024-02-22 09:12
--
-- Render all of the ecs game-world onto a canvas.
--
-- ╭─────────────────────────────────────────────────────────╮
-- │ TODO: Resize.                                           │
-- ╰─────────────────────────────────────────────────────────╯
--

local util = require('util')({ 'math' })
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
---@field teller table
---@field overlayAlpha number
---@field overlayAlphaTarget number
---@field overlayAlphaSpeed number
---@field positionTargetSpeed number
---@field scaleTargetSpeed number
---@field shaderTargetSpeed number
---@field overlayImage love.Image
---@field canvasDimensionMultiplier number
---@field zoomedOut table
---@field zoomedIn table
---@field crystalBallSize number
local RenderCanvas = Goop.Class({
    dynamic = {
        shader                    = love.graphics.newShader(require('shaders.ballShader')),
        distortionAmount          = 0,
        refractionAmount          = 0,
        zoomFactor                = 1,
        scale                     = Vec2(1, 1),
        position                  = Vec2(0, 0),
        offset                    = Vec2(0.5, 0.5),
        canvasDimensionMultiplier = 2,
        zoomedOut                 = {
            tellerScale      = Vec2(1, 1),
            distortionAmount = 10,
            refractionAmount = 25,
            scale            = Vec2(0.5, 0.5),
            position         = Vec2(love.graphics.getWidth() * 0.25, love.graphics.getHeight() * 0.25),
            overlayAlpha     = 1
        },
        zoomedIn                  = {
            tellerScale      = Vec2(15, 15),
            distortionAmount = 0,
            refractionAmount = 0,
            scale            = Vec2(1, 1),
            position         = Vec2(love.graphics.getWidth() * 0.5, love.graphics.getHeight() * 0.5),
            overlayAlpha     = 0
        },
        teller                    = {
            image          = love.graphics.newImage('assets/images/ui/teller.png'),
            anchor         = { x = 0.25, y = 0.25 },
            scale          = { x = 15, y = 15 },
            targetScale    = { x = 15, y = 15 },
            zoomedOutScale = { x = 15, y = 15 },
            zoomedInScale  = { x = 1, y = 1 },
            zoomSpeed      = 3
        },
        crystalBallSize           = 100,
        overlayImage              = love.graphics.newImage('assets/images/ui/overlay.png'),
        overlayAlpha              = 0,
        overlayAlphaTarget        = 0,
        overlayAlphaSpeed         = 2,
        positionTargetSpeed       = 4,
        scaleTargetSpeed          = 3,
        shaderTargetSpeed         = 0.5,
        shaderZoomInSpeed         = 6,
        state                     = 'zoomedIn'
    }
})

----------------------------
-- [[ Public Functions ]] --
----------------------------
function RenderCanvas:startDrawing()
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear(0, 0, 0, 0)
    -- Shift to the left the amount of pixels added by the canvasdimensionmultiplier.
    love.graphics.push()
    love.graphics.translate(
        love.graphics.getWidth() * (self.canvasDimensionMultiplier - 1) * 0.5,
        love.graphics.getHeight() * (self.canvasDimensionMultiplier - 1) * 0.5
    )
end
function RenderCanvas:stopDrawing()
    love.graphics.pop()
    love.graphics.setCanvas()
end
-- Called from "LevelCompleteTransition".
function RenderCanvas:beginZoomOut()
    self.zoomedOut.position = Vec2(
        love.graphics.getWidth() * 0.25,
        love.graphics.getHeight() * 0.25
    )
    self.state = "zoomedOut"
end
function RenderCanvas:beginZoomIn()
    self.zoomedIn.position = Vec2(
        love.graphics.getWidth() * self.offset.x,
        love.graphics.getHeight() * self.offset.y
    )
    self.state = 'zoomedIn'
end

--------------------------
-- [[ Core Functions ]] --
--------------------------
function RenderCanvas:init()
    self:_initCanvas()
    self.position = Vec2(
        love.graphics.getWidth() * self.offset.x,
        love.graphics.getHeight() * self.offset.y
    )
    self.zoomedIn.position = Vec2(
        love.graphics.getWidth() * self.offset.x,
        love.graphics.getHeight() * self.offset.y
    )
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
    love.graphics.stencil(function () self:_stencilFunction() end, 'replace', 1)
    love.graphics.setStencilTest('greater', 0)
    love.graphics.draw(self.canvas,
        self.position.x, self.position.y,
        0, self.scale.x, self.scale.y,
        self.canvas:getWidth() * self.offset.x,
        self.canvas:getHeight() * self.offset.y
    )
    love.graphics.setStencilTest()
    love.graphics.setShader()
    love.graphics.draw(self.teller.image,
        love.graphics.getWidth() * self.teller.anchor.x,
        love.graphics.getHeight() * self.teller.anchor.y,
        0, self.teller.scale.x, self.teller.scale.y,
        self.teller.image:getWidth() * 0.5,
        self.teller.image:getHeight() * 0.5
    )
    love.graphics.setColor(1, 1, 1, self.overlayAlpha)
    love.graphics.draw(self.overlayImage,
        love.graphics.getWidth() * self.teller.anchor.x,
        love.graphics.getHeight() * self.teller.anchor.y,
        0, self.teller.scale.x, self.teller.scale.y,
        self.overlayImage:getWidth() * 0.5,
        self.overlayImage:getHeight() * 0.5
    )
end


-----------------------------
-- [[ Private Functions ]] --
-----------------------------
function RenderCanvas:_updateTargetValues(dt)
    local targetValues = self[self.state]
    self.position.x = util.math.lerp(self.position.x, targetValues.position.x, self.positionTargetSpeed * dt)
    self.position.y = util.math.lerp(self.position.y, targetValues.position.y, self.positionTargetSpeed * dt)
    self.scale.x = util.math.lerp(self.scale.x, targetValues.scale.x, self.scaleTargetSpeed * dt)
    self.scale.y = util.math.lerp(self.scale.y, targetValues.scale.y, self.scaleTargetSpeed * dt)
    self.overlayAlpha = util.math.lerp(self.overlayAlpha, targetValues.overlayAlpha, self.overlayAlphaSpeed * dt)
    self.teller.scale.x = util.math.lerp(self.teller.scale.x, targetValues.tellerScale.x, self.teller.zoomSpeed * dt)
    self.teller.scale.y = util.math.lerp(self.teller.scale.y, targetValues.tellerScale.y, self.teller.zoomSpeed * dt)
    local speed = self.state == 'zoomedIn' and self.shaderZoomInSpeed or self.shaderTargetSpeed
    self.distortionAmount = util.math.lerp(self.distortionAmount, targetValues.distortionAmount, speed * dt)
    self.refractionAmount = util.math.lerp(self.refractionAmount, targetValues.refractionAmount, speed * dt)
end

function RenderCanvas:_stencilFunction()
    local baseRadius = self.crystalBallSize
    local radius = baseRadius * self.teller.scale.x
    love.graphics.circle('fill',
        love.graphics.getWidth() * self.teller.anchor.x,
        love.graphics.getHeight() * self.teller.anchor.y,
        radius
    )
end

function RenderCanvas:_initCanvas()
    self.canvas = love.graphics.newCanvas(
        love.graphics.getWidth() * self.canvasDimensionMultiplier,
        love.graphics.getHeight() * self.canvasDimensionMultiplier
    )
    self.zoomedIn.tellerScale = {
        x = love.graphics.getWidth() / self.crystalBallSize,
        y = love.graphics.getWidth() / self.crystalBallSize
    }
    self.teller.targetScale = {
        x = self.teller.zoomedOutScale.x,
        y = self.teller.zoomedOutScale.y
    }
    self.teller.scale = {
        x = self.teller.zoomedOutScale.x,
        y = self.teller.zoomedOutScale.y
    }
end

return RenderCanvas
