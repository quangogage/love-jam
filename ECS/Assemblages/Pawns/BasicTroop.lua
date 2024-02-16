---@author Gage Henderson 2024-02-16 06:19
--
---@class BasicTroop : Pawn
--

local CharacterAssemblage = require('ECS.Assemblages.Pawns.Pawn')

return function (e, x, y)
    e
        :assemble(CharacterAssemblage, x, y)
        :give('health', 10)
        :give('renderRectangle', 25,50)
end
