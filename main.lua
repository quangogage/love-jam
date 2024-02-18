require('globals')
local Game = require('Classes.Game')
local game

function love.load()
    if arg[#arg] == "-debug" then require("mobdebug").start() end -- Zerobrane studio debugging.
    game = Game()
end
function love.update(dt)
    console:update(dt)
    if not console.input.active then
        game:update(dt)
    end
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
    if not console.input.active then
        game:keypressed(key)
    end

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
function love.wheelmoved(x, y)
    game:wheelmoved(x, y)
end
function love.resize(w, h)
end
