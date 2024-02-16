---@author Gage Henderson 2024-02-16 04:51
--
-- Systems and components are loaded here.
--
-- See `util.entityAssembler` for assemblages being loaded (and how to create
-- them easily).

local Camera = require('Classes.Camera')

---@class CombatScene
local CombatScene = Goop.Class({
})


--------------------------
-- [[ Core Functions ]] --
--------------------------
function CombatScene:init()
    self.concord = require('libs.Concord')
    self.camera  = Camera()
    self.world   = self.concord.world()
    self:_loadComponents()
    self:_loadSystems()

    -- Testing
    self.concord.entity(self.world):give('position', 50, 50)
        :give('renderRectangle', 50, 50)
end
function CombatScene:update(dt)
    self.world:emit('update', dt)
end
function CombatScene:draw()
    self.camera:set()
    self.world:emit('draw')
    self.camera:unset()
end
function CombatScene:buttonpressed(button)
    self.world:emit('buttonpressed', button)
end


-----------------------------
-- [[ Private Functions ]] --
-----------------------------
-- Manually load all systems.
-- Can provide arguments to systems if needed.
function CombatScene:_loadSystems()
    local dir = 'ECS.Systems.'
    self.systems = {}
    local loadSystem = function (name, ...)
        table.insert(
            self.systems,
            require(dir .. name)(self.concord, ...)
        )
    end
    loadSystem('RenderSystem')

    self.world:addSystems(unpack(self.systems))
end

-- Auto-load all components.
function CombatScene:_loadComponents()
    local function loadFilesInDir(dir)
        local files = love.filesystem.getDirectoryItems(dir)
        for _, file in ipairs(files) do
            if string.match(file, '%.lua') then
                local filename = file:gsub('%.lua$', '')
                require(dir .. filename)(self.concord)
            elseif love.filesystem.getInfo(dir .. file).type == 'directory' then
                loadFilesInDir(dir .. file .. '/')
            end
        end
    end
    loadFilesInDir('/ECS/Components/')
end

return CombatScene
