---@author Gage Henderson 2024-02-24 10:20
--
---@class DeleteOOBSystem : System
--

return function (concord)
    local DeleteOOBSystem = concord.system({
        entities = { 'position', 'deleteOOB' }
    })


    function DeleteOOBSystem:update()
        local world = self:getWorld()
        if world then
            for _, e in ipairs(self.entities) do
                if e.position.x < world.bounds.x or
                e.position.x > world.bounds.x + world.bounds.width or
                e.position.y < world.bounds.y or
                e.position.y > world.bounds.y + world.bounds.height then
                    e:destroy()
                end
            end
        end
    end

    return DeleteOOBSystem
end
