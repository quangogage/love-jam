require('globals')
local Game = require('Classes.Game')
local game
local finalOutputCanvas

function love.load()
    if arg[#arg] == "-debug" then require("mobdebug").start() end -- Zerobrane studio debugging.
    game = Game()

    game:setScene('CombatScene')
end
function love.update(dt)
    console:update(dt)
    game:update(dt)
end
function love.draw()
    game:draw()

    -- Dev:
    console:draw()
    love.graphics.setColor(1,1,1)
    love.graphics.print(love.timer.getFPS(), 150, 10)
end
function love.keypressed(key)
    console:keypressed(key)
    game:keypressed(key)

    -- Dev
    if key == 'escape' then
        love.event.quit()
    end
end
function love.mousepressed(x, y, button)
    game:mousepressed(x, y, button)
end
function love.mousereleased(x, y, button)
    game:mousereleased(x, y, button)
end
function love.resize(w, h)
end
