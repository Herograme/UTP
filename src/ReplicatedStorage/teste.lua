local folderBRICKS = game.Workspace.KillBricks




for _,brick in pairs(folderBRICKS:GetChildren()) do
    

    brick.Touched:Connect(function(hit)
        
        if hit.Parent:FindFirstChild("Humanoid") then 

            local Humanoid = hit.Parent.Humanoid

            Humanoid.Health = 0

        end     


        
    end)


end