local players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local WorkSpace = game:GetService("Workspace")
local players = game:GetService("Players")
local proximityprompt = game:GetService("ProximityPromptService")
local utilities =  require(game:GetService("ServerStorage").UtilitiesScript)


local TycoonModel = script.Parent.Parent
local TycoonId = TycoonModel.Name
local Buttons = TycoonModel.Buttons
local Boughtitems = TycoonModel.Boughtitems





local debouce = false
for _,v in pairs(Buttons:GetChildren()) do

	if debouce ==  false then
		v.ButtonPart.Touched:Connect(function(Hit)
			local player = players:GetPlayerFromCharacter(Hit.Parent)
			local playerChekced = utilities.functions.CheckPlayer(player, TycoonModel)
--			print(playerChekced)
			if playerChekced == true then
				
				debouce = true
--				print("chegou aqui")
				local ButtonItem = v:GetAttribute("Item")
--				print(ButtonItem)
				if Boughtitems:FindFirstChild(ButtonItem) == nil then
					ReplicatedStorage.Remotes.BuyItem:Fire(player,v.name)
--					print("PASSOU PELO IF ")
				end	
				wait(4)
			
				debouce =false
			end
		end)
	end
end


