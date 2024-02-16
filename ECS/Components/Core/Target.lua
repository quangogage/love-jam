---@author Gage Henderson 2024-02-16 11:56
--
---@class Target : Component
-- Specifies an entity's "target".
-- As of writing this could be a location or another entity.
-- See `PawnCommandSystem` and `PawnAISystem` for usage.
---@field entity? Pawn|table
---@field position? {x: number, y: number}

return function(concord)
    concord.component("target", function(e, data)
        e.entity   = data.entity
        e.position = data.position
    end)
end
