local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

PowerDatas = require(ReplicatedStorage.PowersData)
InventoryMananger = require(ServerStorage.Services.InventoryMananger)



return{

    CheckPlayerCash = function(Player,Price,CoinType)
        local PlayerInventory = InventoryMananger:GetInventory(Player)

        local CashPlayer =  PlayerInventory[CoinType]

        if CashPlayer > Price then
            return true 
        end 



    end,

    Payment = function(Player,Price, CoinType)
        local PlayerInventory = InventoryMananger:GetInventory(Player)


        
        local CashBackUP = PlayerInventory[CoinType]
        
        PlayerInventory:BankDebit(CoinType,Price)


        if PlayerInventory[CoinType] < 0 then
            PlayerInventory:BankUpdate(CoinType,CashBackUP)
            warn("Erro Na Transação")
        else    
            return true                
        end

        

    end,

    CheckPersonAvaiable =  function(Person)


        local playerList = Players:GetPlayers()

        for _,playerIndex in pairs(playerList) do
            
            local PersonPlayer = playerIndex:GetAttribute("PersonSelected") or "nobody"
            
            if Person == PersonPlayer then
                
                return false

            end

        end

        return true

    end,

    SetPersonInPlayer = function(Player,Person)
        local PersonData = PowerDatas.Skills[Person]
        if not PersonData then return end 



        Player:SetAttribute("PersonSelected",Person)
        Player:SetAttribute("AnimeSelected",PersonData.Anime)

        return PersonData.Anime

    end








}