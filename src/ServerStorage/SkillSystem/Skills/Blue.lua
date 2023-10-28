--export type HitBoxfunc = (Player:Player) -> BasePart

module = {}

local DELAY_TIME = 1.5
local OFFSET = Vector3.new(-0.12, -0, -3.02)


local CommomFuncs = require(script.Parent.Parent.CommonFuncs)

function module.Generate(Player:Player)
    local attach:Attachment = CommomFuncs.AttachPlayer(Player,"HumanoidRootPart",OFFSET)
    local HitIn:Part = CommomFuncs.GenerateBasicBox("Ball",Vector3.new(3,3,3))
    local HitEx:Part = CommomFuncs.GenerateBasicBox("Ball",Vector3.new(15,15,15))
    local Welding:WeldConstraint = Instance.new("WeldConstraint")

    HitIn.Name = "HitIn"
    HitEx.Name = "HitEx"
    HitEx.Parent = HitIn
    Welding.Parent = HitIn
    Welding.Part0 = HitIn
    Welding.Part1 = HitEx
    HitIn.Anchored = true
    HitIn:PivotTo(attach.WorldCFrame)
    HitEx:PivotTo(HitIn:GetPivot())
    HitIn.Parent = game.Workspace.HitBox
    
    print("Hitbox generated")
    return HitIn
end

function module.Effect(Hitbox:Part,Player:Player,Destiny:CFrame)

    local Origin = Hitbox:GetPivot()

    local Attachment:Attachment =  Instance.new("Attachment")
    Attachment.Parent =  Hitbox

    local LinearVelocity:LinearVelocity = Instance.new("LinearVelocity")
    LinearVelocity.MaxForce = math.huge
    LinearVelocity.VectorVelocity = CFrame.lookAt(Origin.Position, Destiny.Position).LookVector * 100
    LinearVelocity.Attachment0 = Attachment
    LinearVelocity.Parent = Hitbox

    task.delay(DELAY_TIME,function()
    Hitbox.Anchored = false
    end)

    print("ApplyEffect in Hitbox")
end

return module 