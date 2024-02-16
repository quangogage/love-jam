---@class collision
---@diagnostic disable
local collision = {}

---Returns the coordiantes and dimensions of the intersection between two rectangles
---Expects rectangle's origins to be at their center.
function collision.getIntersectingRectangle(rect1, rect2)
    local rect1 = {
      position = {
        x = rect1.position.x - rect1.dimensions.width / 2,
        y = rect1.position.y - rect1.dimensions.height / 2,  
      },
      dimensions = {
        width = rect1.dimensions.width,
        height = rect1.dimensions.height
      }
    } 
    local rect2 = {
      position = {
        x = rect2.position.x - rect2.dimensions.width / 2,
        y = rect2.position.y - rect2.dimensions.height / 2
      },
      dimensions = {
        width = rect2.dimensions.width,
        height = rect2.dimensions.height
      }
    }
    local intersect = {
        x = math.max(rect1.position.x,rect2.position.x),
        y = math.max(rect1.position.y,rect2.position.y),
    }
    intersect.width = math.min(rect1.position.x + rect1.dimensions.width, rect2.position.x + rect2.dimensions.width) - intersect.x
    intersect.height = math.min(rect1.position.y + rect1.dimensions.height, rect2.position.y + rect2.dimensions.height) - intersect.y
    return intersect
end

---Returns true if the two rectangles are overlapping
---Assumes both rectangle's origins are at their center
function collision.rectanglesAreOverlapping(rect1,rect2)
    if rect1.position.x + rect1.dimensions.width / 2 > rect2.position.x - rect2.dimensions.width / 2 and
    rect1.position.x - rect1.dimensions.width / 2 < rect2.position.x + rect2.dimensions.width / 2 and
    rect1.position.y + rect1.dimensions.height / 2 > rect2.position.y - rect2.dimensions.height / 2 and
    rect1.position.y - rect1.dimensions.height / 2 < rect2.position.y + rect2.dimensions.height / 2 then
        return true
    end
    return false
end

---Check if a line is intersecting with a rectangle
---Expects a top-left origin point for the rectangle.
function collision.rectangleAndLineCollisionPoint(l,t,w,h, x1,y1,x2,y2)
    local dx, dy  = x2-x1, y2-y1

    local t0, t1  = 0, 1
    local p, q, r

    for side = 1,4 do
      if     side == 1 then p,q = -dx, x1 - l
      elseif side == 2 then p,q =  dx, l + w - x1
      elseif side == 3 then p,q = -dy, y1 - t
      else                  p,q =  dy, t + h - y1
      end

      if p == 0 then
        if q < 0 then return nil end  -- Segment is parallel and outside the bbox
      else
        r = q / p
        if p < 0 then
          if     r > t1 then return nil
          elseif r > t0 then t0 = r
          end
        else -- p > 0
          if     r < t0 then return nil
          elseif r < t1 then t1 = r
          end
        end
      end
    end

    local ix1, iy1, ix2, iy2 = x1 + t0 * dx, y1 + t0 * dy,
                               x1 + t1 * dx, y1 + t1 * dy

    if ix1 == ix2 and iy1 == iy2 then return ix1, iy1 end
    return ix1, iy1, ix2, iy2
end

---Get the nearest side and it's surfaceNormal given a position.
---@param position Vec2
---@param e Entity
---@return string, Vec2
function collision.getNearestSide(position,e)
    local sides = {
        left = {
            diff = math.abs(position.x - (e.position.x - e.dimensions.width / 2)),
            normal = {x = 1,y = 0}
        },
        right = {
            diff = math.abs(position.x - (e.position.x + e.dimensions.width / 2)),
            normal = {x = 1,y = 0}
        },
        top = {
            diff = math.abs(position.y - (e.position.y - e.dimensions.height / 2)),
            normal = {x = 0, y = 1}
        },
        bottom = {
            diff = math.abs(position.y - (e.position.y + e.dimensions.height / 2)),
            normal = {x = 0, y = 1}
        }
    }
    local shortestSide = "left"
    for side,values in pairs(sides) do
        if values.diff < sides[shortestSide].diff then
            shortestSide = side
        end
    end
    return shortestSide, sides[shortestSide].normal
end

---Check if one rectangle is entirely within the bounds of another.
---Origin points of rects should be centered.
---@param rect1 {x: number, y: number, width: number, height: number}
---@param rect2 {x: number, y: number, width: number, height: number}
function collision.rectangleIsWithinBounds(rect1,rect2)
    if rect1.x - rect1.width / 2 > rect2.x - rect2.width / 2 and
    rect1.x + rect1.width / 2 < rect2.x + rect2.width / 2 and
    rect1.y - rect1.height / 2 > rect2.y - rect2.height / 2 and
    rect1.y + rect1.height / 2 < rect2.y + rect2.height / 2 then
        return true
    end
    return false
end

return collision
