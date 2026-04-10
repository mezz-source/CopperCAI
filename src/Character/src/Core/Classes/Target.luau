local Target = {}
Target.__index = Target

function Target.new(targetModel: Model)
    local self = setmetatable({}, Target)
    self.targetModel = targetModel
    self.humanoid = targetModel and targetModel:FindFirstChildOfClass("Humanoid") or nil
    self.type = "Generic"
    return self
end

function Target:GetHealth(): number
    if self.humanoid then
        return self.humanoid.Health
    end
    return 0
end

function Target:IsValid(): boolean
    return self.targetModel and self.humanoid and self.humanoid.Health > 0
end

function Target:GetCFrame(): CFrame
    if self.targetModel and self.targetModel.PrimaryPart then
        return self.targetModel.PrimaryPart.CFrame
    end
    return CFrame.new()
end

function Target:GetPosition(): Vector3
    if self.targetModel and self.targetModel.PrimaryPart then
        return self.targetModel.PrimaryPart.Position
    end
    return Vector3.zero
end

function Target:GetDistance(yourCharacter: Model): number
    if not self.targetModel or not yourCharacter.PrimaryPart then
        return math.huge
    end

    local targetPrimaryPart = self.targetModel.PrimaryPart
    if not targetPrimaryPart then
        return math.huge
    end

    local characterPosition = yourCharacter.PrimaryPart.Position
    local targetPosition = targetPrimaryPart.Position

    return (characterPosition - targetPosition).Magnitude
end

function Target:TakeDamage(damageContext)
    -- TODO: Implement
end

function Target:Kill(breakJoints: boolean?)
    if self.humanoid then
        self.humanoid.BreakJoints = breakJoints or false
        self.humanoid.Health = 0
        self.humanoid:ChangeState(Enum.HumanoidStateType.Dead)
    end
end

-- Destroys the target object and model
function Target:Destroy()
    if self.targetModel then
        self.targetModel:Destroy()
    end
end

-- Destroys the target object but not the model
function Target:Disconnect()
    self.targetModel = nil
end


return Target