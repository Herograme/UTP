local FormatNumber = require(game.ReplicatedStorage.FormatNumber.Custom)

local function DisplayDrop ()
	local CashTemp = script.Parent.Parent:GetAttribute("Cash")
	script.Parent.TextLabel.Text = FormatNumber.functions.FormaterNumbers(CashTemp)

end




DisplayDrop ()
script.Parent.Parent.AttributeChanged:Connect(DisplayDrop)


