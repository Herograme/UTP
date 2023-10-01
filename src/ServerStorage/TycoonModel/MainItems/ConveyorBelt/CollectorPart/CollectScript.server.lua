local CashButton = script.Parent.Parent.Parent.CashButton
local CashTemp = 0

script.Parent.Touched:Connect(function(Hit)
	local Cash = Hit:GetAttribute("Cash")
	if  Cash ~= nil then
		
		CashTemp = Cash + (CashButton:GetAttribute("Cash")or 0)
		
		CashButton:SetAttribute("Cash" , CashTemp)
		Hit:Destroy()
	end
end)
