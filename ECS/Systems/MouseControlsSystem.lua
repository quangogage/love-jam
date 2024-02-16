---@author Gage Henderson 2024-02-16 09:54
--
---@class MouseControlsSystem : System
-- Handles all controls for the mouse.
-- Selecting, dragging, commanding, etc,.
--
-- Also draws the selection rectangle.

-- ──────────────────────────────────────────────────────────────────────
-- ╭─────────────────────────────────────────────────────────╮
-- │ Configuration:                                          │
-- ╰─────────────────────────────────────────────────────────╯
local SELECTION_LINE_WIDTH = 2
local SELECTION_LINE_COLOR = { 1, 1, 1, 1 }
-- ──────────────────────────────────────────────────────────────────────

return function (concord, camera)
    ---@class MouseControlsSystem : System
    ---@field selectionRectangle {x:number, y:number, width:number, height:number} | nil
    ---@field selectableEntities table[] - Would be Character[] but I'm not
    -- sure, maybe you will be able to select other things?
    local MouseControlsSystem = concord.system({
        selectableEntities = { 'selectable', 'position' }
    })


    --------------------------
    -- [[ Core Functions ]] --
    --------------------------
    function MouseControlsSystem:update(dt)
        if self.selectionRectangle then
            self:_updateSelectionRectangle()
            self:_selectEntities()
        end

        -- DEV:
    end
    function MouseControlsSystem:draw()
        if self.selectionRectangle then
            self:_drawSelectionRectangle()
        end
    end
    function MouseControlsSystem:mousepressed(_, _, button)
        if button == 1 then
            self:_startDrag()
        end
    end
    function MouseControlsSystem:mousereleased()
        self.selectionRectangle = nil
    end


    -----------------------------
    -- [[ Private Functions ]] --
    -----------------------------
    -- Start a click-and-drag selection.
    function MouseControlsSystem:_startDrag(x, y)
        x, y = camera:getTranslatedMousePosition()
        self.selectionRectangle = {
            x      = x,
            y      = y,
            width  = 1,
            height = 1
        }
    end

    -- Expand / shrink the selection rectangle.
    function MouseControlsSystem:_updateSelectionRectangle()
        if self.selectionRectangle then
            local x, y                     = camera:getTranslatedMousePosition()
            self.selectionRectangle.width  = x - self.selectionRectangle.x
            self.selectionRectangle.height = y - self.selectionRectangle.y
        end
    end

    function MouseControlsSystem:_drawSelectionRectangle()
        love.graphics.setColor(SELECTION_LINE_COLOR)
        love.graphics.setLineWidth(SELECTION_LINE_WIDTH)
        love.graphics.rectangle(
            'line',
            self.selectionRectangle.x,
            self.selectionRectangle.y,
            self.selectionRectangle.width,
            self.selectionRectangle.height
        )
    end

    -- Select all entities within the selection rectangle.
    function MouseControlsSystem:_selectEntities()
        local entities = self.selectableEntities
        local x, y, width, height = self:_getNormalizedSelectionRectangle()
        for i = 1, #entities do
            local entity = entities[i]
            local position = entity.position
            if position.x > x and position.x < x + width and
            position.y > y and position.y < y + height then
                entity:addComponent('selected')
            end
        end
    end

    -- Return the selection rectangle ensured that width and height are
    -- positive.
    ---@return number, number, number, number
    function MouseControlsSystem:_getNormalizedSelectionRectangle()
        local x      = self.selectionRectangle.x
        local y      = self.selectionRectangle.y
        local width  = self.selectionRectangle.width
        local height = self.selectionRectangle.height
        if width < 0 then
            x = x + width
            width = -width
        end
        if height < 0 then
            y = y + height
            height = -height
        end
        return x, y, width, height
    end
    return MouseControlsSystem
end
