---@author Gage Henderson 2024-02-16 11:34
--
---@class Tower : Entity
-- Upper-most assemblage for towers.
---@field position Position

return function (e, x, y)
    e
        :give('position', x, y)
        :give('health')
        :give('hostile')
end
