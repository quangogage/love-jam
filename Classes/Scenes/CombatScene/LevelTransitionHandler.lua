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
---@field powerupSelectionMenu PowerupSelectionMenu
local LevelTransitionHandler = Goop.Class({
    arguments = { 'eventManager' },
    static = {
        levelComplete = false
    }
})


----------------------------
-- [[ Public Functions ]] --
----------------------------
function LevelTransitionHandler:onLevelComplete()
    self.powerupSelectionMenu:show()
    self.levelComplete = true
end


--------------------------
-- [[ Core Functions ]] --
--------------------------
function LevelTransitionHandler:init()
    self.powerupSelectionMenu = PowerupSelectionMenu(self.eventManager)
end
function LevelTransitionHandler:destroy()
    self.powerupSelectionMenu:destroy()
end
function LevelTransitionHandler:update(dt)
    self.powerupSelectionMenu:update(dt)
end
function LevelTransitionHandler:draw()
    self.powerupSelectionMenu:draw()
end
function LevelTransitionHandler:mousepressed(x, y, button)
    self.powerupSelectionMenu:mousepressed(x, y, button)
end

-----------------------------
-- [[ Private Functions ]] --
-----------------------------


return LevelTransitionHandler
