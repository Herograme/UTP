local Players = game:GetService("Players")
local ServerStorange = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local teleportService = game:GetService("TeleportService")

local TycoonService = require(ServerStorange.Services.TycoonUtilites)
--local InventoryMananger = require(ServerStorange.Services.InventoryMananger)
local DataMananger = require(ServerStorange.Services.DataMananger)

local Remotes = ReplicatedStorage.Remotes

local mainFolder_Workspace = workspace
local playersPets =mainFolder_Workspace.PlayerData.PlayerPets

game.Players.PlayerAdded:Connect(function(player)
	
    player:SetAttribute("Cash",0)
    player:SetAttribute("Shards",0)
    player:SetAttribute("OwnsTycoon",false)

	TycoonService:PlayerInit(player)
    

	

	for _,v in pairs(workspace.TycoonModels:GetChildren()) do
		Remotes.EffectsController:FireClient(player,"OuterButtonsDestroyer",v)
	end
	
	
	
end)








Players.PlayerRemoving:Connect(function(player)

        print(TycoonService:GetPlayerCache(player))
	--TycoonService.DoorReset(player)


end)




function TeleportPlayer(player)
    
    local sucess, err = pcall(teleportService.Teleport, teleportService, 13896208273, player)
    
    if not sucess then
        warn(`Error while teleporting player ({player.UserId}) when the BindToClose is called: {err}`)
    end
    
end

function BindToClose()
    
    for index, player in Players:GetPlayers() do
        task.spawn(TeleportPlayer, player)
    end
    
end

game:BindToClose(BindToClose)