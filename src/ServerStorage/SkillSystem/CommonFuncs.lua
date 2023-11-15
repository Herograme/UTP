module = {}


local Debris = game:GetService("Debris")

local DENSITY = 0.1
local FRICTION = 0.1
local ELASTICITY = 0.1
local FRICTION_WEIGHT = 0.1
local ELASTICITY_WEIGHT = 0.1

module._DEBRIS = false
module._DEBRIS_TIME = 15
module._Visibles = true

module.HitboxFolder =  workspace.HitBox :: Folder


function module.AttachPlayer(Player:Player,PartPlayer:string,Offset:Vector3,Debris:BoolValue?)
    local Attach:Attachment = Instance.new("Attachment")
    Attach.Parent = Player.Character[PartPlayer]
    Attach.Position = Offset

    if module._DEBRIS and not Debris then
        Debris:AddItem(Attach,module.DEBRIS_TIME)
    end

    return Attach
end

function  module.GenerateBasicBox(shape:string,Size:Vector3)
    
    local ShapeTypes = {
        ["Ball" or "BALL" or "ball"] = Enum.PartType.Ball,
        ["Box" or "BOX" or "box"] = Enum.PartType.Block,
        ["Cylinder"] =  Enum.PartType.Cylinder
    }


    local NewHit:Part =  Instance.new("Part")
    NewHit.Shape = ShapeTypes[shape] or Enum.PartType.Ball
    NewHit.Size = Size
    NewHit.Transparency = 1
    NewHit.Color = Color3.fromRGB(255,0,0)
    NewHit.CollisionGroup = "Combat"
    NewHit.CustomPhysicalProperties = PhysicalProperties.new(DENSITY,FRICTION,ELASTICITY,FRICTION_WEIGHT,ELASTICITY_WEIGHT)    
   
    if module._Visibles then
        NewHit.Transparency = 0.5
    end
    if module._DEBRIS then
        Debris:AddItem(NewHit,module.DEBRIS_TIME)
    end

    return NewHit
end

function module:ChangeProperties(properties:string,value:boolean)
    if self["_"..properties] then
        self["_"..properties] = value
    end
end



module.enumparts = {
    RootPart = "HumanoidRootPart",
    RightHand = "RightHand",
}

return module 