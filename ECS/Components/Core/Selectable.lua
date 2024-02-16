---@author Gage Henderson 2024-02-16 09:56
--
---@class Selectable : Component
-- Marks that an entity can be selected by the player.
-- See `MouseControlsSystem` for more info.
--
-- Width and height are used to determine if the mouse has clicked or
-- dragged over (etc) the entity.
---@field width number
---@field height number

return function(concord)
    concord.component("selectable", function(c, width, height)
        assert(width, "Selectable component requires a width.")
        assert(height, "Selectable component requires a height.")
        c.width = width
        c.height = height
    end)
end
