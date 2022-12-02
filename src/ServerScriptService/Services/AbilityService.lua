
local Players = game:GetService("Players")
local Abilities = game.ServerScriptService.Modules.Abilities
local Knit = require(game:GetService("ReplicatedStorage").Packages.knit)

local AbilityService = Knit.CreateService {
    Name = "AbilityService",
    Client = {
        InputSignal = Knit.CreateSignal();
        UIUpdate = Knit.CreateSignal()
    },
    Players = {}
}


function AbilityService:KnitStart()
    
    --\\ if players loaded in before knit start give them dash

    for _,Player in pairs(Players:GetPlayers()) do
        if self.Players[Player.UserId] == nil then
            self.Players[Player.UserId] = {
                Ability = require(Abilities.dash).new(Player)
            }
        end
    end
end


function AbilityService:KnitInit()

    --\\ for right now give players dash

    Players.PlayerAdded:Connect(function(player)
        self.Players[player.UserId] = {
            Ability = require(Abilities.dash).new(player)
        }
    end)

    -- \\ input listener

    self.Client.InputSignal:Connect(function(player, event)
        if event == "Ability" then
            if self.Players[player.UserId].Ability == nil then
                warn(player.DisplayName .." does not have an ability tied.")
            else
                print("Yee?")
                self.Players[player.UserId].Ability:Use()
            end
        end
    end)
    
end


return AbilityService
