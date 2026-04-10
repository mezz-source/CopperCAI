local ThoughtProcess = {}

local RunService = game:GetService("RunService")

local Modules = script.Parent
local State = require(Modules:WaitForChild("State"))

function ThoughtProcess.update()
    State.update()

    if not State.isAlive() then
        return
    end
end

function ThoughtProcess.start()
    print("Thought Process Started")

    -- Bind update process
    RunService.Heartbeat:Connect(ThoughtProcess.update)
end


return ThoughtProcess