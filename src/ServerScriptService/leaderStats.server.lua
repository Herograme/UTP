local DataStoreServices = game:GetService("DataStoreService")
local myDataStore = DataStoreServices:GetDataStore("TycoonPet")
local FormatNumber = require(game.ReplicatedStorage.FormatNumber.Custom)



game.Players.PlayerAdded:Connect(function(player)
	local leaderstats = Instance.new("Folder",player)
	leaderstats.Name = "leaderstats"
	task.wait(2)
	local Cash = Instance.new("StringValue", leaderstats)
	Cash.Name = "Cash"
	Cash.Value = FormatNumber.functions.FormaterNumbers(player:GetAttribute("Cash"))
	
	local Shards = Instance.new("StringValue", leaderstats)
	Shards.Name = "Shards"
	Shards.Value = FormatNumber.functions.FormaterNumbers(player:GetAttribute("Shards"))
	
	
	
	player.AttributeChanged:Connect(function()
		Cash.Value = FormatNumber.functions.FormaterNumbers(player:GetAttribute("Cash"))
		Shards.Value = FormatNumber.functions.FormaterNumbers(player:GetAttribute("Shards"))
	end)
	
	
	
end)


