local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local CollectionService = game:GetService("CollectionService")
local Workspace = game:GetService("Workspace")


local CacheManager =  require(ServerStorage.Services.CacheMananger)
local InventoryMananger = require(ServerStorage.Services.InventoryMananger)
local BridgeNet = require(ReplicatedStorage.Packages.bridgenet2)
local PowerDatas = require(ReplicatedStorage.PowersData)
local TycoonFunctions = require(ServerStorage.Services.SubServices.TycoonFunctions)

local GuiEvents = BridgeNet.ReferenceBridge("GuiEvents")
local TycoonEvents = BridgeNet.ReferenceBridge("TycoonEvents")
local ItemSpawned = BridgeNet.ReferenceBridge("ItemSpawned")

module = {}

function module:Init()
    local TycoonBase =  workspace.TycoonBases.TycoonBase1

    for i = 2,8 do
        local NewBase = TycoonBase:Clone()

        NewBase:PivotTo(NewBase:GetPivot() * CFrame.Angles(0, math.rad(45), 0))

        NewBase.Name = "TycoonBase"..i
        NewBase.Parent = workspace.TycoonBases

        TycoonBase = NewBase
    end
end

function module:ConnectTycoonDoor()
    local DoorTrd
    local DoorList = CollectionService:GetTagged("TycoonDoor")

    if not DoorList then return end 

    for Index,Door in pairs(DoorList) do

      
        if not Door:GetAttribute("OwnedTycoon") then
           DoorTrd = Door.Touched:Connect(function(Hit)
               

                local Character = Hit.Parent 
                local Player = Players:GetPlayerFromCharacter(Character)
                
                if not Player then return end 

                local Cache = CacheManager:GetPlayerCache(Player)

                local db = false

                if not Door:GetAttribute("OwnedTycoon") and  Player:GetAttribute("OwnsTycoon") == false and db == false then
                    db = true 
                    Door.SurfaceGui.TextLabel.Text = Player.Name.." Tycoon"
                    Player:SetAttribute("OwnsTycoon", true)
                    Door:SetAttribute("OwnsTycoon", true)
                    Door.Name = Player.UserId
                    GuiEvents:Fire(Player,{func = "Chosen",content = true})
                    Cache.TycoonBase = Door.Parent.Parent
                    task.wait(2)
                    db = false    
                    Door.CanTouch = false
                    DoorTrd:Disconnect()
                end
            end)
        end
    end
end

function BetaItemSpawner(content)
   
    local item = content.item 
    local destiny = content.destiny
    local origin = content.origin
    local folder = content.folder

    if not item or not destiny or not origin or not folder then return end  

    

    item:PivotTo(destiny:GetPivot() * origin:GetPivot():ToObjectSpace(item:GetPivot()))
    item.Parent = folder

end

function MainItensLoader(Cache)
    local FloorOrigem = Cache.TycoonTemplate.PrimaryPart 
    local FloorDestino = FloorOrigem:Clone()
    FloorDestino:PivotTo(Cache.TycoonBase.PrimaryPart.CFrame)
    Cache.TycoonBase.PrimaryPart.Transparency = 1
    Cache.TycoonBase.PrimaryPart.CanCollide = false
    for _,v in pairs(Cache.TycoonBase.OwnerDoor:GetChildren()) do
        v.Transparency = 1
        v.CanCollide = false
    end
    FloorDestino.Parent = Cache.TycoonModel.MainItens

    Cache:AddThreads("MainItens",task.spawn(function()
        for _,item in pairs(Cache.TycoonTemplate.MainItems:GetChildren()) do
            
            if item.Name ~= "Floor" then
                 
                local newItem = item:Clone()
                --newItem:PivotTo(item:GetPivot()* CFrame.new(0,-10,0))
                newItem.Parent = Workspace
                BetaItemSpawner({item = newItem,origin = FloorOrigem,destiny  = FloorDestino,folder = Cache.TycoonModel.MainItens})
                --ItemSpawned:Fire(BridgeNet.AllPlayers(),{anime = Cache.Anime,item = newItem,origin = FloorOrigem,destiny  = FloorDestino,folder = Cache.TycoonModel.MainItens})
                TycoonFunctions:ActiveSystem("MainItens",newItem,Cache.Owner)
            end
        end
    end))
end

function TycoonInit(Cache)
    local NewModel = Instance.new("Model")
    Cache.TycoonModel = NewModel
    NewModel.Name = Cache.Owner.UserId
    NewModel.Parent = workspace.TycoonModels

    Cache.TycoonTemplate = PowerDatas.AnimeModels[Cache.Anime]

    if not Cache.TycoonTemplate then 
        error("Error in Loading TycoonTemplate")
        return 
    end    

    local NewFolder = Instance.new("Folder")
    NewFolder.Name = "MainItens"
    NewFolder.Parent = NewModel
    local NewFolder2 = Instance.new("Folder")
    NewFolder2.Name = "Boughtitems"
    NewFolder2.Parent = NewModel
    local NewFolder3 = Instance.new("Folder")
    NewFolder3.Name = "MinionsInWorld"
    NewFolder3.Parent = NewModel
end

function NewTycoon(Cache)
    TycoonInit(Cache)
    MainItensLoader(Cache)
    TycoonEvents:Fire(Cache.Owner,{func = "TycoonStart" ,content = {anime = Cache.Anime,tycoon = Cache.TycoonModel}})
end

function LoadTycoon(Cache)
     
end

function GetButtonData(button)
    local buttonData =  button:GetAttributes()
    return {dependency = buttonData.Dependency,item = buttonData.Item,price = buttonData.Price}
end

function CheckDependency(Cache,Dependency)

    print(Cache,Dependency)

    if Cache.TycoonModel.Boughtitems:FindFirstChild(Dependency) then
        return true
    else   
        return false
    end
end

function CheckHaveItem(item:string,cache)
    if cache.TycoonModel.Boughtitems:FindFirstChild(item) then
        return true 
    end
end

function ItemPurchased(item,cache)
    local newItem = cache.TycoonTemplate.Boughtitems[item]:Clone()
    local FloorOrigem = cache.TycoonTemplate.PrimaryPart
    local FloorDestino =  cache.TycoonModel.MainItens.Floor
    BetaItemSpawner({item = newItem,origin = FloorOrigem,destiny  = FloorDestino,folder = cache.TycoonModel.Boughtitems})
    if newItem:GetAttribute("class") then
        TycoonFunctions:ActiveSystem("PurchaseItens",newItem,cache.Owner)
    end
end

local Events = {
    ["PersonChosen"] = function(Player,content)
        print(0)
        local Cache = CacheManager:GetPlayerCache(Player)
        local Inventory  = InventoryMananger:GetInventory(Player)
        print(1)
        if CacheManager:CheckPersonAvailable(content) == false then
            Cache.Person = nil
            return
        else
            Cache:PersonSelected(content)
        end
        print(2)
        Cache.Anime = PowerDatas:GetAnimeFromPerson(Cache.Person)
        print(3)
        if Inventory:CheckDataTycoon(Cache.Anime) then
            print("Data",Cache.Anime,"Found")
            print("Loading Tycoon From Data")
            Cache:AsyncData()
        else
            print("Data Not Found")
            print("Genering New Tycoon")  
            Inventory:NewAnimeTycoon(Cache.Anime)
            Cache:AsyncData()
            NewTycoon(Cache)
        end
    end,
    ["ItemBuy"] = function(Player,content)
        local buttonName =  content.buttonName
        local cache =  CacheManager:GetPlayerCache(Player)
        local Inventory = InventoryMananger:GetInventory(Player)
        local button = cache.TycoonTemplate.Buttons[buttonName]

        if not button then return end
        
        local ButtonData =  GetButtonData(button)

        if not ButtonData.price or not ButtonData.item then return end 
        
        print(Inventory:CheckBankAccount("Cash",ButtonData.price))
        if Inventory:CheckBankAccount("Cash",ButtonData.price) then
            
            if ButtonData["dependency"] then 
                if CheckHaveItem(ButtonData.item,cache) then return end
               
                if CheckDependency(cache,ButtonData.dependency) == false then return end
                Inventory:BankDebit("Cash",ButtonData.price)
                ItemPurchased(ButtonData.item,cache)
                TycoonEvents:Fire(cache.Owner,{func = "ButtonUpdate",content={buttonName = buttonName,tycoonModel = cache.TycoonModel,anime = cache.Anime}})
                
            else
                if CheckHaveItem(ButtonData.item,cache) then return end
                ItemPurchased(ButtonData.item,cache)
                TycoonEvents:Fire(cache.Owner,{func = "ButtonUpdate",content={buttonName = buttonName,tycoonModel = cache.TycoonModel,anime = cache.Anime}})

            end     
        end
    end

}

TycoonEvents:Connect(function(Player,pars)
    local Event = Events[pars.func]
    if Event then Event(Player,pars.content) end
end)

return module