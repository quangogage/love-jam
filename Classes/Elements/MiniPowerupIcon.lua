---@author Gage Henderson 2024-02-24 13:14
--
---@class MiniPowerupIcon
-- Does not extend element, as of right now anyways.
-- Going to manually position these.
--

local FONT = love.graphics.newFont(fonts.title, 24)

local util = require("util")({"graphics"})

local MiniPowerupIcon = Goop.Class({
    parameters = {
        'image',
        'position',
        'dimensions',
        'count'
    },
    dynamic = {
        count = 0,
        position = {x = 0, y = 0},
        dimensions = {width = 32, height = 32},

        -- Default image.
        image = love.graphics.newImage("assets/images/icon/fateful_fury.png"),
    }
})



--------------------------
-- [[ Core Functions ]] --
--------------------------
function MiniPowerupIcon:draw()
    local scale = util.graphics.getScaleForDimensions(self.image, self.dimensions.width, self.dimensions.height)
    love.graphics.setColor(1,1,1)
    love.graphics.draw(self.image, self.position.x, self.position.y, 0, 1, 1)

    love.graphics.setColor(0,0,0)
    love.graphics.setFont(FONT)
    love.graphics.print(
        "x" .. self.count,
        self.position.x + self.dimensions.width - FONT:getWidth("x" .. self.count) - 2,
        self.position.y + self.dimensions.height - FONT:getHeight() - 2
    )
end


return MiniPowerupIcon
