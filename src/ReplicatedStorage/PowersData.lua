local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TycoonModels = ReplicatedStorage.TycoonModels
local personagesModels = ReplicatedStorage.PersonModels


module ={


Animes={"Jujutsu","Charuto","Dragon Hero","BackCover"},

personage ={
["Jujutsu"] = {"Sojo","Ditadori"},
["Charuto"] = {"Charuto","Saske"},
["Zero Peace"] = {"Luckey","Zofo"},
["BackCover"] = {"Astra", "Uno"},
["Dragon Hero"] = {"Golku","Vegetal"},

},

Skills = {
    --Jujutsu
    ["Sojo"] = {["Skill_Q"]="Red",["Skill_E"]="Blue",["Skill_R"]="Purple",["Anime"]="Jujutsu" },
    ["Ditadori"]={["Skill_Q"]="Punch Divergent",["Skill_E"]="Kokusen",["Skill_R"]="Sukuna",["Anime"]="Jujutsu" },

    --Charuto
    ["Charuto"] = {["Skill_Q"]="Clone",["Skill_E"]="Rasengan",["Skill_R"]="RasenShuriken",["Anime"]="Charuto" },
    ["Saske"] = {["Skill_Q"]="Chidori",["Skill_E"]="Amateratsu",["Skill_R"]="Susano",["Anime"]="Charuto"},

    --Zero Peace
    ["Luckey"] = {["Skill_Q"]="Gum Pistol",["Skill_E"]="Graplin Pistol",["Skill_R"]="Graplin Pistol c/Raki",["Anime"]="Zero Peace"},
    ["Zofo"] = {["Skill_Q"]="3Cut",["Skill_E"]="3kCut",["Skill_R"]="Ashura",["Anime"]="Zero Peace"},

    --BackCover
    ["Astra"]={["Skill_Q"]="Demon slayer",["Skill_E"]="Demon Dweller",["Skill_R"]="Demon destroyer",["Anime"]="BackCover"},
    ["Uno"]={["Skill_Q"]="Wind Smash",["Skill_E"]="Zone Mana",["Skill_R"]="Vent Spirit Sword",["Anime"]="BackCover"},

    --Dragon Hero
    ["Golku"] = {["Skill_Q"]="Energy Slash",["Skill_E"]="Teleport",["Skill_R"]="Kamekameha",["Anime"]="Dragon Hero"},
    ["Vegetal"] = {["Skill_Q"]="Energy Slash",["Skill_E"]="Spirit Bomb",["Skill_R"]="GalakGun",["Anime"]="Dragon Hero"},
},


AnimeModels = {
    ["Jujutsu"] = TycoonModels.TycoonModel,
    ["Charuto"] = TycoonModels.TycoonModel,
    ["Dragon Hero"] = TycoonModels.TycoonModel,
    ["Zero Peace"] = TycoonModels.TycoonModel,
    ["BackCover"] = TycoonModels.TycoonModel,
    ["teste"] = TycoonModels.TycoonModel,
},

personageModels = {

    ["Sojo"]=  personagesModels.Sojo:Clone(),
    ["Ditadori"]=  personagesModels.Ditadori:Clone(),
    ["Charuto"]= personagesModels.Charuto:Clone(),
    ["Saske"] = personagesModels.Saske:Clone(),
    ["Luckey"] = personagesModels.Luckey:Clone(),
    ["Zofo"] = personagesModels.Zofo:Clone(),
    ["Astra"] = personagesModels.Astra:Clone(),
    ["Uno"] = personagesModels.Uno:Clone(),
    ["Golku"] = personagesModels.Golku:Clone(),
    ["Vegetal"] = personagesModels.Vegetal:Clone(),
    
},

}

function module:GetPersonData(Person)
     local data = self.Skills[Person]

     if data then
        return data 
     end
end 

function module:GetAnimeFromPerson(Person)
    local data = self.Skills[Person]

    if data then
       return data.Anime 
    end
end 

function module:GetAnimeModel(Anime)
    local model = self.AnimeModels[Anime]

    if model then
        return model:Clone()
    end
end

return module
