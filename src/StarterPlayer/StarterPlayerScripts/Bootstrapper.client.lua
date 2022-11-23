local Knit = require(game:GetService("ReplicatedStorage").Packages.knit)
local Loader = require(game:GetService("ReplicatedStorage").Packages.loader)

local ContextActionService = game:GetService("ContextActionService")

Knit.AddControllersDeep(game:GetService("ReplicatedStorage").Controllers)

--Knit start, print status and then load components
Knit.Start()
	:andThen(function()
		print("[Knit] Client Bootstrapped")
		Loader.LoadDescendants(game:GetService("ReplicatedStorage").Components)
	end)
	:catch(warn)

local FightingController = Knit.GetController("FightingController")

local function handlePunchInput(actionName, inputState, _)
	if inputState == Enum.UserInputState.Begin then
		if actionName == "PunchLeft" then
			FightingController:punch("Left")
		elseif actionName == "PunchRight" then
			FightingController:punch("Right")
		else
			warn("[Client Bootstrapper] handlePunchInput: invalid punch action given. Action name was \" .. actionName .. \".")
		end
	end
end

ContextActionService:BindActionAtPriority("PunchLeft", handlePunchInput, true, Enum.ContextActionPriority.Medium.Value, Enum.KeyCode.Q)
ContextActionService:BindActionAtPriority("PunchRight", handlePunchInput, true, Enum.ContextActionPriority.Medium.Value, Enum.KeyCode.E)