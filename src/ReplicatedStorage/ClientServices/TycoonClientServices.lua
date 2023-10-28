local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character

local BridgeNet = require(ReplicatedStorage.Packages.bridgenet2)
local SimplePath = require(ReplicatedStorage.Packages.simplepath)
local PowerDatas = require(ReplicatedStorage.PowersData)

local TycoonEvents = BridgeNet.ReferenceBridge("TycoonEvents")
local MinionSpawned = BridgeNet.ReferenceBridge("MinionSpawned")
local ItemSpawned = BridgeNet.ReferenceBridge("ItemSpawned")
ItemSpawned.Logging = true

local DbTb = {}
local ButtonsList = {}

local TWEEN_TIME = 4
local TWEEN_STYLE = Enum.EasingStyle.Linear
local TWEEN_DIRECTION = Enum.EasingDirection.Out
local TWEEN_LOOP = 1
local TWEEN_REVERSE = false
local TWEEN_DELAY = 0.5

local tweenInfo = TweenInfo.new(TWEEN_TIME,TWEEN_STYLE,TWEEN_DIRECTION,TWEEN_LOOP,TWEEN_REVERSE,TWEEN_DELAY)

if not Character then
    task.spawn(function()
        while task.wait(1) do
            Character = Player.Character
            if Character then
                break
            end     
        end
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
        ["TycoonStart"] =function(content)
            
            local anime = content.anime
            local tycoon = content.tycoon
           
            if not anime or not tycoon then return end 
           
            local NewFolder =  Instance.new("Folder")
            NewFolder.Name = "Buttons"
            NewFolder.Parent = tycoon
           
            local AnimeModel = PowerDatas:GetAnimeModel(anime)

            for i,button in pairs(AnimeModel.Buttons:GetChildren()) do
                if not button:GetAttribute("Dependency") then 
                    button:PivotTo(tycoon.MainItens.Floor.CFrame * AnimeModel.PrimaryPart.CFrame:ToObjectSpace(button:GetPivot()))
                    button.Parent = NewFolder
                    local debounce = false
                    button.ButtonPart.Touched:Connect(function(Hit)
                        local Character = Hit.Parent
                        local PlayerHit = Players:GetPlayerFromCharacter(Character)

                        if PlayerHit == Player and debounce == false then
                            debounce = true 
                            TycoonEvents:Fire({func = "ItemBuy",content = {buttonName = button.Name}})
                            task.wait(1.5)
                            debounce = false
                        end
                    end)
                else
                    ButtonsList[button.Name] = button
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
                 
                    
                end
                
            end
        end,
        ["ButtonUpdate"] = function(content)
            local buttonName = content.buttonName
            local tycoonModel = content.tycoonModel
            local AnimeModel = PowerDatas:GetAnimeModel(content.anime)

            if not buttonName or not tycoonModel or not AnimeModel then return end

            tycoonModel.Buttons[buttonName]:Destroy()

            for i,button in pairs(ButtonsList) do
                local Dependency = button:GetAttribute("Dependency")

                if tycoonModel.Boughtitems:FindFirstChild(Dependency) then
                    button:PivotTo(tycoonModel.MainItens.Floor.CFrame * AnimeModel.PrimaryPart.CFrame:ToObjectSpace(button:GetPivot()))
                    button.Parent = tycoonModel.Buttons
                    ButtonsList[button.Name] = nil
                    warn(button)
                    local debounce = false 
                    button.ButtonPart.Touched:Connect(function(Hit)
                        print(1)
                        local Character = Hit.Parent
                        local PlayerHit = Players:GetPlayerFromCharacter(Character)

                        if PlayerHit == Player and debounce == false then
                            print(2)
                            debounce = true 
                            TycoonEvents:Fire({func = "ItemBuy",content = {buttonName = button.Name}})
                            task.wait(1.5)
                            debounce = false
                        end
                    end)
                end
            end
        end
    }
--[[ 
    end)]]

    local Event = TycoonEvents[pars.func]
    
    if Event then Event(pars.content) end
end)



--[[MinionSpawned:Connect(function(pars)
    
    local data = pars.data
    local minionName = pars.minion
    local replicator = pars.replicator
    local tycoonModel = pars.tycoonModel

    if not data or not minionName or not replicator or not tycoonModel then return end 

    local minion = tycoonModel.MinionsInWorld[minionName]

    if not minion then return end 

    local CurrencyPoint =  replicator.Spawner.SpawnerExit.WorldCFrame.Position
    local OldPoint
    local WaysLIST = {}
    local Path = 1

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
    
    minion.Humanoid.MoveToFinished:Connect(function()
        if CurrencyPoint == WaysLIST["Goal"] then
            minion:Destroy()
        end

        CurrencyPoint = WaysLIST["WAY_POINT"..Path]

        if not CurrencyPoint then
            CurrencyPoint = WaysLIST["GOAL"]
        end

        minion.Humanoid:MoveTo(CurrencyPoint)
        Path += 1
    end)


end)]]

ItemSpawned:Connect(function(content)

    local anime =  content.anime
    local item = content.item 
    local destiny = content.destiny
    local origin = content.origin
    local folder = content.folder

    if not anime or not item or not destiny or not origin or not folder then return end  

    local DistanceView = (item:GetPivot().Position - Character:GetPivot().Position).magnitude

    item:PivotTo(destiny:GetPivot() * origin:GetPivot():ToObjectSpace(item:GetPivot()))

    if DistanceView < 400 then
        task.spawn(function()
            local itemDestiny =  item:GetPivot()
            item:PivotTo(itemDestiny * CFrame.new(0,80,0))

            local CFrameValue = Instance.new("CFrameValue")
            CFrameValue.Value = item:GetPivot()
            local TweenAnimate = TweenService:Create(CFrameValue,tweenInfo,{Value = itemDestiny})
        
            CFrameValue.Changed:Connect(function()
                item:PivotTo(CFrameValue.Value)
            end)

            item.Parent = folder

            TweenAnimate:Play()
            TweenAnimate.Completed:Wait()
            CFrameValue:Destroy()
            TweenAnimate:Destroy()
            
        end)
    else    
        item.Parent = folder
    end

end)

module = {}



return module















