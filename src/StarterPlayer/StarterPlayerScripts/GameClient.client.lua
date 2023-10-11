local ReplicatedStorage = game:GetService("ReplicatedStorage")
------------
--Create Remotes
local bridgenet = require(ReplicatedStorage.Packages.bridgenet2)

bridgenet.ClientBridge("GuiEvents")
bridgenet.ClientBridge("TycoonEvents")
bridgenet.ClientBridge("MinionSpawned")
local EffectsController = bridgenet.ClientBridge("EffectsController")
local EggsEvent = bridgenet.ClientBridge("EggsEvent")
------------

local TycoonUtilites = require(ReplicatedStorage.ClientServices.TycoonClientServices)
local EggUtilities = require(ReplicatedStorage.ClientServices.PetClientsService)
local Inputs =  require(ReplicatedStorage.ClientServices.Inputs)

Inputs.InputStartPC()

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


