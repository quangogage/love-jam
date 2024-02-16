---@author Gage Henderson 2024-02-16 10:44
--
-- Issue commands to entities by clickin' stuff.
--

---@param concord table
---@param camera Camera
return function (concord, camera)
    ---@class PawnCommandSystem : System
    ---@field selectedEntities table[]
    ---@field targetableEntities table[]
    local PawnCommandSystem = concord.system({
        selectedEntities = { 'selected' },
        -- targetableEntities = { 'targetable' },
    })


    function PawnCommandSystem:mousepressed(_, _, button)
        local world = self:getWorld()
        if button == 2 and world then
            local x, y = camera:getTranslatedMousePosition()
            for _, e in ipairs(self.selectedEntities) do
                e:give("targetPosition", x, y)
            end
        end
    end

    return PawnCommandSystem
end
