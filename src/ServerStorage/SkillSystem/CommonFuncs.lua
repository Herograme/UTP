module = {}

local Debris = game:GetService("Debris")

local DENSITY = 0.1
local FRICTION = 0.1
local ELASTICITY = 0.1
local FRICTION_WEIGHT = 0.1
local ELASTICITY_WEIGHT = 0.1

local _DEBRIS = true
local _Visibles = false

_G.HitboxVisibles = function(State:boolean)
    _Visibles = State
end

function module.AttachPlayer(Player:Player,PartPlayer:string,Offset:Vector3)
    local Attach:Attachment = Instance.new("Attachment")
    Attach.Parent = Player.Character[PartPlayer]
    Attach.Position = Offset

    if _DEBRIS then
        Debris:AddItem(Attach,3)
    end

    return Attach
end

function  module.GenerateBasicBox(shape:string,Size:Vector3)
    
    local ShapeTypes = {
        Ball = Enum.PartType.Ball,
        Box = Enum.PartType.Block,
        Cylinder =  Enum.PartType.Cylinder
    }


    local NewHit:Part =  Instance.new("Part")
    NewHit.Shape = ShapeTypes[shape] or Enum.PartType.Ball
    NewHit.Size = Size
    NewHit.Transparency = 1
    NewHit.Color = Color3.fromRGB(255,0,0)
    NewHit.CollisionGroup = "Combat"
    NewHit.CustomPhysicalProperties = PhysicalProperties.new(DENSITY,FRICTION,ELASTICITY,FRICTION_WEIGHT,ELASTICITY_WEIGHT)    
   
    if _Visibles then
        NewHit.Transparency = 0.5
    end

    return NewHit
end


return module 