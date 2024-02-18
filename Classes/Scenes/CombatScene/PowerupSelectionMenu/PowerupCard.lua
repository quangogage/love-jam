---@author Gage Henderson 2024-02-18 09:11
--
--

local TEXT_PADDING     = 15
local NAME_FONT        = love.graphics.newFont('assets/fonts/BebasNeue-Regular.ttf', 34)
local DESCRIPTION_FONT = love.graphics.newFont('assets/fonts/RobotoCondensed-Light.ttf', 24)

---@class PowerupCard
---@field position {x: number, y: number}
---@field name string
---@field description string
---@field selected boolean
---@field width number
---@field height number
local PowerupCard = Goop.Class({
    parameters = {
        {"position", "table"},
        {"name", "string"},
        {"description", "string"}
    },
    static = {
        width = 300,
        height = 450
    }
})


----------------------------
-- [[ Public Functions ]] --
----------------------------
function PowerupCard:select()
    self.selected = true
end
function PowerupCard:unselect()
    self.selected = false
end

--------------------------
-- [[ Core Functions ]] --
--------------------------
function PowerupCard:init()
    self.position.x = self.position.x - self.width / 2
    self.position.y = self.position.y - self.height / 2
end
function PowerupCard:update()
end
function PowerupCard:draw()
    love.graphics.setColor(1,1,1)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", self.position.x, self.position.y, self.width, self.height)
    if self.selected then
        love.graphics.setColor(0,1,0,0.5)
        love.graphics.rectangle("fill", self.position.x, self.position.y, self.width, self.height)
    end
    local y = self.position.y + TEXT_PADDING
    y = self:_printName(y)
    y = self:_printDescription(y)
end


-----------------------------
-- [[ Private Functions ]] --
-----------------------------
function PowerupCard:_printName(y)
    love.graphics.setColor(1,1,1)
    love.graphics.setFont(NAME_FONT)
    love.graphics.printf(self.name, self.position.x + TEXT_PADDING/2, y, self.width - TEXT_PADDING, "center")
    return y + NAME_FONT:getHeight()
end

function PowerupCard:_printDescription(y)
    love.graphics.setColor(1,1,1)
    love.graphics.setFont(DESCRIPTION_FONT)
    love.graphics.printf(self.description, self.position.x + TEXT_PADDING/2, y, self.width - TEXT_PADDING, "center")
    return y + DESCRIPTION_FONT:getHeight()
end

return PowerupCard

