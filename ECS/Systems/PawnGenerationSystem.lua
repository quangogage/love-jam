---@author Gage Henderson 2024-02-17 04:06
--
--

local util = require('util')({ 'entityAssembler' })

return function (concord)
    ---@class PawnGenerationSystem : System
    ---@field entities Tower[] | table[]
    local PawnGenerationSystem = concord.system({
        entities = { 'pawnGeneration' }
    })


    --------------------------
    -- [[ Core Functions ]] --
    --------------------------
    function PawnGenerationSystem:update(dt)
        for _, e in ipairs(self.entities) do
            local gen = e.pawnGeneration
            gen.spawnTimer = gen.spawnTimer + dt
            if gen.spawnTimer >= gen.spawnRate then
                self:_spawnPawn(e)
                gen.spawnTimer = 0
            end
        end
    end


    -----------------------------
    -- [[ Private Functions ]] --
    -----------------------------
    -- Create a pawn.
    ---@param e Tower | table
    function PawnGenerationSystem:_spawnPawn(e)
        local world = self:getWorld()
        if world then
            util.entityAssembler.assemble(world,
                e.pawnGeneration.pawnType,
                e.position.x, e.position.y,
                e.friendly
            )
        end
    end

    return PawnGenerationSystem
end
