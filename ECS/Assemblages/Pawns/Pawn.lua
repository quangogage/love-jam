---@author Gage Henderson 2024-02-16 06:13
--
---@class Pawn : Entity
-- Uppermost entity for all characters.
---@field position Position
---@field movement Movement
---@field health Health
---@field physics Physics
---@field armor Armor

return function (e, x, y)
    e
        :give('position', x, y)
        :give('health', 10)
        :give('movement')
        :give('physics')
        :give('pushbackRadius')
        :give('groundPosition')
        :give('isPawn')
        :give('armor', 0)
        :give('coinValue', 0.5)
end
