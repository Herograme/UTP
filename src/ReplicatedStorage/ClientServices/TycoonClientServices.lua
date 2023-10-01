local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local Remotes = ReplicatedStorage.Remotes
local DbTb = {}
local ButtonsList = {}


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




Remotes.TycoonEvents.OnClientEvent:Connect(function(Event,...)
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
                            Remotes.TycoonFunctions:InvokeServer("Buy",Button)
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
                            Remotes.TycoonFunctions:InvokeServer("Buy",Button)
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
                                Remotes.TycoonFunctions:InvokeServer("Buy",Button)
                                task.wait(1)
                                DbTb[Button.Name] = nil
                                
                            end
                        end)
                    end
                end
            end)
        end,
        ["EffectSpawnItem"] = function(Item,Type)
           
        end,
    }
   
--[[ 
    end)]]

    local Event = TycoonEvents[Event]
    
    if Event then Event(...) end
end)



 module = {
    EffectsFunction = {}


}



return module















