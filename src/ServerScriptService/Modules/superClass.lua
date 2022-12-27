local superClass = {}
superClass.__index = superClass

function superClass.new()
	local self = setmetatable({}, superClass)

	self.SuperInfo = {
		Name = nil,
		PointsReq = 2500,

		Icon = nil,
	}
	return self
end

function superClass:Use() end

function superClass:ForceStop() end
function superClass:Destroy() end

return superClass
