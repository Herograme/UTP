local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = ReplicatedStorage.Remotes


function FireEgg(EggName,Input)

    Remotes.EggsEvent:FireServer("HatchEgg",EggName,Input)
    
end


local InputTypes = {
    ["Egg"] = function(Input)

        local EggName = Player:GetAttribute("CurrentEgg")
        if not EggName then return end

        FireEgg(EggName,Input)
    end, 

    ["Skill"] = function(Input)

       -- Remotes.CombatEvents:FireServer("InvokeSkill")
        
    end



}

function CheckInputBegin(InputState)
    
    if InputState == Enum.UserInputState.Begin then
        return true
    end

end



function FireAction  (Input,InputState)
  local  InputLocation = Player:GetAttribute("CurrentInput")
  

    if not CheckInputBegin(InputState) then return end

    if InputLocation then 

        local FuncTemp = InputTypes[InputLocation]

        if not FuncTemp then return end 



        FuncTemp(Input)
      

      
    end    


end
    
function BlockAction()
    
end



module ={

    InputStartPC = function()
        

        ContextActionService:BindAction("Q",FireAction,false,Enum.KeyCode.Q) 
        ContextActionService:BindAction("E",FireAction,false,Enum.KeyCode.E)
        ContextActionService:BindAction("R",FireAction,false,Enum.KeyCode.R)
        ContextActionService:BindAction("Block",BlockAction,false,Enum.KeyCode.F)



    end



}




return module