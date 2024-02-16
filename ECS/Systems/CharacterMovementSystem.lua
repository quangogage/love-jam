---@author Gage Henderson 2024-02-16 07:44
--
--
-- Facilitates moving characters around the map.
--
-- ──────────────────────────────────────────────────────────────────────
-- We store the entities that are currently moving in the `movingEntities`,
-- rather than looping through all entities with a movement component just
-- to save some performance.
-- ──────────────────────────────────────────────────────────────────────

local Vec2 = require('Classes.Types.Vec2')

return function (concord)
    ---@class CharacterMovementSystem : System
    ---@field movingEntities Character[]
    local CharacterMovementSystem = concord.system({})


    ----------------------------
    -- [[ Public Functions ]] --
    ----------------------------
    -- Attempt to make the character move towards the provided location.
    ---@param e table The character to move.
    ---@param x number The x coordinate to move towards.
    ---@param y number The y coordinate to move towards.
    function CharacterMovementSystem:character_moveTowards(e, x, y)
        if e then
            if e:get('movement') then
                if not self:_entityIsAlreadyMoving(e) then
                    table.insert(self.movingEntities, e)
                end
                e.movement.targetLocation = Vec2(x, y)
            end
        end
    end


    --------------------------
    -- [[ Core Functions ]] --
    --------------------------
    function CharacterMovementSystem:init()
        self.movingEntities = {}
    end
    function CharacterMovementSystem:update(dt)
        for i=#self.movingEntities, 1, -1 do
            local e = self.movingEntities[i]
            self:_moveEntity(e, dt)
            self:_checkIfEntityHasReachedTarget(i, e)
        end
    end


    --------------------------
    -- [[ Core Functions ]] --
    --------------------------
    -- Check if a character is already moving (if they are already in the
    -- movingEntities list).
    ---@param e Character
    ---@return boolean
    function CharacterMovementSystem:_entityIsAlreadyMoving(e)
        for _, entity in ipairs(self.movingEntities) do
            if entity == e then
                return true
            end
        end
        return false
    end


    -- Move a character towards their target location.
    ---@param e Character
    ---@param dt number
    function CharacterMovementSystem:_moveEntity(e, dt)
        local world = self:getWorld()
        local movement = e.movement
        local targetLocation = movement.targetLocation
        local angle = math.atan2(
            targetLocation.y - e.position.y,
            targetLocation.x - e.position.x
        )
        if world then
            world:emit("physics_applyForce", e,
                math.cos(angle) * movement.walkSpeed,
                math.sin(angle) * movement.walkSpeed
            )
        end
    end

    -- Check if a character has reached their target location.
    -- If they have, remove them from the movingEntities list.
    ---@param i number
    ---@param e Character
    function CharacterMovementSystem:_checkIfEntityHasReachedTarget(i, e)
        local movement = e.movement
        local targetLocation = movement.targetLocation
        local distance = math.sqrt(
            (targetLocation.x - e.position.x) ^ 2 +
            (targetLocation.y - e.position.y) ^ 2
        )
        if distance < 5 then
            table.remove(self.movingEntities, i)
        end
    end
    return CharacterMovementSystem
end
