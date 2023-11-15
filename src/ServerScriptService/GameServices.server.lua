

local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DbAll = {}

local BridgeNet = require(ReplicatedStorage.Packages.bridgenet2)
----------------
--Create Remotes 

 local GuiEvents =BridgeNet.ServerBridge("GuiEvents")
 local TycoonEvents = BridgeNet.ServerBridge("TycoonEvents")
 local EggsEvent = BridgeNet.ServerBridge("EggsEvent")
 local MinionSpawned =  BridgeNet.ServerBridge("MinionSpawned")
 local EffectsController = BridgeNet.ServerBridge("EffectsController")
 local GuiLoader = BridgeNet.ServerBridge("GuiLoader")
 local ItemSpawned = BridgeNet.ServerBridge("ItemSpawned")
 local FireSkill = BridgeNet.ServerBridge("FireSkill")

 
 GuiEvents.Logging = true
 TycoonEvents.Logging = true
 EggsEvent.Logging = true
 MinionSpawned.Logging = true
 EffectsController.Logging = true
 GuiLoader.Logging = true
----------------

local DataMananger =require(ServerStorage.Services.DataMananger)
local InventoryMananger =  require(ServerStorage.Services.InventoryMananger)
local PlayerUtilities = require(ServerStorage.Services.PlayerUtilites)
local PetUtilites = require(ServerStorage.Services.PetUtilites)
local TycoonMananger = require(ServerStorage.Services.TycoonMananger)
local utilities = require(ServerStorage.Services.Utilities)
local SkillMananger = require(ServerStorage.Services.SkillMananger)
local HitBoxMananger = require(ServerStorage.SkillSystem.HitBoxMananger)

local Cmdr = require(ReplicatedStorage.Packages.cmdr)




--------------
--Debugs
_G.PrintData = function(Player)
    print(InventoryMananger:GetInventory(Player))
end

_G.SetMoney = function(Value)
  local dataPlayer = InventoryMananger:GetInventory(Players.herograme)
  dataPlayer:BankUpdate("Cash",Value)
end
--------------

Cmdr:RegisterDefaultCommands()
Cmdr:RegisterCommandsIn(ServerStorage.Cmdr.Commands)
Cmdr:RegisterTypesIn(ServerStorage.Cmdr.Types)

DataMananger:Init()
TycoonMananger:Init()
InventoryMananger:Init()
SkillMananger:Init()
HitBoxMananger:Init()
TycoonMananger:ConnectTycoonDoor()

