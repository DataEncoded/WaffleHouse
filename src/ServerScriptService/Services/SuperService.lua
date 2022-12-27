local Knit = require(game:GetService("ReplicatedStorage").Packages.knit)
local Players = game:GetService("Players")

local Supers = game.ServerScriptService.Modules.Supers

local SuperService = Knit.CreateService({
	Name = "SuperService",
	Client = {
		InputSignal = Knit.CreateSignal(),
		UIUpdate = Knit.CreateSignal(),
	},
	Players = {},
})

function SuperService:KnitStart()
	-- \\ Do a check if a player loaded in before knit start

	for _, Player in pairs(Players:GetPlayers()) do
		if self.Players[Player.UserId] == nil then
			self.Players[Player.UserId] = {
				Super = require(Supers.fryingPan).new(Player),
				Points = 0,
			}
		end
	end
end

function SuperService:KnitInit()
	Players.PlayerAdded:Connect(function(player)
		if self.Players[player.UserId] == nil then
			self.Players[player.UserId] = {
				Super = require(Supers.fryingPan).new(player),
				Points = 0,
				CanGainPoints = true,
			}
		end
	end)

	self.Client.InputSignal:Connect(function(player, event)
		if self.Players[player.UserId] ~= nil then
			local playerData = self.Players[player.UserId]

			print("CUR: " .. playerData.Points .. "REQ: " .. playerData.Super.PointsReq)
			if
				playerData.Points == playerData.Super.PointsReq
				and event == "Activate"
				and not playerData.Super.SuperInfo.Active
			then
				playerData.Super:Activate()
				playerData.CanGainPoints = false
				playerData.Points = 0
			end
		end
	end)
end

function SuperService:AddPoints(player, points)
	if self.Players[player.UserId] ~= nil then
		local playerData = self.Players[player.UserId]
		if playerData.Points < playerData.Super.PointsReq and playerData.CanGainPoints then
			if (playerData.Points + points) <= playerData.Super.PointsReq then
				playerData.Points += points
			elseif (playerData.Points + points) > playerData.Super.PointsReq then
				playerData.Points = playerData.Super.PointsReq
			end

			self.Client.UIUpdate:Fire(player, { playerData.Points, playerData.Super.PointsReq })
		end
	end
end

return SuperService
