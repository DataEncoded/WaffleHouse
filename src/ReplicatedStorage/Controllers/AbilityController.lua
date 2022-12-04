
local Knit = require(game:GetService("ReplicatedStorage").Packages.knit)
local UserInputService = game:GetService("UserInputService")
local AbilityController = Knit.CreateController {
    Name = "AbilityController",
    Client = {},
}


function AbilityController:KnitStart()
    
end


function AbilityController:KnitInit()
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.LeftShift then
            local AbilityService = Knit.GetService("AbilityService")
            AbilityService.InputSignal:Fire("Ability")
        end
    end)

end


return AbilityController
