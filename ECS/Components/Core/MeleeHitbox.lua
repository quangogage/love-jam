---@author Gage Henderson 2024-02-16 16:19
--
---@class MeleeHitbox : Component
-- Describes a hitbox that is used for melee attacks.
--
-- See `ECS.Assemblages.MeleeHitbox` and `ECS.Systems.MeleeHitboxSystem`.
--
---@field width number
---@field height number
---@field targetEntities Entity[] | Pawn[] | Tower[]
---@field ignoreEntities Entity[] | Pawn[] | Tower[]

return function(concord)
    concord.component("meleeHitbox", function(c, width, height, targetEntities, ignoreEntities)
        c.width          = width
        c.height         = height
        c.targetEntities = targetEntities or {}
        c.ignoreEntities = ignoreEntities or {}
    end)
end
