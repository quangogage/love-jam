---@author Gage Henderson 2024-02-18 15:08
--
---@class PowerupSetupSystem : System
-- Sets powerups up for entities with them.
--
-- Not where you might immediately think this should go - But i decided to
-- put this here to keep it all in one place.
--
-- Also, I know, this is inefficient.
--
-- Don't remove the powerup component after setting up as there are other
-- powerups that need to be checked for dynamically throughout the entity's
-- lifetime.
--

return function(concord)
    local PowerupSetupSystem = concord.system({
        entities = { 'powerups' }
    })

    function PowerupSetupSystem:update()
        for _,e in ipairs(self.entities) do
            if not e.powerups.setup then
                for _,powerup in pairs(e.powerups.value) do
                    if powerup.onPawnCreation then
                        powerup.onPawnCreation(powerup,e)
                    end
                end
                e.powerups.setup = true
            end
        end
    end

    return PowerupSetupSystem
end
