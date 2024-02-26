---@author Gage Henderson 2024-02-25 09:02
--
---@class HowToScene
-- The symptom of bad ui code design.
--

local font = love.graphics.newFont(fonts.title, 40)

local HowToScene = Goop.Class({
    arguments = {"eventManager"},
    dynamic = {
        frames = {
            love.graphics.newImage("assets/images/tutorial-slides/1.png"),
            love.graphics.newImage("assets/images/tutorial-slides/2.png"),
            love.graphics.newImage("assets/images/tutorial-slides/3.png"),
            love.graphics.newImage("assets/images/tutorial-slides/4.png")
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
    local str = 'Press any key to continue'
    local img = self.frames[self.index]
    love.graphics.draw(self.frames[self.index], 
        love.graphics.getWidth() / 2 - img:getWidth() / 2,
        love.graphics.getHeight() / 2 - img:getHeight() / 2
    )
    love.graphics.setColor(1,1,1)
    love.graphics.setFont(font)
    love.graphics.print(str, 
        love.graphics.getWidth() / 2 - font:getWidth(str) / 2,
        20
    )
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
