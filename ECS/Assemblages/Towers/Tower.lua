---@author Gage Henderson 2024-02-16 11:34
--
---@class Tower : Entity
-- Upper-most assemblage for towers.
---@field position Position
---@field health Health
---@field hostile Hostile
---@field pawnGeneration PawnGeneration

return function (e, x, y)
    e
        :give('position', x, y)
        :give('health')
        :give('hostile')
        :give("pawnGeneration")
        :give("groundPosition", 0, 170)
        :give("isTower")
        :give("collision", {radius = 95})
        :give("staticCollisionBehavior")
        :give("coinValue", KNOBS.enemyCoinReward.tower)
end
