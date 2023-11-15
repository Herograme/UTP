local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ContextActionService = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local LocalPlayer = Players.LocalPlayer

local ControllerPlayer = require(LocalPlayer.PlayerScripts.PlayerModule)

local animationFolder = ReplicatedStorage.Animations
local skillfolder = ReplicatedStorage.AnimeEffects
local SkillModel
local inputState: string = "front"
local characterSLIST = {}
local Overlapinfo: OverlapParams = OverlapParams.new()
Overlapinfo.FilterType = Enum.RaycastFilterType.Include

local HITBOXRADIUS = 2

type Callbackfunc = (hitbox: Part, PlayerOrigin: Player, animationtracker: AnimationTrack) -> ()

for i, Character in pairs(workspace.characters:GetChildren()) do
	local Player = Players:GetPlayerFromCharacter(Character)

	if CollectionService:HasTag(Character, "NPC") then
		print(Character)
		table.insert(characterSLIST, Character)
		continue
	end

	if not Player then
		continue
	end
	if Player.UserId ~= LocalPlayer.UserId then
		table.insert(characterSLIST, Character)
	end
end

workspace.characters.childAdded:Connect(function(Children)
	local Player = Players:GetPlayerFromCharacter(Children)

	if not Player then
		return
	end
	if Player.UserId ~= LocalPlayer.UserId then
		table.insert(characterSLIST, Children)
	end
end)

function movePlayer(Action: string, State: Enum.UserInputState)
	if State == Enum.UserInputState.Begin then
		inputState = Action
	elseif State == Enum.UserInputState.End then
		inputState = "front"
	end
end

function SecondState(hitbox: Part, PlayerOrigin: Player, animationtrackerOLD: AnimationTrack)
	local ImpactModel = skillfolder.ImpactRasegan:Clone()
	local Animation2 = animationFolder.Rasengan2
	local Animator: Animator = PlayerOrigin.Character.Humanoid.Animator
	local AnimationTrack: AnimationTrack = Animator:LoadAnimation(Animation2)

	AnimationTrack:Play(0.05)
	AnimationTrack:AdjustSpeed(0.7)
	animationtrackerOLD:Stop()
	AnimationTrack.Ended:Wait()
	SkillModel:Destroy()
	ImpactModel:PivotTo(hitbox.CFrame)
	for i, Emiter: ParticleEmitter in pairs(ImpactModel:GetDescendants()) do
		if Emiter:IsA("ParticleEmitter") then
			Emiter:Emit(5)
		end
	end
	ControllerPlayer:AlternateControlls(true)
end

function HeartbeatFunc(State: boolean, hitbox: Part?, callback: Callbackfunc, PlayerOrigin, animationtracker: Animation)
	local Thread

	if State then
		local Tdelay = task.delay(20, function()
			Thread:Disconnect()
			LocalPlayer:Move(Vector3.new(0, 0, 0), true)
			callback(hitbox, PlayerOrigin, animationtracker)
		end)

		Thread = RunService.Heartbeat:Connect(function()
			if inputState == "Left" then
				LocalPlayer:Move(Vector3.new(-1, 0, -1), true)
			elseif inputState == "Right" then
				LocalPlayer:Move(Vector3.new(1, 0, -1), true)
			else
				LocalPlayer:Move(Vector3.new(0, 0, -1), true)
			end

			Overlapinfo.FilterDescendantsInstances = characterSLIST
			local Parts = workspace:GetPartBoundsInRadius(hitbox.Position, HITBOXRADIUS, Overlapinfo)

			if #Parts > 0 then
				print(Parts)
				Thread:Disconnect()
				task.cancel(Tdelay)
				LocalPlayer:Move(Vector3.new(0, 0, 0), true)
				callback(hitbox, PlayerOrigin, animationtracker)
			end
		end)
	else
		Thread:Disconnect()
	end
end

function X_ControllsActivate(state: boolean)
	if state == nil then
		return
	end

	if state then
		ContextActionService:BindAction("Left", movePlayer, false, Enum.KeyCode.A)
		ContextActionService:BindAction("Right", movePlayer, false, Enum.KeyCode.D)
	else
		ContextActionService:UnbindAction("Left")
		ContextActionService:UnbindAction("Right")
	end
end

return function(PlayerOrigin: Player, hitbox: Part, SkillAnimation: Animation?)
	local Animator: Animator = PlayerOrigin.Character.Humanoid.Animator
	local Animation1 = animationFolder.Rasengan1
	SkillModel = skillfolder.Rasengan:Clone()
	local animationtracker: AnimationTrack = Animator:LoadAnimation(Animation1)

	LocalPlayer.Character.HumanoidRootPart.Anchored = false
	animationtracker:Play()
	if PlayerOrigin.UserId == LocalPlayer.UserId then
		ControllerPlayer:AlternateControlls(false)
		HeartbeatFunc(true, hitbox, SecondState, PlayerOrigin, animationtracker)
		X_ControllsActivate(true)
	end

	SkillModel:PivotTo(hitbox.CFrame)
	local welding = Instance.new("WeldConstraint")
	welding.Part0 = hitbox
	welding.Part1 = SkillModel.PrimaryPart
	welding.Parent = hitbox
	SkillModel.Parent = hitbox
end
