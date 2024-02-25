---@author Gage Henderson 2024-02-24 18:45
--
---@class LoopInfoPanel
--

local TITLE_FONT = love.graphics.newFont(fonts.title, 30)
local FONT = love.graphics.newFont(fonts.speechBubble, 20)

local PowerupIcon = require("Classes.Elements.MiniPowerupIcon")

local LoopInfoPanel = Goop.Class({
    arguments = {'loopStateManager'},
    dynamic = {
        anchor = { x = 0, y = 0.7 },
        offset = { x = 25, y = 0 },
        maxWidth = 305
    }
})


--------------------------
-- [[ Core Functions ]] --
--------------------------
function LoopInfoPanel:init()
    self:_initPowerupIcons()
end
function LoopInfoPanel:draw()
    if self.loopStateManager.loop == 0 then return end
    local x = love.graphics.getWidth() * self.anchor.x + self.offset.x
    local y = love.graphics.getHeight() * self.anchor.y + self.offset.y
    x,y = self:_printLoop(x, y)
    x,y = self:_printSubText(x, y)
    self:_drawPowerupIcons(x, y)
end


-----------------------------
-- [[ Private Functions ]] --
-----------------------------
function LoopInfoPanel:_printLoop(x, y)
    local loop = self.loopStateManager.loop
    local loopText = "Loop: " .. loop
    love.graphics.setColor(1,1,1)
    love.graphics.setFont(TITLE_FONT)
    love.graphics.print(loopText, x, y)
    y = y + TITLE_FONT:getHeight()
    return x, y
end
function LoopInfoPanel:_printSubText(x, y)
    local str = "Enemy powerups:"
    love.graphics.setColor(1,1,1)
    love.graphics.setFont(FONT)
    love.graphics.print(str, x, y)
    y = y + FONT:getHeight()
    return x, y
end
function LoopInfoPanel:_drawPowerupIcons(x, y)
    y = y + 10
    for _,icon in ipairs(self.powerupIcons) do
        if icon.powerupRef.count > 0 then
            if x + icon.dimensions.width > self.maxWidth then
                x = 25
                y = y + icon.dimensions.height
            end
            icon:draw(x, y)
            x = x + icon.dimensions.width + 5
        end
    end
end
function LoopInfoPanel:_initPowerupIcons()
    self.powerupIcons = {}
    for _,powerup in pairs(self.loopStateManager.powerupList) do
        table.insert(self.powerupIcons,
            PowerupIcon({
                image = powerup.image,
                position = { x = 0, y = 0 },
                dimensions = { width = 34, height = 34 },
                powerupRef = powerup
            })
        )
    end
end



return LoopInfoPanel
