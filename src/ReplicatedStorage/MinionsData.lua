local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FolderMinions =  ReplicatedStorage.AnimePets
local module = {}




function CreateMinion(Name:string,ValueBase:number,Chance:number,Rarity:string,Model:Model)
    local MinionTemplate = {
        Name = Name,
        Value = ValueBase,
        Chance = Chance,
        Rarity = Rarity,
        Model = Model
    }

    MinionTemplate.__index = MinionTemplate
   return setmetatable({},MinionTemplate)
end

function CreateEgg(Name:StringValue,Price:number,World:string)
    local eggTemplate = {
        Name = Name,
        Price = Price,
        World = World,
        Minions = {}
    }

    eggTemplate.__index = eggTemplate

    function eggTemplate:AddMinion(Minion)
        self.Minions[Minion.Name] = Minion
    end

    return setmetatable ({},eggTemplate)
end


module["DragonHero"] = CreateEgg("DragonHero",4000,"Namek")
local DragonHero = module["DragonHero"]

DragonHero:AddMinion(CreateMinion("Golku",20,75,"Common",FolderMinions.Golku))
DragonHero:AddMinion(CreateMinion("Vegetal",40,55,"Common",FolderMinions.Vegetal))
DragonHero:AddMinion(CreateMinion("Frezer",80,25,"UnCommon",FolderMinions.Frizo))

function module:GetEggData(EggName)
    local tempData = self[EggName]

    if tempData then return tempData end
end

function module:GetMinionData(MinionName)
    if MinionName == "default" then
       return {
        Name = "Noob",
        Value = 15,
        Model = FolderMinions
       }
    end

    for i , Egg in pairs(self) do
        for minionName , Minion in pairs(Egg) do
            if minionName == MinionName then
                return Minion
            end
        end
    end
end

return module 