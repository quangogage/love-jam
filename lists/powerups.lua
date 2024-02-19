---@author Gage Henderson 2024-02-18 09:15
--
-- Must have at least 3.
--
-- See `Classes.Scenes.CombatScene.PowerupSelectionMenu.PowerupSelectionMenu`

return {
    {
        name = "Fast Walker",
        description = "Move 20% faster",
        ---@param self table
        ---@param pawn BasicPawn | Pawn | table
        onPawnCreation = function(self, pawn)
            for _=1, self.count do
                pawn.movement.walkSpeed = pawn.movement.walkSpeed * 1.20
            end
            console:log("Increased speed")
        end
    },
    {
        name = "Bloodlust",
        description = "Deal 15% more damage"
    },
    {
        name = "Tough Skin",
        description = "Take 15% less damage"
    }
}
