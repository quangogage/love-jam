---@author Gage Henderson 2024-02-16 15:44
--
---@class DebugSystem : System
-- Misc debug functionality.
-- Some functions can be called via console commands.
--

return function(concord)
    local DebugSystem = concord.system({
        rangeEntities = { "combatProperties", "position" }
    })

    ----------------------------
    -- [[ Public Functions ]] --
    ----------------------------
    function DebugSystem:toggleRanges()
        self.showRanges = not self.showRanges
        console:log("Ranges toggled " .. (self.showRanges and "on" or "off"))
    end

    --------------------------
    -- [[ Core Functions ]] --
    --------------------------
    function DebugSystem:init()
        self.showRanges = false
    end

    return DebugSystem
end
