---@class tbl
local tbl = {}

function tbl.createCopy(original)
    local newCopy = {}
    for key,value in pairs(original) do
        newCopy[key] = value
    end
    return newCopy
end

function tbl.createDeepCopy(original)
    local newCopy = {}
    if type(original) == "table" then
        local mt = getmetatable(original)
        setmetatable(newCopy, mt)
    end
    for key,value in pairs(original) do
        if type(value) == "table" then
            newCopy[key] = tbl.createDeepCopy(value)
        else
            newCopy[key] = value
        end
    end
    return newCopy
end

function tbl.copy(new, original)
    for key,value in pairs(original) do
        new[key] = value
    end
end

function tbl.deepCopy(new, original)
    if type(original) == "table" then
        local mt = getmetatable(original)
        setmetatable(new, mt)
    end
    for key,value in pairs(original) do
        if type(value) == "table" then
            new[key] = {}
            tbl.deepCopy(new[key], value)
        else
            new[key] = value
        end
    end
end

-- Shuffles the given table in-place using the Fisher-Yates algorithm
function tbl.shuffle(t)
    local count = #t
    for i = count, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
    return t
end

function tbl.getKeysAsArray(tbl)
    local keys = {}
    for key,value in pairs(tbl) do
        table.insert(keys, key)
    end
    return keys
end

function tbl.convertMapToArray(map)
    local arr = {}
    for key,value in pairs(map) do
        table.insert(arr, value)
    end
    return arr
end

function tbl.mergeArrays(arr1, arr2)
    local merged = {}
    for _,value in ipairs(arr1) do
        table.insert(merged, value)
    end
    for _,value in ipairs(arr2) do
        table.insert(merged, value)
    end
    return merged
end

return tbl
