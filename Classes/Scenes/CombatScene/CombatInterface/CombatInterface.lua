---@author Gage Henderson 2024-02-16 09:02
--
-- Gui for CombatScene.
--

local PawnSelectionMenu = require('Classes.Scenes.CombatScene.CombatInterface.PawnSelectionMenu')

---@class CombatInterface
---@field eventManager EventManager
---@field pawnSelectionMenu PawnSelectionMenu
local CombatInterface = Goop.Class({
    arguments = { 'eventManager', 'powerupStateManager' }
})

function CombatInterface:init()
    self.pawnSelectionMenu = PawnSelectionMenu(self.eventManager, self.powerupStateManager)
end
function CombatInterface:destroy()
    self.pawnSelectionMenu:destroy()
end
function CombatInterface:update(dt)
    self.pawnSelectionMenu:update(dt)
end
function CombatInterface:draw()
    self.pawnSelectionMenu:draw()
end
---@return boolean - Whether or not we clicked an interface element.
function CombatInterface:mousepressed(x, y, button)
    return self.pawnSelectionMenu:mousepressed(x, y, button)
end
function CombatInterface:keypressed(key)
    self.pawnSelectionMenu:keypressed(key)
end

return CombatInterface
