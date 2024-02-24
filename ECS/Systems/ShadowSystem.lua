---@author Gage Henderson datetime
--
---@class ShadowSystem : System
--

local ALPHA = 0.2

return function(concord)
    local ShadowSystem = concord.system({
        entities = { 'shadow', 'groundPosition' }
    })



    function ShadowSystem:drawBelow()
        for _,e in ipairs(self.entities) do
            love.graphics.setColor(0,0,0,ALPHA)
            love.graphics.circle('fill', e.groundPosition.x, e.groundPosition.y, e.shadow.size)
        end
    end

    return ShadowSystem
end
