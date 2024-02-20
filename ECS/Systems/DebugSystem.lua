---@author Gage Henderson 2024-02-16 15:44
--
---@class DebugSystem : System
-- Misc debug functionality.
-- Some functions can be called via console commands.
--

local util = require("util")({ "entityAssembler" })

return function (concord, camera, onLevelComplete)
    local DebugSystem = concord.system({
        rangeEntities = { 'combatProperties', 'position' },
        hitboxes = { 'position', 'dimensions' },
        hostileEntities = { 'hostile' }
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
    function DebugSystem:testRoom()
        for _, entity in ipairs(self.hostileEntities) do
            self:getWorld():emit('event_pawnDied', entity)
            entity:destroy()
        end
        self.testRoom = true
        console:log('Killed all enemies')
    end
    function DebugSystem:completeLevel()
        onLevelComplete()
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
    function DebugSystem:keypressed(key)
        self:_spawnPawnsInTestRoom(key)
    end


    -----------------------------
    -- [[ Private Functions ]] --
    -----------------------------
    function DebugSystem:_drawRanges()
        if not self.showRanges then return end

        for _, entity in ipairs(self.rangeEntities) do
            local combatProperties = entity:get('combatProperties')
            local position = entity:get('position')
            local dimensions = entity:get('dimensions')
            love.graphics.setLineWidth(2)
            love.graphics.setColor(1, 0, 0)
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
        local drawHitbox = function (hitbox)
            love.graphics.setColor(1, 0, 1)
            love.graphics.rectangle(
                'line',
                hitbox.position.x - hitbox.dimensions.width / 2,
                hitbox.position.y - hitbox.dimensions.height / 2,
                hitbox.dimensions.width,
                hitbox.dimensions.height
            )
        end
        for _, hitbox in ipairs(self.hitboxes) do
            drawHitbox({
                position = hitbox.position,
                dimensions = hitbox.dimensions
            })
        end
    end
    function DebugSystem:_spawnPawnsInTestRoom(key)
        if self.testRoom then
            local x,y = camera:getTranslatedMousePosition()
            if key == 't' then
                util.entityAssembler.assemble(
                    self:getWorld(),
                    'BasicTower',
                    x, y
                )
            elseif key == "r" then
                util.entityAssembler.assemble(
                    self:getWorld(),
                    'Knight',
                    x, y
                )
            end
        end
    end
    return DebugSystem
end
