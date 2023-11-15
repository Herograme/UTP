local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ContentProvider = game:GetService("ContentProvider")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local LoadingScreen = ReplicatedFirst.GameLoading.LoadingScreen:Clone()
local PlayerGui = Player:WaitForChild("PlayerGui")

LoadingScreen.Parent = PlayerGui
local MainFrame = LoadingScreen.Main
local AssetsCount = MainFrame.AssetsCount
local ExpandBar = MainFrame.LoadingBar.ExpandBar

ReplicatedFirst:RemoveDefaultLoadingScreen()


local Assets = {
    unpack(game.ReplicatedFirst:GetDescendants()),
    unpack(game.Players:GetDescendants()),
    unpack(game.StarterPlayer:GetDescendants()),
	unpack(game.Lighting:GetDescendants()),
	--unpack(game.MaterialService:GetDescendants()),
	unpack(game.ReplicatedStorage.ClientServices:GetDescendants()),
    unpack(game.ReplicatedStorage.VFXHERO:GetDescendants()),
    unpack(game.ReplicatedStorage.Animations:GetDescendants()),
    unpack(game.ReplicatedStorage.PersonModels:GetDescendants()),
	unpack(game.StarterGui:GetDescendants()),
	unpack(game.StarterPack:GetDescendants()),
    unpack(game.Workspace.TycoonModels:GetDescendants()),
    unpack(game.Workspace.TycoonBases:GetDescendants()),
}

module = {} 

function module:Init()
    print("GameLoading...")
    for i = 1, #Assets do
        local Asset = Assets[i]
        local Percentage = math.round(i/#Assets * 100)

        ContentProvider:PreloadAsync({Asset})

        AssetsCount.Text = "("..i.."/"..#Assets..")"

        if  i % 5 == 0 then
            --task.wait()
        end
        if i == #Assets then
            task.wait(1)
            local info = TweenInfo.new(0.5,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0)
            local Goal:CanvasGroup = {}
            Goal.GroupTransparency = 1
            local TweenAnimate:TweenBase= TweenService:Create(MainFrame,info,Goal)
            --TweenService:Create(MainFrame.BackGround.ImageLabel,info,Goal):Play()
            TweenAnimate:Play()
            TweenAnimate.Completed:Wait()
            LoadingScreen:Destroy()
        end
        if Percentage < 90 then
            ExpandBar.Size = UDim2.new((Percentage/100),0,0.125,0)
            --[[local info = TweenInfo.new(0.1,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0.1)
            local Goal = {}
            Goal.Size = UDim2.new((Percentage/100),0,0.125,0)
            local TweenAnimate = TweenService:Create(ExpandBar,info,Goal)
            TweenAnimate:Play()
            task.wait()]]
        end
        --task.wait(0.1)
    end
end

return module