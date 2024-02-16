---@author Gage Henderson 2024-02-16 09:56
--
---@class Selectable : Component
-- Marks that an entity can be selected by the player.
-- See `MouseControlsSystem` for more info.
--
-- Use the `clickDimensions` component to define the area that can be clicked.
--

return function(concord)
    concord.component("selectable")
end
