local TweenService = game:GetService("TweenService")

module = {}

local SIZE = Vector3.new(1,1,1)
local DistancyMax = Vector3.new(SIZE.X,SIZE.Y,400)
local OFFSET = Vector3.new(0, 0, -3)
local TWInfo = TweenInfo.new(5)

local DELAY_TIME = 6

local CommomFuncs = require(script.Parent.Parent.CommonFuncs)

function module.Generate(Player:Player)
    local Attach = CommomFuncs.AttachPlayer(Player,"HumanoidRootPart",OFFSET)
    local Hitbox = CommomFuncs.GenerateBasicBox("Box",SIZE)
    Hitbox.Name = "HitBox"
    Hitbox:PivotTo(Attach.WorldCFrame)
    Hitbox.Parent = game.Workspace.HitBox
    Hitbox.Anchored = true

    print("Hitbox generated")
    return Hitbox
end

function Raycasting()
    
end

function module.Effect(Hitbox:Part,Player:Player,Destiny:CFrame)
    task.wait(DELAY_TIME)

    local origin = Player.Character.HumanoidRootPart

    local initialPivot = Vector3.new(0,0,Hitbox.Size.Z/2)
    local LookVector = CFrame.lookAt(origin.Position, Destiny.Position).LookVector
    Hitbox.PivotOffset = CFrame.new(initialPivot,LookVector)
    local InitialPosition = Hitbox.CFrame

    local SizeValue = Instance.new("Vector3Value")
    SizeValue.Value = SIZE
    local Goal = {}
    Goal.Value = DistancyMax
    TweenService:Create(SizeValue,TWInfo,Goal):Play()

    SizeValue.Changed:Connect(function()
        Hitbox.Size = SizeValue.Value
        Hitbox.PivotOffset = CFrame.new(0,0,Hitbox.Size.Z/2)
        Hitbox:PivotTo(InitialPosition)
    end)
end    



return module