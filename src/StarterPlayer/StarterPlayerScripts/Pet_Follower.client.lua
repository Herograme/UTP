local runService = game:GetService("RunService")

local playerPets = workspace:WaitForChild("PlayerData"):WaitForChild("PlayerPets")

local circle = math.pi * 2

local function getPosition(angle, radius)
	local x = math.cos(angle) * radius
	local z = math.sin(angle) * radius
	return x, z
end

local function positionPets(character, folder, dt)
	for i, pet in pairs(folder:GetChildren()) do
		local radius = 4+#folder:GetChildren()
		local angle = i * (circle / #folder:GetChildren())
		local x, z = getPosition(angle, radius)
		local _, characterSize = character:GetBoundingBox()
		local _, petSize = pet:GetBoundingBox()

		local offsetY = - characterSize.Y/2 + petSize.Y/2
		local sin = (math.sin(15 * time() + 1.6)/.5)+1
		local cos = math.cos(7 * time() + 1)/4
		
		--[[if pet:FindFirstChild("Attack").Value ~= nil then
			if pet:FindFirstChild("Walks") then
				local position = (pet:FindFirstChild("Attack").Value.PrimaryPart.CFrame * CFrame.new(x, 0, z)).p
				local lookAt = pet:FindFirstChild("Attack").Value.PrimaryPart.Position
				pet:SetPrimaryPartCFrame(pet.PrimaryPart.CFrame:Lerp(CFrame.new(position, lookAt) * CFrame.new(0, 1 +sin, 0) * CFrame.fromEulerAnglesXYZ(0,0,cos),0.1))
			else
				local position = (pet:FindFirstChild("Attack").Value.PrimaryPart.CFrame * CFrame.new(x, 0, z)).p
				local lookAt = pet:FindFirstChild("Attack").Value.PrimaryPart.Position
				pet:SetPrimaryPartCFrame(pet.PrimaryPart.CFrame:Lerp(CFrame.new(position, lookAt) * CFrame.new(0, 3+math.sin(time()*7)/2, 0) * CFrame.fromEulerAnglesXYZ(cos,0,0) ,0.1))
			end 
		else]]
			if character.Humanoid.MoveDirection.Magnitude > 0 then
				if pet:FindFirstChild("Walks") then
					pet:SetPrimaryPartCFrame(pet.PrimaryPart.CFrame:Lerp(character.PrimaryPart.CFrame * CFrame.new(x, offsetY+sin, z) * CFrame.fromEulerAnglesXYZ(0,0,cos),0.1))
				else
					pet:SetPrimaryPartCFrame(pet.PrimaryPart.CFrame:Lerp(character.PrimaryPart.CFrame * CFrame.new(x, offsetY/2+math.sin(time()*3)+1, z),0.1))
				end 
			else
				if pet:FindFirstChild("Walks") then 
					pet:SetPrimaryPartCFrame(pet.PrimaryPart.CFrame:Lerp(character.PrimaryPart.CFrame * CFrame.new(x, offsetY, z) ,0.1))
				else
					pet:SetPrimaryPartCFrame(pet.PrimaryPart.CFrame:Lerp(character.PrimaryPart.CFrame * CFrame.new(x, offsetY/2+math.sin(time()*3)+1, z) ,0.1))
				end
			end
		--end

	end
end

runService.RenderStepped:Connect(function(dt)
	for _, PlrFolder in pairs(playerPets:GetChildren()) do
		local Player = game.Players:FindFirstChild(PlrFolder.Name) or nil
		if Player ~= nil then
			local character = Player.Character or nil
			if character ~= nil then
				positionPets(character, PlrFolder, dt)
			end
		end
 	end
end)