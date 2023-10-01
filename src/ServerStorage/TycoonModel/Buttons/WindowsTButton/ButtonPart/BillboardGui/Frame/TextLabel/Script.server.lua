local ButtonTycoon = script.Parent.Parent.Parent.Parent.Parent

local TextInButton = ButtonTycoon:GetAttribute("NameButton")
local PriceValue =  tostring(ButtonTycoon:GetAttribute("Price")) 

local TextComplete = TextInButton .. " - " .. PriceValue.. "$"

script.Parent.Text =  TextComplete 

script:Destroy()