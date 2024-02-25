---@author Gage Henderson 2024-02-24 13:14
--
---@class MiniPowerupIcon
-- Does not extend element, as of right now anyways.
-- Going to manually position these.
--

local FONT = love.graphics.newFont(fonts.title, 16)

local util = require("util")({"graphics"})

local MiniPowerupIcon = Goop.Class({
    parameters = {
        'image',
        'position',
        'dimensions',
        'powerupRef'
    },
    dynamic = {
        position = {x = 0, y = 0},
        dimensions = {width = 32, height = 32},
        textColor = {1,1,1},

        -- Default image.
        image = love.graphics.newImage("assets/images/icon/fateful_fury.png"),
    }
})



--------------------------
-- [[ Core Functions ]] --
--------------------------
function MiniPowerupIcon:draw(x,y)
    local scale = util.graphics.getScaleForDimensions(self.image, self.dimensions.width, self.dimensions.height)
    local count = self.powerupRef.count
    x = x or self.position.x
    y = y or self.position.y
    love.graphics.setColor(1,1,1)
    love.graphics.draw(self.image, x, y, 0, scale.x, scale.y)


    -- Shadow
    local textX = math.floor(x + self.dimensions.width - FONT:getWidth("x" .. count))
    local textY = math.floor(y + self.dimensions.height - FONT:getHeight())
    love.graphics.setColor(0,0,0,1)
    love.graphics.setFont(FONT)
    love.graphics.print(
        "x" .. count,
        textX-3,
        textY-3,0,1.2,1.2
    )
    --
    love.graphics.setColor(self.textColor)
    love.graphics.setFont(FONT)
    love.graphics.print(
        "x" .. count,
        textX - 2, textY - 2
    )
end


return MiniPowerupIcon
