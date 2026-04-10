local CopperTarget = {}
CopperTarget.__index = CopperTarget

local Target = require(script.Parent.Target)

function CopperTarget.new(targetModel: Model)
    local self = Target.new(targetModel)
    self.type = "Copper"
    return self
end

function CopperTarget:TakeDamage(damageContext)
    -- TODO: Implement
end

return CopperTarget