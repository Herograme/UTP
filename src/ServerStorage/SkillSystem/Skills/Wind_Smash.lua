
module = {}

type hitTable = {[number]:Part}

local DELAY_TIME:number = 1.5
local OFFSET = Vector3.new(0,0,-3.02)
local AMOUNT = 8
local RANGE_LIMIT = 20
local SPACE_BETWEEN = 1
local SIZE = Vector3.new(2,4,2)

local LocalizationTable = {}
local GlobalLocazationTable = {}


local CommomFuncs = require(script.Parent.Parent.CommonFuncs)

function CheckLocation(Position:Vector3)
    for i,EffectPosition:Vector3 in pairs(LocalizationTable) do
        if (EffectPosition.X-Position.X) > SPACE_BETWEEN then
            if (EffectPosition.Y-Position.Y) > SPACE_BETWEEN then
                return true 
            end
        end
    end
end

function SetPosition()
    local X = math.random(-RANGE_LIMIT,RANGE_LIMIT)
    local Y = math.random(-RANGE_LIMIT,RANGE_LIMIT)

    local attachPosition = Vector3.new(X,Y,OFFSET.Z)

    return attachPosition
end

function GenerateRandomPositions(Attachment:Attachment)
    for i = 1, AMOUNT do
        local attachPosition = SetPosition()

        while not CheckLocation(attachPosition) do
            attachPosition = SetPosition()
       
            task.wait()
        end

        Attachment.Position = attachPosition

        LocalizationTable[i] = Attachment.Position

        GlobalLocazationTable[i] = Attachment.WorldCFrame
    end
end

function module.Generate(Player:Player)
    local attach:Attachment = CommomFuncs.AttachPlayer(Player,"HumanoidRootPart",OFFSET)

    GenerateRandomPositions(attach)
    local HitboxTable:hitTable = {}
    for i:number,CFrame:CFrame in pairs(GlobalLocazationTable) do
        HitboxTable[i] = CommomFuncs.GenerateBasicBox("Box",SIZE)
        HitboxTable[i]:PivotTo(CFrame)
        HitboxTable[i].Anchored = true
        
    end
end

function module.Effect(Hitboxes,Player:Player,Destiny:CFrame)
    for i, hitbox in pairs(Hitboxes)do
        local Origin = hitbox:GetPivot()

        local Attachment:Attachment =  Instance.new("Attachment")
        Attachment.Parent =  hitbox

        local LinearVelocity:LinearVelocity = Instance.new("LinearVelocity")
        LinearVelocity.MaxForce = math.huge
        LinearVelocity.VectorVelocity = CFrame.lookAt(Origin.Position, Destiny.Position).LookVector * 100
        LinearVelocity.Attachment0 = Attachment
        LinearVelocity.Parent = hitbox

        task.delay(DELAY_TIME,function()
        hitbox.Anchored = false
        end)
        end

        
    end
    print("ApplyEffect in Hitbox")
return module 