local Enabled = true

script.Parent.ClickDetector.MouseClick:Connect(function(Hit)
	if Enabled == true then
		script.Parent.Parent.Lasers.Particles.Red.Enabled=false
		script.Parent.Parent.Lasers.Particles2.Red.Enabled=false
		script.Parent.Parent.Lasers.CanTouch = false
		Enabled = false
		
		
	else
		if Enabled == false then
			script.Parent.Parent.Lasers.Particles.Red.Enabled=true
			script.Parent.Parent.Lasers.Particles2.Red.Enabled=true
			script.Parent.Parent.Lasers.CanTouch = true
			Enabled = true
		end
	end
end)

