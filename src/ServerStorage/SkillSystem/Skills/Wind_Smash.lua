
module = {}

type hitTable = {[number]:Part}

local DELAY_TIME:number = 3.5
local OFFSET = Vector3.new(0,0,-3.02)
local AMOUNT = 8
local RANGE_LIMIT = 10
local SPACE_BETWEEN = 2
local SIZE = Vector3.new(2,2,4)

--local LocalizationTable = {}
local GlobalLocazationTable = {}


local CommomFuncs = require(script.Parent.Parent.CommonFuncs)

function CheckLocation(Position:Vector3,LocalizationTable:table)

   -- print(LocalizationTable)

    if #LocalizationTable == 0 then
        return true 
    end
    local teste = true 
    for i,EffectPosition:Vector3 in pairs(LocalizationTable) do

        --print("Sub-",(EffectPosition.X-Position.X))

        if ((EffectPosition.X-Position.X) < SPACE_BETWEEN and (EffectPosition.X-Position.X) > -SPACE_BETWEEN) 
        --and((EffectPosition.Y-Position.Y) > SPACE_BETWEEN or (EffectPosition.Y-Position.Y) < -SPACE_BETWEEN)
        then
            teste = false
        end

        if i == #LocalizationTable then
            return teste
        end
    end
end

function SetPosition()
    local X = (math.random(-(RANGE_LIMIT*10),(RANGE_LIMIT*10)))/10
    local Y = (math.random(-10,10))/10

    local attachPosition = Vector3.new(X,Y,OFFSET.Z)
    --print(attachPosition)
    return attachPosition
end

function GenerateRandomPositions(Attachment:Attachment,LocalizationTable:table)
    for i = 1, AMOUNT do
        local attachPosition = SetPosition()

        local count = 1
        while task.wait() and count < 50 do
            print(count)
            if  CheckLocation(attachPosition,LocalizationTable) then
                break
            end
            attachPosition = SetPosition()
            
            count += 1
        end

       

        Attachment.Position = attachPosition

        LocalizationTable[i] = Attachment.Position

        GlobalLocazationTable[i] = Attachment.WorldCFrame
    end
end

function module.Generate(Player:Player)

    warn("Generate Hitboxs")
    local attach:Attachment = CommomFuncs.AttachPlayer(Player,"HumanoidRootPart",OFFSET)

    local LocalizationTable = {}

    GenerateRandomPositions(attach,LocalizationTable)
    local HitboxTable:hitTable = {}
    for i:number,GBCFrame:CFrame in pairs(GlobalLocazationTable) do
        HitboxTable[i] = CommomFuncs.GenerateBasicBox("Box",SIZE)
        HitboxTable[i]:PivotTo(GBCFrame)
        HitboxTable[i].Orientation = Player.Character.HumanoidRootPart.Orientation
        HitboxTable[i].Anchored = true
        HitboxTable[i].Parent = game.Workspace.HitBox
        
    end

    warn("HitboxGenerated")

    
    --GlobalLocazationTable = {}

    print()
    return HitboxTable
end

function module.Effect(Hitboxes,Player:Player,Destiny:CFrame)
    print(Hitboxes)
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
    --print("ApplyEffect in Hitbox")
return module 