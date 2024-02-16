---@diagnostic disable
---@author: Callgage 2023-07-29 13:14:13
-- Very incomplete Vec2 class.
---@class Vec2
---@field x number
---@field y number
---@field width number
---@field height number
local util = require("util")({"table","type"})

---@param x number
---@param y number
---@return Vec2
return function(x,y)
    util.type.assert("number",x)
    util.type.assert("number",y)
    local newVec2 = {
        type = "Vec2",
        x = x, y = y
    }
    setmetatable(newVec2, {
        __index = function(self,key)
            if key == 1 or key == "width" then
                return self.x
            elseif key == 2 or key == "height" then
                return self.y
            else
                return rawget(self, key)
            end
        end,
        __newindex = function(self,key,val)
            if key == 1 or key == "width" then
                self.x = val
            elseif key == 2 or key == "height" then
                self.y = val
            else
                rawset(self, key, val)
            end
        end,
        __mul = function(self,value)
            if type(value) == "number" then
                self.x = self.x * value
                self.y = self.y * value
                return self
            end
        end
    })
    return newVec2
end
