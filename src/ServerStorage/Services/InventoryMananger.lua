type tycoonData = {["Purchased"]:{string},["Replicators"]:{}}
type ProductsType = {[number]:number}
type dataType = {Pets:{[string]:{}},
GamePass:ProductsType,
Products:ProductsType,
TycoonModels:{[string]:tycoonData},
Cash:number,
Shards:number,
World:string}

local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")

local DataMananger =  require(ServerStorage.Services.DataMananger)
GI = require(ServerStorage.Services.Profile.InventoryPlayers)

local DataMethods:dataType = {}
DataMethods.__index = DataMethods

function PlayerInit(Profile,Player:Player)
    
    local data = setmetatable({},DataMethods)
    data.__index = data
    data.Owner = Player
    
    return setmetatable(Profile,data)
end
--------------------------------//--------------------------------------
function DataMethods:CheckDataTycoon(Anime)
    if self.TycoonModels[Anime] then
        return true
    else
        return false
    end
end

function DataMethods:NewAnimeTycoon(Anime)
    DataMananger:AddAnimeTemplate(self.Owner,Anime)
end

function DataMethods:CheckBankAccount(Currency,Value)
    if self[Currency] then 
        if self[Currency] > Value then
            return true
        else
            return false
        end
    end     
end

function DataMethods:BankDebit(Currency,Value)
    if self[Currency] then
        self[Currency] -= Value 
    end    
end

function DataMethods:BankCredit(Currency,Value)
    if self[Currency] then
        self[Currency] += Value 
    end    
end



 
--------------------------------//--------------------------------------
module = {}

function module:Init()
    GI = {}
end

function PlayerAdded(Player)
    GI[Player.UserId] = PlayerInit(DataMananger:GetData(Player),Player)
end

function PlayerRemoving(Player)
    GI[Player.UserId] = nil
end

function module:GetAnime(Player)
    local anime = GI[Player.UserId].Anime

    if anime then
        return anime
    end

end

function module:GetPerson(Player)
    local Person = GI[Player.UserId].Person

    if Person then
        return Person
    end
end

function module:GetInventory(Player)
    local InvTemp = GI[Player.UserId]

    if InvTemp then
        return InvTemp
    end
    
end





Players.PlayerAdded:Connect(PlayerAdded)
Players.PlayerRemoving:Connect(PlayerRemoving)

return module