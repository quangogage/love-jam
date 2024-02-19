---@author Gage Henderson 2024-02-19 08:22
--
--

---@class LevelTransitionHandler
---@field eventManager EventManager
---@field combatScene CombatScene
---@field state string
local LevelTransitionHandler = Goop.Class({
    arguments = { 'eventManager', 'combatScene' },
    static = {
        state = 'level-starting'
    }
})


return LevelTransitionHandler
