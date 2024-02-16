---@author Gage Henderson 2024-02-16 15:44
--
---@class DebugSystem : System
-- Misc debug functionality.
-- Some functions can be called via console commands.
--

return function (concord)
    local DebugSystem = concord.system({
        rangeEntities = { 'combatProperties', 'position' }
    })


    ----------------------------
    -- [[ Public Functions ]] --
    ----------------------------
    function DebugSystem:toggleRanges()
        self.showRanges = not self.showRanges
        console:log('Ranges toggled ' .. (self.showRanges and 'on' or 'off'))
    end


    --------------------------
    -- [[ Core Functions ]] --
    --------------------------
    function DebugSystem:init()
        self.showRanges = false
    end
    function DebugSystem:draw()
        self:_drawRanges()
    end


    -----------------------------
    -- [[ Private Functions ]] --
    -----------------------------
    function DebugSystem:_drawRanges()
        if not self.showRanges then return end

        for _,entity in ipairs(self.rangeEntities) do
            local combatProperties = entity:get('combatProperties')
            local position = entity:get('position')
            local dimensions = entity:get('dimensions')
            love.graphics.circle(
                'line',
                position.x,
                position.y + dimensions.height / 2,
                combatProperties.range
            )
        end
    end
    return DebugSystem
end
