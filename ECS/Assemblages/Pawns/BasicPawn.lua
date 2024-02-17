---@author Gage Henderson 2024-02-16 06:19
--
---@class BasicPawn : Pawn
--

local CharacterAssemblage = require('ECS.Assemblages.Pawns.Pawn')

---@param e Entity
---@param x number
---@param y number
---@param friendly boolean
return function (e, x, y, friendly)
    e
        :assemble(CharacterAssemblage, x, y)
        :give('health', 5)
        :give('renderRectangle', 25, 50)
        :give('dimensions', 25, 50)
        :give("combatProperties", "melee", {
            damageAmount = 1,
            attackSpeed = 1,
            range = 50
        })

    if friendly then
        e:give('friendly')
        e:give("color", 1, 1, 1)
    else
        e:give('hostile')
        e:give("color", 1, 0.1, 0.1)
    end
end
