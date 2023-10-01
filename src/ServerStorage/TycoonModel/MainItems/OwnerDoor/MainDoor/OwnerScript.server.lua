local players = game:GetService("Players")





script.Parent.Touched:Connect(function(Hit)
	local player = players:GetPlayerFromCharacter(Hit.Parent)
	task.wait(0.5)
	if not player then
		return 
	end
	local OwnsTycoon = player:GetAttribute("OwnsTycoon")
	
--	print(tostring(OwnsTycoon))
	
	local TycoonModel = script.Parent.Parent.Parent.Parent
	local PlayerID = players[player.Name].UserId
	local ownedTycoon = TycoonModel:GetAttribute("OwnedTycoon")
	
	
	if OwnsTycoon == false and ownedTycoon == false then
	--	print(PlayerID)
		TycoonModel.Name = PlayerID
		script.Parent.SurfaceGui.TextLabel.Text = tostring(player.Name) .. " Tycoon "
		players[player.Name]:SetAttribute("OwnsTycoon", true)
		TycoonModel:SetAttribute("OwnedTycoon", true)
	end
	
end)