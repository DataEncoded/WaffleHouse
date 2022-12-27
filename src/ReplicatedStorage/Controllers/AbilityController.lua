local ContextActionService = game:GetService("ContextActionService")
local Knit = require(game:GetService("ReplicatedStorage").Packages.knit)
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local AbilityController = Knit.CreateController({
	Name = "AbilityController",
	Client = {},
})

local ACTION_ABILITY = "Ability"
local ACTION_SUPER = "Super"

function AbilityController:KnitStart()
	--\\ Ability UI Listener

	local AbilityService = Knit.GetService("AbilityService")
	local SuperService = Knit.GetService("SuperService")

	AbilityService.UIUpdate:Connect(function(event, Time)
		print("yeehaw")
		if event == "Use" then
			local localPlayer = Players.LocalPlayer
			local playerGui = localPlayer.PlayerGui
			local AbilityUI = playerGui.MainUI.Ability
			local AbilityIcon = playerGui.MainUI.AbilityIcon

			AbilityIcon.BackgroundColor3 = Color3.fromRGB(157, 157, 157)
			for i = Time, 0, -1 do
				if i <= 0 then
					AbilityUI.Text = ""
					AbilityIcon.BackgroundColor3 = Color3.fromRGB(255, 242, 0)
				else
					AbilityUI.Text = i
				end
				task.wait(1)
			end
		end
	end)

	SuperService.UIUpdate:Connect(function(data)
		local localPlayer = Players.LocalPlayer
		local playerGui = localPlayer.PlayerGui
		local SuperUI = playerGui.MainUI.Super
		local SuperIcon = playerGui.MainUI.SuperIcon
		local currentPoints = data[1]
		local neededPoints = data[2]
		local completion = currentPoints / neededPoints

		if completion < 1 then
			SuperIcon.BackgroundColor3 = Color3.fromRGB(157, 157, 157)
			SuperUI.Text = math.ceil(completion * 100) .. "%"
		elseif completion >= 1 then
			SuperIcon.BackgroundColor3 = Color3.fromRGB(255, 242, 0)
			SuperUI.Text = ""
		end
	end)
end

function AbilityController:KnitInit()
	local function handleAction(actionName, inputState, _inputObject)
		if actionName == ACTION_ABILITY and inputState == Enum.UserInputState.Begin then
			local AbilityService = Knit.GetService("AbilityService")
			AbilityService.InputSignal:Fire("Ability")
		elseif actionName == ACTION_SUPER and inputState == Enum.UserInputState.Begin then
			local SuperService = Knit.GetService("SuperService")
			SuperService.InputSignal:Fire("Activate")
		end
	end

	ContextActionService:BindAction(ACTION_ABILITY, handleAction, true, Enum.KeyCode.LeftShift)
	ContextActionService:BindAction(ACTION_SUPER, handleAction, true, Enum.KeyCode.T)
end

return AbilityController
