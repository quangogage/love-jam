local geo = {}

---Draw a polygon rectangle that can be rotated
function geo.drawRotatedRectangle(position,dimensions,rotation,anchorPoint)
  local x = position.x
  local y = position.y
  local anchorX = anchorPoint.x
  local anchorY = anchorPoint.y

  local halfWidth = dimensions.width / 2
  local halfHeight = dimensions.height / 2

  local topLeftX = -halfWidth
  local topLeftY = -halfHeight

  local topRightX = halfWidth
  local topRightY = -halfHeight

  local bottomRightX = halfWidth
  local bottomRightY = halfHeight

  local bottomLeftX = -halfWidth
  local bottomLeftY = halfHeight
  
  local cos = math.cos(rotation)
  local sin = math.sin(rotation)
  local ax = anchorX - x
    local ay = anchorY - y

    local transformedPoints = {
        x + (ax - halfWidth) * cos - (ay - halfHeight) * sin, y + (ax - halfWidth) * sin + (ay - halfHeight) * cos,
        x + (ax + halfWidth) * cos - (ay - halfHeight) * sin, y + (ax + halfWidth) * sin + (ay - halfHeight) * cos,
        x + (ax + halfWidth) * cos - (ay + halfHeight) * sin, y + (ax + halfWidth) * sin + (ay + halfHeight) * cos,
        x + (ax - halfWidth) * cos - (ay + halfHeight) * sin, y + (ax - halfWidth) * sin + (ay + halfHeight) * cos
    }
  love.graphics.polygon("fill",transformedPoints)
end

return geo
