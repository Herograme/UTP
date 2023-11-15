local Players = game:GetService("Players")
local Player:Player = Players.LocalPlayer
local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BridgeNet = require(ReplicatedStorage.Packages.bridgenet2)
local SkillAnimator = require(ReplicatedStorage.ClientServices.SkillAnimator)

--local Remotes = ReplicatedStorage.Remotes
local FireSkill = BridgeNet.ReferenceBridge("FireSkill")

local mouse:Mouse = Player:GetMouse()

local DebounceSkill = {}
local CooldownTime = 5

function FireEgg(EggName,Input)

    --Remotes.EggsEvent:FireServer("HatchEgg",EggName,Input)
    
end




local InputTypes = {
    ["Egg"] = function(Input)

        local EggName = Player:GetAttribute("CurrentEgg")
        if not EggName then return end

        FireEgg(EggName,Input)
    end, 

    ["Skill"] = function(Input)
        warn("Apertou",Input)
        local Skill = Player:GetAttribute(Input)

        if not Skill or DebounceSkill[Skill] then return end 
        DebounceSkill[Skill] = true

        Player.Character.HumanoidRootPart.Anchored = true
        
        FireSkill:Fire({input = Input,Direction = mouse.Hit})
      
        task.delay(CooldownTime,function()
            DebounceSkill[Skill] = nil
        end)
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
    --FireSkill:Fire("Block")
end

module ={
    InputStartPC = function()
       
    end
}

ContextActionService:BindAction("Q",FireAction,false,Enum.KeyCode.Q) 
ContextActionService:BindAction("E",FireAction,false,Enum.KeyCode.E)
ContextActionService:BindAction("R",FireAction,false,Enum.KeyCode.R)
ContextActionService:BindAction("Block",BlockAction,false,Enum.KeyCode.F)

return module