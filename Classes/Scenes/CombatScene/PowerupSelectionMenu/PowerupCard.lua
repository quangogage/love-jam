---@author Gage Henderson 2024-02-18 09:11
--
--

local WIDTH = 165
local HEIGHT = 300
local TEXT_PADDING = 15

---@class PowerupCard
---@field position {x: number, y: number}
---@field name string
---@field description string
local PowerupCard = Goop.Class({
    parameters = {
        {"position", "table"},
        {"name", "string"},
        {"description", "string"}
    },
})


--------------------------
-- [[ Core Functions ]] --
--------------------------
function PowerupCard:update()
end
function PowerupCard:draw()
    love.graphics.setColor(1,1,1)
    love.graphics.setLineWidth(1)
    love.graphics.rectangle("line", self.position.x, self.position.y, WIDTH, HEIGHT)
end


-----------------------------
-- [[ Private Functions ]] --
-----------------------------
function PowerupCard:_printName()
end

return PowerupCard

