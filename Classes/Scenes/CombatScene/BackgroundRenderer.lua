---@author Gage Henderson 2024-02-20 04:23
--
-- Handles rendering the background / ground of the world.
--


---@class BackgroundRenderer
---@field camera Camera
---@field layer1 love.Image
---@field layer2 love.Image
---@field size number
local BackgroundRenderer = Goop.Class({
    dynamic = {
        layer1 = love.graphics.newImage("assets/images/bg/Layer-5.png"),
        layer2 = love.graphics.newImage("assets/images/bg/Layer-6.png"),
        size = 15000
    }
})

BackgroundRenderer.layer1:setWrap("repeat", "repeat")
BackgroundRenderer.layer2:setWrap("repeat", "repeat")

function BackgroundRenderer:draw()
    self:_drawLayer(self.layer1)
    self:_drawLayer(self.layer2)
end

function BackgroundRenderer:_drawLayer(layer)
    love.graphics.setColor(1, 1, 1, 1)
    local q = love.graphics.newQuad(0,0, self.size, self.size, layer:getDimensions())
    love.graphics.draw(layer, q, -self.size / 2, -self.size / 2)
end

return BackgroundRenderer
