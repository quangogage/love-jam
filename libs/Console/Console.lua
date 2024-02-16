---@author Gage Henderson 2023-10-26 18:06
-- 
---@class Console
---@field messages ConsoleMessages
---@field input ConsoleInput
---@field world table - Should be attached manually.
-- A singleton class that handles a live console that you can access in-game.
-- The primary purpose is to be able to print out debug information for convenience,
-- and also input world events through text input.
-- 
-- Externally set the `console.rooms` parameter to 
-- enable the ability to execute world emissions from the console.
-- 
local Console         = Goop.Class({
    dynamic = {}
})
local commands        = require("lists.consoleCommands")
local ConsoleMessages = require("libs.Console.ConsoleMessages")
local ConsoleInput    = require("libs.Console.ConsoleInput")

----------------------------
-- [[ Public Functions ]] --
----------------------------
-- Log a message to the console.
-- Also prints it out.
---@param message string
function Console:log(message)
    self.messages:addMessage(message)
    print(message)
end

-- Attempt to execute a command.
-- Broadcasts the command as a world emission to all rooms.
-- As of right now this only works for commands that take no arguments.
---@param input string
function Console:executeCommand(input)
    local msg           = ""
    local args          = {}
    local inputCommand  = input:match("%S+")
    local commandRef    = self:getCommand(inputCommand)
    local i = 1 ---Ignore the first arg (which is the command itself).

    ---Get the arguments.
    for arg in input:gmatch("%S+") do
        if i ~= 1 then
            table.insert(args, arg)
        end
        i = i + 1
    end

    if commandRef then -- If the command is registered in commandList
        -- Execute custom function or emit world event.
        if commandRef.customFunction and self.world then
            msg = commandRef.customFunction(self.world,unpack(args))
        elseif self.world then
            self.world:emit(inputCommand,unpack(args))
            msg = commandRef.successMessage
        end
    elseif not commandRef then
        -- Command isn't registered in commandList.
        msg = "Command '" .. inputCommand .. "' does not exist."
    end
    if msg then
        self:log(msg)
    end
end

-- Execute launch options.
function Console:launchOptions()
    local options = require("LAUNCH_OPTIONS")
    for _,option in ipairs(options) do
        self:executeCommand(option)
    end
end


--------------------------
-- [[ Core Functions ]] --
--------------------------
function Console:init()
    self.messages = ConsoleMessages()
    self.input    = ConsoleInput({executeCommand = function(command) self:executeCommand(command) end})
end
function Console:update(dt)
    self.messages:update(dt)
end
function Console:draw()
    self.messages:draw()
    self.input:draw()
end
function Console:keypressed(key)
    self.input:keypressed(key)
end


-----------------------------
-- [[ Private Functions ]] --
-----------------------------
-- Check if a command exists.
---@param command string
---@return table
function Console:getCommand(command)
    return commands[command]
end


return Console
