local replicatedStorage =  game:GetService("ReplicatedStorage")
local remotes =  replicatedStorage.Remotes
local players =  game:GetService("Players")




local BoughtItems = script.Parent.Parent.Boughtitems
local Scripts = script.Parent.Parent.Scripts
local tycoonModel  = script.Parent.Parent
local Eggs =  script.Parent.Parent.MainFolder_Workspace.Eggs


 BoughtItemsTable = {}


for _, items in ipairs(BoughtItems:GetChildren()) do
	
	BoughtItemsTable[items.Name] = items:Clone()
	items:Destroy()
	
end
for _, items in ipairs(Eggs:GetChildren()) do
	BoughtItemsTable[items.Name] = items:Clone()
	items:Destroy()
end


local function BuildItem (item)
	if item:match("Egg") ~= nil then
		local buildItem  = BoughtItemsTable [item]
		buildItem.Parent = Eggs
		return
	end

	local buildItem  = BoughtItemsTable [item]
	buildItem.Parent = BoughtItems
	
	local DropperScript = buildItem:FindFirstChild("ScriptDropper")
	if DropperScript ~= nil  then
		DropperScript.Enabled =  true
	end
	
end






remotes.BuildItem.Event:Connect(function(player, item)
	
	local TycoonId = tonumber(tycoonModel.Name)
	local playerId = players[player.Name].UserId

	 
	if TycoonId ==  playerId then
		BuildItem(item)
	end

end)




