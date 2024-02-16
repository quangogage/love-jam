require('globals')
local Game = require('Classes.Game')
local FinalOutputCanvas = require('Classes.FinalOutputCanvas')
local game
local finalOutputCanvas

function love.load()
    game = Game()
    finalOutputCanvas = FinalOutputCanvas()
    userInput.onButtonPressed = function (button) game:buttonpressed(button) end

    game:setScene('CombatScene')
end
function love.update(dt)
    console:update(dt)
    game:update(dt)
    userInput:update()
end
function love.draw()
    finalOutputCanvas:startDrawing()
    console:draw()
    game:draw()
    finalOutputCanvas:stopDrawing()
    finalOutputCanvas:draw()
end
function love.keypressed(key)
    console:keypressed(key)
    userInput:keypressed(key)

    -- Dev
    if key == 'escape' then
        love.event.quit()
    end
end
function love.gamepadpressed(joystick, button)
    userInput:gamepadpressed(joystick, button)
end
function love.mousepressed(x, y, button)
    userInput:mousepressed(x, y, button)
end
function love.resize(w, h)
    finalOutputCanvas:resize(w, h)
end
