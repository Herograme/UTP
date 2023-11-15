local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
--local LocalPlayer:Player = Players.LocalPlayer

return function (PlayerOrigin:Player,hitbox:Part,SkillAnimation:Animation)
    warn("Spawning Blue Client")
    local Origin = hitbox:GetPivot()

    local Animator:Animator = PlayerOrigin.Character.Humanoid.Animator
    local AnimationTrack  = Animator:LoadAnimation(SkillAnimation)

    AnimationTrack:Play(0.2)

    AnimationTrack:GetMarkerReachedSignal("power"):Connect(function(parms)
        warn(parms)
        AnimationTrack:AdjustSpeed(0)
        
        local SkillModel:Model = ReplicatedStorage.AnimeEffects.Blue:Clone()
        SkillModel:PivotTo(Origin)

        local Welding = Instance.new("WeldConstraint")
        Welding.Part0 = hitbox
        Welding.Part1 = SkillModel.PrimaryPart
        Welding.Parent = hitbox

        SkillModel.Parent = hitbox

        task.wait(1.23)
        SkillModel.External:Destroy()
        PlayerOrigin.Character:SetAttribute("AnimationState",false)
        PlayerOrigin.Character.HumanoidRootPart.Anchored = false
        AnimationTrack:AdjustSpeed(1)
    end)
end