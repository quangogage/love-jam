---@author Gage Henderson 2024-02-20 11:53
--
---@class GroundPositionSystem : System
-- Continously update where we consider an entity to be standing.
--
-- See the `GroundPosition` component.
--
-- By default is the pawns bottom middle, but can be offset.
--

return function (concord)
    local GroundPositionSystem = concord.system({
        entities = { 'groundPosition' }
    })


    function GroundPositionSystem:update()
        for _, entity in ipairs(self.entities) do
            local position = entity:get('position')
            local groundPosition = entity:get('groundPosition')
            local dimensions = entity:get('dimensions')

            groundPosition.x = position.x + groundPosition.offsetX
            groundPosition.y = position.y + dimensions.height / 2 + groundPosition.offsetY
        end
    end
    return GroundPositionSystem
end
