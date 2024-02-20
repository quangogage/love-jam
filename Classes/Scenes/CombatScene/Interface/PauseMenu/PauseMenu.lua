---@author Gage Henderson 2024-02-19 12:50
--
--

local ACTIVE_BACKGROUND_ALPHA = 0.8

local subMenus = {
    primaryPauseMenu = require("Classes.Scenes.CombatScene.Interface.PauseMenu.PrimaryPauseMenu"),
    optionsMenu      = require("Classes.OptionsMenuLayout")
}

---@class PauseMenu
---@field active boolean
---@field combatScene CombatScene
---@field eventManager EventManager
---@field backgroundOverlay table
---@field currentMenu table
local PauseMenu = Goop.Class({
    arguments = {"combatScene", "eventManager"},
    dynamic = {
        active = false,
        backgroundOverlay = {
            alpha = 0,
            fadeSpeed = 12
        }
    },
})


----------------------------
-- [[ Public Functions ]] --
----------------------------

function PauseMenu:loadMenu(menuName, ...)
    self.currentMenu = subMenus[menuName](self, self.eventManager, ...)
end
function PauseMenu:open()
    self:loadMenu("primaryPauseMenu")
    self.active = true
    self.combatScene.paused = true
end
function PauseMenu:close()
    self.currentMenu = nil
    self.active = false
    self.combatScene.paused = false
end

--------------------------
-- [[ Core Functions ]] --
--------------------------
function PauseMenu:update(dt)
    self:_fadeBackgroundOverlay(dt)
    if self.currentMenu then
        self.currentMenu:update(dt)
    end
end
function PauseMenu:draw()
    self:_drawBackgroundOverlay()
    if self.currentMenu then
        self.currentMenu:draw()
    end
end
function PauseMenu:keypressed(key)
    self:_toggle(key)
    if self.currentMenu then
        self.currentMenu:keypressed(key)
    end
end
function PauseMenu:mousepressed(x, y, button)
    if self.currentMenu then
        self.currentMenu:mousepressed(x, y, button)
    end
end


-----------------------------
-- [[ Private Functions ]] --
-----------------------------
function PauseMenu:_toggle(key)
    if key == 'escape' then
        if self.active then
            self:close()
        else
           self:open()
        end
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
