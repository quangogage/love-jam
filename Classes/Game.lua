---@author Gage Henderson
--
---@class Game

local Game = Goop.Class({})

--------------------------
-- [[ Core Functions ]] --
--------------------------
function Game:init()
end

function Game:update(dt)
end

function Game:draw()
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("fill",100,100,100,100)
end

function Game:buttonpressed(button)
end

return Game
