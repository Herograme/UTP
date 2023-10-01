local players = game:GetService("Players")
local FormatNumber = require(game.ReplicatedStorage.FormatNumber.Custom)



local CashButton = script.Parent.Parent.MainItems.CashButton
local screen =  CashButton.ScreenPart.SurfaceGui.TextLabel
local PartCollect = CashButton.ButtonPartT
local buttonAnimed = CashButton.ButtonPart

local Debounce



local function ButtonAnimed (Debounce)
	if Debounce == true then
		buttonAnimed.Color = Color3.fromRGB(255,0,0)
	else 	
		buttonAnimed.Color = Color3.fromRGB(0,255,0)
	end	
end

CashButton.AttributeChanged:Connect(function()
	local Cash = FormatNumber.functions.FormaterNumbers(CashButton:GetAttribute("Cash"))
	
	if Cash then
		screen.Text =  Cash
	end
end)

PartCollect.Touched:Connect(function(hit)
	
	local player = game.Players:GetPlayerFromCharacter(hit.Parent)
	if not player then
		return
	end
	
	
	local playerId = player.UserId
	local TycoonId = tonumber(script.Parent.Parent.Name)
	
	if TycoonId == playerId and not Debounce then
		Debounce = true
		ButtonAnimed (Debounce)
		local Cash = CashButton:GetAttribute("Cash")
		local PlayerCash = player:GetAttribute("Cash")
		local temp  = PlayerCash + (Cash or 0)
		player:SetAttribute("Cash", temp)
		CashButton:SetAttribute("Cash", 0)
	end
end)

PartCollect.TouchEnded:Connect(function()
	Debounce = false
	ButtonAnimed (Debounce)
end)


