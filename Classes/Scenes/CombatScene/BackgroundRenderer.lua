---@author Gage Henderson 2024-02-20 04:23
--
-- Handles rendering the background / ground of the world.
--


---@class BackgroundRenderer
---@field camera Camera
---@field size number
---@field images love.Image[]
---@field combatScene CombatScene
local BackgroundRenderer = Goop.Class({
    arguments = {"combatScene"},
    dynamic = {
        images = {
            love.graphics.newImage('assets/images/bg_green.png'),
            love.graphics.newImage('assets/images/bg_green_2.png'),
            love.graphics.newImage('assets/images/bg_brown.png'),
            love.graphics.newImage('assets/images/bg_black.png'),
        },
        size = 19000
    }
})

for _, img in ipairs(BackgroundRenderer.images) do
    img:setWrap('repeat', 'repeat')
end

function BackgroundRenderer:draw()
    local layer = self.images[self.combatScene.currentLevelIndex % #self.images + 1]
    love.graphics.setColor(1, 1, 1, 1)
    local q = love.graphics.newQuad(0,0, self.size, self.size, layer:getDimensions())
    love.graphics.draw(layer, q, -self.size / 2, -self.size / 2)

end


return BackgroundRenderer
