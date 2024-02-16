---@author Gage Henderson 2024-02-16 04:51
--
-- Systems and components are loaded here.
--
-- See `util.entityAssembler` for assemblages being loaded (and how to create
-- them easily).

local Camera = require('Classes.Camera')

---@class CombatScene
---@field concord Concord
---@field camera Camera
---@field world World
local CombatScene = Goop.Class({})


--------------------------
-- [[ Core Functions ]] --
--------------------------
function CombatScene:init()
    self.concord = require('libs.Concord')
    self.camera  = Camera()
    self.world   = self.concord.world()
    self:_loadComponents()
    self:_loadSystems()

    -- DEV:
    console.world = self.world
end
function CombatScene:update(dt)
    self.world:emit('update', dt)
end
function CombatScene:draw()
    self.camera:set()
    self.world:emit('draw')
    self.camera:unset()
end
function CombatScene:keypressed(key)
    if key == 'space' then
        local util = require('util')({ 'entityAssembler' })
        util.entityAssembler.assemble(self.world, 'basicTroop', 100, 100)
    end
end
function CombatScene:mousepressed(x, y, button)
end

-----------------------------
-- [[ Private Functions ]] --
-----------------------------
-- Manually load all systems.
-- Can provide arguments to systems if needed.
function CombatScene:_loadSystems()
    local dir = 'ECS.Systems.'
    local systems = {}
    local loadSystem = function (name, ...)
        table.insert(
            systems,
            require(dir .. name)(self.concord, ...)
        )
    end
    loadSystem('RenderSystem')
    loadSystem('PhysicsSystem')

    self.world:addSystems(unpack(systems))
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
