---@author Gage Henderson 2024-02-19 12:50
--
--

local ACTIVE_BACKGROUND_ALPHA = 0.8

---@class PauseMenu
---@field active boolean
---@field combatScene CombatScene
---@field backgroundOverlay table
local PauseMenu = Goop.Class({
    arguments = {"combatScene"},
    static = {
        active = false,
        backgroundOverlay = {
            alpha = 0,
            fadeSpeed = 5
        }
    },
})


----------------------------
-- [[ Public Functions ]] --
----------------------------
function PauseMenu:open()
    self.active = true
    self.combatScene.paused = true
end
function PauseMenu:close()
    self.active = false
    self.combatScene.paused = false
end

--------------------------
-- [[ Core Functions ]] --
--------------------------
function PauseMenu:update(dt)
    self:_fadeBackgroundOverlay(dt)
end
function PauseMenu:draw()
    self:_drawBackgroundOverlay()
end
function PauseMenu:keypressed(key)
    self:_toggle(key)
end
function PauseMenu:mousepressed(x, y, button)
end


-----------------------------
-- [[ Private Functions ]] --
-----------------------------
function PauseMenu:_toggle(key)
    if self.active then
        self:close()
    else
       self:open()
    end
end
function PauseMenu:_fadeBackgroundOverlay(dt)
    local targetAlpha = self.active and ACTIVE_BACKGROUND_ALPHA or 0
    self.backgroundOverlay.alpha = self.backgroundOverlay.alpha + (targetAlpha - self.backgroundOverlay.alpha) * self.backgroundOverlay.fadeSpeed * dt
end
function PauseMenu:_drawBackgroundOverlay()
    love.graphics.setColor(0, 0, 0, self.backgroundOverlay.alpha)
    love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
end


return PauseMenu
