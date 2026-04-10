local Configuration = {}

local Folder = script.Parent.Parent.Parent.Configuration :: Configuration

export type ConfigKey = "REACTION_SPEED" | "TARGETTING_SPEED" | "TARGETTING_PREFERENCE"

local CONFIG: {[ConfigKey]: number | string | Vector3 | Instance} = {
    REACTION_SPEED = 0.2, -- How long it takes for the character to react to changes in the environment, in seconds
    TARGETTING_SPEED = 1, -- How often the character updates its targetting information, in seconds
    TARGETTING_PREFERENCE = "Closest", -- The method used to select targets. Options: "Closest", "LowestHealth", "HighestThreat"
}

-- Remaps CONFIG to match the configuration folder
local function updateConfig()
    for name, value in ipairs(Folder:GetDescendants()) do
        if value:IsA("ValueBase") then
            CONFIG[value.Name] = value.Value
        end
    end
end

function Configuration.get(key: ConfigKey): number | string | Vector3 | Instance | nil
    if not CONFIG[key] then
        warn("Configuration key '" .. key .. "' does not exist.")
        return nil
    end

    return CONFIG[key]
end

function Configuration.reload()
    updateConfig()
end

return Configuration