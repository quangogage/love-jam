---@author Gage Henderson 2024-01-11 13:51
---
---
---Can be used to easily assemble entities by their filename
---anywhere throughout the codebase.
---

local concord = require("libs.Concord")

---@class entityAssembler
local entityAssembler = {}

---Load all of the assemblages
local assemblages = {}
local function loadFilesInDir(dir)
    local files = love.filesystem.getDirectoryItems(dir)
    for _, file in ipairs(files) do
        if string.match(file, "%.lua") then
            local filename = file:gsub("%.lua$", "")
            assemblages[string.lower(filename)] = require(dir..filename)
        elseif love.filesystem.getInfo(dir..file).type == "directory" then
            loadFilesInDir(dir..file.."/")
        end
    end
end
loadFilesInDir("/ECS/Assemblages/")


---
---Check if an assemblage exists with the given name.
---@param name string
---@return boolean
function entityAssembler.exists(name)
    return assemblages[string.lower(name)] ~= nil
end

---
---Create an assemblage.
---@param world table | nil
---@param name string
function entityAssembler.assemble(world, name, ...)
    local assemblage = assemblages[string.lower(name)]
    assert(type(world) == "table" or world == nil, "EntityAssembler.assemble: world must be a table or nil")
    if assemblage then
        if world then
            return concord.entity(world):assemble(assemblage, ...)
        else
            return concord.entity():assemble(assemblage, ...)
        end
    else
        console:log("Assemblage not found for "..name)
        return "Assemblage not found for "..name
    end
end


return entityAssembler
