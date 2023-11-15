local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
------------
--GameInizializer

local GameLoading = require(ReplicatedFirst.GameLoading.GameLoadingService)

GameLoading:Init()
task.wait()

------------
--Create Remotes
local bridgenet = require(ReplicatedStorage.Packages.bridgenet2)

bridgenet.ClientBridge("GuiEvents")
bridgenet.ClientBridge("TycoonEvents")
bridgenet.ClientBridge("MinionSpawned")
bridgenet.ClientBridge("GuiLoader")
bridgenet.ClientBridge("ItemSpawned")
bridgenet.ClientBridge("FireSkill")
local EffectsController = bridgenet.ClientBridge("EffectsController")
local EggsEvent = bridgenet.ClientBridge("EggsEvent")

------------

local TycoonUtilites = require(ReplicatedStorage.ClientServices.TycoonClientServices)
local EggUtilities = require(ReplicatedStorage.ClientServices.PetClientsService)
local Inputs =  require(ReplicatedStorage.ClientServices.Inputs)
local SkillAnimator = require(ReplicatedStorage.ClientServices.SkillAnimator)
local GuiServices =  require(ReplicatedStorage.ClientServices.GuiServices)

local Cmdr = require(ReplicatedStorage:WaitForChild("CmdrClient"))


Cmdr:SetActivationKeys({ Enum.KeyCode.F2 })

Inputs.InputStartPC()

SkillAnimator:init()
GuiServices:init()


EffectsController:Connect(function(Pars)
    local EffectFunctionTemp = TycoonUtilites.EffectsFunction[Pars.func] 

    if  not EffectFunctionTemp then return end 

    EffectFunctionTemp(Pars.content)
end)


EggsEvent:Connect(function(Pars)
    local FuncTemp = EggUtilities.EggsEvent[Pars.func]

    if not  FuncTemp then return end 

    FuncTemp(Pars.content)
end)


--[[if UIS.KeyboardEnabled and UIS.MouseEnabled then
	game.ReplicatedStorage.LOL2:FireServer()
elseif UIS.TouchEnabled and not UIS.KeyboardEnabled and not UIS.MouseEnabled then
	game.ReplicatedStorage.LOL1:FireServer()
end]]


