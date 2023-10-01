local Idle1 = script.Parent:WaitForChild("Idle1") --breathing
local Idle2 = script.Parent:WaitForChild("Idle2") --looking around
local Idle3 = script.Parent:WaitForChild("Idle3") --Slap him

local anim1 = script.Parent.Humanoid:LoadAnimation(Idle1)
local anim2 = script.Parent.Humanoid:LoadAnimation(Idle2)
local anim3 = script.Parent.Humanoid:LoadAnimation(Idle3)

while true do
	anim1:Play()
	wait(30)
	anim1:Stop()
	anim2:Play()
	wait(30)
	anim2:Stop()
	anim3:Play()
	wait(30)
	anim3:Stop()
end