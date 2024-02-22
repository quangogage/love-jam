---@author Gage Henderson 2024-02-16 06:13
--
---@class Pawn : Entity
-- Uppermost entity for all characters.
---@field position Position
---@field movement Movement
---@field health Health
---@field physics Physics
---@field armor Armor

return function (e, x, y)
    e
        :give('position', x, y)
        :give('health', 10)
        :give('movement')
        :give('physics')
        :give('pushbackRadius')
        :give('groundPosition')
        :give('isPawn')
        :give('armor', 0)
        :give('coinValue', 0.5)
        :give("shader", require("shaders.rippleShader"), function(shader)
            shader:send('rippleIntensity', 1.5)
            shader:send('rippleSpeed', 0.5)
            shader:send('rippleFrequency', 20)
            shader:send('timeValue', love.timer.getTime())
        end)
end
