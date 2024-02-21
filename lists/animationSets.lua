---@author Gage Henderson 2024-02-20 06:24
--

local animationSets = {
    knight = {
        attack = {
            perFrameFramerateOffset = {
                [2] = 5     -- Second frame will last 0.5 seconds longer.
            },
            framerate               = 0.1,
            up                      = 'assets/images/knight/attack_up',
            down                    = 'assets/images/knight/attack_down',
            left                    = 'assets/images/knight/attack_left',
            right                   = 'assets/images/knight/attack_right',
            downRight               = 'assets/images/knight/attack_down_right',
            downLeft                = 'assets/images/knight/attack_down_left',
            upRight                 = 'assets/images/knight/attack_up_right',
            upLeft                  = 'assets/images/knight/attack_up_left',
        },
        walk = {
            framerate = 0.1,
            up        = 'assets/images/knight/walk_up',
            down      = 'assets/images/knight/walk_down',
            left      = 'assets/images/knight/walk_left',
            right     = 'assets/images/knight/walk_right',
            downRight = 'assets/images/knight/walk_down_right',
            downLeft  = 'assets/images/knight/walk_down_left',
            upRight   = 'assets/images/knight/walk_up_right',
            upLeft    = 'assets/images/knight/walk_up_left',
        },
        idle = {
            framerate = 0.1,
            up        = 'assets/images/knight/idle_up',
            down      = 'assets/images/knight/idle_down',
            left      = 'assets/images/knight/idle_left',
            right     = 'assets/images/knight/idle_right',
            downRight = 'assets/images/knight/idle_down_right',
            downLeft  = 'assets/images/knight/idle_down_left',
            upRight   = 'assets/images/knight/idle_up_right',
            upLeft    = 'assets/images/knight/idle_up_left',
        },
        dead = {
            framerate = 0.1,
            up        = 'assets/images/knight/dead_up',
            down      = 'assets/images/knight/dead_down',
            left      = 'assets/images/knight/dead_left',
            right     = 'assets/images/knight/dead_right',
            downRight = 'assets/images/knight/dead_down_right',
            downLeft  = 'assets/images/knight/dead_down_left',
            upRight   = 'assets/images/knight/dead_up_right',
            upLeft    = 'assets/images/knight/dead_up_left'
        }
    },
    archer = {
        attack = {
            perFrameFramerateOffset = {
                [2] = 5     -- Second frame will last 0.5 seconds longer.
            },
            framerate               = 0.1,
            up                      = 'assets/images/archer/attack_up',
            down                    = 'assets/images/archer/attack_down',
            left                    = 'assets/images/archer/attack_left',
            right                   = 'assets/images/archer/attack_right',
            downRight               = 'assets/images/archer/attack_down_right',
            downLeft                = 'assets/images/archer/attack_down_left',
            upRight                 = 'assets/images/archer/attack_up_right',
            upLeft                  = 'assets/images/archer/attack_up_left',
        },
        walk = {
            framerate = 0.1,
            up        = 'assets/images/archer/walk_up',
            down      = 'assets/images/archer/walk_down',
            left      = 'assets/images/archer/walk_left',
            right     = 'assets/images/archer/walk_right',
            downRight = 'assets/images/archer/walk_down_right',
            downLeft  = 'assets/images/archer/walk_down_left',
            upRight   = 'assets/images/archer/walk_up_right',
            upLeft    = 'assets/images/archer/walk_up_left',
        },
        idle = {
            framerate = 0.1,
            up        = 'assets/images/archer/idle_up',
            down      = 'assets/images/archer/idle_down',
            left      = 'assets/images/archer/idle_left',
            right     = 'assets/images/archer/idle_right',
            downRight = 'assets/images/archer/idle_down_right',
            downLeft  = 'assets/images/archer/idle_down_left',
            upRight   = 'assets/images/archer/idle_up_right',
            upLeft    = 'assets/images/archer/idle_up_left',
        },
        dead = {
            framerate = 0.1,
            up        = 'assets/images/archer/dead_up',
            down      = 'assets/images/archer/dead_down',
            left      = 'assets/images/archer/dead_left',
            right     = 'assets/images/archer/dead_right',
            downRight = 'assets/images/archer/dead_down_right',
            downLeft  = 'assets/images/archer/dead_down_left',
            upRight   = 'assets/images/archer/dead_up_right',
            upLeft    = 'assets/images/archer/dead_up_left'
        }
    }

}

for setName, set in pairs(animationSets) do
    for animationName, animation in pairs(set) do
        for direction, filepath in pairs(animation) do
            animation.perFrameFramerateOffset = animation.perFrameFramerateOffset or {}

            if direction ~= "framerate" and direction ~= "perFrameFramerateOffset" then
                local files = love.filesystem.getDirectoryItems(filepath)

                animation[direction] = {}

                for _, file in ipairs(files) do
                    local filename  = file:match("(.+)%.(.+)")
                    animation[direction][tonumber(filename)] = love.graphics.newImage(filepath .. "/" .. file)
                end
            end
        end
    end
end

return animationSets
