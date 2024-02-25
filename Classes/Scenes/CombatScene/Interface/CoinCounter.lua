---@author Gage Henderson 2024-02-24 17:05
--
---@class CoinCounter
-- Display how many coins the player has.
--

local FONT = love.graphics.newFont(fonts.speechBubble, 20)
local IMAGE = love.graphics.newImage('assets/images/pawn_ui/coins.png')
local SCALE = { x = 1, y = 1 }

local CoinCounter = Goop.Class({
    arguments = { 'coinManager' },
    dynamic = {
        anchor = { x = 0, y = 1},
        offset = {x = 25, y = -160}
    }
})

function CoinCounter:draw()
    local x = love.graphics.getWidth() * self.anchor.x + self.offset.x
    local y = love.graphics.getHeight() * self.anchor.y + self.offset.y
    local flooredCoins = math.floor(self.coinManager.coins * 10) / 10

    love.graphics.setFont(FONT)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(IMAGE, x, y, 0, SCALE.x, SCALE.y)
    love.graphics.print(flooredCoins, math.floor(x + 40), math.floor(y + IMAGE:getHeight() / 2 - FONT:getHeight() / 2))
end

return CoinCounter
