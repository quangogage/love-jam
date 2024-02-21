---@author Gage Henderson 2024-02-21 07:05
--
---@class CoinValue : Component
-- Determines how many coins the player should get when slaying this entity.
---@field value integer
--

return function (concord)
    concord.component('coinValue', function (e, value)
        e.value = value
    end)
end
