local TycoonModel = script.Parent.Parent
local Upgrader = TycoonModel.Boughtitems:WaitForChild("UpgradePet")
local Pets = TycoonModel.PetInUpgrader



local function UpdateMultiplier (PetEquipped)
	local UpgraderPet = TycoonModel.Boughtitems.UpgradePet
	local TempMultiplier = 0
	if PetEquipped == true then
		for _, v in pairs(Pets:GetDescendants()) do
			if v:IsA("StringValue")	== true then
				local multiplier = v:GetAttribute("multiplier")
				--print("Mutiplier: ".. tostring(multiplier))
				TempMultiplier += multiplier 	
			end
		end
	else 	
		TempMultiplier = 0
	end
	UpgraderPet:SetAttribute("Multiplier", TempMultiplier)
end








Pets.ChildAdded:Connect(function()
	UpdateMultiplier(true)
end)


Pets.ChildRemoved:Connect(function()
	if #Pets:GetChildren() > 0 then
		UpdateMultiplier(true)
	else
		UpdateMultiplier(false)
	end
end)

---local teste1 = Upgrader:GetAttribute()