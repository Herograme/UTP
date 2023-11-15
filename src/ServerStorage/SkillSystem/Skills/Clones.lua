local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

module = {}

type HitboxesTable = {[number]:Part}
type AttachTable  = {[number]:Attachment}
type ClonesTable = {[number]:Model}

local OFFSET1 = Vector3.new(0, 0, -4)
local OFFSET2 = Vector3.new(-6, 0, 0)
local OFFSET3 = Vector3.new(6, 0, 0)

local DELAY_TIME = 6

local CommomFuncs = require(script.Parent.Parent.CommonFuncs)
local SimplePath = require(ReplicatedStorage.Packages.simplepath)

function module.Generate(Player:Player)
    

    local PlayerSize =  Player.Character:GetExtentsSize()
    local Hitboxes:HitboxesTable = {}
    local Attachs:AttachTable = {}

    Attachs[1] = CommomFuncs.AttachPlayer(Player,CommomFuncs.enumparts.RootPart,OFFSET1)
    Attachs[2] = CommomFuncs.AttachPlayer(Player,CommomFuncs.enumparts.RootPart,OFFSET2)
    Attachs[3] = CommomFuncs.AttachPlayer(Player,CommomFuncs.enumparts.RootPart,OFFSET3)

    Hitboxes[1] = CommomFuncs.GenerateBasicBox("Box",PlayerSize)
    Hitboxes[2] = Hitboxes[1]:Clone()
    Hitboxes[3] = Hitboxes[1]:Clone()

    for i:number,hitbox:Part in pairs(Hitboxes) do
        hitbox:PivotTo(Attachs[i].WorldCFrame)
        hitbox.Anchored =  true 
        hitbox.Parent = CommomFuncs.HitboxFolder
    end

    print("Hitbox generated")
    return Hitboxes
end 

function module.Effect(Hitboxes:Part|table,Player:Player,Destiny:CFrame)
    local clones:ClonesTable = {} 

    Player.Character.Archivable = true
    local Character =  Player.Character:Clone()
    for i ,script:Script in pairs(Character:GetDescendants()) do
       if script:IsA("Script") then
        script:Destroy()
       end 
    end

    for i:number,hitbox:Part in pairs(Hitboxes) do
        clones[i] =  Character:Clone()
        clones[i]:PivotTo(hitbox.CFrame)
        CollectionService:AddTag(clones[i],"CLONE")
        local attach = Instance.new("Attachment")
        attach.Parent =  hitbox
        local Smoke:Model = ReplicatedStorage.AnimeEffects.SmokeNaruto:Clone()
        Smoke.Name = "Smoke"
        Smoke.Parent = clones[i]
        local Rigid2 = Instance.new("RigidConstraint")
        Rigid2.Parent = Smoke
        Rigid2.Attachment0 = clones[i].HumanoidRootPart.RootAttachment
        Rigid2.Attachment1 = Smoke.PrimaryPart.Attach
        Smoke:PivotTo(attach.WorldCFrame)
        --Smoke.PrimaryPart.Attach.Smoke:Emit(3)                            
        clones[i].Parent = workspace.characters
        hitbox.Parent = clones[i]
        local Rigid = Instance.new("RigidConstraint")
        Rigid.Attachment0 = clones[i].HumanoidRootPart.RootAttachment
        Rigid.Attachment1 = attach
        Rigid.Parent = hitbox
    end

    
end    

return module 