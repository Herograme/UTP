local TycoonModel = script.Parent.Parent.Parent.Parent

local OwnerValueId = TycoonModel:GetAttribute("OwnedTycoon")
local ownedTycoon = TycoonModel:GetAttribute("OwnedTycoon")
local players = game:GetService("Players")

local Utilities = require(game:GetService("ServerStorage").UtilitiesScript)

script.Parent.Touched:Connect(function(Hit)
	
	if Hit.Parent:FindFirstChild("Humanoid")then
		local player= players:GetPlayerFromCharacter(Hit.Parent)
		local PlayerID = player.UserId
		
		local playerChecked = Utilities.functions.CheckPlayer(player, TycoonModel)
		
		if not playerChecked then
			
			if script.Parent.Parent.Lasers.CanTouch == true then
				Hit.Parent:FindFirstChild("Humanoid").Health = 0
				
			end
		end
	end
end)


