---@author Gage Henderson 2024-02-16 09:02
--
---@class CombatInterface
-- Gui for CombatScene.
--

local PawnSelectionMenu = require("Classes.Scenes.CombatScene.CombatInterface.PawnSelectionMenu")

local CombatInterface = Goop.Class({
    arguments = {'eventManager'}
})

function CombatInterface:init()
    self.pawnSelectionMenu = PawnSelectionMenu(self.eventManager)
end
function CombatInterface:update(dt)
    self.pawnSelectionMenu:update(dt)
end
function CombatInterface:draw()
    self.pawnSelectionMenu:draw()
end
---@return boolean Whether or not we clicked an interface element.
function CombatInterface:mousepressed(x, y, button)
    return self.pawnSelectionMenu:mousepressed(x, y, button)
end

return CombatInterface
