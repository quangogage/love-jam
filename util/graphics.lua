local graphics = {}

-- Given an image and dimensions, determine what scaling would need to
-- be applied to the image in order for it to match those dimensions.
---@param image any
---@param width number
---@param height number
function graphics.getScaleForDimensions(image, width, height)
    local imageWidth, imageHeight = image:getDimensions()
    return {x = width / imageWidth, y = height / imageHeight}
end

-- Draw an image repeating over the boundaries.
-- Can rotate around origin point.
-- Origin point is centered.
---@param image any
---@param x number
---@param y number
---@param rotation number
---@param width number
---@param height number
---@param tileSize number
function graphics.drawTiled(image, x, y, rotation, width, height, tileSize)
    local scale = {
        x = tileSize / image:getWidth(),
        y = tileSize / image:getHeight()
    }
    local cols = math.floor(width / tileSize) - 1
    local rows = math.floor(height / tileSize) - 1
    for col = 0, cols do
        for row = 0, rows do
            local tileX = x + tileSize / 2 + col * tileSize
            local tileY = y + tileSize / 2 + row * tileSize
            love.graphics.draw(image, tileX, tileY, rotation, scale.x, scale.y, image:getWidth() / 2, image:getHeight() / 2)
        end
    end
end

-- z-index emulation.
---@param a table
---@param b table
function graphics.zIndexSort(a, b)
    return a.position.y < b.position.y
end

return graphics
