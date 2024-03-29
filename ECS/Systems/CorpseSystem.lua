---@author Gage Henderson 2024-02-21 06:08
--
---@class CorpseSystem : System
-- Makes creating corpses as simple as one function call.
--
-- Handles the corpse canvas.
--


local COLOR = {0.6,0.6,0.6}
local util = require('util')({ 'entityAssembler' })

return function (concord)
    local CorpseSystem = concord.system()


    ----------------------------
    -- [[ Public Functions ]] --
    ----------------------------
    function CorpseSystem:event_newLevel()
        local world = self:getWorld()
        self.canvas = love.graphics.newCanvas(
            world.bounds.width,
            world.bounds.height
        )
    end

    ---@param e BasicPawn | Pawn | table
    function CorpseSystem:entity_createCorpse(e)
        local world = self:getWorld()
        if e.pawnAnimations and world then
            if not e.pawnAnimations.dead then error('No dead animation found for entity') end
            local scale = e.scale or { x = 1, y = 1 }
            local offset = e.offset or { x = 0.5, y = 0.5 }
            local deadAnimation = e.pawnAnimations.dead[e.pawnAnimations.direction]
            deadAnimation.framerate = e.pawnAnimations.dead.framerate
            util.entityAssembler.assemble(self:getWorld(), 'AnimatedEffect',
                { x = e.position.x, y = e.position.y },
                {
                    defaultAnimation = {
                        name = 'dead',
                        playOnce = true
                    },
                    list = {
                        dead = {
                            frames = e.pawnAnimations.dead[e.pawnAnimations.direction],
                            framerate = e.pawnAnimations.dead.framerate,
                        }
                    }
                },
                {
                    scale = { x = scale.x, y = scale.y },
                    offset = { x = offset.x, y = offset.y },
                },
                function(animatedEffect)
                    -- Remove and draw to corpse layer.
                    local storedCanvas = love.graphics.getCanvas()
                    love.graphics.setCanvas(self.canvas)
                    animatedEffect:give('color', COLOR[1], COLOR[2], COLOR[3])
                    world:emit("entity_render", animatedEffect)
                    love.graphics.setCanvas(storedCanvas)
                    animatedEffect:destroy()
                end
            )
        end
    end
    
    ---@param e BasicTower | Entity | table
    function CorpseSystem:entity_createTowerCorpse(e)
        if e.isTower then
            local storedCanvas = love.graphics.getCanvas()
            love.graphics.setCanvas(self.canvas)
            e.image.value = e.images.dead
            e:give('color', COLOR[1], COLOR[2], COLOR[3])
            self:getWorld():emit("entity_render", e)
            love.graphics.setCanvas(storedCanvas)
        end
    end


    --------------------------
    -- [[ Core Functions ]] --
    --------------------------
    function CorpseSystem:drawCorpses()
        love.graphics.setColor(1,1,1)
        love.graphics.draw(self.canvas)
    end

    return CorpseSystem
end
