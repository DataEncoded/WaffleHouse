local dash = {}
local abilityClass = require(script.Parent.Parent.abilityClass)
dash.__index = dash
setmetatable(dash, abilityClass)
local EFFECTIVE_TIME = 0.10

function dash.new(player)
	local newAbility = abilityClass.new()
	local self = setmetatable(newAbility, dash)

	self.playerInstance = player
	self.AbilityInfo = {
		Name = "Dash",
		Cooldown = 12,

		isAvail = true,
	}
	return self
end

function dash:Use()
	if self.AbilityInfo.isAvail == true then
		self.AbilityInfo.isAvail = false
		local Character = self.playerInstance.Character or self.playerInstance.CharacterAdded:Wait()
		local HumRoot = Character:FindFirstChild("HumanoidRootPart")
		local Humanoid = Character:FindFirstChild("Humanoid")

		local Animator = Humanoid:FindFirstChild("Animator")

		local DashAnimation = Instance.new("Animation")
		DashAnimation.AnimationId = "rbxassetid://11722050071"

		local DashTrack = Animator:LoadAnimation(DashAnimation)
		DashTrack:Play()

		local Particle = game.ServerScriptService.Assets.Particles:FindFirstChild("Sparks")

		if Particle == nil then
			warn("Some FX is missing and wont be displayed.")
		else
			local Sparks = Particle:Clone()
			Sparks.Parent = HumRoot

			Particle = Sparks
		end

		local DashSound = Instance.new("Sound")
		DashSound.SoundId = "rbxassetid://558640653"
		DashSound.Parent = HumRoot
		DashSound.RollOffMaxDistance = 125
		DashSound.RollOffMinDistance = 15
		DashSound.RollOffMode = Enum.RollOffMode.InverseTapered
		DashSound:Play()

		local ShockSound = Instance.new("Sound")
		ShockSound.SoundId = "rbxassetid://9120985853"
		ShockSound.Parent = HumRoot
		ShockSound.RollOffMaxDistance = 125
		ShockSound.RollOffMinDistance = 15
		ShockSound.RollOffMode = Enum.RollOffMode.InverseTapered

		ShockSound:Play()

		task.wait(0.1)
		Humanoid.Jump = true
		local BV = Instance.new("BodyVelocity")
		BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		BV.Velocity = HumRoot.CFrame.LookVector.Unit * 100
		BV.Parent = HumRoot

		task.wait(EFFECTIVE_TIME)
		BV:Destroy()
		task.wait(self.AbilityInfo.Cooldown / 2)
		if Particle ~= nil then
			Particle:Destroy()
		end
		DashSound:Destroy()

		task.wait(self.AbilityInfo.Cooldown / 2)
		self.AbilityInfo.isAvail = true
		ShockSound:Destroy()
	end
end

function dash:Destroy() end

return dash
