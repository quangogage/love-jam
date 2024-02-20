---@author Gage Henderson 2024-02-20 15:06
--
---@class Armor : Component
---@field value number
-- Used to mitigate damage, simple direct calculation nothing fancy.
--

return function(concord)
    concord.component("armor", function(c, value)
        c.value = value or 0
    end)
end
