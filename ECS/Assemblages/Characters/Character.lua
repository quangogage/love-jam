---@author Gage Henderson 2024-02-16 06:13
--
---@class Character : Entity
-- Uppermost entity for all characters.
---@field position Position
---@field movement Movement
---@field health Health
---@field physics Physics

return function (e, x, y)
    e
        :give('position', x, y)
        :give('health', 10)
        :give('movement')
        :give('physics')
end
