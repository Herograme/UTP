module =  {}

local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")

local Caches =  require(ServerStorage.Services.Profile.PlayersCache)
local InventoryMananger = require(ServerStorage.Services.InventoryMananger)

CacheMethods = {}

CacheMethods.__index = CacheMethods

function CreateCache(Player)

    CacheMethods = {
        ["Anime"] = false,
        ["Person"] = false,
        ["Owner"] = Player,
        ["TycoonBase"] = false,
        ["Threads"] = {},
        ["PurchasedItems"] = {},
        ["TycoonTemplate"] = false,
        ["TycoonCash"] = 0,
        ["TycoonModel"] = false,
        ["ReplicatorList"] = {}
    }

    return setmetatable({},CacheMethods)
end

function CacheMethods:SetTycoonBase(Model:Model)
    self.TycoonBase = Model    
end

function CacheMethods:AsyncData()
    local Inventory = InventoryMananger:GetInventory(self.Owner)

    self.PurchasedItems = Inventory.TycoonModels[self.Anime].Purchased
    self.ReplicatorList = Inventory.TycoonModels[self.Anime].Replicators
end

function CacheMethods:AddMinionReplicator(Name:string)
    self.ReplicatorList[Name] = "default"
end

function CacheMethods:MinionSelected(ReplicatorName,MinionName)
    self.ReplicatorList[ReplicatorName] = MinionName
end

function CacheMethods:GetMinionReplicator(ReplicatorName)
    local tempReplicator = self.ReplicatorList[ReplicatorName]

    if tempReplicator then return tempReplicator else end
end

function CacheMethods:AddThreads(Name,func)
    self.Threads[Name] = task.spawn(func)
end

function PlayerAdd(Player)
    Caches[Player.UserId] = CreateCache(Player)
end

function PlayerRemoving(Player)
    Caches[Player.UserId] = nil
end

Players.PlayerAdded:Connect(PlayerAdd) 
Players.PlayerRemoving:Connect(PlayerRemoving)

function module:GetPlayerCache(Player)
    return Caches[Player.UserId]
end

function module:CheckPersonAvailable(Person)
    for _,Cache in pairs(Caches) do
        if Cache.Person == Person then
            return false
        end
    end

    return true 
end

return module











