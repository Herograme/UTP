local Players = game:GetService("Players")
local ServerStorange = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local teleportService = game:GetService("TeleportService")
local ContentProvider = game:GetService("ContentProvider")


--local InventoryMananger = require(ServerStorange.Services.InventoryMananger)
--local DataMananger = require(ServerStorange.Services.DataMananger)
local BridgeNet = require(ReplicatedStorage.Packages.bridgenet2)

---------------
--Remotes
local TycoonEvents = BridgeNet.ReferenceBridge("TycoonEvents")
local GuiLoader =  BridgeNet.ReferenceBridge("GuiLoader")
---------------

local mainFolder_Workspace = workspace
local playersPets =mainFolder_Workspace.PlayerData.PlayerPets

game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(Character)
        repeat
            task.wait()
        until Character:IsDescendantOf(workspace)
        
        Character.Parent = workspace.characters
        player.Character:SetAttribute("AnimationState",false)
        --GuiLoader:Fire(player,{"load"}) 
    end)   

    player:SetAttribute("Cash",0)
    player:SetAttribute("Shards",0)
    player:SetAttribute("OwnsTycoon",false)
    player:SetAttribute("CurrentInput","Skill")
    

    player:SetAttribute("Q","Kamehameha")
    player:SetAttribute("E","Blue")
    player:SetAttribute("R","Purple")   

    local TycoonBases = workspace.TycoonModels:GetChildren()
	--TycoonEvents:Fire(player,{Func="OuterButtonsDestroyer",content = TycoonBases}
end)


--[[Players.PlayerRemoving:Connect(function(player)
        
	--TycoonService.DoorReset(player)
end)]]

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