
local dash = {}
local abilityClass = require(script.Parent.Parent.abilityClass)
dash.__index = dash
setmetatable(dash, abilityClass)
local EFFECTIVE_TIME = .10
function dash.new(player)
    local newAbility = abilityClass.new()
    local self = setmetatable(newAbility, dash)

    self.playerInstance = player;
    self.AbilityInfo = {
        Name = "Dash";
        Cooldown = 8;

        isAvail = true;
        
    }
    return self
end

function dash:Use()

    if self.AbilityInfo.isAvail == true then
        local Character = self.playerInstance.Character or self.playerInstance.CharacterAdded:Wait()
        local HumRoot = Character:FindFirstChild("HumanoidRootPart")
        
        local BV = Instance.new("BodyVelocity")
        BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        BV.Velocity = HumRoot.CFrame.LookVector.Unit * 100
        BV.Parent = HumRoot

        local DashSound = Instance.new("Sound")
        DashSound.SoundId = "rbxassetid://558640653"
        DashSound.Parent = HumRoot

        DashSound:Play()

        task.wait(EFFECTIVE_TIME)
        BV:Destroy()
        task.wait(3)
        DashSound:Destroy()
    end
end

function dash:Destroy()
    
end


return dash
