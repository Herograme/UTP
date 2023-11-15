

module = {}
type Hitbox = Part
type hitboxfunc = () -> Hitbox
type effectfunc = (Hitbox:Part,Player:Player,Destiny:CFrame) -> ()
type hitboxTable = {[string]:hitboxfunc}
type effectsList = {[string]:effectfunc}
local HitBoxGenerateList:hitboxTable = {}
local HitBoxEffectsList:effectsList = {}

local SkillSystem = script.Parent

function module:Init() 
    for i , SkillModule:ModuleScript in pairs(SkillSystem.Skills:GetChildren()) do
        local SkillScript = require(SkillModule)
        HitBoxGenerateList[SkillModule.Name] = SkillScript.Generate
        HitBoxEffectsList[SkillModule.Name] = SkillScript.Effect
        print("inicializing",SkillModule.Name)
    end
end

function module:GetHitBox(Skill:string,Player:Player)
    if HitBoxGenerateList[Skill] then
        print("Generate Hitbox")
        return HitBoxGenerateList[Skill](Player)
    end
end

function module:ApplyEffect(Skill:string,Hitbox:Part|table,Player:Player,Destiny:CFrame)
    if HitBoxEffectsList[Skill] then
        warn("Apply effect in",Skill)
        HitBoxEffectsList[Skill](Hitbox,Player,Destiny)
    end
end



return module