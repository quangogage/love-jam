---@author Gage Henderson 2024-02-17 04:06
--
-- Handles generating pawns from towers.
--
-- Right now only enemies can have towers, but I've tried to keep things general
-- enough that we could have friendly towers in the future.
--
--
-- Disables all generation until the player has issued their first command.
--

local util = require('util')({ 'entityAssembler' })

return function (concord)
    ---@class PawnGenerationSystem : System
    ---@field entities Tower[] | table[]
    ---@field playerHasCommanded boolean
    local PawnGenerationSystem = concord.system({
        entities = { 'pawnGeneration' }
    })


    ----------------------------
    -- [[ Public Functions ]] --
    ----------------------------
    function PawnGenerationSystem:event_newLevel()
        self:_spawnInitialPawns()
        self.playerHasCommanded = false
    end
    function PawnGenerationSystem:event_playerCommand()
        self.playerHasCommanded = true
    end

    --------------------------
    -- [[ Core Functions ]] --
    --------------------------
    function PawnGenerationSystem:update(dt)
        if self.playerHasCommanded then
            for _, e in ipairs(self.entities) do
                local gen = e.pawnGeneration
                gen.spawnTimer = gen.spawnTimer + dt
                if gen.spawnTimer >= gen.spawnRate then
                    self:_spawnPawn(e)
                    gen.spawnTimer = 0
                end
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
            local friendlyBase = world.friendlyBase
            local angle = math.atan2(friendlyBase.position.y - e.position.y, friendlyBase.position.x - e.position.x)
            local distance = 150
            local newPawn = util.entityAssembler.assemble(world,
                e.pawnGeneration.pawnType,
                e.position.x + math.cos(angle) * distance,
                e.position.y + math.sin(angle) * distance,
                e.friendly
            )
            world:emit("event_pawnSpawned", newPawn)
        end
    end

    -- Spawn the initial pawns.
    function PawnGenerationSystem:_spawnInitialPawns()
        for _, e in ipairs(self.entities) do
            self:_spawnPawn(e)
        end
    end

    return PawnGenerationSystem
end
