local Buttons = script.Parent.Parent.Buttons
local Boughtitems = script.Parent.Parent.Boughtitems
local eggs= script.Parent.Parent.MainFolder_Workspace.Eggs


local function loop()
	for _, v in pairs(Buttons:GetChildren()) do
		local ButtonDependency = v:GetAttribute("Dependency")
		local ButtonItem = v:GetAttribute("Item")
		local eggName = v.Name
		if eggName:match("Egg") ~= nil then
			if eggs:FindFirstChild(ButtonItem) == nil then
				if ButtonDependency ~= nil then
					if Boughtitems:FindFirstChild(ButtonDependency) ~= nil then
						v.ButtonPart.CanCollide = true 
						v.ButtonPart.Transparency = 0
						v.ButtonPart.CanTouch = true 
						v.ButtonPart.BillboardGui.Enabled = true

					else	
						v.ButtonPart.CanCollide = false 
						v.ButtonPart.Transparency = 1
						v.ButtonPart.CanTouch = false
						v.ButtonPart.BillboardGui.Enabled = false
					end
				else	
					v.ButtonPart.CanCollide = true 
					v.ButtonPart.Transparency = 0
					v.ButtonPart.CanTouch = true
					v.ButtonPart.BillboardGui.Enabled = true
				end
			else
				print("teste")
				v.ButtonPart.CanCollide = false 
				v.ButtonPart.Transparency = 1
				v.ButtonPart.CanTouch = false
				v.ButtonPart.BillboardGui.Enabled = false

			end
		else
			if Boughtitems:FindFirstChild(ButtonItem) == nil then
				if ButtonDependency ~= nil then
					if Boughtitems:FindFirstChild(ButtonDependency) ~= nil then
						v.ButtonPart.CanCollide = true 
						v.ButtonPart.Transparency = 0
						v.ButtonPart.CanTouch = true 
						v.ButtonPart.BillboardGui.Enabled = true

					else	
						v.ButtonPart.CanCollide = false 
						v.ButtonPart.Transparency = 1
						v.ButtonPart.CanTouch = false
						v.ButtonPart.BillboardGui.Enabled = false
					end
				else	
					v.ButtonPart.CanCollide = true 
					v.ButtonPart.Transparency = 0
					v.ButtonPart.CanTouch = true
					v.ButtonPart.BillboardGui.Enabled = true
				end
			else
--				print("teste")
				v.ButtonPart.CanCollide = false 
				v.ButtonPart.Transparency = 1
				v.ButtonPart.CanTouch = false
				v.ButtonPart.BillboardGui.Enabled = false

			end
		end
	end
end


task.delay(3,loop)

Boughtitems.ChildAdded:Connect(function(add)
	loop()
end)

eggs.ChildAdded:Connect(function(add)
	loop()
end)