---@author Gage Henderson 2024-02-18 15:10
--
---@class Powerups : Component
-- Stores information about what powerups this entity has.
-- Should be defined upon creation, see FriendlySpawnHandler for 
-- more info.
---@field value table<string, table>
---@field setup boolean

return function(concord)
    concord.component("powerups", function(c, value)
        c.value = value
    end)
end
