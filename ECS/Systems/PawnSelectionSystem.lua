---@author Gage Henderson 2024-02-16 09:54
--
---@class EntitySelectionSystem : System
-- Handles selecting entities with the mouse.
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
    ---@class EntitySelectionSystem : System
    ---@field selectionRectangle {x:number, y:number, width:number, height:number} | nil
    ---@field selectableEntities table[] - Would be Character[] but I'm not
    -- sure, maybe you will be able to select other things?
    ---@field selectedEntities table[]
    local EntitySelectionSystem = concord.system({
        selectableEntities = { 'friendly', 'position' },
        selectedEntities   = { 'selected', 'position' }
    })


    --------------------------
    -- [[ Core Functions ]] --
    --------------------------
    function EntitySelectionSystem:update()
        if self.selectionRectangle then
            self:_updateSelectionRectangle()
            self:_selectEntities()
        end
    end
    function EntitySelectionSystem:draw()
        if self.selectionRectangle then
            self:_drawSelectionRectangle()
        end
    end
    function EntitySelectionSystem:mousepressed(_, _, button)
        if button == 1 then
            self:_startDrag()
        end
    end
    function EntitySelectionSystem:mousereleased()
        self.selectionRectangle = nil
    end


    -----------------------------
    -- [[ Private Functions ]] --
    -----------------------------
    -- Start a click-and-drag selection.
    function EntitySelectionSystem:_startDrag(x, y)
        x, y = camera:getTranslatedMousePosition()
        self.selectionRectangle = {
            x      = x,
            y      = y,
            width  = 1,
            height = 1
        }
    end

    -- Expand / shrink the selection rectangle.
    function EntitySelectionSystem:_updateSelectionRectangle()
        if self.selectionRectangle then
            local x, y                     = camera:getTranslatedMousePosition()
            self.selectionRectangle.width  = x - self.selectionRectangle.x
            self.selectionRectangle.height = y - self.selectionRectangle.y
        end
    end

    function EntitySelectionSystem:_drawSelectionRectangle()
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
    function EntitySelectionSystem:_selectEntities()
        local entities = self.selectableEntities
        local x, y, width, height = self:_getNormalizedSelectionRectangle()
        local sr = { x = x, y = y, width = width, height = height } -- Selection rectangle.
        for i = 1, #entities do
            local entity = entities[i]
            local er = { -- Entity rectangle.
                x      = entity.position.x,
                y      = entity.position.y,
                width  = entity.clickDimensions.width,
                height = entity.clickDimensions.height
            }
            if sr.x + sr.width > er.x - er.width / 2 and
            sr.x - sr.width < er.x + er.width / 2 and
            sr.y + sr.height > er.y - er.height / 2 and
            sr.y - sr.height < er.y + er.height / 2 then
                entity:give('selected')
            else
                entity:remove('selected')
            end
        end
    end

    -- Return the selection rectangle ensured that width and height are
    -- positive.
    ---@return number, number, number, number
    function EntitySelectionSystem:_getNormalizedSelectionRectangle()
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
    return EntitySelectionSystem
end
