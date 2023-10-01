-- Função para criar um novo pet com nome
local function createPet(id,petName, chance, rarity, secret, health, damage, multiplier)
    return {
        Id = id,
        petName = petName,
        chance = chance,
        rarity = rarity,
        secret = secret,
        health = health,
        damage = damage,
        multiplier = multiplier,
        Equipped = false,
        lock = false
    }
end

-- Função para criar um novo ovo
local function createEgg(eggPrice, eggCurrency)
    local egg = {
        eggPrice = eggPrice,
        eggCurrency = eggCurrency,
        eggPets = {},
    }

    -- Método para adicionar um pet ao ovo
    function egg:addPet(pet)
        table.insert(self.eggPets, pet)
    end

    -- Função para pegar o ovo inteiro
    function egg:GetEggData()
        return {
            eggPrice = self.eggPrice,
            eggCurrency = self.eggCurrency,
            eggPets = self.eggPets,
        }
    end

    -- Função para pegar os dados de um pet específico pelo nome do pet
    function egg:GetPetDataByName(petName)
        for _, pet in ipairs(self.eggPets) do
            if pet.petName == petName then
                return pet
            end
        end
        return nil
    end

    -- Configurando a metatable para o ovo
    local eggMetatable = {
        __index = egg,
    }

    return setmetatable(egg, eggMetatable)
end

-- Criando os ovos
local FirstEgg = createEgg(150, "Cash")
local SecondEgg = createEgg(500, "Cash")
local ThirdEgg = createEgg(1500, "Cash")

-- Adicionando pets aos ovos com nomes
FirstEgg:addPet(createPet(0,"Mac", 40, "Common", false, 15, 15, 2.0))
FirstEgg:addPet(createPet(0,"Bat", 40, "Common", false, 20, 20, 3.0))
FirstEgg:addPet(createPet(0,"Light Bat", 12, "UnCommon", false, 30, 30, 5.0))
FirstEgg:addPet(createPet(0,"Billy", 7.5, "Rare", false, 50, 50, 10.0))
FirstEgg:addPet(createPet(0,"Candy Stack", 0.5, "Legendary", true, 70, 70, 50.0))

SecondEgg:addPet(createPet(0,"Mickey", 40, "Common", false, 25, 25, 5.0))
SecondEgg:addPet(createPet(0,"Angel", 40, "Common", false, 40, 40, 7.0))
SecondEgg:addPet(createPet(0,"Angeler fish", 12, "UnCommon", false, 75, 75, 10.0))
SecondEgg:addPet(createPet(0,"Ricky", 7.5, "Rare", false, 120, 120, 25.0))
SecondEgg:addPet(createPet(0,"Overlord", 0.5, "Legendary", true, 200, 200, 75.0))

ThirdEgg:addPet(createPet(0,"Snikers", 40, "Common", false, 15, 15, 2.0))
ThirdEgg:addPet(createPet(0,"Cloud", 40, "Common", false, 15, 15, 2.0))
ThirdEgg:addPet(createPet(0,"Read fly", 12, "UnCommon", false, 15, 15, 2.0))
ThirdEgg:addPet(createPet(0,"Ice golem", 7.5, "Rare", false, 15, 15, 2.0))
ThirdEgg:addPet(createPet(0,"Covid-19", 0.5, "Legendary", true, 15, 15, 2.0))


-- Tabela final que contém os ovos
local eggs = {
    FirstEgg = FirstEgg,
    SecondEgg = SecondEgg,
    ThirdEgg = ThirdEgg,
}

-- Função para pegar um ovo pelo nome
function GetEggByName(eggName)
    return eggs[eggName]
end

-- Função para pegar os dados de um pet específico em um ovo pelo nome do ovo e pelo nome do pet
function GetPetDataByName(eggName, petName)
    local egg = GetEggByName(eggName)
    if egg then
        return egg:GetPetDataByName(petName)
    else
        return nil
    end
end

function GetPetByChance(eggName, chance)
    local egg = GetEggByName(eggName)
    if egg then
        local possiblePets = {}
        for _, pet in ipairs(egg.eggPets) do
            if pet.chance >= chance then
                table.insert(possiblePets, pet)
            end
        end

        if #possiblePets > 0 then
            -- Escolha aleatoriamente um dos pets com base na chance
            local selectedPetIndex = math.random(1, #possiblePets)
            return possiblePets[selectedPetIndex]
        end
    end

    return nil
end

Module =  {
    GetEggByName = GetEggByName,
    GetPetDataByName = GetPetDataByName,
    GetPetByChance = GetPetByChance,
}

return Module