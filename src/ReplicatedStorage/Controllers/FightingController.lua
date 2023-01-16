local Knit = require(game:GetService("ReplicatedStorage").Packages.knit)
local Option = require(game:GetService("ReplicatedStorage").Packages.option)
local Promise = require(game:GetService("ReplicatedStorage").Packages.promise)

local CollectionService = game:GetService("CollectionService")

local FightingController = Knit.CreateController({ Name = "FightingController" })
local DamageService

local Players = game:GetService("Players")

local localPlayer = Players.LocalPlayer

local function getCharacter()
	if
		localPlayer
		and localPlayer.Character
		and localPlayer.Character.Humanoid
		and localPlayer.Character.Humanoid.Health > 0
	then
		return Option.Some(localPlayer.Character)
	end
	return Option.None
end

function FightingController:KnitStart()
	DamageService = Knit.GetService("DamageService")
end

--Play animation, then tell server
function FightingController:punch(punchDirection)
	local character = getCharacter()

	if character:IsNone() then
		--No character, return
		return
	else
		character = character:Unwrap()
	end

	local hand = character:FindFirstChild(punchDirection .. "Hand")

	assert(
		hand and hand:FindFirstChild(punchDirection .. "GripAttachment"),
		"[FightingController] punch: Invalid punch direction given."
	)

	local grip = hand[punchDirection .. "GripAttachment"]

	self:watchHitbox(grip, 3)
end

function FightingController:watchHitbox(attachment, seconds)
	local character = getCharacter()
	assert(attachment and attachment:IsA("Attachment"), "[FightingController] watchHitbox: Invalid attachment given.")
	assert(character:IsSome(), "[FightingController] watchHitbox: Attempting to watch hitbox of no character.")
	character = character:Unwrap()

	--Loop over characters to skip checks in GetPartBoundsInRadius
	local hittable = CollectionService:GetTagged("Hittable")

	--If memory really becomes an issue with this, move this outside of this function, should be fine tho
	local params = OverlapParams.new()
	params.FilterDescendantsInstances = hittable
	params.FilterType = Enum.RaycastFilterType.Whitelist

	Promise.new(function(resolve, _, onCancel)
		local breakVal
		for _ = 0, seconds * 10, 1 do
			onCancel(function()
				breakVal = true
			end)

			if breakVal then
				break
			end

			local hits = workspace:GetPartBoundsInRadius(attachment.WorldPosition, 2, params)

			local characterHits = {}

			if #hits > 0 then
				--Seperate hits into different characters
				for _, hit in ipairs(hits) do
					local posChar = hit:FindFirstAncestorWhichIsA("Model")

					if posChar then
						if table.find(hittable, posChar) and not table.find(characterHits, posChar) then
							table.insert(characterHits, posChar)
						end
					end
				end
			end

			if #characterHits > 0 then
				--Player hit!!!
				DamageService.dealDamage:Fire(characterHits[1], false)

				breakVal = true
				resolve()
			end

			task.wait(0.1)
		end
		resolve()
	end)
end

function FightingController:block()
	DamageService.block:Fire()
end

return FightingController
