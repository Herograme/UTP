local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage.Remotes

local TycoonUtilites = require(ReplicatedStorage.ClientServices.TycoonClientServices)
local EggUtilities = require(ReplicatedStorage.ClientServices.PetClientsService)
local Inputs =  require(ReplicatedStorage.ClientServices.Inputs)

Inputs.InputStartPC()

Remotes.EffectsController.OnClientEvent:Connect(function(func,Argument)
    

  

    local EffectFunctionTemp = TycoonUtilites.EffectsFunction[func] 

    if  not EffectFunctionTemp then return end 

    EffectFunctionTemp(Argument)
    


end)


Remotes.EggsEvent.OnClientEvent:Connect(function(FuncREQ,Argument)
    
  
    local FuncTemp = EggUtilities.EggsEvent[FuncREQ]

    if not  FuncTemp then return end 

    FuncTemp(Argument)


end)


--[[if UIS.KeyboardEnabled and UIS.MouseEnabled then
	game.ReplicatedStorage.LOL2:FireServer()
elseif UIS.TouchEnabled and not UIS.KeyboardEnabled and not UIS.MouseEnabled then
	game.ReplicatedStorage.LOL1:FireServer()
end]]


