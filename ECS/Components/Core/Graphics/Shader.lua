---@author Gage Henderson 2024-02-22 08:54
--
---@class Shader : Component
-- Define a shader to be applied to the entity when drawn.
--
-- ╭─────────────────────────────────────────────────────────╮
-- │ TODO: Actually  implement these.                        │
-- ╰─────────────────────────────────────────────────────────╯
--
---@field shader love.Shader
---@field update function(shader: love.Shader)

return function(concord)
    ---@param c Shader
    ---@param shaderCode string
    ---@param update function(shader: love.Shader)
    concord.component("shader", function(c, shaderCode, update)
        c.shader = love.graphics.newShader(shaderCode)
        c.update = update or function(shader) end
    end)
end
