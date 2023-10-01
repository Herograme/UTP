local Players = game:GetService("Players")
local module = {}

CacheMethods = {}

CacheMethods.__index = CacheMethods

function CreateCache(Player)

    CacheMethods = {
        ["Anime"] = false,
        ["Person"] = false,
        ["Owner"] = Player,
        ["TycoonBase"] = false,
        ["TycoonThreads"] = {},
        ["Purchased"] = {},
        ["TycoonCash"] = 0
    }
    
    

    return setmetatable({},CacheMethods)
end

function CacheMethods:SetTycoonBase(Model:Model)
    self.TycoonBase = Model    
end

function PlayerAdd(Player)
    module[Player.UserId] = CreateCache(Player)
end

function PlayerRemoving(Player)
    module[Player.UserId] = nil
end

Players.PlayerAdded:Connect(PlayerAdd) 
Players.PlayerRemoving:Connect(PlayerRemoving)

return module 