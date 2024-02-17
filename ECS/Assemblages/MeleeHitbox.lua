---@author Gage Henderson 2024-02-16 16:16
--
---@class MeleeHitbox : Entity
-- An extremely simple assemblage.
--
-- Represents a *2d* hitbox that is used to detect if a melee attack has hit a
-- target (it does not consider depth when calculating collision).
--
---@field position Position
---@field meleeHitbox MeleeHitbox

---@param e Entity
---@param x number
---@param y number
---@param width number
---@param height number
---@param ignoreEntities Entity[] | Pawn[] | Tower[]
return function(e,x,y,width,height,ignoreEntities)
    e
        :give("position", x, y)
        :give("meleeHitbox", width, height, ignoreEntities)
end
