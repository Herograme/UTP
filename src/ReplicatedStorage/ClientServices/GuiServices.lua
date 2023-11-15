local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")



local player = game.Players.LocalPlayer
local playerGui = player.PlayerGui
local ScreenGui = playerGui:WaitForChild("GuiTeste")


local OpenGuiButton = ScreenGui.Frame1.OpenGuiButton
local CloseGuiButton =  ScreenGui.Frame1.CloseGuiButton
local Animator = require(ScreenGui.Frame1.Animator)

local Timer = ScreenGui.Frame1.GuiElements1.Timer

local NumberFormat = require(ReplicatedStorage.FormatNumber.Custom)
local Module3D = require(ReplicatedStorage.Module3D)
local PowerDatas= require(ReplicatedStorage.PowersData)
local TycoonClient = require(ReplicatedStorage.ClientServices.TycoonClientServices)
local BridgeNet = require(ReplicatedStorage.Packages.bridgenet2)
local SkillAnimator = require(ReplicatedStorage.ClientServices.SkillAnimator)
---------------------------------------------------------------------
--Remotes

local GuiEvents =  BridgeNet.ReferenceBridge("GuiEvents")
local TycoonEvents = BridgeNet.ReferenceBridge("TycoonEvents")
local GuiLoader =  BridgeNet.ReferenceBridge("GuiLoader")

GuiEvents.Logging = true
GuiLoader.Logging = true

---------------------------------------------------------------------

local DisplayCash1 = ScreenGui.Frame1.GuiElements1.CashDisplay
local DisplayCash2 = ScreenGui.Frame1.GuiElements2.CashDisplay
local DisplayShard1 = ScreenGui.Frame1.GuiElements1.ShardDisplay
local DisplayShard2 = ScreenGui.Frame1.GuiElements2.ShardDisplay

----------------------------------------------------------------------

local ChosenGui = playerGui.ChosenGui
local template = ChosenGui.BackFrame.Template

local PersonFrame =  ChosenGui.PersonFrame

local GuiTreads =  {}
GuiTreads["TycoonChosen"] = {}

function DisconnectGui()
    ChosenGui.Enabled = false

    for _,Tread in pairs(GuiTreads["TycoonChosen"]) do
        Tread:Disconnect()
    end
end



local function PopUpPersonsLoad(anime)
   
    local ScrollingTemplate = PersonFrame.ScrollingTemplate
    local Template =  ScrollingTemplate.Template

     

    local PersonList = PowerDatas.personage[anime]

        if not PersonList then return end 

 
        local NewScrollingTemplate  = ScrollingTemplate:Clone()
        NewScrollingTemplate.Name =  anime

        local PersonList = PowerDatas.personage[anime]
        
        if not PersonList then return end 

        for _,Person in pairs(PersonList) do 
            
            local newTemplate = Template:Clone()
            newTemplate.Name = Person
            newTemplate.Visible =  true

            local PersonModel = PowerDatas.personageModels[Person]

            if PersonModel then 

                local Module3DTemplate = Module3D:Attach3D(newTemplate,PersonModel)
                Module3DTemplate:SetActive(true)
                Module3DTemplate:SetDepthMultiplier(3)

                GuiTreads["TycoonChosen"][Person]=RunService.RenderStepped:Connect(function(deltaTime)
                    Module3DTemplate:SetCFrame(CFrame.Angles(0,tick() % (math.pi * 2),0)
                     * CFrame.Angles(math.rad(-10),0,0))
                end)

            end     
            
            newTemplate.TextLabel.Text = Person
            newTemplate.Parent = NewScrollingTemplate

            newTemplate.TextButton.Activated:Connect(function()
               
                if not newTemplate:GetAttribute("Unavailable") then

                    TycoonEvents:Fire({func = "PersonChosen",content = Person}) 
                    Lighting.Blur.Enabled = false 
                    ChosenGui.Enabled = false
                    SkillAnimator:PreLoadAnimations(Person)
                    DisconnectGui()

                end

            end)

        end     

        NewScrollingTemplate.Parent =  PersonFrame


        PersonFrame.CloseButton.Activated:Connect(function()
            
            PersonFrame.Visible = false
            NewScrollingTemplate.Visible = false
            
        end)

    
        return NewScrollingTemplate
end

local function PopUpPersonsList(ScrollingTemplate,State)
    
    

    PersonFrame.Visible = State
    ScrollingTemplate.Visible = State
    
   

end

module =  {


    UpdateGuiState1 =   function(State)
	
		
        for _,v in pairs(ScreenGui.Frame1.GuiElements1:GetChildren()) do
            v.Visible = State
        end
    end,

    UpdateGuiState2 = function (State)
        local GuiSelect = ScreenGui.Frame1.GuiSelect.Value
        
        for _,v in pairs(ScreenGui.Frame1.GuiElements2:GetChildren()) do
            
            if State == true then
                if v.Name == GuiSelect or v.Name =="BlackBar" then
                    v.Visible = State 
                elseif v:IsA("Frame") and v.Name ~= GuiSelect then
                    v.Visible = false
                else
                    v.Visible = true 
                
                end
            else 	
                
                v.Visible = false
                
            end
                
        end
        
        
    end,

    GetTimer = function()
        local fomatedTemp
        local tempo = DateTime.now():ToLocalTime()
        if tempo.Hour < 10 and tempo.Minute < 10  then
            fomatedTemp ="0".. tempo.Hour..":0"..tempo.Minute
        elseif tempo.Minute < 10 then
            fomatedTemp = tempo.Hour..":0"..tempo.Minute	
        elseif tempo.Hour < 10 then
            fomatedTemp = "0"..tempo.Hour..":"..tempo.Minute
        else
            fomatedTemp = tempo.Hour..":"..tempo.Minute
        end
        return fomatedTemp
    end,

    FormatCash = function()
        local Cash = NumberFormat.functions.FormaterNumbers(player:GetAttribute("Cash"))
        local Shards =  NumberFormat.functions.FormaterNumbers(player:GetAttribute("Shards"))
    
        DisplayCash1.Text = Cash
        DisplayCash2.Text = Cash
        DisplayShard1.Text = Shards
        DisplayShard2.Text = Shards
    end,
    
    GuiControl = {
        ["Chosen"] = function(content)
            print(content)
            ChosenGui.Enabled = content
            Lighting.Blur.Enabled = content
        end, 
    }
}

function module:init()
    for _,anime in pairs(PowerDatas.Animes) do

       

        local newTemplate = template:Clone()
         
        local AnimeModelTemp = PowerDatas.AnimeModels[anime]

        if AnimeModelTemp then
             local AnimeModel = AnimeModelTemp:Clone()

             local Template3D =Module3D:Attach3D(newTemplate,AnimeModel)
             Template3D:SetActive(true)
             Template3D:SetDepthMultiplier(4)

             newTemplate.Name = anime
             newTemplate.Visible = true 
             newTemplate.Parent = ChosenGui.BackFrame

             newTemplate.TextLabel.Text = anime

             GuiTreads["TycoonChosen"][anime] = RunService.RenderStepped:Connect(function()
                Template3D:SetCFrame(CFrame.Angles(0,tick() % (math.pi * 2),0)
                * CFrame.Angles(math.rad(-10),0,0))
             end)

             local PopUPframe = PopUpPersonsLoad(anime)

             newTemplate.TextButton.Activated:connect(function()
                PopUpPersonsList(PopUPframe,true)
             end)
         end
    end
end

GuiEvents:Connect(function(pars)
    local Event = module.GuiControl[pars.func] 
    print(Event)
    --if Event then
        Event(pars.content)
    --end
end)

GuiLoader:Connect(function(Value)
    

   
end)




return module