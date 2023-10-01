local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiServices =  require(ReplicatedStorage.ClientServices.GuiServices)

local remotes = ReplicatedStorage.Remotes


local player = game.Players.LocalPlayer
local playerGui = player.PlayerGui
local ScreenGui = playerGui:WaitForChild("GuiTeste")
local OpenGuiButton = ScreenGui.Frame1.OpenGuiButton
local CloseGuiButton =  ScreenGui.Frame1.CloseGuiButton
local Animator = require(ScreenGui.Frame1.Animator)


local Timer = ScreenGui.Frame1.GuiElements1.Timer


local GuiOpen = false






OpenGuiButton.MouseButton1Click:Connect(function()
	
	GuiOpen = true
	
	OpenGuiButton.Visible= false
	CloseGuiButton.Visible= true
	
	
	Animator.OpenGui:Play()
	Animator.OpenGui.Completed:Wait()
	task.wait(0.1)
	ScreenGui.Frame1.BlackScreen.Visible = true
	task.wait(0.2)
	GuiServices.UpdateGuiState1(false)
	GuiServices.UpdateGuiState2(true)
	
	ScreenGui.Frame1.BlackScreen.Visible = false
	
	CloseGuiButton.Visible = true
	
	
end)


CloseGuiButton.MouseButton1Click:Connect(function()
	
	GuiOpen = false
	
	CloseGuiButton.Visible= false
	OpenGuiButton.Visible= true
	

	Animator.CloseGui:Play()
	Animator.CloseGui.Completed:Wait()
	task.wait(0.1)
	ScreenGui.Frame1.BlackScreen.Visible = true
	task.wait(0.2)
	GuiServices.UpdateGuiState1(true)
	GuiServices.UpdateGuiState2(false)


	ScreenGui.Frame1.BlackScreen.Visible = false

	CloseGuiButton.Visible = true

	ScreenGui.Frame1:SetAttribute("GuiOpen", false)
	
	
end)



local function Timeloop ()
	Timer.Text = GuiServices.GetTimer ()
	while task.wait(30) do
		Timer.Text = GuiServices.GetTimer ()
	end
end
task.spawn(Timeloop)

local function UpdateCash()
	GuiServices.FormatCash()
	player.AttributeChanged:Connect(GuiServices.FormatCash)
end
UpdateCash()

OpenGuiButton.MouseEnter:Connect(function()
	if GuiOpen == false then
		Animator.UpGui:Play()
	end
end)


OpenGuiButton.MouseLeave:Connect(function()
	if GuiOpen == false then
		Animator.DownGui:Play()
	end
end)


remotes.GuiControl.OnClientEvent:Connect(function(Gui,State)


	local GuiFunction = GuiServices.GuiControl[Gui]
	if not GuiFunction then return end

	GuiFunction(State)
	

end)

