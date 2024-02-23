---@author Gage Henderson 2024-02-16 04:51
--
-- Systems and components are loaded here.
--
-- See `util.entityAssembler` for assemblages being loaded (and how to create
-- them easily).
--
-- Interface behavior is currently hooked into the game-world in here via
-- the EventManager.
--
-- Level completion is checked for in DamageSystem.

local util                   = require('util')({ 'entityAssembler' })
local Concord                = require('libs.Concord')
local levels                 = require('lists.levels')
local Camera                 = require('Classes.Camera')
local CameraControls         = require('Classes.Scenes.CombatScene.CameraControls')
local FriendlySpawnHandler   = require('Classes.Scenes.CombatScene.FriendlySpawnHandler')
local PowerupStateManager    = require('Classes.Scenes.CombatScene.PowerupStateManager')
local PawnSelectionMenu      = require('Classes.Scenes.CombatScene.Interface.PawnSelectionMenu')
local PowerupSelectionMenu   = require('Classes.Scenes.CombatScene.Interface.PowerupSelectionMenu')
local LevelTransitionHandler = require('Classes.Scenes.CombatScene.LevelTransitionHandler.LevelTransitionHandler')
local PauseMenu              = require('Classes.Scenes.CombatScene.Interface.PauseMenu.PauseMenu')
local BackgroundRenderer     = require('Classes.Scenes.CombatScene.BackgroundRenderer')
local CoinManager            = require('Classes.Scenes.CombatScene.CoinManager')
local RenderCanvas           = require('Classes.Scenes.CombatScene.RenderCanvas')

---@class CombatScene
---@field camera Camera
---@field world World
---@field pawnSelectionMenu PawnSelectionMenu
---@field eventManager EventManager
---@field friendlyBase Base The player's base.
---@field enemyBase Base The enemy's base.
---@field levels table[]
---@field friendlySpawnHandler FriendlySpawnHandler
---@field powerupStateManager PowerupStateManager
---@field cameraControls CameraControls
---@field currentLevelIndex integer
---@field levelTransitionHandler LevelTransitionHandler
---@field pauseMenu PauseMenu
---@field backgroundRenderer BackgroundRenderer
---@field coinManager CoinManager
---@field disableWorldUpdate boolean
---@field renderCanvas RenderCanvas
---@field paused boolean - Set in PauseMenu
---@field disableCameraControls boolean
---@field songs love.Source[]
---@field ambienceTrack love.Source
local CombatScene            = Goop.Class({
    arguments = { 'eventManager' },
    static = {
        currentLevelIndex = 1,
        songs = {
            love.audio.newSource('assets/audio/songs/warfare-1.mp3', 'stream'),
            love.audio.newSource('assets/audio/songs/warfare-2.mp3', 'stream'),
        },
        ambienceTrack = love.audio.newSource('assets/audio/sfx/battle-ambience.mp3', 'stream'),
    }
})

----------------------------
-- [[ Public Functions ]] --
----------------------------
function CombatScene:loadNextLevel()
    self.currentLevelIndex = self.currentLevelIndex + 1

    -- TODO: Loop properly if no more levels. (new game+ stuff...)
    if self.currentLevelIndex > #self.levels then
        self.currentLevelIndex = 1
    end

    -- Clear out all current entities and generate new ones.
    self:_generateLevel(self.currentLevelIndex)

    self.coinManager:addCoins(KNOBS.newLevelCoinReward)

    -- Disable pawn generation.
    -- See PawnGenerationSystem.
    self.world:emit('event_newLevel')

    self:_startCombatAudio()
end
function CombatScene:completeLevel()
    self:_stopCombatAudio()
    self.levelTransitionHandler:setState('level-complete')
end

--------------------------
-- [[ Core Functions ]] --
--------------------------
function CombatScene:init()
    self:_createSubscriptions()
    self:_initWorld()
    self.renderCanvas         = RenderCanvas()
    self.camera               = Camera()
    self.coinManager          = CoinManager()
    self.powerupStateManager  = PowerupStateManager(self.eventManager)
    self.pawnSelectionMenu    = PawnSelectionMenu(self.eventManager, self.powerupStateManager, self.coinManager)
    self.powerupSelectionMenu = PowerupSelectionMenu(self.eventManager, self)
    self.friendlySpawnHandler = FriendlySpawnHandler(self.eventManager, self.world, self.powerupStateManager, self,
        self.coinManager)
    self.cameraControls       = CameraControls(self.camera, self.world)
    self.pauseMenu            = PauseMenu(self, self.eventManager)
    self.backgroundRenderer   = BackgroundRenderer()
    self:_loadSystems()
    self:_initLevels()
    self.currentLevelIndex = 0
    self:loadNextLevel()
    self.levelTransitionHandler = LevelTransitionHandler(self.eventManager, self, self.renderCanvas)
    self.levelTransitionHandler:setState('scene-starting')
    -- DEV:
    console.world = self.world
    console:launchOptions()
end
function CombatScene:destroy()
    self.friendlySpawnHandler:destroy()
    self.powerupSelectionMenu:destroy()
    self.song:stop()
    self.ambienceTrack:stop()
    self:_destroySubscriptions()
end
function CombatScene:update(dt)
    if not self.disableWorldUpdate and not self.paused then
        self.world:emit('update', dt)
        if not self.disableCameraControls then
            self.cameraControls:update(dt)
        end
        self.camera:update(dt)
    end
    if not self.paused then
        self.pawnSelectionMenu:update(dt)
        self.powerupSelectionMenu:update(dt)
        self.levelTransitionHandler:update(dt)
    end
    self.renderCanvas:update(dt)
    self.pauseMenu:update(dt)
end
function CombatScene:draw()
    self.renderCanvas:startDrawing()
    self.camera:set()
    self.backgroundRenderer:draw()
    self.world:emit('drawCorpses')
    self.world:emit('draw')
    self:_drawWorldBoundary()
    self.camera:unset()
    self.renderCanvas:stopDrawing()
    self.renderCanvas:draw()

    self.powerupSelectionMenu:draw()
    self.pawnSelectionMenu:draw()
    self.levelTransitionHandler:draw()
    self.pauseMenu:draw()
end
function CombatScene:keypressed(key)
    if not self.paused then
        self.world:emit('keypressed', key)
        self.pawnSelectionMenu:keypressed(key)
        self.levelTransitionHandler:keypressed(key)
    end
    self.pauseMenu:keypressed(key)
end
function CombatScene:mousepressed(x, y, button)
    local didClickInterface = self.pawnSelectionMenu:mousepressed(x, y, button)
    if not didClickInterface then
        self.world:emit('mousepressed', x, y, button)
    end
    if not self.paused then
        self.levelTransitionHandler:mousepressed()
        self.powerupSelectionMenu:mousepressed(x, y, button)
    end
    self.pauseMenu:mousepressed(x, y, button)
end
function CombatScene:mousereleased(x, y, button)
    if not self.paused and not self.disableWorldUpdate then
        self.world:emit('mousereleased', x, y, button)
    end
end
function CombatScene:wheelmoved(x, y)
    if not self.paused and not self.disableWorldUpdate then
        self.cameraControls:wheelmoved(x, y)
    end
end


-----------------------------
-- [[ Private Functions ]] --
-----------------------------
function CombatScene:_initWorld()
    ---@class World
    ---@field bounds { x: number, y: number, width: number, height: number }
    self.world = Concord.world()
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
            require(dir .. name)(Concord, ...)
        )
    end
    loadSystem('TargetClearingSystem')
    loadSystem('PowerupSetupSystem')
    loadSystem('Pawn.PawnAnimationSystem')
    loadSystem('RenderSystem')
    loadSystem('PhysicsSystem')
    loadSystem('ClickHandlerSystem', self.camera)
    loadSystem('MouseControlsSystem', self.camera)
    loadSystem('GroundPositionSystem')
    loadSystem('Pawn.EnemyPawnTargetSystem')
    loadSystem('CorpseSystem')
    loadSystem('DamageSystem', function () self:completeLevel() end)
    loadSystem('Pawn.PawnAISystem')
    loadSystem('Pawn.PawnAttackSystem')
    loadSystem('DamageOnContactSystem')
    loadSystem('Pawn.PawnPushSystem')
    loadSystem('PawnGenerationSystem')
    loadSystem('HealthBarSystem')
    loadSystem('Pawn.RetaliationSystem')
    loadSystem('AnimationSystem')
    loadSystem('CoinGenerationSystem', self.coinManager)
    loadSystem('MovementSystem')
    loadSystem('Pawn.FriendlyPawnTargetSystem')
    loadSystem('DebugSystem', self.camera, function () self:completeLevel() end, self.coinManager)
    self.world:addSystems(unpack(systems))
end


function CombatScene:_drawWorldBoundary()
    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.setLineWidth(4)
    love.graphics.rectangle('line', 0, 0, self.world.bounds.width, self.world.bounds.height)
end

function CombatScene:_initLevels()
    self.levels = {}
    for _, level in pairs(levels) do
        level.level = tonumber(level.name)
        table.insert(self.levels, level)
    end
    table.sort(self.levels, function (a, b)
        return tonumber(a.level) < tonumber(b.level)
    end)
end

---@param index integer
function CombatScene:_generateLevel(index)
    local level = self.levels[index]
    self.world:clear()
    for _, e in ipairs(level.entities) do
        if e.className == 'EnemyBase' then
            self.enemyBase = util.entityAssembler.assemble(
                self.world, 'Base',
                e.position.x, e.position.y
            )
            self.world.enemyBase = self.enemyBase
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
            self.world.friendlyBase = self.friendlyBase
        elseif e.className == 'SpawnZone' then
            self.friendlySpawnHandler:setSpawnZone(
                e.position.x - e.dimensions.width / 2,
                e.position.y - e.dimensions.height / 2,
                e.dimensions.width, e.dimensions.height
            )
        end
    end

    self.world.bounds = {
        x      = 0,
        y      = 0,
        width  = level.dimensions.width,
        height = level.dimensions.height
    }
end

function CombatScene:_createSubscriptions()
    self.subscriptions = {}
    self.subscriptions['disableCameraControls'] = self.eventManager:subscribe('disableCameraControls', function ()
        self.disableCameraControls = true
    end)
    self.subscriptions['enableCameraControls'] = self.eventManager:subscribe('enableCameraControls', function ()
        self.disableCameraControls = false
    end)
    self.subscriptions['centerCameraOnFriendlyBase'] = self.eventManager:subscribe('centerCameraOnFriendlyBase',
        function ()
            self.camera:centerOnPosition(self.friendlyBase.position.x, self.friendlyBase.position.y)
            self.camera:setToMaxZoom()
        end)
    self.subscriptions['openPowerupSelectionMenu'] = self.eventManager:subscribe('openPowerupSelectionMenu', function ()
        self:_stopCombatAudio()
        self.powerupSelectionMenu:open()
    end)
    self.subscriptions['disableWorldUpdate'] = self.eventManager:subscribe('disableWorldUpdate', function ()
        self.disableWorldUpdate = true
    end)
    self.subscriptions['enableWorldUpdate'] = self.eventManager:subscribe('enableWorldUpdate', function ()
        self.disableWorldUpdate = false
    end)
    self.subscriptions['endPowerupSelection'] = self.eventManager:subscribe('endPowerupSelection', function ()
        self.levelTransitionHandler:setState('powerup-selection-complete')
    end)
    self.subscriptions['closePowerupSelectionMenu'] = self.eventManager:subscribe('closePowerupSelectionMenu',
        function ()
            self.powerupSelectionMenu:close()
        end)
    self.subscriptions['loadNextLevel'] = self.eventManager:subscribe('loadNextLevel', function ()
        self:loadNextLevel()
    end)
end
function CombatScene:_destroySubscriptions()
    for event, uuid in pairs(self.subscriptions) do
        self.eventManager:unsubscribe(event, uuid)
    end
end
function CombatScene:_startCombatAudio()
    for _, song in ipairs(self.songs) do
        song:setVolume(settings:getVolume('music'))
        song:setLooping(true)
    end
    self.song = self.songs[love.math.random(1, #self.songs)]
    self.song:play()
    self.ambienceTrack:setLooping(true)
    self.ambienceTrack:setVolume(settings:getVolume('sfx') * 0.2)
    self.ambienceTrack:play()
end
function CombatScene:_stopCombatAudio()
    for _, song in ipairs(self.songs) do
        song:stop()
    end
    self.ambienceTrack:stop()
end
return CombatScene
