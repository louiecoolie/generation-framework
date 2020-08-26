local Resources = game:GetService("ServerStorage")
local Assets = Resources:FindFirstChild("Assets")
local ServerModules = Resources:WaitForChild("Modules", 60)
--local Database = Resources:WaitForChild("Database", 60)

local Events = game:GetService("ReplicatedStorage"):WaitForChild("Events", 60)
local Database = game:GetService("ReplicatedStorage"):WaitForChild("Database", 60)
-- module declarations
-- wait for modules to load
for _, module in ipairs(ServerModules:GetChildren()) do
    ServerModules:WaitForChild(module.Name, 30)
    print(module.Name)
end

local Modules = {}
-- require/initialize modules
for _, module in ipairs(ServerModules:GetChildren()) do
        Modules[module.Name] = require(module)
        print(module.Name)
end

local init = {}

function init.GenerateServer()
    Modules["Generate"].AnimalSpawns(Vector3.new(0,4,0), 30, 10, 0, "Doe")
    Modules["Generate"].AnimalSpawns(Vector3.new(0,4,0), 10, 1, 0, "Guppy")
    Modules["Generate"].AnimalSpawns(Vector3.new(0,4,20), 30, 10, 0, "Doe")
end

function init:CreateConnections()
    self.SpawnRequest = Modules["Request"].RemoteFunction("spawn_request", Events)
	self.AnimalRequest = Modules["Request"].RemoteEvent("animal_request", Events) --print(UpdateArea.Scan(char))
    self.OwnershipRequest = Modules["Request"].RemoteFunction("ownership_request", Events)

end

function init:EstablishConnections()
    self.AnimalRequest.OnServerEvent:Connect(function(player, animal, position, spawn_object)
            Modules["Animals"].Spawn(Assets.Animal:FindFirstChild(animal), position, player, Database.Player, spawn_object)
            
        end)
    self.SpawnRequest.OnServerInvoke = (function(player, animal, position)
            --print(player, animal, position)
            return Modules["Animals"].SpawnRequest(player, animal, position)
            
        end)

    print(self)
end

function init.StartServer()
    init.GenerateServer()
    init:CreateConnections()
    init:EstablishConnections()
end

init.StartServer()