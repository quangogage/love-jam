---@author Gage Henderson 2024-02-16 05:04
--
-- Attempts to render any entity with a position component.
-- Render behavior / what is rendered will depend on what other components the
-- entity may have.

return function(concord)
    ---@class RenderSystem : System
    ---@field entities table[]
    local RenderSystem = concord.system({
        entities = {"position"}
    })


    --------------------------
    -- [[ Core Functions ]] --
    --------------------------
    function RenderSystem:draw()
        for _, entity in ipairs(self.entities) do
            self:_renderEntity(entity)
        end
    end


    -----------------------------
    -- [[ Private Functions ]] --
    -----------------------------
    -- Render the entity.
    ---@param entity table
    function RenderSystem:_renderEntity(entity)
        if entity:get("renderRectangle") then
            self:_renderRectangle(entity)
        end
    end

    -- Render a rectangle at the entity position.
    ---@param entity table
    function RenderSystem:_renderRectangle(entity)
        local color     = entity:get("color") or {r     = 255, g = 255, b = 255}
        local alpha     = entity:get("alpha") or 255
        local rectangle = entity:get("renderRectangle")
        love.graphics.setColor(color.r, color.g, color.b, alpha)
        love.graphics.rectangle("fill",
            entity.position.x - rectangle.width / 2,
            entity.position.y - rectangle.height / 2,
            rectangle.width, rectangle.height
        )
    end


    return RenderSystem
end
