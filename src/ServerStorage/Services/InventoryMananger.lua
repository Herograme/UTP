local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")

local DataMananger =  require(ServerStorage.Services.DataMananger)


GI = require(ServerStorage.Services.Profile.InventoryPlayers)



local DataMethods = {}
DataMethods.__index = DataMethods

function PlayerInit(Profile,Player)
    
    local data = setmetatable({},DataMethods)
    data.__index = data
    data.Owner = Player
    
    return setmetatable(Profile,data)
end






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