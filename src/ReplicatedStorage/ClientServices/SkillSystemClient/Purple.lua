local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
--local LocalPlayer:Player = Players.LocalPlayer

local OFFSET_RED = Vector3.new(12.16, 1.46, -7.85)
local OFFSET_BLUE= Vector3.new(-12.16, 1.46, -7.85)
local OFFSET_CENTRAL = Vector3.new(0, 1.46, -7.85)

local infoTW = TweenInfo.new(1.5)

local contprint = 1

function de_bug()
    print(contprint)
    contprint += 1
end

function OffsetInWorld(Offset:Vector3,Player:Player,hitbox:Part)
    local attach:Attachment =  Instance.new("Attachment")
    attach.Parent = Player.Character.HumanoidRootPart
    attach.Position = Offset
    local OffsetInWorld = attach.WorldCFrame
    attach:Destroy()
    return OffsetInWorld
end

return function (PlayerOrigin:Player,hitbox:Part,SkillAnimation:Animation)

    warn("Spawning Purple Client")
    local Origin = hitbox:GetPivot()

    local Animator:Animator = PlayerOrigin.Character.Humanoid.Animator
    local AnimationTrack:AnimationTrack  = Animator:LoadAnimation(SkillAnimation)

    AnimationTrack:Play(0.2)
    warn("Purple")
    
    AnimationTrack:AdjustSpeed(0)

    task.wait(0.5)
    --AnimationTrack:AdjustSpeed(0)
    local Blue = ReplicatedStorage.VFXHERO.Gojo.BlueH:Clone()
    local Red = ReplicatedStorage.VFXHERO.Gojo.RedH:Clone()

    Blue.CFrame = OffsetInWorld(OFFSET_BLUE,PlayerOrigin)
    Red.CFrame = OffsetInWorld(OFFSET_RED,PlayerOrigin)

    Blue.Parent = PlayerOrigin.Character
    Blue.Spawn.ParticleEmitter:Emit(1) 
    task.wait(1)
    Red.Parent = PlayerOrigin.Character
    Red.Spawn.ParticleEmitter:Emit(1)
    task.wait(1)

    local tweenTable:Part = {}
    tweenTable.CFrame = OffsetInWorld(OFFSET_CENTRAL,PlayerOrigin)

    TweenService:Create(Blue,infoTW,tweenTable):Play()
    TweenService:Create(Red,infoTW,tweenTable):Play()
    task.wait(1.2)

    local SkillModel:Model = ReplicatedStorage.AnimeEffects.Purple:Clone()
    SkillModel:PivotTo(Origin)

    local Welding = Instance.new("WeldConstraint")
    Welding.Part0 = hitbox
    Welding.Part1 = SkillModel.PrimaryPart
    Welding.Parent = hitbox

    SkillModel.PrimaryPart.Anchored = false
    SkillModel.Parent = hitbox

    Red:Destroy()
    Blue:Destroy()

    for i,ParticleEmitter:ParticleEmitter in pairs(SkillModel:GetDescendants()) do
        if ParticleEmitter:IsA("ParticleEmitter") then
            ParticleEmitter.Enabled = true
        end
    end

    AnimationTrack:AdjustSpeed(1)
   
    AnimationTrack.Ended:Wait()
    PlayerOrigin.Character:SetAttribute("AnimationState",false)
    PlayerOrigin.Character.HumanoidRootPart.Anchored = false
end