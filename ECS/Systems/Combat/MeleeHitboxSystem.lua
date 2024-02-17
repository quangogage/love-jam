---@author Gage Henderson 2024-02-16 16:37
--
---@class MeleeHitboxSystem : System
-- Handles collision detection between melee hitboxes and their target entities.
--

return function(concord)
    local MeleeHitboxSystem = concord.system({
        hitboxes = {"position", "meleeHitbox"}
    })

    --------------------------
    -- [[ Core Functions ]] --
    --------------------------
    function MeleeHitboxSystem:update(dt)
        local destroyHitboxes = {}
        for i=#self.hitboxes, 1, -1 do
            local hitbox = self.hitboxes[i]
            local hitboxRect = {
                x      = hitbox.position.x,
                y      = hitbox.position.y,
                width  = hitbox.meleeHitbox.width,
                height = hitbox.meleeHitbox.height
            }
            for _, target in ipairs(hitbox.meleeHitbox.targetEntities) do
                local targetRect = {
                    x      = target.position.x,
                    y      = target.position.y,
                    width  = target.dimensions.width,
                    height = target.dimensions.height
                }
                if hitboxRect.x + hitboxRect.width / 2 > targetRect.x - targetRect.width / 2 and
                hitboxRect.x - hitboxRect.width / 2 < targetRect.x + targetRect.width / 2 and
                hitboxRect.y + hitboxRect.height / 2 > targetRect.y - targetRect.height / 2 and
                hitboxRect.y - hitboxRect.height / 2 < targetRect.y + targetRect.height / 2 then
                    console:log("hitbox hit target")
                    -- TODO: Deal damage!
                    table.insert(destroyHitboxes, hitbox)
                    break
                end
            end
        end
        for _, hitbox in ipairs(destroyHitboxes) do
            hitbox:destroy()
        end
    end

    return MeleeHitboxSystem
end
