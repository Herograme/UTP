local DropperPartsFolder = script.Parent.Parent.Parent.DropperParts
local Drops = game:GetService("ReplicatedStorage").Drops

--local drop = script.Parent:GetAttribute("Drop")
--local Material = script.Parent.MaterialVariant
--print("Qualquer coisa ")
while wait(2) do
	local NewPart = Drops.Drop1:Clone()
	NewPart.Parent = DropperPartsFolder
	NewPart.Position = script.Parent.SpawnPart.Position
	--print(NewPart.Name)
	--NewPart.Size = Vector3.new(1,1,1)
	--NewPart.Color = Color
	--NewPart.MaterialVariant = Material
	

	--[[local CashValue = Instance.new("NumberValue", NewPart)
	CashValue.Value = script.Parent.ValueDropper.Value
	CashValue.Name = "CashValue"]]
end