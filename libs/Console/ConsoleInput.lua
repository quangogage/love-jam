---@author Gage Henderson 2023-10-26 22:08
-- 
---@class ConsoleInput
-- Handles logic for and rendering of text input for the console.

local modifierKeys = {
    "lctrl",
    "rctrl",
    "rgui",
    "lgui"
}
local comboKeys = {
    ["1"] = "!",
    ["2"] = "@",
    ["3"] = "#",
    ["4"] = "$",
    ["5"] = "%",
    ["6"] = "^",
    ["7"] = "&",
    ["8"] = "*",
    ["9"] = "(",
    ["0"] = ")",
    ["-"] = "_",
    ["="] = "+",
    ["["] = "{",
    ["]"] = "}",
    ["\\"] = "|",
    [";"] = ":",
    ["'"] = "\"",
    [","] = "<",
    ["."] = ">",
    ["/"] = "?",
    ["`"] = "~",
}

local ConsoleInput = Goop.Class({
    parameters = {
        {"executeCommand","function"}
    },
    dynamic = {
        toggleKey = "`",
        active    = false,
        command   = "",
        color     = {1,1,1,1},
        font      = love.graphics.newFont(12)
    }
})


--------------------------
-- [[ Core Functions ]] --
--------------------------
function ConsoleInput:draw()
    love.graphics.setColor(self.color)
    love.graphics.setFont(self.font)
    love.graphics.print(self.command, 15, love.graphics.getHeight() - self.font:getHeight())
end
function ConsoleInput:keypressed(key)
    if self.active then
        self:_handleInput(key)
    end
    if key == self.toggleKey then self.active = not self.active; self.command = "" end ---Toggle
end

-----------------------------
-- [[ Private Functions ]] --
-----------------------------
-- Handles keyboard input if the consoleinput is active.
---@param key string
function ConsoleInput:_handleInput(key)

    if key == "enter" or key == "return" then
        self.executeCommand(self.command)
        self.command = ""
    elseif key == "backspace" or key == "delete" then
        self.command = self.command:sub(1, -2)
    elseif key == "escape" then
        self.active  = false
        self.message = ""
    elseif key == "space" then
        self.command = self.command .. " "
    elseif not self:_isModifierKey(key) and key ~= "lshift" and key ~= "rshift" then
        if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
            if comboKeys[key] then
                self.command = self.command .. comboKeys[key]
            else
                self.command = self.command .. key:upper()
            end
        elseif not love.keyboard.isDown("lctrl") and not love.keyboard.isDown("rctrl") then
            self.command = self.command .. key
        end
    end
end


-- Check if a key is a modifier key.
---@param key string
function ConsoleInput:_isModifierKey(key)
    for _,v in ipairs(modifierKeys) do
        if key == v then return true end
    end
    return false
end
return ConsoleInput
