local abilityClass = {}
abilityClass.__index = abilityClass


function abilityClass.new()
    local self = setmetatable({}, abilityClass)

    self.AbilityInfo = {
        Name = nil;
        Cooldown = nil;
    }
    return self
end

function abilityClass:Use()
    
end

function abilityClass:ForceStop()
    
end
function abilityClass:Destroy()
    
end


return abilityClass
