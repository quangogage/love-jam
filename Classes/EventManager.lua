---@author Gage Henderson 2024-02-17 17:48
--
-- Send and listen-to events across the codebase.
-- Normally would make you define events in a table.
-- I know the whole uuid think is jank and bad but it's fast and easy.

---@class EventManager
---@field events table<string, table>
local EventManager = Goop.Class({
    static = {
        events = {}
    }
})


----------------------------
-- [[ Public Functions ]] --
----------------------------
---@param eventName string
---@param callback function
---@return string
function EventManager:subscribe(eventName, callback)
    self:_ensureEventExists(eventName)
    table.insert(self.events[eventName].listeners, callback)
    return self:_generateUUID()
end
---@param eventName string
---@param callback function
function EventManager:unsubscribe(eventName, callback)
    self:_ensureEventExists(eventName)
    for i, listener in ipairs(self.events[eventName].listeners) do
        if listener == callback then
            table.remove(self.events[eventName].listeners, i)
            break
        end
    end
end
---@param eventName string
---@vararg any
function EventManager:broadcast(eventName, ...)
    self:_ensureEventExists(eventName)
    for _, listener in ipairs(self.events[eventName].listeners) do
        listener(...)
    end
end


-----------------------------
-- [[ Private Functions ]] --
-----------------------------
-- Create an event if it doesn't already exist.
---@param eventName string
function EventManager:_ensureEventExists(eventName)
    if not self.events[eventName] then
        self.events[eventName] = {listeners = {}}
    end
end

-- Generate a UUID for the event.
---@return string
function EventManager:_generateUUID()
    return tostring(math.random(1000000000, 9999999999))
end

return EventManager
