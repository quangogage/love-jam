---@class mth
local mth = {}

---Get the distance between two points
function mth.getDistance(x1,y1,x2,y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

---Returns a number, from 0 to 1, flipped/mirrored over 0.5.
function mth.getMirroredNormalValue(val)
    return 0.5 - (val - 0.5)
end

---Linearly interpolates between a and b by t.
---@param a number 
---@param b number
---@param t number - Interpolation amount between 0 and 1
---@return number
function mth.lerp(a, b, t)
    return (1 - t) * a + t * b
end

function mth.angleDiff(a, b)
  local diff = math.abs(a - b)
  if diff > math.pi then
    if a > b then
      diff = diff - 2 * math.pi
    else
      diff = 2 * math.pi - diff
    end
  end
  return diff
end

function mth.shortestRotation(a, b)
  local diff = math.abs(a - b)
  if diff > math.pi then
    if a > b then
      return b + (math.pi * 2 - a)
    else
      return a + (math.pi * 2 - b)
    end
  end
  return b - a
end

return mth
