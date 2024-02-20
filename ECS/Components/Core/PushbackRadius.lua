---@author Gage Henderson 2024-02-20 07:21
--
---@class PushbackRadius : Component
-- How close pawns can be to eachother before pushing eachother away
-- @field value number

return function(concord)
    concord.component("pushbackRadius", function(c, value)
        c.value = value or 50
    end)
end
