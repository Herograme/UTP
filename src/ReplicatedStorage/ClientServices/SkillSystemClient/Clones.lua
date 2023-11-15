local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local localPlayer:Player =  Players.LocalPlayer
local CharactersFolder =  workspace.characters :: Folder


CharactersFolder.ChildAdded:Connect(function(child)
    if CollectionService:HasTag(child,"CLONE") then
        local smoke =  child:WaitForChild("Smoke")
        if smoke then 
            smoke.PrimaryPart.Attach.Smoke:Emit(3)
        end
    end
end)

local udim  = UDim2.new(0,0.5,0,0)
--local udim  = UDim2.new(XOFSET,XSCALE,YOFSET,YSCALE)

-- 1200,400

return function(PlayerOrigin: Player, hitbox: Part, SkillAnimation: Animation?)
    local Animator:Animator = PlayerOrigin.Character.Humanoid.Animator

    if SkillAnimation then
        local AnimationTrack:AnimationTrack = Animator:LoadAnimation(SkillAnimation)
        AnimationTrack:Play()
    
    
        AnimationTrack.Ended:Wait()
    end
    PlayerOrigin.Character:SetAttribute("AnimationState",false)
    localPlayer.Character.HumanoidRootPart.Anchored = false
end     