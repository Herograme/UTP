local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local BridgeNet = require(ReplicatedStorage.Packages.bridgenet2)
local HitBoxMananger = require(ServerStorage.SkillSystem.HitBoxMananger)
local CacheManager = require(ServerStorage.Services.CacheMananger)

local FireSkill = BridgeNet.ReferenceBridge("FireSkill")
FireSkill.Logging = true

local DbList = {}

local module = {}

local IdList = {
    ["Blue"] = "15115659933",
    ["Red"] = "15115662179",
    ["Purple"] = "14777262539",
    ["Wind_Smash"] = "15199629620",
    ["Kamehameha"] = "14777396785",
    ["Rasengan1"] = "15234914919",
    ["Rasengan2"] = "15234930814",
    ["Clones"] = "15304259390",
}

function module:Init()
    for SkillName,AnimationID in pairs(IdList) do
        local Animation = Instance.new("Animation")
        Animation.AnimationId = "rbxassetid://"..AnimationID
        Animation.Parent = ReplicatedStorage.Animations
        Animation.Name = SkillName
    end
end

function GetDistances(PlayerOrigin:Player,OuterPlayer:Player):number
    local CFrame1:CFrame = PlayerOrigin.Character.HumanoidRootPart.CFrame
    local CFrame2:CFrame = OuterPlayer.Character.HumanoidRootPart.CFrame

    local Distance = ((CFrame1.X - CFrame2.X)^2 + (CFrame1.Y-CFrame2.Y)^2 + (CFrame1.Z- CFrame2.Z)^2)^0.5
    --local distance =  (CFrame1.Position - CFrame2.Position).Magnitude
    --[[H² = C² + C²]]
    return Distance
end


function GenerateGroupRender(Player:Player,MaxDistance:number):table
    local PlayersInArea = {}
    for i,OuterPlayer:Player in pairs(Players:GetPlayers()) do
        if GetDistances(Player,OuterPlayer) < MaxDistance then
            table.insert(PlayersInArea,OuterPlayer)
        end
    end
    
    return PlayersInArea
end


FireSkill:Connect(function(Player:Player,Content)
    local Input:string = Content.input
    local Direction:CFrame = Content.Direction
    --local Origin:CFrame = Content.Origin

    if not Input or not Direction then return end 

    local Skill:string = Player:GetAttribute(Input) or "Blue"

    if not Skill then return end 

    local Hitbox:Part|table = HitBoxMananger:GetHitBox(Skill,Player)

    local PlayerList = GenerateGroupRender(Player,800)

    FireSkill:Fire(BridgeNet.Players(PlayerList),{player = Player,skill = Skill,hitbox= Hitbox})
    HitBoxMananger:ApplyEffect(Skill,Hitbox,Player,Direction)

end)




--Players.playerAdded:Connect(AddPlayer)


return module