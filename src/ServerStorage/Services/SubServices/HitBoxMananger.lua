local DENSITY = 0.3
local FRICTION = 0.1
local ELASTICITY = 1
local FRICTION_WEIGHT = 1
local ELASTICITY_WEIGHT = 1


function  GenerateBasicBox(Shape,Size):Part
    print("Generate Hitbox")
    local ShapeTypes = {
        Ball = Enum.PartType.Ball,
        Box = Enum.PartType.Block,
        Cylinder =  Enum.PartType.Cylinder
    }


    local NewHit =  Instance.new("Part")
    NewHit.Shape = ShapeTypes[Size] or Enum.PartType.Ball
    NewHit.Size = Size
    NewHit.Transparency = 0.5
    NewHit.Color = Color3.fromRGB(255,0,0)
    NewHit.CollisionGroup = "Combat"
    NewHit.CustomPhysicalProperties = PhysicalProperties.new(DENSITY,FRICTION,ELASTICITY,FRICTION_WEIGHT,ELASTICITY_WEIGHT)    
   

    return NewHit
end


hitbox =  {
["Red"] = function()
    local NewHit =  GenerateBasicBox("Ball",Vector3.new(3,3,3))
    

    return NewHit
end,
["Blue"] =  function(Player:Player,Origin:CFrame)
  
    local HitIn:Part = GenerateBasicBox("Ball",Vector3.new(3,3,3))
    local HitEx:Part = GenerateBasicBox("Ball",Vector3.new(15,15,15))
    local Welding:WeldConstraint = Instance.new("WeldConstraint")

    HitIn.Name = "HitIn"
    HitEx.Name = "HitEx"
    HitEx.Parent = HitIn
    Welding.Parent = HitIn
    Welding.Part0 = HitIn
    Welding.Part1 = HitEx
    HitIn.Anchored = true
    HitIn:PivotTo(Origin)
    HitEx:PivotTo(HitIn:GetPivot())
    HitIn.Parent = game.Workspace.HitBox
    
    print("Hitbox generated")
    return HitIn
end,
}

effects = {
    ["Red"] = function()
        
    end,
    ["Blue"] = function(hitbox:Part,Player:Player,Direction:CFrame)--,Velocity:number)
       
        local Origin = hitbox:GetPivot()
        
        local Attachment:Attachment =  Instance.new("Attachment")
        Attachment.Parent =  hitbox

        local LinearVelocity:LinearVelocity = Instance.new("LinearVelocity")
        LinearVelocity.MaxForce = math.huge
        LinearVelocity.VectorVelocity = CFrame.lookAt(Origin.Position, Direction.Position).LookVector * 100
        LinearVelocity.Parent = hitbox
        LinearVelocity.Attachment0 = Attachment

        hitbox.Anchored = false
        
        print("ApplyEffect in Hitbox")
    end
}

module = {hitbox = hitbox,effects = effects}


function module:GetHitBox(Skill,Player:Player,Origin:CFrame)
    if self.hitbox[Skill] then
        return self.hitbox[Skill](Player,Origin)
    end
end



function module:GetEffect(hitbox:Part,Skill:string,Player:Player,Direction:CFrame,Velocity:number)
    if self.effects[Skill] then
        return self.effects[Skill](hitbox,Player,Direction)--,Velocity)
    end
end


return module