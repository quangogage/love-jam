---@author Gage Henderson 2024-02-16 04:51
--
-- Systems and components are loaded here.
--
-- See `util.entityAssembler` for assemblages being loaded (and how to create
-- them easily).
--
-- Interface behavior is currently hooked into the game-world in here via
-- the EventManager.

local util            = require('util')({ 'entityAssembler' })
local Vec2            = require('Classes.Types.Vec2')
local levels          = require('lists.levels')
local Camera          = require('Classes.Camera')
local CameraControls  = require('Classes.Scenes.CombatScene.CameraControls')
local CombatInterface = require(
    'Classes.Scenes.CombatScene.CombatInterface.CombatInterface')


---@class CombatScene
---@field concord Concord
---@field camera Camera
---@field world World
---@field interface CombatInterface
---@field eventManager EventManager
---@field friendlyBase Base The player's base.
---@field animatingCamera boolean
local CombatScene = Goop.Class({
    arguments = { 'eventManager' }
})


--------------------------
-- [[ Core Functions ]] --
--------------------------
function CombatScene:init()
    self.concord   = require('libs.Concord')
    self.camera    = Camera()
    self.interface = CombatInterface(self.eventManager)
    self:_initWorld()
    self.cameraControls = CameraControls(self.camera, self.world)
    self:_loadComponents()
    self:_loadSystems()
    self:_initLevels()
    self:_generateLevel(1)
    self:_startLevelCameraAnimation()
    self:_createSubscriptions()
    -- DEV:
    console.world = self.world
    console:launchOptions()
end
function CombatScene:destroy()
    self:_destroySubscriptions()
end
function CombatScene:update(dt)
    self.world:emit('update', dt)
    self.interface:update(dt)
    self.camera:update(dt)
    if not self.animatingCamera then
        self.cameraControls:update(dt)
    else
        self:_updateLevelCameraAnimation(dt)
    end
end
function CombatScene:draw()
    self.camera:set()
    self.world:emit('draw')
    self:_drawWorldBoundary()
    self.camera:unset()
    self.interface:draw()
end
function CombatScene:keypressed(key)
    self.world:emit('keypressed', key)
    self.interface:keypressed(key)
    self:_endLevelCameraAnimation()
end
function CombatScene:mousepressed(x, y, button)
    local didClickInterface = self.interface:mousepressed(x, y, button)

    if not didClickInterface then
        self.world:emit('mousepressed', x, y, button)
    end
    self:_endLevelCameraAnimation()
end
function CombatScene:mousereleased(x, y, button)
    self.world:emit('mousereleased', x, y, button)
end
function CombatScene:wheelmoved(x, y)
    if not self.animatingCamera then
        self.cameraControls:wheelmoved(x, y)
    end
    self:_endLevelCameraAnimation()
end


-----------------------------
-- [[ Private Functions ]] --
-----------------------------
function CombatScene:_initWorld()
    ---@class World
    ---@field bounds { x: number, y: number, width: number, height: number }
    self.world = self.concord.world()
    self.world.bounds = { x = 0, y = 0, width = 1280, height = 720 }
end
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
    loadSystem('ClickHandlerSystem', self.camera)
    loadSystem('MouseControlsSystem', self.camera)
    loadSystem('Pawn.EnemyPawnTargetSystem')
    loadSystem('DamageSystem')
    loadSystem('Pawn.PawnAISystem')
    loadSystem('Pawn.PawnAttackSystem')
    loadSystem('Pawn.PawnPushSystem')
    loadSystem('PawnGenerationSystem')
    loadSystem('HealthBarSystem')
    loadSystem('SelectedHighlightSystem')
    loadSystem('DebugSystem', self.camera)

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

-- Subscribe to various events.
function CombatScene:_createSubscriptions()
    self.subscriptions = {}
    self.subscriptions['interface_attemptSpawnPawn'] = self.eventManager
                                                           :subscribe(
            'interface_attemptSpawnPawn',
            function ()
                local pawn = util.entityAssembler.assemble(self.world,
                    'basicPawn',
                    self.friendlyBase.position.x, self.friendlyBase.position.y,
                    true
                )
                self.world:emit('event_pawnSpawned', pawn)
            end
        )
end

-- Unsubscribe from all events.
function CombatScene:_destroySubscriptions()
    for eventName, uuid in pairs(self.subscriptions) do
        self.eventManager:unsubscribe(eventName, uuid)
    end
end

function CombatScene:_drawWorldBoundary()
    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.setLineWidth(1)
    love.graphics.rectangle('line', 0, 0, self.world.bounds.width,
        self.world.bounds.height)
end

function CombatScene:_initLevels()
    self.levels = {}
    for _, level in pairs(levels) do
        table.insert(self.levels, level)
    end
    table.sort(self.levels, function (a, b)
        return tonumber(a.level) < tonumber(b.level)
    end)
end

---@param index integer
function CombatScene:_generateLevel(index)
    local level = self.levels[index]
    for _, e in ipairs(level.entities) do
        if e.className == 'EnemyBase' then
            util.entityAssembler.assemble(
                self.world, 'Base',
                e.position.x, e.position.y
            )
        elseif e.className == 'EnemyTower' then
            util.entityAssembler.assemble(
                self.world, e.type,
                e.position.x, e.position.y
            )
        elseif e.className == 'FriendlyBase' then
            self.friendlyBase = util.entityAssembler.assemble(
                self.world, 'Base',
                e.position.x, e.position.y,
                true
            )
        end
    end

    self.world.bounds = {
        x = 0,
        y = 0,
        width = level.dimensions.width,
        height = level.dimensions.height
    }
end

-- Start the camera animation for when you begin a level.
function CombatScene:_startLevelCameraAnimation()
    self.animatingCamera = true
end

-- Update the camera animation for when you begin a level.
function CombatScene:_updateLevelCameraAnimation(dt)
end

-- End the camera animation for when you begin a level.
function CombatScene:_endLevelCameraAnimation()
    if self.animatingCamera then
        self.animatingCamera = false
    end
end

return CombatScene
