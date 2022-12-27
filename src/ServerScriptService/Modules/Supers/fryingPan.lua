local fryingPan = {}
fryingPan.__index = fryingPan

local superClass = require(script.Parent.Parent.superClass)
setmetatable(fryingPan, superClass)

local promise = require(game:GetService("ReplicatedStorage").Packages.promise)

local Swings = {
	"rbxassetid://11789393896",
	"rbxassetid://11789390447",
}

function fryingPan.new(player)
	local newSuper = superClass.new()
	local self = setmetatable(newSuper, fryingPan)

	self.PointsReq = 1500 -- \\ 2500

	self.Swing = 1
	self.SwingInterval = 0.75
	self.CanSwing = true

	self.playerInstance = player

	self.SuperInfo = {
		Name = "Frying Pan",

		Icon = nil,

		Active = false,
		Duration = 8,
	}
	return self
end

function fryingPan:Activate()
	-- \\ Visual Activation
	local Character = self.playerInstance.Character or self.playerInstance.CharacterAdded:Wait()
	local HumRoot = Character:FindFirstChild("HumanoidRootPart")
	local Humanoid = Character:FindFirstChild("Humanoid")

	local Animator = Humanoid:FindFirstChild("Animator")

	local FryPanAnimation = Instance.new("Animation")
	FryPanAnimation.AnimationId = "rbxassetid://11780748158"

	local FryPanTrack = Animator:LoadAnimation(FryPanAnimation)
	FryPanTrack:Play()

	-- 9125644905

	local PanSound = Instance.new("Sound")
	PanSound.SoundId = "rbxassetid://9119077183"
	PanSound.Parent = HumRoot
	PanSound.RollOffMaxDistance = 125
	PanSound.RollOffMinDistance = 15
	PanSound.Volume = 1
	PanSound.RollOffMode = Enum.RollOffMode.InverseTapered
	PanSound:Play()

	local MagicSound = Instance.new("Sound")
	MagicSound.SoundId = "rbxassetid://9116384762"
	MagicSound.Parent = HumRoot
	MagicSound.RollOffMaxDistance = 125
	MagicSound.RollOffMinDistance = 15
	MagicSound.Volume = 1
	MagicSound.RollOffMode = Enum.RollOffMode.InverseTapered
	MagicSound:Play()

	local FryingPan = game.ServerScriptService.Assets.Supers.FryingPan:Clone()
	Humanoid:AddAccessory(FryingPan)

	task.wait(2.5)
	for i, v in pairs(FryingPan.Handle.Middle:GetChildren()) do
		if v:IsA("ParticleEmitter") then
			v.Enabled = false
		end
	end

	local FryPanIdleAnimation = Instance.new("Animation")
	FryPanIdleAnimation.AnimationId = "rbxassetid://11783558043"

	local FryPanIdleTrack = Animator:LoadAnimation(FryPanIdleAnimation)
	FryPanIdleTrack:Play()

	promise.delay(self.SuperInfo.Duration):andThen(function()
		self:End()
	end)
end

function fryingPan:Action()
	if self.SuperInfo.Active and self.CanSwing then
	end
end

function fryingPan:End() end
function fryingPan:Destroy() end

return fryingPan
