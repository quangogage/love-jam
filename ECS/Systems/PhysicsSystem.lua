---@author Gage Henderson 2024-02-16 06:29
--
---@class PhysicsSystem : System
--

return function(concord)
    local PhysicsSystem = concord.system({
        entities = {'physics', 'position'}
    })


    --------------------------
    -- [[ Core Functions ]] --
    --------------------------
    function PhysicsSystem:update(dt)
        for _,e in ipairs(self.entities) do
            self:_applyVelocity(e, dt)
            self:_applyFriction(e, dt)
        end
    end


    -----------------------------
    -- [[ Private Functions ]] --
    -----------------------------
    ---@param e table
    function PhysicsSystem:_applyVelocity(e, dt)
        local velocity = e.physics.velocity
        local position = e.position

        position.x = position.x + velocity.x * dt
        position.y = position.y + velocity.y * dt
    end

    ---@param e table
    function PhysicsSystem:_applyFriction(e, dt)
        local velocity = e.physics.velocity
        local friction = e.physics.friction

        velocity.x = velocity.x * (1 - math.min(friction * dt, 1))
        velocity.y = velocity.y * (1 - math.min(friction * dt, 1))
    end

    return PhysicsSystem
end
