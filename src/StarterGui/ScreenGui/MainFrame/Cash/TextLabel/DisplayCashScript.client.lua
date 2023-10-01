local FormatNumber =  require(game.ReplicatedStorage.FormatNumber.Custom)




local player = game.Players.LocalPlayer

local function DisplayAtt ()
	local Cash = player:GetAttribute("Cash")
	local FormatedCASH = FormatNumber.functions.FormaterNumbers(Cash)
	
	
	
	script.Parent.Text = FormatedCASH
end
DisplayAtt ()
player.AttributeChanged:Connect(DisplayAtt)

