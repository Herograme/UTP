local character = script.Parent
local humanoid = character:WaitForChild("Humanoid")
local animator = humanoid:WaitForChild("Animator")
local UnAvailable = false 


local animationTracks = {
	cheer = {"rbxassetid://507770677", Enum.AnimationPriority.Idle},
	dance = {"rbxassetid://507772104", Enum.AnimationPriority.Idle},
	dance2 = {"rbxassetid://507776879", Enum.AnimationPriority.Idle},
	dance3 = {"rbxassetid://507777623", Enum.AnimationPriority.Idle},
	wave = {"rbxassetid://507770239", Enum.AnimationPriority.Idle},
	laugh = {"rbxassetid://507770818", Enum.AnimationPriority.Idle},
	Lunge = {"rbxassetid://522638767", Enum.AnimationPriority.Movement, Play = nil},
	point = {"rbxassetid://507770453", Enum.AnimationPriority.Idle},

	Climb = {"rbxassetid://507765644", Enum.AnimationPriority.Movement},
	Fall = {"rbxassetid://507767968", Enum.AnimationPriority.Idle},
	Idle = {"rbxassetid://14777253718", Enum.AnimationPriority.Idle},
	Run = {"rbxassetid://14777263766", Enum.AnimationPriority.Movement},
	Sit = {"rbxassetid://2506281703", Enum.AnimationPriority.Core},
	Slash = {"rbxassetid://522635514", Enum.AnimationPriority.Action, Play = nil},
	Swim = {"rbxassetid://913384386", Enum.AnimationPriority.Movement},
	SwimIdle = {"rbxassetid://913389285", Enum.AnimationPriority.Idle},
	Tool = {"rbxassetid://507768375", Enum.AnimationPriority.Idle, Play = nil},
}


local animation = Instance.new("Animation")

for key, value in animationTracks do
	animation.AnimationId = value[1]

	local animationTrack = animator:LoadAnimation(animation)
	animationTrack.Priority = value[2]
	animationTracks[key] = animationTrack
end
animator, animation = animation:Destroy()

local animationTrack:AnimationTrack = animationTracks.Idle

script.Parent.AttributeChanged:Connect(function(AttributeChanged)
	if AttributeChanged ~= "AnimationState" then return end

	UnAvailable = script.Parent:GetAttribute(AttributeChanged)
	
	if UnAvailable == true then
		animationTrack:Stop()
	else
		animationTrack:Play(0.3)
	end
end)

if UnAvailable == false then
	animationTrack:Play()
end

local childAdded

character.ChildAdded:Connect(function(instance)
	if instance:IsA"Tool" and instance:FindFirstChild"Handle" then
		animationTracks.Tool:Play()

		childAdded = instance.ChildAdded:Connect(function(instance)
			if instance:IsA"StringValue" then
				local value = instance.Value

				if value == "Slash" then
					instance:Destroy()
					animationTracks.Slash:Play(0)
				elseif value == "Lunge" then
					instance:Destroy()
					animationTracks.Lunge:Play(0, 1, 6)
				end
			end
		end)
	end
end)

character.ChildRemoved:Connect(function(instance)
	local tool = animationTracks.Tool

	if tool.IsPlaying then
		tool:Stop()
		childAdded = childAdded:Disconnect()
	end
end)
character = nil

humanoid.Climbing:Connect(function(speed)
	if UnAvailable then return end 
	local climb = animationTracks.Climb

	if climb.IsPlaying then
		climb:AdjustSpeed(speed / 5)
	else
		animationTrack:Stop()
		animationTrack = climb
		animationTrack:Play()
	end
end)

humanoid.FreeFalling:Connect(function(active)
	if UnAvailable then return end 
	if active then
		animationTrack:Stop()
		animationTrack = animationTracks.Fall
		animationTrack:Play()
	end
end)

humanoid.Running:Connect(function(speed)
	if UnAvailable then return end 
	speed /= 16

	if speed > 1e-2 then
		local run = animationTracks.Run

		if run.IsPlaying then
			run:AdjustSpeed(speed)
		else
			animationTrack:Stop()
			animationTrack = run
			animationTrack:Play()
		end
	else
		animationTrack:Stop()
		animationTrack = animationTracks.Idle
		animationTrack:Play()
	end
end)

humanoid.Seated:Connect(function(active)
	if UnAvailable then return end 
	if active then
		animationTrack:Stop()
		animationTrack = animationTracks.Sit
		animationTrack:Play()
	end
end)

humanoid.Swimming:Connect(function(speed)
	if UnAvailable then return end 
	speed /= 10

	if speed > 1 then
		local swim = animationTracks.Swim

		if swim.IsPlaying then
			swim:AdjustSpeed(speed)
		else
			animationTrack:Stop()
			animationTrack = swim
			animationTrack:Play()
		end
	else
		local swimIdle = animationTracks.SwimIdle

		if not swimIdle.IsPlaying then
			animationTrack:Stop()
			animationTrack = swimIdle
			animationTrack:Play()
		end
	end
end)
humanoid = nil

--[[game.TextChatService:WaitForChild"TextChatCommands":WaitForChild"RBXEmoteCommand".Triggered:Connect(function(_, text)
	text = string.split(text, ' ')[2]

	local emotes = {
		cheer = 0,
		dance = 1,
		dance2 = 1,
		dance3 = 1,
		laugh = 0,
		point = 0,
		wave = 0}

	local emote = emotes[text]

	if emote then
		animationTrack:Stop()
		animationTrack = animationTracks[text]

		if emote == 1 then
			animationTrack.Looped = true
			animationTrack:Play()
		else
			animationTrack.Looped = false
			animationTrack:Play()
			animationTrack.Ended:Wait()

			if animationTrack == animationTracks[text] then
				animationTrack = animationTracks.Idle
				animationTrack:Play()
			end
		end
	end
end)]]