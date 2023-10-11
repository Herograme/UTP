local ServerStorage = game:GetService("ServerStorage")
local module = {}

local function TableClone(original)
	local copy = {}
	for k, v in pairs(original) do
		if type(v) == "table" then
			v = TableClone(v)
		end
		copy[k] = v
	end
	return copy
end

local ProfileService = require(ServerStorage.Services.Profile.ProfileService)


local players = game:GetService("Players")

local AnimeTemplate = {
    Purchased = {},
	Replicators = {}
	
}

local profileTemplate = {
    Pets = {},
    GamePass = {},
    Products = {},
    TycoonModels = {},
    Cash = 15,
    Shards = 15,
	World = "Namek",
}	

--game:GetService("DataStoreService"):GetDataStore("playerData")
local profileStore = ProfileService.GetProfileStore("TesteData", profileTemplate)

local profiles = require(ServerStorage.Services.Profile.Profile)

function onPlayerAdded(player)
	
	local profile = profileStore:LoadProfileAsync(`{player.UserId}`)
	
	profile:AddUserId(player.UserId)
	profile:Reconcile()
	profile:ListenToRelease(function()
		profiles[player.UserId] = nil
		player:Kick()
	end)
	
	if player:IsDescendantOf(players) then
		profiles[player.UserId] = profile
	else
		profile:Release() -- Libera a data para poder carregar em outros servidores
	end
	
end

local function onPlayerRemoving(player)
	
	local profile = profiles[player.UserId]
	print(profile.Data)
	if profile then
		profile:Release() -- Libera a data para poder carregar em outros servidores
	end
	
end

function module:GetData(player): {any}
	
	local profile = profiles[player.UserId]
	
	while not profile and player:IsDescendantOf(players) do
		
		profile = profiles[player.UserId]
		
		if profile then break end
		
		task.wait(0.4)
		
	end
	
	if profile then
		return profile.Data
	end
	
end

function module:AddAnimeTemplate(player,Anime)
	local profile = profiles[player.UserId]
	profile.Data.TycoonModels[Anime] = TableClone(AnimeTemplate)
	
end

function module.Init()
	
	for index, player in players:GetPlayers() do
		task.spawn(onPlayerAdded, player)
	end
	
	players.PlayerAdded:Connect(onPlayerAdded)
	players.PlayerRemoving:Connect(onPlayerRemoving)
	
end

return module