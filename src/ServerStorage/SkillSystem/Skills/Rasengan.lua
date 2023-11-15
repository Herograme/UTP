local module = {}

local SIZE = Vector3.new(1, 1, 1)

local OFFSET = Vector3.new(0, -1, 0)
local TWInfo = TweenInfo.new(5)

local DELAY_TIME = 6

local CommomFuncs = require(script.Parent.Parent.CommonFuncs)

function module.Generate(Player: Player)
	local attach = CommomFuncs.AttachPlayer(Player, CommomFuncs.enumparts.RightHand, OFFSET, false)
	local Hitbox = CommomFuncs.GenerateBasicBox("Ball", SIZE)
	local AtachHit = Instance.new("Attachment",Hitbox)

	local RigidConstraint = Instance.new("RigidConstraint")
	RigidConstraint.Attachment0 = attach
	RigidConstraint.Attachment1 = AtachHit
	RigidConstraint.Parent = attach

	Hitbox.Parent =  CommomFuncs.HitboxFolder
	return Hitbox
end

function module.Effect(Hitbox: Part, Player: Player, Destiny: CFrame)
    
end

return module
