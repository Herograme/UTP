

local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DbAll = {}




local Remotes = ReplicatedStorage.Remotes

local DataMananger =require(ServerStorage.Services.DataMananger)
local InventoryMananger =  require(ServerStorage.Services.InventoryMananger)
local PlayerUtilities = require(ServerStorage.Services.PlayerUtilites)
local PetUtilites = require(ServerStorage.Services.PetUtilites)
local TycoonManger = require(ServerStorage.Services.TycoonMananger)
local utilities = require(ServerStorage.Services.Utilities)


--------------
--Debugs
_G.PrintData = function(Player)
    print(InventoryMananger:GetInventory(Player))
end

_G.SetMoney = function(Value)
  local dataPlayer = InventoryMananger:GetInventory(Players.herograme)
  dataPlayer:BankUpdate("Cash",Value)
end
--------------


DataMananger:Init()
TycoonManger:Init()
InventoryMananger:Init()
TycoonManger.ConnectTycoonDoor()

Remotes.EggsEvent.OnServerEvent:Connect(function(Player,Func,...)
    
    warn("Recebi",Player,Func,...)

    if DbAll[Player.UserId..Func] == true then return end 

    DbAll[Player.UserId..Func] = true 

    local tempFunc = PetUtilites[Func]



    if tempFunc then 
        tempFunc(Player,...)
    end    

    task.spawn(function()
        task.wait(2)
        DbAll[Player.UserId..Func] = false
    end)

    --local PlayersInventory = InventoryMananger.GetPlayerInventory(Player)
    --print(PlayersInventory)
end)








--local function LoadModelTycoon (Player,TycoonModel)
    
--









--Remotes.ChosenTycoon.OnServerEvent:Connect()











