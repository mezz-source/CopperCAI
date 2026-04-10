local ThoughtProcess = {}

local RunService = game:GetService("RunService")

local Modules = script.Parent
local Enums = Modules:WaitForChild("Enums")

local Events = require(Enums.Events).Events
local Requests = require(Enums.Requests).Requests

local Bus = require(Modules:WaitForChild("Bus"))
local State = require(Modules:WaitForChild("State"))
local Configuration = require(Modules:WaitForChild("Configuration"))
local Targetting = require(Modules:WaitForChild("Targetting"))

local intervalElapsed: {[string]: number} = {}

local lastTarget: Targetting.Target? = nil
local currentTarget: Targetting.Target? = nil

ThoughtProcess.Bus = Bus.new()
local Bus = ThoughtProcess.Bus

-- TODO: Update ya states, boy

function ThoughtProcess.wanderSequence()
    if not State.canAct() then
        return
    end

    Bus:Send(Events.WanderSequenceUpdate)
end

function ThoughtProcess.combatSequence()
    if not State.canAct() then
        return
    end

    local targettingPreference = Configuration.get("TARGETTING_PREFERENCE")
    currentTarget = Bus:Recieve(Requests.GetTarget, targettingPreference)

    if currentTarget ~= lastTarget then
        lastTarget = currentTarget
        Bus:Send(Events.NewTarget, currentTarget)
    end

    Bus:Send(Events.CombatSequenceUpdate, currentTarget)
end

function ThoughtProcess.updateTargetting(dt: number)
    if not State.canAct() then
        return
    end

    Bus:Send(Events.TargettingUpdate)
end

function ThoughtProcess.updateReactions(dt: number)
    if not State.canAct() then
        return
    end

    local inCombat = State.isCombatting()

    if not inCombat then
        ThoughtProcess.wanderSequence()
    else
        ThoughtProcess.combatSequence()
    end
end

--[[
    Thought Process Update Logic
]]

local INTERVAL_FUNCTIONS: {[string]: (number) -> ()} = {
    REACTION_SPEED = ThoughtProcess.updateReactions,
    TARGETTING_SPEED = ThoughtProcess.updateTargetting
}

for intervalName, _ in pairs(INTERVAL_FUNCTIONS) do
    intervalElapsed[intervalName] = 0
end

function ThoughtProcess.update(dt: number)
    State.update()

    if not State.isAlive() then
        return
    end

    -- Update intervals
    for intervalName, intervalFunction in pairs(INTERVAL_FUNCTIONS) do
        local intervalSeconds = Configuration.get(intervalName)

        if typeof(intervalSeconds) == "number" and intervalSeconds > 0 then
            local elapsed = intervalElapsed[intervalName] + dt

            while elapsed >= intervalSeconds do
                elapsed -= intervalSeconds
                intervalFunction(dt)
            end

            intervalElapsed[intervalName] = elapsed
        end
    end
end

function ThoughtProcess.start()
    print("Thought Process Started")

    -- Bind update process
    RunService.Heartbeat:Connect(ThoughtProcess.update)
end


return ThoughtProcess