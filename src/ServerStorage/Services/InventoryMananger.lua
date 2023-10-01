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




function DataMethods:GetOwner()
    return self.Owner
end

function DataMethods:SetAnime(AnimeName)

    self.Anime = AnimeName
    
end

function DataMethods:SetPerson(PersonName)

    self.Person = PersonName
    
end

function DataMethods:AddPet(Pet)
    self.Pets[Pet.Id] =  Pet
end

function DataMethods:RemovePet(Pet)
    self.Pets[Pet.Id] = nil
end

function DataMethods:GamePassAdd(PassId)
    table.insert(self.GamePass,PassId)     
end

function DataMethods:Checkgamepass(PassId)
    if table.find(self.GamePass,PassId) then
        return true 
    end
end

function DataMethods:GamePassRemove(PassId)
   local Index =  table.find(self.GamePass,PassId)

   if Index then
    table.remove(self.GamePass,Index)
   end
end


function DataMethods:AddProduct(ProductId)
    self.Products[ProductId] += 1
end
function DataMethods:RemoveProduct(ProductId)
    self.Products[ProductId] -= 1
end

function DataMethods:AddModel(AnimeName)
    DataMananger:AddAnimeTemplate(self.Owner,AnimeName)
end

function DataMethods:UpdateBoughtItens(ItemName,AnimeName)


    table.insert(self.TycoonModels[AnimeName].Purchased,ItemName)

    local Index = table.find(self.TycoonModels[AnimeName].ToPurchase,ItemName)    

    if Index then
        table.remove(self.TycoonModels[AnimeName].ToPurchase,Index)
    end
end

function DataMethods:GetDataTycoon(Anime)
    local dataTable = self.TycoonModels[Anime]
    if dataTable then
        return dataTable
    end
end

function DataMethods:RemoveTycoon(AnimeName)
    self.TycoonModels[AnimeName] = nil
end

function DataMethods:BankUpdate(Currency,Value)
    self[Currency] = Value
    self.Owner:SetAttribute(Currency,self[Currency])
end

function DataMethods:BankCredit(Currency,Value)
    self[Currency] += Value
    self.Owner:SetAttribute(Currency,self[Currency])
end

function DataMethods:BankDebit(Currency,Value)
    self[Currency] -= Value
    self.Owner:SetAttribute(Currency,self[Currency])
end

function DataMethods:BankCheck(Currency,Value)
    if self[Currency] >= Value then
        return true
    else    
        return false
    end
end

function DataMethods:CheckHaveTycoonDate(Anime)
    warn(self.TycoonModels," ",Anime)
    for Index, data in pairs(self.TycoonModels) do
        if Index == Anime then
            return true
        end
    end

    return false
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

function module:CheckPersonAvaiable(PersonName)
    for _,PlayerData in pairs(GI) do
        
        if PlayerData.Person == PersonName then
            return false
        end

    end
    
    return true

end

Players.PlayerAdded:Connect(PlayerAdded)
Players.PlayerRemoving:Connect(PlayerRemoving)

return module