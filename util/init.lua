---@class util
---@field collision collision
---@field entityAssembler entityAssembler
---@field math mth
---@field string str
---@field table tbl
---@field type t
---@field filesystem filesystem
local function getUtilTables(tables)
    local newUtil = {}
    for i=1,#tables do
        local tbl = tables[i]
        newUtil[tbl] = require("util." .. tbl)
    end
    return newUtil
end

return getUtilTables
