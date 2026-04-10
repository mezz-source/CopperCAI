local Movement = {}

local Character = script.Parent.Parent.Parent
local Bus = script.Parent.Parent.GetBus:Invoke()
local Humanoid = Character:WaitForChild("Humanoid")

local isLocked = false

local function getCurrentPosition()
    local PrimaryPart = Character.PrimaryPart
    if PrimaryPart then
        return PrimaryPart.Position
    end
    return Vector3.zero
end

local function stateChanged(lastState, newState) end



-- Picks a random spot and pathfinds over there
function Movement.wander()
    local randomPosition = getCurrentPosition() + Vector3.new(math.random(-20, 20), 0, math.random(-20, 20))
    Humanoid:MoveTo(randomPosition)
end

-- Forces the orientation to look at a character until released
function Movement.faceCharacter(targetCharacter)
    Movement.lock()

    -- TODO: Face character by updating
end

function Movement.lock()
    Humanoid.AutoRotate = false
    isLocked = true
end

-- Releases the forced orientation
function Movement.releaseFace()
    Humanoid.AutoRotate = true
    isLocked = false
end

-- Moves forward relative to the current orientation
function Movement.forward()
    local forwardVector = Character.PrimaryPart.CFrame.LookVector
    Humanoid:MoveTo(getCurrentPosition() + forwardVector * 5)
end

-- Moves backward relative to the current orientation
function Movement.backward()
    local backwardVector = -Character.PrimaryPart.CFrame.LookVector
    Humanoid:MoveTo(getCurrentPosition() + backwardVector * 5)
end

-- Moves left relative to the current orientation
function Movement.left()
    local leftVector = Character.PrimaryPart.CFrame.RightVector
    Humanoid:MoveTo(getCurrentPosition() + leftVector * 5)
end

-- Moves right relative to the current orientation
function Movement.right()
    local rightVector = -Character.PrimaryPart.CFrame.RightVector
    Humanoid:MoveTo(getCurrentPosition() + rightVector * 5)
end

-- Forces sprinting when moving
function Movement.sprint()

end

-- Returns default walk speed
function Movement.walk()
end

function Movement.jump()
end

function Movement.dashLeft()
    Bus:Send("PlayAnimation", "DashLeft")
end

function Movement.dashRight()
    Bus:Send("PlayAnimation", "DashRight")
end

function Movement.dashForward()
    Bus:Send("PlayAnimation", "DashForward")
end

function Movement.dashBackward()
    Bus:Send("PlayAnimation", "DashBackward")
end

return Movement