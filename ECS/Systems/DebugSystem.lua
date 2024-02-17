---@author Gage Henderson 2024-02-16 15:44
--
---@class DebugSystem : System
-- Misc debug functionality.
-- Some functions can be called via console commands.
--

return function (concord)
    local DebugSystem = concord.system({
        rangeEntities = { 'combatProperties', 'position' },
        hitboxes = { 'position', 'dimensions' }
    })


    ----------------------------
    -- [[ Public Functions ]] --
    ----------------------------
    function DebugSystem:toggleRanges()
        self.showRanges = not self.showRanges
        console:log('Ranges toggled ' .. (self.showRanges and 'on' or 'off'))
    end
    function DebugSystem:toggleHitboxes()
        self.showHitboxes = not self.showHitboxes
        console:log('Hitboxes toggled ' .. (self.showHitboxes and 'on' or 'off'))
    end


    --------------------------
    -- [[ Core Functions ]] --
    --------------------------
    function DebugSystem:init()
        self.showRanges = false
        self.showHitboxes = false
    end
    function DebugSystem:draw()
        self:_drawRanges()
        self:_drawHitboxes()
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
            love.graphics.setLineWidth(1)
            love.graphics.setColor(1,0,0)
            love.graphics.circle(
                'line',
                position.x,
                position.y + dimensions.height / 2,
                combatProperties.range
            )
        end
    end
    function DebugSystem:_drawHitboxes()
        if not self.showHitboxes then return end
        local drawHitbox = function(hitbox)
            love.graphics.setColor(1,0,1)
            love.graphics.rectangle(
                'line',
                hitbox.position.x - hitbox.dimensions.width / 2,
                hitbox.position.y - hitbox.dimensions.height / 2,
                hitbox.dimensions.width,
                hitbox.dimensions.height
            )
        end
        for _,hitbox in ipairs(self.hitboxes) do
            drawHitbox({
                position = otherHitbox.position,
                dimensions = otherHitbox.dimensions
            })
        end
    end
    return DebugSystem
end
