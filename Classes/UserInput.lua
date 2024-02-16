---@author Gage Henderson
---@class UserInput
-- Basic input handling class that I use in my games.
---@field movementDeadzone number
---@field aimingDeadzone number
---@field onButtonPressed? function - Can be set to a function that will be called when a button is pressed.

local controls = {
    moveRight = {
        key = 'd'
    },
    moveLeft = {
        key = 'a'
    },
    moveUp = {
        key = 'w'
    },
    moveDown = {
        key = 's'
    },
    jump = {
        key = 'space',
        controllerButton = 'a'
    },
    -- dash = {
    --     key = 'lshift',
    --     controllerButton = 'leftshoulder'
    -- },
    -- primaryAttack = {
    --     mouseButton = 1,
    --     controllerButton = 'triggerright'
    -- },
    -- secondaryAttack = {
    --     mouseButton = 2,
    --     controllerButton = 'triggerleft'
    -- },
    -- interact = {
    --     key = 'e',
    --     controllerButton = 'x'
    -- },
    -- secondaryInteract = {
    --     key = 'q',
    --     controllerButton = 'y'
    -- },
}

local UserInput = Goop.Class({
    static = {
        triggerDeadzone = 0.01,
        movementDeadzone = 0.1,
        aimingDeadzone = 0.1
    },
    dynamic = {
        movement = { x = 0, y = 0 },
        controllerAim = {
            direction = 0,
            distance = 0
        }
    }
})


----------------------------
-- [[ Public Functions ]] --
----------------------------
-- Check if a control is pressed.
---@param control string
---@return boolean
function UserInput:isDown(control)
    assert(controls[control], 'Control does not exist.')
    return self:_checkControlState(control)
end

-- Vibrate the controller (if it is found).
---@param left number
---@param right number
---@param duration number
function UserInput:vibrate(left, right, duration)
    if self.controller then
        self.controller:setVibration(left, right, duration)
    end
end

--------------------------
-- [[ Core Functions ]] --
--------------------------
function UserInput:update()
    self:_checkForController()
    self:_updateMovementValues()
    self:_updateControllerAim()
    self:_executeTriggerPresses()
end

function UserInput:keypressed(key)
    self:_checkKeyboardButton(key)
end

function UserInput:gamepadpressed(_, button)
    self:_checkControllerButton(button)
end

function UserInput:mousepressed(_, _, button)
    self:_checkMouseButton(button)
end

-----------------------------
-- [[ Private Functions ]] --
-----------------------------
-- Check if a control is pressed.
---@param control string
---@return boolean
function UserInput:_checkControlState(control)
    local control = controls[control]
    local isPressed = false
    -- Mnk input.
    if control.key then
        if love.keyboard.isDown(control.key) then
            isPressed = true
        end
    end
    if control.mouseButton then
        if love.mouse.isDown(control.mouseButton) then
            isPressed = true
        end
    end

    -- Controller input.
    if self.controller then
        if control.controllerButton then
            if control.controllerButton ~= 'triggerright' and control.controllerButton ~= 'triggerleft' then
                if self.controller:isGamepadDown(control.controllerButton) then
                    isPressed = true
                end
            else
                ---Use triggers as buttons.
                if self.controller:getGamepadAxis(control.controllerButton) > self.triggerDeadzone then
                    isPressed = true
                end
            end
        end
    end
    return isPressed
end

-- Continously check for controller input and store a reference to it.
function UserInput:_checkForController()
    local joysticks = love.joystick.getJoysticks()
    if #joysticks > 0 then
        self.controller = joysticks[1]
    end
end

-- Continously update the movement values.
function UserInput:_updateMovementValues()
    local x, y = 0, 0
    ---Mnk.
    if love.keyboard.isDown(controls.moveRight.key) then
        x = 1
    elseif love.keyboard.isDown(controls.moveLeft.key) then
        x = -1
    elseif self.controller then
        ---Controller
        local joystickX = self.controller:getGamepadAxis('leftx')
        if math.abs(joystickX) > self.movementDeadzone then
            x = joystickX
        end
    end
    if love.keyboard.isDown(controls.moveUp.key) then
        y = -1
    elseif love.keyboard.isDown(controls.moveDown.key) then
        y = 1
    elseif self.controller then
        ---Controller
        local joystickY = self.controller:getGamepadAxis('lefty')
        if math.abs(joystickY) > self.movementDeadzone then
            y = joystickY
        end
    end
    self.movement.x = x
    self.movement.y = y
end

-- Check for control's being pressed by the keyboard.
function UserInput:_checkKeyboardButton(key)
    for controlName, control in pairs(controls) do
        if control.key == key then
            if self.onButtonPressed then
                self.onButtonPressed(controlName)
            end
        end
    end
end

-- Check for control's being pressed by the controller.
function UserInput:_checkControllerButton(button)
    for controlName, control in pairs(controls) do
        if control.controllerButton == button then
            if self.onButtonPressed then
                self.onButtonPressed(controlName)
            end
        end
    end
end

-- Check for control's being pressed by the mouse.
function UserInput:_checkMouseButton(button)
    for controlName, control in pairs(controls) do
        if control.mouseButton == button then
            if self.onButtonPressed then
                self.onButtonPressed(controlName)
            end
        end
    end
end

-- Update the controller aim values.
function UserInput:_updateControllerAim()
    self.controllerAim.distance = 0
    if self.controller then
        local x = self.controller:getGamepadAxis('rightx')
        local y = self.controller:getGamepadAxis('righty')
        local distance = math.sqrt(x ^ 2 + y ^ 2)
        if distance >= self.aimingDeadzone then
            self.controllerAim.distance = distance
            self.controllerAim.direction = math.atan2(y, x)
        end
    end
end

-- Triggers are treated as axes by the joystick api. However, we want to use
-- them as buttons. This function enables that behavior.
function UserInput:_executeTriggerPresses()
    if self.controller and self.onButtonPressed then
        local rightTrigger = self.controller:getGamepadAxis('triggerright')
        local leftTrigger  = self.controller:getGamepadAxis('triggerleft')
        if rightTrigger > self.triggerDeadzone and not self._rightTriggerPressed then
            self.onButtonPressed('primaryAttack')
            self._rightTriggerPressed = true
        elseif rightTrigger < self.triggerDeadzone then
            self._rightTriggerPressed = false
        end
        if leftTrigger > self.triggerDeadzone and not self._leftTriggerPressed then
            self.onButtonPressed('secondaryAttack')
        elseif leftTrigger < self.triggerDeadzone then
            self._leftTriggerPressed = false
        end
    end
end

return UserInput
