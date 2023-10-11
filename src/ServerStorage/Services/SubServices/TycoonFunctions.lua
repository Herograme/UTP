local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local InventoryMananger = require(ServerStorage.Services.InventoryMananger)
local CacheManager = require(ServerStorage.Services.CacheMananger)
local NumberFormatter = require(ReplicatedStorage.FormatNumber.Custom)
local minionData =  require(ReplicatedStorage.MinionsData)
local bridgenet2 =  require(ReplicatedStorage.Packages.bridgenet2)

local MinionSpawned = bridgenet2.ReferenceBridge("MinionSpawned")

local module = {}

local MainItensSystem = {
   ["cashbutton"] = function(Item,Inventory,Cache)
        local Screen = Item.ScreenPart.SurfaceGui
        local PartTouch = Item.ButtonPartT

        PartTouch.Touched:Connect(function(Hit)
            local Character =  Hit.Parent
            local Player = Players:GetPlayerFromCharacter(Character)

            if not Player then return end 

            if Player.UserId == Cache.Owner.UserId then
                Inventory.Cash += Cache.TycoonCash
                Cache.TycoonCash = 0
                Cache.TycoonModel:SetAttribute("Cash",0)
                Player:SetAttribute("Cash",Inventory.Cash)
            end

        end)

        Cache.TycoonModel.AttributeChanged:Connect(function()
            local CashAtt = Cache.TycoonModel:GetAttribute("Cash") or 0
            Screen.TextLabel.Text = NumberFormatter.functions.FormaterNumbers(CashAtt).."$"
        end)
   end,
   [""] = function()
    
   end
}



local PurchaseItensSystem = {
    ["replicator"] = function(Item,Inventory,Cache)
        Cache:AddThreads(Item.Name,function()
            local Minion = Cache:GetMinionReplicator(Item.Name)
            if Minion then
                local DataMinion = minionData:GetMinionData(Minion)
                if not Minion then return end 
                while task.wait(4) do
                    local MinionModel= DataMinion.Model:Clone()
                    MinionModel:SetNetworkOwner(Cache.Owner)
                    MinionSpawned:Fire(Cache.Owner, {data = DataMinion,minion = MinionModel,replicator = Item})
                end
            else
                Cache:AddMinionReplicator(Item.Name)
                local DataMinion = minionData:GetMinionData("default")
                while task.wait(4) do
                    local MinionModel = DataMinion.Model:Clone()
                    MinionModel:SetNetworkOwner(Cache.Owner)
                    MinionSpawned:Fire(Cache.Owner, {data = DataMinion,minion = MinionModel,replicator = Item,tycoonModel = Cache.TycoonModel})
                end
            end
        end)
    end
}


function module:ActiveSystem(ClassSystem,Item,Player)
    local Inventory = InventoryMananger:GetInventory(Player)
    local Cache =  CacheManager:GetPlayerCache(Player)
    local Class =  Item:GetAttribute("Class")

    if not Class then return end 

    Cache:AddThreads(ClassSystem.."_"..Item.Name,function()
        if ClassSystem == "MainItens" then
            local System = MainItensSystem[Class]
            
            if System then
                System(Item,Inventory,Cache)
            end     
        elseif ClassSystem == "PurchaseItens" then
            local System = PurchaseItensSystem[Class]
            
            if System then
                System(Item,Inventory,Cache)
            end    
        end
    end)

end

return module