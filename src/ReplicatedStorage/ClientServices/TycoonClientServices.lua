local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local BridgeNet = require(ReplicatedStorage.Packages.bridgenet2)
local SimplePath = require(ReplicatedStorage.Packages.simplepath)

local TycoonEvents = BridgeNet.ReferenceBridge("TycoonEvents")
local MinionSpawned = BridgeNet.ReferenceBridge("MinionSpawned")


local DbTb = {}
local ButtonsList = {}
local MinionsThreads = {}


local TWEEN_TIME = 3
local TWEEN_STYLE = Enum.EasingStyle.Linear
local TWEEN_DIRECTION = Enum.EasingDirection.Out
local TWEEN_LOOP = 1
local TWEEN_REVERSE = false
local TWEEN_DELAY = 0.5





function ButtonAdded(TycoonModel)
    TycoonModel.Buttons.ChildAdded:Connect(function(Button)
         
    end)
end

function TweenEffect(SubItem,Type) 
    local tweenInfo = TweenInfo.new(TWEEN_TIME,TWEEN_STYLE,TWEEN_DIRECTION,TWEEN_LOOP,TWEEN_REVERSE,TWEEN_DELAY)
    if Type == "Transparency" then
        local ItemAnimation = TweenService:Create(SubItem,tweenInfo,{Transparency = 0})
        ItemAnimation:Play()
    end
end


--Remotes.TycoonFunctions:InvokeServer("Buy",Button)




TycoonEvents:Connect(function(pars)
    local TycoonEvents = {
        ["TycoonPurchase"] = function(Model,PlayerOwner)
            if PlayerOwner == Player then
                Model.Buttons.Parent = nil  
            end
        end,
        ["TycoonStart"] =function(TycoonModel)
            for _,Button in pairs (TycoonModel.Buttons:GetChildren()) do
               
                local ButtonDatas = Button:GetAttributes()
                Button.ButtonPart.BillboardGui.Frame.TextLabel.Text = ButtonDatas.NameButton.." - ".. ButtonDatas.Price.."$"

                if Button:GetAttribute("Dependency") then
                    ButtonsList[Button.Name] = Button
                    Button.Parent = nil
                else
                    DbTb[Button.Name] = false
                    Button.ButtonPart.Touched:Connect(function(Hit)
                        local Character =  Hit.Parent
                        local PlayerHit = Players:GetPlayerFromCharacter(Character)

                        if PlayerHit == Player and DbTb[Button.Name] ~= true  then
                            DbTb[Button.Name] = true
                            TycoonEvents:Fire("Buy",Button)
                            task.wait(1) 
                            DbTb[Button.Name] = nil
                            
                        end
                    end)
                   
                    ButtonAdded(TycoonModel)
                end
            end
        end,
        ["TycoonLoad"] =function(TycoonModel,Data) --Purchase
            
            for _,Button in pairs(TycoonModel.Buttons:GetChildren()) do
                local ButtonDatas = Button:GetAttributes()
                Button.ButtonPart.BillboardGui.Frame.TextLabel.Text = ButtonDatas.NameButton.." - ".. ButtonDatas.Price.."$"

                if table.find(Data,Button:GetAttribute("Item")) then
                    ButtonsList[Button.Name] = Button
                    Button.Parent = nil
                elseif not table.find(Data,Button:GetAttribute("Dependency")) then
                    ButtonsList[Button.Name] = Button
                    Button.Parent = nil
                else
                    DbTb[Button.Name] = false
                    Button.ButtonPart.Touched:Connect(function(Hit)
                        local Character =  Hit.Parent
                        local PlayerHit = Players:GetPlayerFromCharacter(Character)

                        if PlayerHit == Player and DbTb[Button.Name] ~= true  then
                            DbTb[Button.Name] = true
                           -- Remotes.TycoonFunctions:InvokeServer("Buy",Button)
                            DbTb[Button.Name] = nil
                           
                        end
                    end)
                 
                    ButtonAdded(TycoonModel)
                end
                
            end
        end,
        ["ButtonUpdate"] = function(Button,TycoonModel)
            Button:Destroy()

            TycoonModel.Boughtitems.ChildAdded:Connect(function(Item)
                for _, Button in pairs(ButtonsList) do

                    print(Button:GetAttribute("Dependency"),Item)
                    if Button:GetAttribute("Dependency") == Item.Name then
                        Button.Parent = TycoonModel.Buttons 
                        ButtonsList[Button.Name] = nil
                        DbTb[Button.Name] = false
                        Button.ButtonPart.Touched:Connect(function(Hit)
                            local Character =  Hit.Parent
                            local PlayerHit = Players:GetPlayerFromCharacter(Character)

                            if PlayerHit == Player and DbTb[Button.Name] ~= true then
                                DbTb[Button.Name] = true
                                --Remotes.TycoonFunctions:InvokeServer("Buy",Button)
                                task.wait(1)
                                DbTb[Button.Name] = nil
                                
                            end
                        end)
                    end
                end
            end)
        end,
        ["SpawnItemAnimate"] = function(pairs)
            local CFrameValue = Instance.new("CFrameValue")
            local tweenInfo = TweenInfo.new(TWEEN_TIME,TWEEN_STYLE,TWEEN_DIRECTION,TWEEN_LOOP,TWEEN_REVERSE,TWEEN_DELAY)
            local tweenParameter = {Value = pairs.Destiny}
            local tweenAnimate = TweenService.Create(CFrameValue,tweenInfo,tweenParameter)
            tweenAnimate:Play()

            CFrameValue.Changed:Connect(function()
                pairs.Item:PivotTo(CFrameValue.Value)
            end)
            
        end,
        
       
    }
   
--[[ 
    end)]]

    local Event = TycoonEvents[pars.func]
    
    if Event then Event(pars.content) end
end)

MinionSpawned:Connect(function(pars)
    local data = pars.data
    local minion = pars.minion
    local replicator = pars.replicator
    local tycoonModel = pars.tycoonModel

    if not data or not minion or not replicator or not tycoonModel then return end 

    local MinionPath = SimplePath.new(minion)
    --WAY_POINT1
    local PathList = {}

    for i,PathPoint in pairs(tycoonModel.MainItems.ConveyorBelt.Path:GetChildren())do
        PathList[PathPoint.Name] = PathPoint
    end
    local PathCurrent = PathList["WAY_POINT1"]
    minion:PivotTo(replicator.Spawner:GetPivot())
    minion.Parent = tycoonModel.MinionsSpawned

    MinionPath:Run(PathCurrent)

    local PathsNumber = 2
    MinionPath._events.Reached:Connect(function()

        if PathCurrent.Name == "GOAL" then
            MinionPath:Stop()
            MinionPath:Destroy()
        end

        PathCurrent = PathList["WAY_POINT"..tostring(PathsNumber)]
        if not PathCurrent then
            PathCurrent = PathList["GOAL"]
        end
 
        PathsNumber += 1
        MinionPath:Run(PathCurrent)
    end)

    MinionPath._events.Blocked:Connect(function()
        MinionPath:Run(PathCurrent)
    end)
    
    MinionPath._events.Error:Connect(function()
        MinionPath:Run(PathCurrent)
    end)

    MinionPath._events.Stopped:Connect(function()
        MinionPath:Run(PathCurrent)
    end)

    --[[MinionsThreads[minion.Name] = RunService.RenderStepped:Connect(function()
        
    end)]]

    
end)

module = {}



return module















