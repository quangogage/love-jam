---@class filesystem
local filesystem = {}

---@param filename string
local function endsWithLuaExtension(filename)
end

---@param dir string
function filesystem.requireFromDir(dir)
    local items = love.filesystem.getDirectoryItems(dir)
    for _, item in ipairs(items) do
        local path = dir .. "/" .. item
        local info = love.filesystem.getInfo(path)
        if info.type == "file" then
            require(path:sub(1,-5))
        end
    end
end

---@param dir string
---@param tbl table
function filesystem.loadDirIntoTable(dir,tbl)
    local items = love.filesystem.getDirectoryItems(dir)
    for _, item in ipairs(items) do
        local path = dir .. "/" .. item
        local info = love.filesystem.getInfo(path)
        if info.type == "file" then
            table.insert(tbl, require(path:sub(1,-5)))
        end
    end
end

---Loads a directory into a table, with the name of the file being the key and the return value being it's value.
---@param dir string
---@param tbl table
function filesystem.loadDirIntoPairs(dir,tbl)
    local items = love.filesystem.getDirectoryItems(dir)
    for _, item in ipairs(items) do
        local path = dir .. "/" .. item
        local info = love.filesystem.getInfo(path)
        if info.type == "file" then
            tbl[item:sub(1,-5)] = require(path:sub(1,-5))
        end
    end
end
return filesystem
