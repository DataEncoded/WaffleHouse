local Knit = require(game:GetService("ReplicatedStorage").Packages.knit)
local Loader = require(game:GetService("ReplicatedStorage").Packages.loader)

Knit.AddServicesDeep(script.Parent.Services)

Knit.Start()
	:andThen(function()
		print("[Knit] Server Bootstrapped")
		Loader.LoadDescendants(script.Parent.Components)
	end)
	:catch(warn)
