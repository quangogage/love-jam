---@author Gage Henderson 2024-02-17 17:38
--
---@class Base : Entity
-- The home base of a team (player or enemy).
---@field position Position
---@field hostile? Hostile
---@field friendly? Friendly
---@field health Health
---@field dimensions Dimensions
---@field unselectable Unselectable
---@field isBase IsBase

---@param e Entity
---@param x number
---@param y number
---@param friendly boolean
return function (e, x, y, friendly)
    e
        :give('position', x, y)
        :give('dimensions', 60, 30)
        :give('health', 20)
        :give('renderRectangle', 60, 30)
        :give("unselectable")
        :give("isBase")
        :give("groundPosition")

    if friendly then
        e:give('friendly')
        :give("color",1,1,1)
    else
        e:give('hostile')
        :give("color",1,0,0)
    end
end
