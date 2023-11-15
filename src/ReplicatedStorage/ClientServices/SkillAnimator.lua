type skillfunc = (PlayerOrigin: Player, hitbox: Part, Skill: Animation) -> ()
type skilltable = { [string]: skillfunc }
--
local Players = game:GetService("Players")
local LocalPlayer: Player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BridgeNet = require(ReplicatedStorage.Packages.bridgenet2)

local FireSkill = BridgeNet.ReferenceBridge("FireSkill")
--FireSkill.Logging = true
local AnimationsFolder = ReplicatedStorage.Animations :: Folder
local SkillSystem = script.Parent.SkillSystemClient
local Skills: skilltable = {}

local module = {}
--https://prod.liveshare.vsengsaas.visualstudio.com/join?A349A6F874A0FDD3715CEF7ED3C58E1DCA68
function module:init()
	for i, skillmodule in pairs(SkillSystem:GetChildren()) do
		Skills[skillmodule.Name] = require(skillmodule)
	end
end

function ReceiveSkill(Content)
	print("Skill-Client", Content)
	local PlayerOrigin: Player = Content.player
	local skill: string = Content.skill
	local hitbox: Part = Content.hitbox

	if not PlayerOrigin or not skill or not hitbox then
		return
	end

	local SkillAnimation: Animation = AnimationsFolder:FindFirstChild(skill)

	if Skills[skill] then
		if LocalPlayer.UserId == PlayerOrigin.UserId then
			LocalPlayer.Character:SetAttribute("AnimationState",true)
		end
		Skills[skill](PlayerOrigin, hitbox, SkillAnimation)
	end
end

FireSkill:Connect(ReceiveSkill)
return module