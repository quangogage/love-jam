---@author Gage Henderson 2024-02-25 09:02
--
---@class HowToScene
-- The symptom of bad ui code design.
--

local HowToScene = Goop.Class({
    arguments = {"eventManager"},
    dynamic = {
        frames = {
            love.graphics.newImage("assets/images/how-to-slides/1.png"),
            love.graphics.newImage("assets/images/how-to-slides/2.png"),
            love.graphics.newImage("assets/images/how-to-slides/3.png"),
            love.graphics.newImage("assets/images/how-to-slides/4.png")
        },
        index = 1
    }
})

function HowToScene:next()
    self.index = self.index + 1
    if self.index > #self.frames then
        self.eventManager:broadcast("openMainMenu")
        self.index = 1
    end
end

function HowToScene:destroy()
end
function HowToScene:update()
end
function HowToScene:draw()
    love.graphics.draw(self.frames[self.index], 0, 0)
end
function HowToScene:keypressed(key)
    self:next()
end
function HowToScene:mousepressed(x, y, button)
    self:next()
end
function HowToScene:mousereleased(x, y, button)
end
function HowToScene:wheelmoved(x, y)
end

return HowToScene
