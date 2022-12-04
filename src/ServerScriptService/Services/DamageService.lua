local Knit = require(game:GetService("ReplicatedStorage").Packages.knit)

local CollectionService = game:GetService("CollectionService")

local DamageService = Knit.CreateService({ Name = "DamageService", Client = { dealDamage = Knit.CreateSignal() } })

function DamageService:KnitStart()
	local PlayerService = Knit.GetService("PlayerService")

	function DamageService.DealDamage(player, hit, _critical)
		player = PlayerService:GetPlayer(player)

		if player:IsSome() and hit and hit:IsA("Model") and CollectionService:HasTag(hit, "Hittable") then
			player = player:Unwrap()

			if
				player.character
				and player.character:FindFirstChild("Humanoid")
				and player.character.Humanoid.Health > 0
				and hit:FindFirstChild("Humanoid")
				and hit.Humanoid.Health > 0
			then
				if (player.character:GetPivot().Position - hit:GetPivot().Position).Magnitude < 5 then
					hit.Humanoid.Health = hit.Humanoid.Health - 17
				end
			end
		end
	end

	DamageService.Client.dealDamage:Connect(function(player, hit, critical)
		DamageService.DealDamage(player, hit, critical)
	end)
end

return DamageService
