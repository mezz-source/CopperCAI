local Configuration = {}

local Folder = script.Parent.Parent.Configuration :: Configuration

local CONFIG: {[string]: number | string | Vector3 | Instance} = {}

-- Remaps CONFIG to match the configuration folder
local function updateConfig()
    for name, value in ipairs(Folder:GetDescendants()) do
        if value:IsA("ValueBase") then
            CONFIG[value.Name] = value.Value
        end
    end
end

function Configuration.get(key: string): number | string | Vector3 | Instance
    return CONFIG[key]
end

return Configuration