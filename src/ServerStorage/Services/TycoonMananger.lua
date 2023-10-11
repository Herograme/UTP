local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local CollectionService = game:GetService("CollectionService")


local CacheManager =  require(ServerStorage.Services.CacheMananger)
local InventoryMananger = require(ServerStorage.Services.InventoryMananger)
local BridgeNet = require(ReplicatedStorage.Packages.bridgenet2)
local PowerDatas = require(ReplicatedStorage.PowersData)
local TycoonFunctions = require(ServerStorage.Services.SubServices.TycoonFunctions)

local GuiEvents = BridgeNet.ReferenceBridge("GuiEvents")
local TycoonEvents = BridgeNet.ReferenceBridge("TycoonEvents")

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

        print("Conectou-", Door)
        if not Door:GetAttribute("OwnedTycoon") then
           DoorTrd = Door.Touched:Connect(function(Hit)
                print("DoorTouched",Hit)

                local Character = Hit.Parent 
                local Player = Players:GetPlayerFromCharacter(Character)
                print(Player)
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
                    DoorTrd:Disconnect()
                end
            end)
        end
    end
end

function MainItensLoader(Cache)
    local FloorOrigem:Model = Cache.TycoonTemplate.PrimaryPart 
    local FloorDestino = FloorOrigem:Clone()
    FloorDestino:PivotTo(Cache.TycoonBase)
    Cache.TycoonBase.PrimaryPart.Transparency = 1
    Cache.TycoonBase.PrimaryPart.CanCollide = false
    for _,v in pairs(Cache.TycoonBase.OwnerDoor:GetChildren()) do
        v.Transparency = 1
        v.CanCollide = false
    end

    Cache:AddThreads("MainItens",task.spawn(function()
        for _,item in pairs(Cache.TycoonTemplate.MainItems:GetChildren()) do
            if item.Name ~= "Floor" then
                item = item:Clone()
                item:PivotTo(FloorDestino * FloorOrigem:ToObjectSpace(item:GetPivot()))
                local ItemDestiny = item:GetPivot()
                item:PivotTo(ItemDestiny * CFrame.new(0,80,0))
                item:SetNetworkOwner(Cache.Owner)
                item.Parent = Cache.TycoonModel.MainItems
                TycoonEvents:Fire(Cache.Owner,{func = "SpawnItemAnimate",content = {Item = item, Destiny = ItemDestiny}})
                item:SetNetworkOwnershipAuto()
                task.wait(0.5)
            else
                TycoonFunctions:ActiveSystem("MainItens",item,Cache.Owner)
            end
        end
    end))
end

function TycoonInit(Cache)
    local NewModel = Instance.new("Model")
    Cache.TycoonModel = NewModel
    NewModel.Name = Cache.Owner.UserId
    NewModel.Parent = workspace.TycoonModels

    Cache.TycoonTemplate = ReplicatedStorage.TycoonModels[Cache.Anime]

    local NewFolder = Instance.new("Folder")
    NewFolder.Name = "MainItens"
    NewFolder.Parent = NewModel
end

function NewTycoon(Cache)
    TycoonInit(Cache)
    MainItensLoader(Cache)
end

function LoadTycoon(Cache)
     
end

local Events = {
    ["PersonChosen"] = function(Player,content)
        local Cache = CacheManager:GetPlayerCache(Player)
        local Inventory  = InventoryMananger:GetInventory(Player)
        Cache.Person = content

        if not CacheManager:CheckPersonAvailable(Cache.Person) then
            Cache.Person = nil
            return
        end

        Cache.Anime = PowerDatas:GetAnimeFromPerson(Cache.Person)

        if Inventory:CheckDataTycoon(Cache.Anime) then
            Cache:AsyncData()
        else    
            Inventory:NewAnimeTycoon(Cache.Anime)
            Cache:AsyncData()
            NewTycoon(Cache)
        end
    end
}

TycoonEvents:Connect(function(Player,pars)
    local Event = Events[pars.func]
    if Event then Event(Player,pars.content) end
end)

return module