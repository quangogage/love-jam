---@author Gage Henderson 2024-02-16 09:02
--
---@class CombatInterface
-- Gui for CombatScene.
--

local PawnSelectionMenu = require("Classes.Scenes.CombatScene.CombatInterface.PawnSelectionMenu")

local CombatInterface = Goop.Class({})

function CombatInterface:init()
    self.pawnSelectionMenu = PawnSelectionMenu()
end
function CombatInterface:update(dt)
    self.pawnSelectionMenu:update(dt)
end
function CombatInterface:draw()
    self.pawnSelectionMenu:draw()
end

return CombatInterface
