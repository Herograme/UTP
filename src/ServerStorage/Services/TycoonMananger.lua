local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local CollectionService = game:GetService("CollectionService")


local Cache = require(ServerStorage.Services.Profile.PlayersCache)
local InventoryMananger = require(ServerStorage.Services.InventoryMananger)

module = {}

function module:Init()
    local TycoonBase =  workspace.TycoonBases.TycoonBase1

    for i = 2,8 do
        local NewBase = TycoonBase:Clone()
        
        NewBase:PivotTo(NewBase:GetPivot() * CFrame.Angles(0, math.rad(45), 0))

        NewBase.Name = "TycoonBase"..i
        NewBase.Parent = workspace.TycoonBases

        TycoonBase = NewBase
    end
end

function module:ConnectTycoonDoor()
    local DoorTrd
    local DoorList = CollectionService:GetTagged("TycoonDoor")

    if not DoorList then return end 

    for Index,Door in pairs(DoorList) do
        if Door:GetAttribute("OwnedTycoon") then
           DoorTrd = Door.OwnerDoor.MainDoor.Touched:Connect(function(Hit)
                local Character = Hit.Parent 
                local Player = Players:GetPlayerFromCharacter(Character)

                if not Player then return end 

                if not Door:GetAttribute("OwnedTycoon") and not Player:GetAttribute("OwnsTycoon") then
                    Door.SurfaceGui.TextLabel.Text = Player.Name.." Tycoon"
                    Player:SetAttribute("OwnsTycoon", true)
                    Door:SetAttribute("OwnsTycoon", true)
                    Door.Name = Player.UserI
                    
                    DoorTrd:Disconnect()
                end
            end)
        end
    end

end



