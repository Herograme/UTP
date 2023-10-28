type skillfunc = (PlayerOrigin:Player,hitbox:Part,Skill:Animation) -> ()
type skilltable = {[string]:skillfunc}
--


local Players = game:GetService("Players")
local LocalPlayer:Player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BridgeNet = require(ReplicatedStorage.Packages.bridgenet2)

local FireSkill = BridgeNet.ReferenceBridge("FireSkill")
--FireSkill.Logging = true
local AnimationsFolder = ReplicatedStorage.Animations :: Folder
local SkillSystem = script.Parent.SkillSystemClient
local Skills:skilltable = {}



local module = {}

function module:init()
    for i,skillmodule in pairs(SkillSystem:GetChildren()) do
        Skills[skillmodule.Name] = require(skillmodule)
    end
end

function ReceiveSkill(Content)
    print("Skill-Client",Content)
    local PlayerOrigin:Player = Content.player
    local skill:string = Content.skill
    local hitbox:Part = Content.hitbox
    print(1)
    if not PlayerOrigin or not skill or not hitbox then return end

    print(2)
    local SkillAnimation:Animation = AnimationsFolder[skill]

    if Skills[skill] then
        print(3)
        Skills[skill](PlayerOrigin,hitbox,SkillAnimation)
    end
end




FireSkill:Connect(ReceiveSkill)
return module

