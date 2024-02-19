---@author Gage Henderson 2024-02-19 13:43
--
-- Horrible name srry.
--

local FONT = love.graphics.newFont(fonts.sub, 20)

local Button = require("Classes.Elements.Button")

---@class PrimaryPauseMenu
---@field pauseMenu table
---@field eventManager EventManager
---@field active boolean
---@field elements Button[]
local PrimaryPauseMenu = Goop.Class({
    arguments = {"pauseMenu", "eventManager"},
    dynamic = {
        active = false,
        elements = {}
    },
})

function PrimaryPauseMenu:init()
    table.insert(self.elements, Button({
        text   = "RESUME",
        anchor = {x = 0.5, y = 0.5},
        offset = {x = 0, y = -100},
        font   = FONT,
        onClick = function()
            self.pauseMenu:close()
        end
    }))
    table.insert(self.elements, Button({
        text   = "SETTINGS",
        anchor = {x = 0.5, y = 0.5},
        offset = {x = 0, y = 0},
        font   = FONT,
        onClick = function()
            console:log("open settings here........")
        end
    }))
    table.insert(self.elements, Button({
        text   = "QUIT TO DESKTOP",
        anchor = {x = 0.5, y = 0.5},
        offset = {x = 0, y = 100},
        font   = FONT,
        onClick = function()
            love.event.quit()
        end
    }))
    table.insert(self.elements, Button({
        text   = "QUIT TO MAIN MENU",
        anchor = {x = 0.5, y = 0.5},
        offset = {x = 0, y = 200},
        font   = FONT,
        onClick = function()
            self.eventManager:broadcast("openMainMenu")
        end
    }))
    for _, el in ipairs(self.elements) do
        el.offset.x = el.offset.x - el.dimensions.width / 2
        el.offset.y = el.offset.y - el.dimensions.height / 2
    end
end
function PrimaryPauseMenu:update(dt)
    for _, el in ipairs(self.elements) do
        el:update(dt)
    end
end
function PrimaryPauseMenu:draw()
    for _, el in ipairs(self.elements) do
        el:draw()
    end
end
function PrimaryPauseMenu:keypressed(key)
    ---zzz.
end
function PrimaryPauseMenu:mousepressed(x, y, button)
    for _, el in ipairs(self.elements) do
        el:mousepressed(x, y, button)
    end
end

return PrimaryPauseMenu
