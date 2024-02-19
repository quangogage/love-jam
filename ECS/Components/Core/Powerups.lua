---@author Gage Henderson 2024-02-18 15:10
--
---@class Powerups : Component
-- Stores information about what powerups this entity has.
-- Should be defined upon creation, see FriendlySpawnHandler for 
-- more info.
---

return function(concord)
    concord.component("powerups", function(c, powerups)
        c.list = powerups
    end)
end
