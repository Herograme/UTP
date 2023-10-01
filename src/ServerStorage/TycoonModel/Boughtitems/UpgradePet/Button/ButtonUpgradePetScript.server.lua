local button = script.Parent
local Utilities = require(game.ServerStorage.UtilitiesScript)
local remote = Utilities.GameServices.replicatedStorange.Remotes

--print("printou alguma coisa ")
button.ClickDetector.MouseClick:Connect(function(player)
		remote.OpenInventoryPetUpgrade:FireClient(player)
		--print("enviou")
end)

