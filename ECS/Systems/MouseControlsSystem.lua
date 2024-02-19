---@author Gage Henderson 2024-02-16 10:44
--
-- Issue commands and select entities with the mouse.
--
-- Logic for how to handle clicking on multiple (overlapping) entities is
-- handled here. But see `ClickHandlerSystem` for the actual callback
-- function definition (event_mousepressed, event_mousereleased).

-- ──────────────────────────────────────────────────────────────────────
-- How far you have to move the mouse before it is considered a drag and
-- not a click.
local DRAG_THRESHOLD = 35
-- ──────────────────────────────────────────────────────────────────────

---@param concord table
---@param camera Camera
return function (concord, camera)
    ---@class MouseControlsSystem : System
    ---@field selectedEntities table[]
    ---@field friendlyEntities table[]
    ---@field hostileEntities table[]
    local MouseControlsSystem = concord.system({
        selectedEntities = { 'selected' },
        friendlyEntities = { 'friendly', 'dimensions' },
        hostileEntities  = { 'hostile', 'dimensions' },
    })


    ----------------------------
    -- [[ Public Functions ]] --
    ----------------------------
    -- Called from ClickHandlerSystem.
    -- Determine what to do if mutliples entities are clicked on, only one is,
    -- or none are.
    ---@param button number
    ---@param topEntity Pawn[] | table[]
    ---@param allEntities Pawn[] | table[]
    function MouseControlsSystem:event_mousereleased(_, _, button, topEntity, allEntities)
        local x, y = camera:getTranslatedMousePosition()
        local world = self:getWorld()
        if button == 1 and world then
            if self.mousepressOrigin then
                -- If we have not moved the mouse enough to register as a drag.
                -- Register a target instead.
                if not self.selectionRectangle and x > world.bounds.x and x < world.bounds.x + world.bounds.width and
                y > world.bounds.y and y < world.bounds.y + world.bounds.height then
                    if #allEntities == 0 then
                        self:_setTarget({position = { x = x, y = y }})
                    else
                        -- If there is a hostile entity anywhere in the list,
                        -- target it.
                        local clickedEnemy
                        for _, e in ipairs(allEntities) do
                            if e.hostile then
                                clickedEnemy = e
                                break
                            end
                        end
                        if clickedEnemy then
                            self:_setTarget({entity = clickedEnemy})
                        else
                            -- If there are no hostile entities, select the
                            -- uppermost one.
                            for _, e in ipairs(allEntities) do
                                if not e.unselectable then
                                    self:_unselectAll()
                                    e:give('selected')
                                    return
                                end
                            end
                            --If none of these entities are 'selectable', then
                            -- target the clicked position.
                            self:_setTarget({position = { x = x, y = y }})
                        end
                    end
                end
                self.mousepressOrigin = nil
            end
            self.selectionRectangle = nil
        end
    end

    --------------------------
    -- [[ Core Functions ]] --
    --------------------------
    function MouseControlsSystem:update()
        self:_updateSelectionRectangle()
        self:_updateSelectedEntities()
    end
    function MouseControlsSystem:draw()
        self:_drawSelectionRectangle()
    end
    function MouseControlsSystem:mousepressed(_, _, button)
        local world = self:getWorld()
        local x, y = camera:getTranslatedMousePosition()
        if not world then return end
        if button == 1 then
            self.mousepressOrigin = { x = x, y = y }
        end
    end


    -----------------------------
    -- [[ Private Functions ]] --
    -----------------------------
    -- Create and update the selection rectangle if you've moved it further
    -- than the drag threshold.
    function MouseControlsSystem:_updateSelectionRectangle()
        if love.mouse.isDown(1) and self.mousepressOrigin then
            local x, y = camera:getTranslatedMousePosition()
            -- Create the selection rectangle if it doesn't exist.
            if not self.selectionRectangle then
                local dx = x - self.mousepressOrigin.x
                local dy = y - self.mousepressOrigin.y
                if math.sqrt(dx * dx + dy * dy) > DRAG_THRESHOLD then
                    self.selectionRectangle = {
                        x = self.mousepressOrigin.x,
                        y = self.mousepressOrigin.y,
                        width = 1,
                        height = 1
                    }
                end
            else -- Continously update the selection rectangle.
                self.selectionRectangle.width = x - self.selectionRectangle.x
                self.selectionRectangle.height = y - self.selectionRectangle.y
            end
        end
    end

    -- Draw the selection rectangle if it exists.
    function MouseControlsSystem:_drawSelectionRectangle()
        if self.selectionRectangle then
            love.graphics.setColor(1, 1, 1)
            love.graphics.setLineWidth(2)
            love.graphics.rectangle(
                'line',
                self.selectionRectangle.x, self.selectionRectangle.y,
                self.selectionRectangle.width, self.selectionRectangle.height
            )
            love.graphics.setColor(1, 1, 1, 1)
        end
    end

    -- Continously update the selected entities within the selection rectangle.
    function MouseControlsSystem:_updateSelectedEntities()
        if self.selectionRectangle and love.mouse.isDown(1) then
            local rect = self:_getAbsoluteSelectionRectangle()
            for _, entity in ipairs(self.friendlyEntities) do
                if not entity.unselectable then
                    if rect.x + rect.width > entity.position.x - entity.dimensions.width / 2 and
                    rect.x < entity.position.x + entity.dimensions.width / 2 and
                    rect.y + rect.height > entity.position.y - entity.dimensions.height / 2 and
                    rect.y < entity.position.y + entity.dimensions.height / 2 then
                        entity:give('selected')
                    else
                        entity:remove('selected')
                    end
                end
            end
        end
    end

    -- Attempt to target whatever is under the mouse right now.
    function MouseControlsSystem:_targetMouseCoords()
        local x, y = camera:getTranslatedMousePosition()
        local targetData

        -- Clicking on a hostile entity.
        for _, hostile in ipairs(self.hostileEntities) do
            if x > hostile.position.x - hostile.dimensions.width / 2 and
            x < hostile.position.x + hostile.dimensions.width / 2 and
            y > hostile.position.y - hostile.dimensions.height / 2 and
            y < hostile.position.y + hostile.dimensions.height / 2 then
                targetData = { entity = hostile }
            end
        end

        -- Clicking on the ground.
        if not targetData then
            targetData = { position = { x = x, y = y } }
        end

        for _, e in ipairs(self.selectedEntities) do
            e:give('target', targetData)
        end
    end

    -- Get the rectangle with no negative width or height.
    ---@return {x:number, y:number, width:number, height:number}
    function MouseControlsSystem:_getAbsoluteSelectionRectangle()
        local rect = {
            x = self.selectionRectangle.x,
            y = self.selectionRectangle.y,
            width = self.selectionRectangle.width,
            height = self.selectionRectangle.height
        }
        if rect.width < 0 then
            rect.x = rect.x + rect.width
            rect.width = -rect.width
        end
        if rect.height < 0 then
            rect.y = rect.y + rect.height
            rect.height = -rect.height
        end
        return rect
    end

    function MouseControlsSystem:_unselectAll()
        for _, e in ipairs(self.selectedEntities) do
            e:remove('selected')
        end
    end

    -- Set the target for all selected entities.
    ---@param data table
    function MouseControlsSystem:_setTarget(data)
        local world = self:getWorld()
        for _,e in ipairs(self.selectedEntities) do
            e:give('target', data)
            if world then
                world:emit("event_playerCommand", data)
            end
        end
    end

    return MouseControlsSystem
end
