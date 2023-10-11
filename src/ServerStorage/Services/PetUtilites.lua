local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local HttpService = game:GetService("HttpService")

local EggsData = require(ReplicatedStorage.EggsData)
local EggsDataMeta = require(ReplicatedStorage.EggDataMeta)
local PlayerUtilities = require(ServerStorage.Services.PlayerUtilites)
local InventoryMananger = require(ServerStorage.Services.InventoryMananger)

--local Remotes = ReplicatedStorage.Remotes




function PetGenerator(Player,ChosenPet)
    local PlayersInventory = InventoryMananger:GetInventory(Player)

    ChosenPet.Id = HttpService:GenerateGUID(false)

    PlayersInventory:AddPet(ChosenPet)
    

end


function getRandomPet(EggName)
    print("4")
    local randomNumber = math.random(0,10000)/100
    local ChosenPet = EggsDataMeta.GetPetByChance(EggName,randomNumber)
    print(ChosenPet)
    if ChosenPet then 
        return ChosenPet
    end     
end

_G.FuncTest = getRandomPet

function HatchEgg(Player,EggName)
    local Egg = EggsDataMeta.GetEggByName(EggName)
    if not Egg then return end 
        print("1")
    if PlayerUtilities.CheckPlayerCash(Player,Egg.eggPrice,Egg.eggCurrency) then
        print("2")
        if not PlayerUtilities.Payment(Player,Egg.eggPrice,Egg.eggCurrency) then return end
        print("3")
        local ChosenPet = getRandomPet(EggName)

        if not ChosenPet then return end 
       
        PetGenerator(Player,ChosenPet)


        --local PlayersInventory = InventoryMananger.GetPlayerInventory(Player)
        
        --print(PlayersInventory)
    end


    
end


local inputFuncTable = {

    ["E"] = function(...)
        HatchEgg(...)
    end,
    ["Q"] = function(Player,EggName)
        
    end,
    ["R"] = function(Player,EggName)
        
    end,


}

return {


    

    ["HatchEgg"] =function(Player,EggName,Input)
            
       local FuncTemp = inputFuncTable[Input]

        if FuncTemp then
            
            FuncTemp(Player,EggName)

        end

        --HatchEgg(Player,EggName)

       
    end

}
