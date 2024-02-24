---@author Gage Henderson 2024-02-24 09:26
--
---@class CollisionSystem : System
--

return function(concord)
    local CollisionSystem = concord.system({ 
        dynamic = { "dynamicCollisionBehavior", "position", "collision" },
        static  = { "staticCollisionBehavior", "position", "collision" }
    })

    function CollisionSystem:update()
        for _, e1 in ipairs(self.dynamic) do
            for _, e2 in ipairs(self.static) do
                local e1Circle = {
                    position = e1:get('groundPosition') or e1:get('position'),
                    radius   = e1:get('collision').radius
                }
                local e2Circle = {
                    position = e2:get('groundPosition') or e2:get('position'),
                    radius   = e2:get('collision').radius
                }
                local dx = e1Circle.position.x - e2Circle.position.x
                local dy = e1Circle.position.y - e2Circle.position.y
                local distance = math.sqrt(dx * dx + dy * dy)

                if distance < e1Circle.radius + e2Circle.radius then
                    e1.position.x = e1.position.x + dx / distance * (e1Circle.radius + e2Circle.radius - distance)
                    e1.position.y = e1.position.y + dy / distance * (e1Circle.radius + e2Circle.radius - distance)
                end
            end
        end
    end

    return CollisionSystem
end
