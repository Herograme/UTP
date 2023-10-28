local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local HttpService = game:GetService("HttpService")
local CollectionService = game:GetService("CollectionService")
local TweenService = game:GetService("TweenService")

local InventoryMananger = require(ServerStorage.Services.InventoryMananger)
local CacheManager = require(ServerStorage.Services.CacheMananger)
local NumberFormatter = require(ReplicatedStorage.FormatNumber.Custom)
local minionData =  require(ReplicatedStorage.MinionsData)
local bridgenet2 =  require(ReplicatedStorage.Packages.bridgenet2)

local MinionSpawned = bridgenet2.ReferenceBridge("MinionSpawned")

local module = {}

local MainItensSystem = {
   ["cashbutton"] = function(Item,Inventory,Cache)
        warn("cashbutton")
        local Screen = Item.ScreenPart.SurfaceGui
        local PartTouch = Item.ButtonPartT

        local db = false

        PartTouch.Touched:Connect(function(Hit)
            local Character =  Hit.Parent
            local Player = Players:GetPlayerFromCharacter(Character)

            if not Player then return end 

            
            if Player.UserId == Cache.Owner.UserId and db == false then
                db = true
                Item.ButtonPart.Color = Color3.fromRGB(255,0,0)
                Inventory:BankCredit("Cash",Cache.TycoonCash)
                Cache.TycoonCash = 0
                Cache.TycoonModel:SetAttribute("Cash",0)
                Player:SetAttribute("Cash",Inventory.Cash)
                task.wait(0.5)
                db = false
                Item.ButtonPart.Color = Color3.fromRGB(0,255,0)
            end

        end)

        Cache.TycoonModel.AttributeChanged:Connect(function()
            local CashAtt = Cache.TycoonModel:GetAttribute("Cash") or 0
            Screen.TextLabel.Text = NumberFormatter.functions.FormaterNumbers(CashAtt).."$"
        end)
   end,
   ["colector"] = function(Item,Inventory,Cache)
        local db = false
        Item.HITBOX.Touched:Connect(function(Hit)
            local MinionCharacter = Hit.Parent
            if CollectionService:HasTag(MinionCharacter,"minion") and db == false then
                db = true 
                Cache:AddTycoonCash(MinionCharacter:GetAttribute("Value"))
                task.wait(1)
                MinionCharacter:Destroy()
                db = false
            end
        end)
   end
}

function MinionMoviment(replicator,tycoonModel,minion)
    local CurrencyPoint =  replicator.Spawner.SpawnerExit.WorldCFrame.Position
    local OldPoint
    local WaysLIST = {}
    local Path = 1

    for i,part in pairs(minion:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end

    for i,waypoint in pairs(tycoonModel.MainItens.ConveyorBelt.Path:GetChildren()) do
        WaysLIST[waypoint.Name] = waypoint.Position
    end

    local Animator = minion.Humanoid.Animator
	local Animation = Instance.new("Animation")
	Animation.Parent = Animator
	Animation.AnimationId = "rbxassetid://14777263766"
	local AnimationTrack = Animator:LoadAnimation(Animation)
	task.wait()

	AnimationTrack:Play()

    minion.Humanoid:MoveTo(CurrencyPoint)
    local Reached = false
    minion.Humanoid.MoveToFinished:Connect(function()
        if Reached then
            AnimationTrack:Stop()
           -- minion:Destroy()
        end

        CurrencyPoint = WaysLIST["WAY_POINT"..Path]

        if not CurrencyPoint then
            CurrencyPoint = WaysLIST["GOAL"]
            Reached = true
        end

        minion.Humanoid:MoveTo(CurrencyPoint)
        Path += 1
    end)
end

local PurchaseItensSystem = {
    ["replicator"] = function(Item,Inventory,Cache)
        Cache:AddThreads(Item.Name,function()
            local Minion = Cache:GetMinionReplicator(Item.Name)
            if Minion then
                local DataMinion = minionData:GetMinionData(Minion)
                if not Minion then return end 
                while task.wait(4) do
                    local MinionModel= DataMinion.Model:Clone()
                    MinionModel:PivotTo(Item.Spawner:GetPivot())
                    MinionModel.Parent = Item.Parent.Parent.MinionsInWorld
                    MinionModel:SetAttribute("Value",DataMinion.Value)
                    --MinionModel:SetNetworkOwner(Cache.Owner)
                    MinionSpawned:Fire(Cache.Owner, {data = DataMinion,minion = MinionModel,replicator = Item})
                end
            else
                Cache:AddMinionReplicator(Item.Name)
                local DataMinion = minionData:GetMinionData("default")
                while task.wait(4) do
                    local MinionModel = DataMinion.Model:Clone()
                    CollectionService:AddTag(MinionModel,"minion")
                    Debris:AddItem(MinionModel,30)
                    MinionModel:PivotTo(Item.Spawner:GetPivot())
                    MinionModel.Name =  HttpService:GenerateGUID(false)
                    MinionModel:SetAttribute("Value",DataMinion.Value)
                    MinionModel.Parent = Item.Parent.Parent.MinionsInWorld 
                    --MinionModel:SetNetworkOwner(Cache.Owner)
                    MinionMoviment(Item,Cache.TycoonModel,MinionModel)
                    
                end
            end
        end)
    end
}


function module:ActiveSystem(ClassSystem,Item,Player)
    local Inventory = InventoryMananger:GetInventory(Player)
    local Cache =  CacheManager:GetPlayerCache(Player)
    local Class =  Item:GetAttribute("class")

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