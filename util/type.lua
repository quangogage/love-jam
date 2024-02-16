---@class t
local t = {}

function t.assert(desiredType, val)
    assert(type(val) == desiredType or val == nil, "Expected " .. desiredType .. " received " .. type(val))
end

return t
