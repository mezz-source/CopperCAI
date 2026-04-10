local Targetting = {}

local Modules = script.Parent
local Classes = Modules.Classes
local GenericTarget = require(Classes.Target)
local CopperTarget = require(Classes.CopperTarget)

export type Target = {
    targetModel: Model?,
    humanoid: Humanoid?,
    type: string,

    GetHealth: (self: Target) -> number,
    GetCFrame: (self: Target) -> CFrame,
    GetPosition: (self: Target) -> Vector3,
    IsValid: (self: Target) -> boolean,
    GetDistance: (self: Target, yourCharacter: Model) -> number,
    TakeDamage: (self: Target, damageContext: any) -> (),
    Kill: (self: Target, breakJoints: boolean?) -> (),
    Destroy: (self: Target) -> (),
    Disconnect: (self: Target) -> ()
}

local Configuration = require(Modules:WaitForChild("Configuration"))
local Character = script.Parent.Parent.Parent

local lastValidTargetList = {}

local function getCurrentPosition(): Vector3
    if not Character.PrimaryPart then
        return Vector3.zero
    end
    return Character.PrimaryPart.Position
end

local function getDistanceFromCharacter(target: Instance): number
    if not target:IsA("Model") then return math.huge end
    local targetPrimaryPart = target.PrimaryPart
    if not targetPrimaryPart then return math.huge end

    local characterPosition = getCurrentPosition()
    local targetPosition = targetPrimaryPart.Position

    return (characterPosition - targetPosition).Magnitude
end

local function createTargetObject(targetModel: Model): Target
    -- TODO: Implement target recognition systems
    return GenericTarget.new(targetModel)
end

local function getValidTargets(): {Target}
    local children = workspace:GetChildren()
    local validTargets: {Model} = {}
    local targetList: {Target} = {}

    -- TODO: Team check

    local TARGETTING_RADIUS = Configuration.get("TARGETTING_RADIUS")

    for _, child in ipairs(children) do
        if not child:IsA("Model") then continue end
        if not child.PrimaryPart then continue end
        local Humanoid = child:FindFirstChildOfClass("Humanoid")
        if not Humanoid or Humanoid.Health <= 0 then continue end

        if getDistanceFromCharacter(child) <= TARGETTING_RADIUS then
            table.insert(validTargets, child)
        end
    end
    
    -- Convert valid targets (do it after for loop to avoid unnecessary object creation)
    for _, targetModel in ipairs(validTargets) do
        table.insert(targetList, createTargetObject(targetModel))
    end

    return targetList
end

local function closestInList(validTargets)
    local closestTarget: Target? = nil
    local closestDistance = math.huge

    for _, target in ipairs(validTargets) do
        local distance = target:GetDistance(Character)
        if distance < closestDistance then
            closestDistance = distance
            closestTarget = target
        end
    end

    return closestTarget
end

local function lowestHealthInList(validTargets)
    local lowestHealthTarget: Target? = nil
    local lowestHealth = math.huge

    for _, target in ipairs(validTargets) do
        local health = target:GetHealth()
        if health < lowestHealth then
            lowestHealth = health
            lowestHealthTarget = target
        end
    end

    return lowestHealthTarget
end

local function highestThreatInList(validTargets)
    -- TODO: Threat analysis
end

function Targetting.getTarget(targettingPreference: "Closest" | "LowestHealth" | "HighestThreat", updateList: boolean): Target?
    if updateList then
        lastValidTargetList = getValidTargets()
    end

    local targets = lastValidTargetList

    local prefToFunction = {
        Closest = closestInList,
        LowestHealth = lowestHealthInList,
        HighestThreat = highestThreatInList
    }

    return prefToFunction[targettingPreference](targets)
end

function Targetting.update()
    lastValidTargetList = getValidTargets()
end

return Targetting