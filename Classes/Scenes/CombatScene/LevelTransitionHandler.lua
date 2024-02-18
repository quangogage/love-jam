---@author Gage Henderson 2024-02-18 08:26
--
-- Handles the transition between levels, this includes creating / managing
-- the powerup selection menu, and the fade out animation.
--
--
-- (The fade in animation is handled by `LevelStartAnimation`)
--
-- Level completion is checked for in DamageSystem.
--
--
-- ──────────────────────────────────────────────────────────────────────
-- Crude, ugly, and bad way of handling this high level stuff. But the fastest
-- and easiest right now.
-- ──────────────────────────────────────────────────────────────────────

local PowerupSelectionMenu = require(
    'Classes.Scenes.CombatScene.PowerupSelectionMenu.PowerupSelectionMenu'
)

---@class LevelTransitionHandler
---@field eventManager EventManager
---@field levelComplete boolean
---@field fadingOut boolean
---@field powerupSelectionMenu PowerupSelectionMenu
---@field combatScene CombatScene
---@field overlay { alpha: number, fadeSpeed: number }
local LevelTransitionHandler = Goop.Class({
    arguments = { 'eventManager', 'combatScene' },
    dynamic = {
        levelComplete = false,
        fadingOut     = false,
        overlay       = {
            alpha     = 0,
            fadeSpeed = 2
        }
    }
})


----------------------------
-- [[ Public Functions ]] --
----------------------------
function LevelTransitionHandler:onLevelComplete()
    self.powerupSelectionMenu:show()
    self.fadingOut     = false
    self.levelComplete = true
    self.overlay.alpha = 0
end
function LevelTransitionHandler:endPowerupSelection()
    self.overlay.alpha = 0
    self.fadingOut = true
end
-- Finish powerup selection and load the next level.
function LevelTransitionHandler:endTransition()
    self.fadingOut     = false
    self.levelComplete = false
    self.overlay.alpha = 0
    self.powerupSelectionMenu:hide()
    self.combatScene:loadNextLevel()
end


--------------------------
-- [[ Core Functions ]] --
--------------------------
function LevelTransitionHandler:init()
    self.powerupSelectionMenu = PowerupSelectionMenu(self.eventManager, self)
end
function LevelTransitionHandler:destroy()
    self.powerupSelectionMenu:destroy()
end
function LevelTransitionHandler:update(dt)
    self.powerupSelectionMenu:update(dt)
    self:_fadeOverlay(dt)
end
function LevelTransitionHandler:draw()
    self.powerupSelectionMenu:draw()
    self:_drawOverlay()
end
function LevelTransitionHandler:mousepressed(x, y, button)
    self.powerupSelectionMenu:mousepressed(x, y, button)
end


-----------------------------
-- [[ Private Functions ]] --
-----------------------------
function LevelTransitionHandler:_fadeOverlay(dt)
    if self.fadingOut then
        self.overlay.alpha = self.overlay.alpha + self.overlay.fadeSpeed * dt
        if self.overlay.alpha >= 1 and self.fadingOut then
            self:endTransition()
            self.fadingOut = false
        end
    end
end
function LevelTransitionHandler:_drawOverlay()
    if self.fadingOut then
        love.graphics.setColor(0, 0, 0, self.overlay.alpha)
        love.graphics.rectangle(
            'fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight()
        )
    end
end


return LevelTransitionHandler
