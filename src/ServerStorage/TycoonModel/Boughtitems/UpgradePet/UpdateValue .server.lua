local UpgradePart = script.Parent.UpgraderPart
local UpgraderPet = script.Parent
local Debounce = {}



UpgradePart.Touched:Connect(function(Hit)
	
	if Hit.Name:match("Drop") == "Drop" then
		if not Debounce[Hit] then
			local CashTemp = Hit:GetAttribute("Cash")
			local multiplier = UpgraderPet:GetAttribute("Multiplier")
			print("Mutiplier drop: ".. tostring(multiplier))
			local percentage = (multiplier or 0)/100
			
			
			
			CashTemp = CashTemp+(CashTemp * percentage)  

			Hit:SetAttribute("Cash",CashTemp)
			
			
			
			if multiplier ~= nil and multiplier ~=0 then
				Hit.BrickColor = BrickColor.Random()
				Hit.Transparency = 0
			end


			Debounce[Hit] = true
		end
	end
end)



