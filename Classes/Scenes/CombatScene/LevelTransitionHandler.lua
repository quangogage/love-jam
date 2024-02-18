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

---@class LevelTransitionHandler
local LevelTransitionHandler = Goop.Class({})


----------------------------
-- [[ Public Functions ]] --
----------------------------
function LevelTransitionHandler:onLevelComplete()
    console:log("level complete")
end


--------------------------
-- [[ Core Functions ]] --
--------------------------
function LevelTransitionHandler:update(dt)
end
function LevelTransitionHandler:draw()
end


-----------------------------
-- [[ Private Functions ]] --
-----------------------------


return LevelTransitionHandler
