---@author Gage Henderson 2024-02-16 15:44
--
---@class DebugSystem : System
-- Misc debug functionality.
-- Some functions can be called via console commands.
--

local util = require("util")({ "entityAssembler" })

return function (concord, camera, onLevelComplete, coinManager)
    local DebugSystem = concord.system({
        rangeEntities = { 'combatProperties', 'position', 'groundPosition' },
        hitboxes = { 'position', 'dimensions', 'groundPosition' },
        hostileEntities = { 'hostile' },
        targetingEntities = { 'target' }
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
            -- self:getWorld():emit('event_pawnDied', entity)
            entity:destroy()
        end
        self.testRoom = true
        console:log('Killed all enemies')
    end
    function DebugSystem:completeLevel()
        onLevelComplete()
    end
    function DebugSystem:motherlode()
        coinManager:addCoins(1000000)
    end
    function DebugSystem:toggleFriendlyTargets()
        self.showFriendlyTargets = not self.showFriendlyTargets
    end


    --------------------------
    -- [[ Core Functions ]] --
    --------------------------
    function DebugSystem:init()
        self.showRanges          = false
        self.showHitboxes        = false
        self.showFriendlyTargets = false
    end
    function DebugSystem:draw()
        self:_drawRanges()
        self:_drawHitboxes()
        self:_drawFriendlyTargets()
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
            local position = entity:get('groundPosition')
            local dimensions = entity:get('dimensions')
            love.graphics.setLineWidth(2)
            love.graphics.setColor(1, 0, 0)
            love.graphics.circle(
                'line',
                position.x,
                position.y,
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
            if hitbox.pushbackRadius then
                love.graphics.circle(
                    'line',
                    hitbox.groundPosition.x,
                    hitbox.groundPosition.y,
                    hitbox.pushbackRadius.value
                )
            end
        end
    end
    function DebugSystem:_spawnPawnsInTestRoom(key)
        if self.testRoom then
            local x,y = camera:getTranslatedMousePosition()
            if key == "t" then
                util.entityAssembler.assemble(
                    self:getWorld(),
                    'RangedEnemy',
                    x, y
                )
            end
        end
    end

    function DebugSystem:_drawFriendlyTargets()
        if self.showFriendlyTargets then
            for _,e in ipairs(self.targetingEntities) do
                if e.target and e.friendly then
                    if e.target.entity then
                        love.graphics.setColor(0,0,1,0.5)
                        love.graphics.circle("fill",
                            e.position.x, e.position.y, 75
                        )
                        love.graphics.setColor(1,0,1)
                        love.graphics.line(
                            e.position.x, e.position.y,
                            e.target.entity.position.x, e.target.entity.position.y
                        )
                    end
                end
            end
        end
    end
    return DebugSystem
end
