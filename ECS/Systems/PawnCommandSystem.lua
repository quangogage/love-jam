---@author Gage Henderson 2024-02-16 10:44
--
-- Issue commands to entities by clickin' stuff.
--

---@param concord table
---@param camera Camera
return function (concord, camera)
    ---@class PawnCommandSystem : System
    ---@field selectedEntities table[]
    ---@field hostileEntities table[]
    local PawnCommandSystem = concord.system({
        selectedEntities = { 'selected' },
        hostileEntities  = { 'hostile' , 'clickDimensions'},
    })


    --------------------------
    -- [[ Core Functions ]] --
    --------------------------
    function PawnCommandSystem:mousepressed(_, _, button)
        local world = self:getWorld()
        if button == 2 and world then
            local x, y = camera:getTranslatedMousePosition()

            -- Click on enemies.
            for _,e in ipairs(self.hostileEntities) do
                if x > e.position.x - e.clickDimensions.width / 2 and
                x < e.position.x + e.clickDimensions.width / 2 and
                y > e.position.y - e.clickDimensions.height / 2 and
                y < e.position.y + e.clickDimensions.height / 2 then
                    self:_setTarget({entity = e})
                    return
                end
            end

            -- If you didn't click an enemy, move to where you clicked.
            self:_setTarget({position = {x = x, y = y}})
        end
    end


    -----------------------------
    -- [[ Private Functions ]] --
    -----------------------------
    ---@param data table See `ECS.Components.Target` for details.
    function PawnCommandSystem:_setTarget(data)
        for _, e in ipairs(self.selectedEntities) do
            e:give("target", data)
        end
    end


    return PawnCommandSystem
end
