local ServerStorage = game:GetService("ServerStorage")
local hitboxGenerator = require(ServerStorage.SkillSystem.CommonFuncs)


return function(context,property:string,value:boolean)
    if hitboxGenerator["_"..property] then
        hitboxGenerator["_"..property] = value
    end
end    