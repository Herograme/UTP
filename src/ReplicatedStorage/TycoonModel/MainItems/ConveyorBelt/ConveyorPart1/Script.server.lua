ConveyorSpeed = 10


while wait() do
	script.Parent.Velocity= script.Parent.CFrame.LookVector* ConveyorSpeed
end