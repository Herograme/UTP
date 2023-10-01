local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local ConnectTask = {}
local db =  false



module  = {

EggsEvent =  {
    ["EggConnect"] = function(Egg)
        local BillboardGui = ReplicatedStorage.Guis.EggGui
        local eggTrigger = ReplicatedStorage.Guis.EggTrigger
        local NewGui =  BillboardGui:Clone()
        local NewTrigger = eggTrigger:Clone()



        NewGui.Parent = player.PlayerGui
        NewGui.Adornee =  Egg
        NewGui.Name = Egg.Name.."Gui"


        NewTrigger.Parent = Egg
        NewTrigger.Name = Egg.Name.."Trigger"

        ConnectTask[Egg.Name.."ShowTrigger"]=NewTrigger.PromptShown:Connect(function()    
                player:SetAttribute("CurrentInput","Egg")
                player:SetAttribute("CurrentEgg",Egg.Name)
                NewGui.Enabled = true

        end)

        ConnectTask[Egg.Name.."HideTrigger"]=NewTrigger.PromptHidden:Connect(function()
                player:SetAttribute("CurrentInput","Skill")
                player:SetAttribute("CurrentEgg",nil)
                NewGui.Enabled = false
        end)


        --[[ConnectTask [Egg.Name] = RunService.Heartbeat:Connect(function(deltaTime)
            if NewGui.CurrentDistance <= NewGui.MaxDistance then
                
                if player:GetAttribute("CurrentInput") == Egg.Name then
                    
                    db = true return 

                else

                    db = false return 

                end    
                
                if db == false then
                    player:SetAttribute("CurrentInput",Egg.Name)
                end
                


            end
        end)]]
      
        


    end



}








}

return module