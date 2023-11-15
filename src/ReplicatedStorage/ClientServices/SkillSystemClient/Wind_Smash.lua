local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local localPlayer:Player = Players.LocalPlayer 
local EffectsList = {}
local TwInfo = TweenInfo.new(0.5)

function ApplyWelding(hitbox:Part,skillModel:Model)
    local welding = Instance.new("WeldConstraint")
    skillModel.PrimaryPart:PivotTo(hitbox.CFrame)
    
    welding.Part0 = hitbox
    welding.Part1 = skillModel.PrimaryPart
    welding.Parent = hitbox
    
end

return function (PlayerOrigin:Player,hitboxes:Part,SkillAnimation:Animation)
    if not PlayerOrigin or not hitboxes or not SkillAnimation then
        localPlayer.Character.HumanoidRootPart.Anchored = false
        return 
    end
    
    local PlayerOrietation:Vector3= PlayerOrigin.Character.HumanoidRootPart.Orientation

    for i,hitbox in pairs(hitboxes) do
        local Goal:MeshPart = {}
        Goal.Transparency = 0.5
        local SkillModel:Model = ReplicatedStorage.AnimeEffects.Wind_Smash:Clone()
        ApplyWelding(hitbox,SkillModel)
        SkillModel.PrimaryPart.Orientation = PlayerOrietation + Vector3.new(0,0,math.random(-180,180))
        
        SkillModel.WindEffects:PivotTo(SkillModel.PrimaryPart.CFrame)
        SkillModel.PrimaryPart.Transparency = 1
        table.insert(EffectsList,SkillModel)
        task.wait(0.3)
        SkillModel.Parent = hitbox
        TweenService:Create(SkillModel.PrimaryPart,TwInfo,Goal):Play()
    end

    local Animator:Animator = PlayerOrigin.Character.Humanoid.Animator    
    local AnimationTrack:AnimationTrack = Animator:LoadAnimation(SkillAnimation)
    AnimationTrack:Play()

    

    AnimationTrack.Ended:Wait()

    for i, SkillModel in pairs(EffectsList) do
        for x, Particles:ParticleEmitter in pairs(SkillModel.WindEffects:GetDescendants()) do
            if Particles:IsA("ParticleEmitter") then
                Particles.Enabled = true
            end
        end
    end

    localPlayer.Character.HumanoidRootPart.Anchored = false
end