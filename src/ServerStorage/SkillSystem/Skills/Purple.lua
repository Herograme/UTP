
module = {}

local DELAY_TIME = 6
local OFFSET = Vector3.new(-0.25, 0, -71.67)
local SIZE = Vector3.new(36,36,36)


local CommomFuncs = require(script.Parent.Parent.CommonFuncs)

function module.Generate(Player:Player)
    local attach:Attachment = CommomFuncs.AttachPlayer(Player,"HumanoidRootPart",OFFSET)
    local HitIn:Part = CommomFuncs.GenerateBasicBox("Ball",SIZE)

    HitIn.Name = "HitIn"
    HitIn.Anchored = true
    HitIn:PivotTo(attach.WorldCFrame)
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