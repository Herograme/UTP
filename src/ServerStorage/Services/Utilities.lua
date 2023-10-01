local ServerStorage = game:GetService("ServerStorage")
--local tycoonUtilities =require(ServerStorage.Services.TycoonUtilites)


return {

    

    ErrorPrint =  function(ErrorID)
      local errorList = {
        [1] = "EggData",
        [2] = "CashInsuficient",
        [3] = "Pet Sorter",
        [4] = "Person Select",
        [5] = "AnimeModel Load",
        [6] = "Tycoon Slot Ocupped",
        [7] = "Data Person Require",
        [8] = "Get Data Button",
        [9] = "Get Player Item Table",
     
     
      }

      warn("Error-".. ErrorID.." ".. errorList[ErrorID])

    end,





    ClearCachePlayer = function(Player)
      --tycoonUtilities:ClearCachePlayer(Player)
    end






}