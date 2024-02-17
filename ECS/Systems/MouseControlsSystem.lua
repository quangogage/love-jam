---@author Gage Henderson 2024-02-16 10:44
--
-- Issue commands and select entities with the mouse.
--

-- ──────────────────────────────────────────────────────────────────────
-- How far you have to move the mouse before it is consideree a drag and
-- not a click.
local DRAG_THRESHOLD = 30
-- ──────────────────────────────────────────────────────────────────────

---@param concord table
---@param camera Camera
return function (concord, camera)
    ---@class MouseControlsSystem : System
    ---@field selectedEntities table[]
    ---@field hostileEntities table[]
    local MouseControlsSystem = concord.system({
        selectedEntities = { 'selected' },
        friendlyEntities = { 'friendly', 'dimensions' },
        hostileEntities  = { 'hostile', 'dimensions' },
    })


    --------------------------
    -- [[ Core Functions ]] --
    --------------------------
    function MouseControlsSystem:update(dt)
        self:_updateSelectionRectangle()
        self:_updateSelectedEntities()
    end
    function MouseControlsSystem:draw()
        self:_drawSelectionRectangle()
    end
    function MouseControlsSystem:mousepressed(_, _, button)
        if button == 1 then
            local x,y = camera:getTranslatedMousePosition()
            self.mousepressOrigin = { x = x, y = y }
        end
    end
    function MouseControlsSystem:mousereleased(_, _, button)
        if button == 1 then
            local x,y = camera:getTranslatedMousePosition()
            local dx = x - self.mousepressOrigin.x
            local dy = y - self.mousepressOrigin.y
            if math.sqrt(dx * dx + dy * dy) < DRAG_THRESHOLD then
                self:_targetMouseCoords()
            end
            self.mousepressOrigin = nil
            self.selectionRectangle = nil
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
            love.graphics.setLineWidth(1)
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
                targetData = {entity = hostile}
            end
        end

        -- Clicking on the ground.
        if not targetData then
            targetData = {position = {x = x, y = y}}
        end

        for _,e in ipairs(self.selectedEntities) do
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

    return MouseControlsSystem
end
