---@author Gage Henderson 2024-02-24 11:06
--
---@class LevelStartNotification
--

local TITLE_FONT = love.graphics.newFont(fonts.title, 40)
local SUB_FONT = love.graphics.newFont(fonts.speechBubble, 30)

local LevelStartNotification = Goop.Class({
    arguments = { 'combatScene', 'loopStateManager' },
    dynamic = {
        alpha       = 0,
        targetAlpha = 1,
        holdTime    = 2,
        fadeSpeed   = 5,
        timer       = 0
    }
})


----------------------------
-- [[ Public Functions ]] --
----------------------------
function LevelStartNotification:trigger()
    self.targetAlpha = 1
    self.timer = 0
end


--------------------------
-- [[ Core Functions ]] --
--------------------------
function LevelStartNotification:update(dt)
    self.timer = self.timer + dt
    if self.timer >= self.holdTime then
        self.targetAlpha = 0
    end
    self.alpha = self.alpha + (self.targetAlpha - self.alpha) * self.fadeSpeed * dt
end
function LevelStartNotification:draw()
    local titleStr = 'Level ' .. self.combatScene.currentLevelIndex
    local x = love.graphics.getWidth() * 0.1
    local y = love.graphics.getHeight() * 0.5 - 10


    -- Shadow
    love.graphics.setColor(0, 0, 0, self.alpha * 0.5)
    love.graphics.setFont(TITLE_FONT)
    love.graphics.print(titleStr, x - 2, y + 2)

    --
    love.graphics.setColor(1, 1, 1, self.alpha)
    love.graphics.setFont(TITLE_FONT)
    love.graphics.print(titleStr, x, y)
    y = y + TITLE_FONT:getHeight() + 5
    x = x + 5

    if self.loopStateManager.loop > 0 then
        local subStr = 'Loop ' .. self.loopStateManager.loop

        -- Shadow
        love.graphics.setColor(0, 0, 0, self.alpha * 0.5)
        love.graphics.setFont(SUB_FONT)
        love.graphics.print(subStr, x - 2, y + 2)

        love.graphics.setColor(1, 1, 1, self.alpha)
        love.graphics.setFont(SUB_FONT)
        love.graphics.print(subStr, x, y)
    end
end

return LevelStartNotification
