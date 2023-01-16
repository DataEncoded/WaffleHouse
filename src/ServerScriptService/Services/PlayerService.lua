local Knit = require(game:GetService("ReplicatedStorage").Packages.knit)
local Option = require(game:GetService("ReplicatedStorage").Packages.option)

local Players = game:GetService("Players")

local PlayerService =
	Knit.CreateService({ Name = "PlayerService", players = {}, Client = { dealDamage = Knit.CreateSignal() } })

function PlayerService:KnitInit()
	Players.PlayerAdded:Connect(function(player)
		self.players[player] = {}
		self.players[player]["punchCooldown"] = false
		self.players[player]["blocking"] = false
		self.players[player]["blockTick"] = -1
		self.players[player]["characterConnection"] = player.CharacterAdded:Connect(function(character)
			self.players[player]["character"] = character
			self.players[player]["punchCooldown"] = false
			self.players[player]["blocking"] = false
			self.players[player]["blockTick"] = -1
		end)
	end)

	Players.PlayerRemoving:Connect(function(player)
		if self.players[player] then
			if self.players[player]["characterConnection"] then
				self.players[player]["characterConnection"]:Disconnect()
				self.players[player]["characterConnection"] = nil
			end

			if self.players[player]["character"] then
				self.players[player]["character"] = nil
			end
		end
	end)
end

function PlayerService:GetPlayer(player)
	if self.players[player] then
		return Option.Some(self.players[player])
	end

	return Option.None
end

return PlayerService
