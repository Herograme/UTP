local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer :: Player
local effectsFolder =  ReplicatedStorage.AnimeEffects.Kamehameha
local twininfo =  TweenInfo.new(1,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut)
local Effect:Model
local rigid:RigidConstraint
local AnimationParms = {}

local SCALE_I = 0.001
local SCALE_T = 0.2

function AnimationParms.charge1(AnimationTrack:AnimationTrack,PlayerOrigin:Player) 
print("charge1")
	--AnimationTrack:AdjustSpeed(0)
	local attach = Instance.new("Attachment")
	attach.Parent = PlayerOrigin.Character.RightHand
	attach.Position = Vector3.new(0, -0.8, 0)

	Effect = effectsFolder.KamehamehaCharge:Clone()
	Effect:ScaleTo(0.1)

	rigid= Instance.new("RigidConstraint")
	rigid.Attachment0 = attach
	rigid.Attachment1 = Effect.PrimaryPart.Attachment
	rigid.Parent = attach

	Effect.Parent = PlayerOrigin.Character

	local ObjNumber = Instance.new("NumberValue")
	ObjNumber.Value = SCALE_I

	local TWEEN = TweenService:Create(ObjNumber,twininfo,{Value = SCALE_T})
	local numberConnect = ObjNumber.Changed:Connect(function(value)
		Effect:ScaleTo(value)
		if value > SCALE_T/3 then
			Effect.PrimaryPart.Attachment.ParticleEmitter.Rate = 20
			Effect.PrimaryPart.Attachment.ParticleEmitter.Enabled = true
		end
	end)
	TWEEN:Play()
	TWEEN.Completed:Wait()
	--AnimationTrack:AdjustSpeed(1)
	numberConnect:Disconnect()
end

function AnimationParms.finalcharge(AnimationTrack:AnimationTrack) 
	print("chargefinal")
	AnimationTrack:AdjustSpeed(0)
	task.wait(1)

	
	AnimationTrack:AdjustSpeed(1)
end

function AnimationParms.launcher(AnimationTrack:AnimationTrack,PlayerOrigin:Player)
	AnimationTrack:AdjustSpeed(0)
	task.delay(3,function()
		AnimationTrack:AdjustSpeed(1)
	end)
	print("launcher")
end

return function(PlayerOrigin: Player, hitbox: Part, SkillAnimation: Animation)
	local Animator: Animator = PlayerOrigin.Character.Humanoid.Animator
	local AnimationTrack: AnimationTrack = Animator:LoadAnimation(SkillAnimation)

	AnimationTrack:Play(0.2)

	local animeEvetion = AnimationTrack:GetMarkerReachedSignal("power"):Connect(function(parms)
		if AnimationParms[parms] then
			AnimationParms[parms](AnimationTrack,PlayerOrigin)
		end
	end)

	AnimationTrack.Ended:Once(function()
		animeEvetion:Disconnect()
		if PlayerOrigin.UserId == LocalPlayer.UserId then
			LocalPlayer.Character:SetAttribute("AnimationState",false)
			LocalPlayer.Character.HumanoidRootPart.Anchored = false
		end
	end)

end
