---@author Gage Henderson datetime
--
---@class LoseMenu
-- Pops up when you lose!

local Button = require("Classes.Elements.Button")
local Text = require("Classes.Elements.Text")

local LoseMenu = Goop.Class({
    arguments = {
        { "eventManager", "table" }
    },
    dynamic = {
        background = {
            alpha = 0,
        },
        title = {
            font = love.graphics.newFont(fonts.title, 45),
            anchor = {x = 0.5, y = 0.2},
        }
    }
})

----------------------------
-- [[ Public Functions ]] --
----------------------------
function LoseMenu:open()
    self.background.alpha = 0.9
    self.active = true
end
function LoseMenu:close()
    self.background.alpha = 0
    self.active = false
end


--------------------------
-- [[ Core Functions ]] --
--------------------------
function LoseMenu:init()
    self:_generateElements()
end
---@return boolean
function LoseMenu:update(dt)
    local hovered = false
    for _,el in ipairs(self.elements) do
        if el.hovered and el.type ~= "Text" then
            hovered = true
        end
        el:update(dt)
    end
    return hovered
end
function LoseMenu:draw()
    if self.active then
        self:_drawBackground()
        for _,el in ipairs(self.elements) do
            el:draw()
        end
        self:_printTitle()
    end
end
function LoseMenu:mousepressed(x,y,button)
    if self.active then
        for _,el in ipairs(self.elements) do
            el:mousepressed(x,y,button)
        end
    end
end


-----------------------------
-- [[ Private Functions ]] --
-----------------------------
function LoseMenu:_generateElements()
    self.elements = {
        Button({
            text = "Retry",
            anchor = {x = 0.5, y = 0.5},
            onClick = function()
                self.eventManager:broadcast("restart")
            end
        }),
        Button({
            text = "Quit to Menu",
            anchor = {x = 0.5, y = 0.5},
            offset = {x = 0, y = 50},
            onClick = function()
                self.eventManager:broadcast("openMainMenu")
            end
        }),
    }
end
function LoseMenu:_drawBackground()
    love.graphics.setColor(0,0,0,self.background.alpha)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
end
function LoseMenu:_printTitle()
    love.graphics.setFont(self.title.font)
    love.graphics.setColor(1,1,1)
    love.graphics.print("You Lose!",
        love.graphics.getWidth() * self.title.anchor.x,
        love.graphics.getHeight() * self.title.anchor.y
    )
end


return LoseMenu
