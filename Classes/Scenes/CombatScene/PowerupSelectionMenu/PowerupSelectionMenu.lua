---@author Gage Henderson 2024-02-18 09:07
--
---@class PowerupSelectionMenu
-- Choose wisely...
--
-- Initialized in LevelTransitionHandler
--

local PowerupSelectionMenu = Goop.Class({
})


----------------------------
-- [[ Public Functions ]] --
----------------------------
function PowerupSelectionMenu:show()
    self.active = true
end


--------------------------
-- [[ Core Functions ]] --
--------------------------
function PowerupSelectionMenu:update(dt)
end
function PowerupSelectionMenu:draw()
end
function PowerupSelectionMenu:mousepressed(x, y, button)
end

return PowerupSelectionMenu
