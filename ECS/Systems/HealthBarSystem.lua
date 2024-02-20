---@author Gage Henderson 2024-02-17 03:08
--
---@class HealthBarSystem : System
-- An extremely focused and simple system that draws a healthbar above
-- entities.

local BACKGROUND_COLOR = { 0.4, 0.4, 0.4 }
local FOREGROUND_COLOR = { 0, 1, 0 }
local HEIGHT           = 5
local WIDTH            = 50
local VERTICAL_OFFSET  = 10

return function (concord)
    local HealthBarSystem = concord.system({
        entities = { 'health', 'position' }
    })


    ----------------------------
    -- [[ Public Functions ]] --
    ----------------------------
    ---@param successfulAttack SuccessfulAttack
    function HealthBarSystem:event_damageDealt(successfulAttack)
        local target             = successfulAttack.target
        target.health.bar.hidden = false
        target.health.bar.timer  = 0
    end


    --------------------------
    -- [[ Core Functions ]] --
    --------------------------
    function HealthBarSystem:update(dt)
        for _, e in ipairs(self.entities) do
            e.health.bar.timer = e.health.bar.timer + dt
            if e.health.bar.timer > e.health.bar.duration then
                e.health.bar.hidden = true
            end
        end
    end

    --------------------------
    -- [[ Core Functions ]] --
    --------------------------
    function HealthBarSystem:draw()
        for _, e in ipairs(self.entities) do
            if not e.health.bar.hidden then
                local x = e.position.x - WIDTH / 2
                local y = e.position.y - e.dimensions.height / 2 - HEIGHT - VERTICAL_OFFSET
                local width = (e.health.value / e.health.max) * WIDTH
                local height = HEIGHT
                love.graphics.setColor(BACKGROUND_COLOR)
                love.graphics.rectangle('fill', x, y, WIDTH, height)
                love.graphics.setColor(FOREGROUND_COLOR)
                love.graphics.rectangle('fill', x, y, width, height)
            end
        end
    end
    return HealthBarSystem
end
