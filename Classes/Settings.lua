---@author Gage Henderson 2024-02-19 21:43
--

---@class Settings
---@field cameraWASDMoveSpeed number
---@field cameraPushMoveSpeed number
---@field cameraPanSpeed number
---@field resolution table[{number,number}]
---@field fullscreen boolean
---@field vsync boolean
---@field resolutions table[{number,number}]
---@field sound table
local Settings = Goop.Class({
    static = {
        cameraWASDMoveSpeed = 6600,
        cameraPushMoveSpeed = 2000,
        cameraPanSpeed      = 10,
        resolution          = { 1280, 720 },
        fullscreen          = false,
        vsync               = false,
        resolutions         = {
            { 1280, 720 },
            { 1920, 1080 },
            { 2560, 1440 },
            { 3840, 2160 }
        },
        sound               = {
            masterVolume = 1,
            sfxVolume    = 0.25,
            musicVolume  = 1
        }
    }
})


----------------------------
-- [[ Public Functions ]] --
---------------------------
---@param width number
---@param height number
function Settings:setResolution(width, height)
    love.window.setMode(width, height, { fullscreen = false, vsync = self.vsync })
    self.resolution = { width, height }
    self:_saveSettings()
end

-- Worst code in the entire game.
function Settings:mute()
    self.muted = true
    love.audio.setVolume(0)
    self:_saveSettings()
end
function Settings:unmute()
    self.muted = false
    love.audio.setVolume(1)
    self:_saveSettings()
end

---@param volumeType string
---@return number
function Settings:getVolume(volumeType)
    if volumeType == 'master' then
        return self.sound.masterVolume
    else
        return self.sound[volumeType .. 'Volume'] * self.sound.masterVolume
    end
end


--------------------------
-- [[ Core Functions ]] --
--------------------------
-- Called before anything in love.load
function Settings:load()
    self:_removeInvalidResolutions()
    self:_attemptLoadSettings()
end


-----------------------------
-- [[ Private Functions ]] --
-----------------------------
-- Get rid of resolutions larger than this desktop.
function Settings:_removeInvalidResolutions()
    local desktopWidth, desktopHeight = love.window.getDesktopDimensions()
    local resolutions = self.resolutions
    for i = #resolutions, 1, -1 do
        local res = resolutions[i]
        if res[1] > desktopWidth or res[2] > desktopHeight then
            table.remove(resolutions, i)
        end
    end
end

function Settings:_attemptLoadSettings()
    local savedSettings = love.filesystem.load('settings.lua')
    if savedSettings then
        for key, value in pairs(savedSettings()) do
            self[key] = value
        end
        love.window.setMode(self.resolution[1], self.resolution[2], { fullscreen = self.fullscreen, vsync = self.vsync })
        if self.muted then
            love.audio.setVolume(0)
        else
            love.audio.setVolume(1)
        end
    else
        -- Set to the highest available resolution.
        self:setResolution(self.resolutions[#self.resolutions][1], self.resolutions[#self.resolutions][2])
        self:_saveSettings()
    end
end

function Settings:_saveSettings()
    local settings = 'return {\n'
    for key, value in pairs(self) do
        if type(value) == 'number' then
            settings = settings .. '    ' .. key .. ' = ' .. value .. ',\n'
        elseif type(value) == 'table' then
            settings = settings .. '    ' .. key .. ' = { ' .. value[1] .. ', ' .. value[2] .. ' },\n'
        elseif type(value) == 'boolean' then
            settings = settings .. '    ' .. key .. ' = ' .. tostring(value) .. ',\n'
        end
    end
    settings = settings .. '}'
    love.filesystem.write('settings.lua', settings)
end


return Settings
