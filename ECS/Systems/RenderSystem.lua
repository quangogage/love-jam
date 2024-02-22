---@author Gage Henderson 2024-02-16 05:04
--
-- Attempts to render any entity with a position component.
-- Render behavior / what is rendered will depend on what other components the
-- entity may have.

local outlineShader = love.graphics.newShader(require('shaders.outlineShader'))
outlineShader:send('outlineWidth', 20)
outlineShader:send('outlineColor', { 0, 1, 0, 1 })

return function (concord)
    ---@class RenderSystem : System
    ---@field entities table[]
    local RenderSystem = concord.system({
        entities = { 'position' }
    })


    ----------------------------
    -- [[ Public Functions ]] --
    ----------------------------
    -- Render an entity from somewhere else.
    ---@param e table
    function RenderSystem:entity_render(e)
        self:_renderEntity(e)
    end

    --------------------------
    -- [[ Core Functions ]] --
    --------------------------
    function RenderSystem:draw()
        local sortedEntities = {}
        table.move(self.entities, 1, #self.entities, 1, sortedEntities)
        table.sort(sortedEntities, self._zIndexSort)
        for _, entity in ipairs(sortedEntities) do
            self:_renderEntity(entity)
        end
    end


    -----------------------------
    -- [[ Private Functions ]] --
    -----------------------------
    -- Render the entity.
    ---@param entity table
    function RenderSystem:_renderEntity(entity)
        if entity:get('renderRectangle') then
            self:_renderRectangle(entity)
        end
        if entity:get('image') then
            self:_renderImage(entity)
        end
    end

    -- Render a rectangle at the entity position.
    ---@param entity table
    function RenderSystem:_renderRectangle(entity)
        local color     = entity:get('color') or { r = 1, g = 1, b = 1 }
        local alpha     = entity:get('alpha') or 1
        local rectangle = entity:get('renderRectangle')
        love.graphics.setColor(color.r, color.g, color.b, alpha)
        love.graphics.rectangle('fill',
            entity.position.x - rectangle.width / 2,
            entity.position.y - entity.position.z - rectangle.height / 2,
            rectangle.width, rectangle.height
        )
    end

    -- Render an image at the entity position.
    ---@param entity table
    function RenderSystem:_renderImage(entity)
        local color     = entity:get('color') or { r = 1, g = 1, b = 1 }
        local alpha     = entity:get('alpha') or 1
        local image     = entity:get('image').value
        local offset    = entity:get('offset') or { x = 0.5, y = 0.5 }
        local scale     = entity:get('scale') or { x = 1, y = 1 }
        local rotation  = self:_getRotation(entity)
        love.graphics.setColor(color.r, color.g, color.b, alpha)
        love.graphics.draw(image,
            entity.position.x, entity.position.y - entity.position.z,
            rotation, scale.x, scale.y,
            image:getWidth() * offset.x, image:getHeight() * offset.y
        )
    end

    -- z-index emulation.
    ---@param a table
    ---@param b table
    ---@return boolean
    function RenderSystem._zIndexSort(a, b)
        if a.dimensions and b.dimensions then
            return a.position.y + a.dimensions.height / 2 < b.position.y + b.dimensions.height / 2
        end
        return a.position.y < b.position.y
    end

    -- Get the rotation of the entity.
    ---@param entity table
    ---@return number
    function RenderSystem:_getRotation(entity)
        if entity:get('rotation') then
            return entity:get('rotation').value
        end
        return 0
    end


    return RenderSystem
end
