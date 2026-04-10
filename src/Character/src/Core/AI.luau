local AI = {}

local Modules = script.Parent
local ThoughtProcess = require(Modules:WaitForChild("ThoughtProcess"))
ThoughtProcess.start()

Modules.Parent.GetBus.OnInvoke = function()
    return ThoughtProcess.Bus
end

return AI