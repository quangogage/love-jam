---@author Gage Henderson 2024-02-16 11:35
--
---@class BasicTower : Tower
---@field color Color
---@field renderRectangle RenderRectangle

local TowerAssemblage = require('ECS.Assemblages.Towers.Tower')

return function (e, x, y)
    e
        :assemble(TowerAssemblage, x, y)
        :give('health', 100)
        :give('color', 1, 0, 0)
        :give('renderRectangle', 50, 100)
        :give('clickDimensions', 50, 100)
end
